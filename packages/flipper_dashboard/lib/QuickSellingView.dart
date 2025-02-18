// ignore_for_file: unused_result
import 'package:feather_icons/feather_icons.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/TransactionItemTable.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:stacked/stacked.dart';

class QuickSellingView extends StatefulHookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController discountController;
  final TextEditingController deliveryNoteCotroller;
  final TextEditingController receivedAmountController;
  final TextEditingController customerPhoneNumberController;
  final TextEditingController customerNameController;
  final TextEditingController paymentTypeController;

  const QuickSellingView({
    Key? key,
    required this.formKey,
    required this.discountController,
    required this.receivedAmountController,
    required this.deliveryNoteCotroller,
    required this.customerPhoneNumberController,
    required this.customerNameController,
    required this.paymentTypeController,
  }) : super(key: key);

  @override
  _QuickSellingViewState createState() => _QuickSellingViewState();
}

class _QuickSellingViewState extends ConsumerState<QuickSellingView>
    with
        TransactionMixin,
        TextEditingControllersMixin,
        PreviewCartMixin,
        TransactionItemTable,
        DateCoreWidget {
  double get totalAfterDiscountAndShipping {
    final discountPercent =
        double.tryParse(widget.discountController.text) ?? 0.0;
    final discountAmount = (grandTotal * discountPercent) / 100;
    return grandTotal - discountAmount;
  }

  @override
  void initState() {
    super.initState();
    ref.read(paymentMethodsProvider)[0].controller.addListener(() async {
      await Future.delayed(Duration(seconds: 5));
      try {
        updatePaymentAmounts(transactionId: "");
      } catch (e) {}
    });
  }

  void updatePaymentAmounts({required String transactionId}) {
    if (ref.read(paymentMethodsProvider).isEmpty) return;

    double remainingAmount = totalAfterDiscountAndShipping;
    final payments = ref.read(paymentMethodsProvider);

    // Handle the first payment method
    if (payments.isNotEmpty) {
      double firstAmount = double.tryParse(payments[0].controller.text) ?? 0.0;
      remainingAmount -= firstAmount;
      payments[0].amount = firstAmount;
    }

    // Distribute remaining amount among other payment methods
    for (int i = 1; i < payments.length; i++) {
      if (i == payments.length - 1) {
        // Last payment method gets the remaining amount
        payments[i].amount = remainingAmount;
        if (remainingAmount > 0) {
          payments[i].controller.text = remainingAmount.toStringAsFixed(2);
        }
      } else {
        // Keep the entered amount for middle payment methods
        double enteredAmount =
            double.tryParse(payments[i].controller.text) ?? 0.0;
        payments[i].amount = enteredAmount;
        remainingAmount -= enteredAmount;
      }

      // Update the payment method in the provider
      ref.read(paymentMethodsProvider.notifier).updatePaymentMethod(
            transactionId: transactionId,
            i,
            Payment(
              amount: payments[i].amount,
              method: payments[i].method,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering() ?? false;

    final transactionAsyncValue =
        ref.watch(pendingTransactionStreamProvider(isExpense: false));

    Future.microtask(() {
      ref.refresh(pendingTransactionStreamProvider(isExpense: false));
    });

    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          internalTransactionItems = ref
                  .watch(transactionItemsProvider(
                      transactionId: transactionAsyncValue.value?.id))
                  .value ??
              [];
          return context.isSmallDevice
              ? _buildSmallDeviceScaffold(
                  isOrdering, transactionAsyncValue, model)
              : _buildSharedView(
                  transactionAsyncValue, context.isSmallDevice, isOrdering);
        });
  }

  Widget _buildSmallDeviceScaffold(bool isOrdering,
      AsyncValue<ITransaction> transactionAsyncValue, CoreViewModel model) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            ref.read(previewingCart.notifier).state = false;
          },
        ),
        title: Text('Orders'),
      ),
      floatingActionButton: !(ProxyService.box.isOrdering() ?? false)
          ? PayableView(
              transactionId: transactionAsyncValue.value?.id ?? "",
              wording:
                  "Pay ${getSumOfItems(transactionId: transactionAsyncValue.value?.id).toRwf()}",
              mode: SellingMode.forSelling,
              completeTransaction: (imediteCompleteTransaction) {
                talker.warning("We are about to complete a sale");
                transactionAsyncValue.whenData((ITransaction transaction) {
                  startCompleteTransactionFlow(
                      immediateCompletion: imediteCompleteTransaction,
                      completeTransaction: () {},
                      transaction: transaction,
                      paymentMethods: ref.watch(paymentMethodsProvider));
                });
                ref.read(previewingCart.notifier).state = false;
              },
              model: model,
              ticketHandler: () {
                talker.warning("We are about to complete a ticket");
                transactionAsyncValue.whenData((ITransaction transaction) {
                  handleTicketNavigation(transaction);
                });
                ref.read(toggleProvider.notifier).state = false;
              },
            )
          : SizedBox.shrink(),
      body: _buildSharedView(transactionAsyncValue, true, isOrdering),
    );
  }

  Widget _buildSharedView(AsyncValue<ITransaction> transactionAsyncValue,
      bool isSmallDevice, bool isOrdering) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildTransactionItemsTable(isOrdering),
          SizedBox(height: 20),
          _buildTotalRow(),
          SizedBox(height: 20),
          if (!isOrdering)
            _buildForm(isOrdering,
                transactionId: transactionAsyncValue.value?.id ?? ""),
          SizedBox(height: 20),
          if (isOrdering) ...[
            Column(
              children: [
                Row(
                  children: [
                    Text("Delivery Date"),
                    datePicker(),
                  ],
                ),
                _deliveryNote()
              ],
            ),
          ],
          _buildFooter(transactionAsyncValue),
        ],
      ),
    );
  }

  Widget _buildTotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Grand Total: ${grandTotal.toRwf()}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildForm(bool isOrdering, {required String transactionId}) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: [
              if (!isOrdering) ...[
                Expanded(
                    child: _buildReceivedAmountField(
                        transactionId: transactionId)),
              ],
            ],
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              if (!isOrdering) Expanded(child: _customerNameField()),
            ],
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              if (!isOrdering) Expanded(child: _buildCustomerPhoneField()),
              SizedBox(width: 16.0),
              Expanded(
                  child:
                      _buildPaymentMethodField(transactionId: transactionId)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveryNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: StyledTextFormField.create(
        context: context,
        labelText: 'Delivery Note',
        hintText: 'Enter any special instructions for delivery',
        controller: widget.deliveryNoteCotroller,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        minLines: 1,
        prefixIcon: Icons.local_shipping,
        onChanged: (value) {
          setState(() {});
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }
          return null;
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _buildDiscountField() {
    return TextFormField(
      controller: widget.discountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Discount',
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(FluentIcons.shopping_bag_percent_24_regular,
            color: Colors.blue),
        border: OutlineInputBorder(),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
      ),
      onChanged: (value) async =>
          await ProxyService.box.writeString(key: 'discountRate', value: value),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        final number = double.tryParse(value);
        if (number == null) {
          ref.read(payButtonLoadingProvider.notifier).stopLoading();
          return 'Please enter a valid number';
        }

        /// this is a percentage not amount as this percenage will be applicable
        /// to the whole item on cart, currently we only support discount on whole total
        if (number < 0 || number > 100) {
          ref.read(payButtonLoadingProvider.notifier).stopLoading();
          return 'Discount must be between 0 and 100';
        }
        return null;
      },
    );
  }

  Widget _buildReceivedAmountField({required String transactionId}) {
    return StyledTextFormField.create(
        context: context,
        labelText: 'Received Amount',
        hintText: 'Received Amount',
        controller: widget.receivedAmountController,
        keyboardType: TextInputType.number,
        maxLines: 3,
        minLines: 1,
        suffixIcon: Icon(FeatherIcons.dollarSign, color: Colors.blue),
        onChanged: (value) => setState(() {
              final receivedAmount = double.tryParse(value);

              if (receivedAmount != null) {
                ref.read(paymentMethodsProvider)[0].controller.text = value;
                if (ref.read(paymentMethodsProvider).length == 1) {
                  /// if it is one payment method just swap
                  ref.read(paymentMethodsProvider.notifier).addPaymentMethod(
                      Payment(
                          amount: receivedAmount,
                          method: ref.read(paymentMethodsProvider)[0].method));

                  talker.warning(ref.read(paymentMethodsProvider).first.amount);
                  talker.warning(ref.read(paymentMethodsProvider).first.method);
                  return;
                }
                for (Payment payment in ref.read(paymentMethodsProvider)) {
                  ref.read(paymentMethodsProvider.notifier).addPaymentMethod(
                      Payment(amount: receivedAmount, method: payment.method));
                }
                updatePaymentAmounts(transactionId: transactionId);
              } // Update payment amounts after received amount changes
            }),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            ref.read(payButtonLoadingProvider.notifier).stopLoading();
            return 'Please enter received amount';
          }
          final number = double.tryParse(value);
          if (number == null) {
            ref.read(payButtonLoadingProvider.notifier).stopLoading();
            return 'Please enter a valid number';
          }
          if (number < totalAfterDiscountAndShipping) {
            ref.read(payButtonLoadingProvider.notifier).stopLoading();
            return 'You are receiving less than the total due';
          }
          return null;
        });
  }

  Widget _customerNameField() {
    return StyledTextFormField.create(
      context: context,
      labelText: 'Customer  Name',
      hintText: 'Customer  Name',
      controller: widget.customerNameController,
      keyboardType: TextInputType.text,
      maxLines: 3,
      minLines: 1,
      suffixIcon: Icon(FluentIcons.person_20_regular, color: Colors.blue),
      onChanged: (value) {
        ProxyService.box.writeString(key: "customerName", value: value);
      },
    );
  }

  Widget _buildCustomerPhoneField() {
    return StyledTextFormField.create(
      context: context,
      labelText: 'Customer Phone number',
      hintText: 'Customer Phone number',
      controller: widget.customerPhoneNumberController,
      keyboardType: TextInputType.number,
      maxLines: 3,
      minLines: 1,
      suffixIcon: Icon(FluentIcons.call_20_regular, color: Colors.blue),
      onChanged: (value) => ProxyService.box
          .writeString(key: 'currentSaleCustomerPhoneNumber', value: value),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          ref.read(payButtonLoadingProvider.notifier).stopLoading();
          return 'Please enter a phone number';
        }
        final phoneExp = RegExp(r'^[1-9]\d{8}$');
        if (!phoneExp.hasMatch(value)) {
          ref.read(payButtonLoadingProvider.notifier).stopLoading();
          return 'Please enter a valid 9-digit phone number without a leading zero';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentMethodField({required String transactionId}) {
    return Column(
      children: [
        for (int i = 0; i < ref.read(paymentMethodsProvider).length; i++)
          _buildPaymentMethodRow(i, transactionId: transactionId),
        SizedBox(height: 10),
        FlipperButton(
          height: 30,
          onPressed: () => _addPaymentMethod(transactionId: transactionId),
          textColor: Colors.black,
          text: 'Add Payment Method',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow(int index, {required String transactionId}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRect(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: ref.read(paymentMethodsProvider)[index].method,
                    items: paymentTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          final payment =
                              ref.read(paymentMethodsProvider)[index];
                          payment.method = newValue;
                          ref
                              .read(paymentMethodsProvider.notifier)
                              .updatePaymentMethod(
                                  index,
                                  Payment(
                                    amount: payment.amount,
                                    method: newValue,
                                  ),
                                  transactionId: transactionId);
                          // save the payment method.
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10, height: 5),
            Expanded(
              flex: 3,
              child: StyledTextFormField.create(
                context: context,
                labelText: 'Amount',
                hintText: 'Enter Amount',
                controller: ref.read(paymentMethodsProvider)[index].controller,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  ref.read(paymentMethodsProvider)[index].amount = amount;

                  // Only update other amounts if this isn't the last payment method
                  if (index < ref.read(paymentMethodsProvider).length - 1) {
                    updatePaymentAmounts(transactionId: transactionId);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: index == 0
                  ? null
                  : () =>
                      _removePaymentMethod(index, transactionId: transactionId),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void _addPaymentMethod({required String transactionId}) {
    setState(() {
      ref
          .read(paymentMethodsProvider)
          .add(Payment(amount: 0.0, method: 'Cash'));
      ref.read(paymentMethodsProvider).last.controller.addListener(
          () => updatePaymentAmounts(transactionId: transactionId));

      updatePaymentAmounts(transactionId: transactionId);
    });
  }

  void _removePaymentMethod(int index, {required String transactionId}) {
    setState(() {
      ref.read(paymentMethodsProvider)[index];
      ref.read(paymentMethodsProvider.notifier).removePaymentMethod(index);
      updatePaymentAmounts(transactionId: transactionId);
    });
  }

  String? validatePaymentMethods() {
    double total = ref
        .read(paymentMethodsProvider)
        .fold(0, (sum, method) => sum + method.amount);
    if ((total - totalAfterDiscountAndShipping).abs() > 0.01) {
      return 'Total received amount does not match the total due';
    }
    return null;
  }

  Widget _buildFooter(AsyncValue<ITransaction> transactionAsyncValue) {
    final transaction = transactionAsyncValue.asData?.value;
    final displayId =
        (transaction != null) ? transaction.id.toString() : 'Invalid';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        // Changed from Row to Wrap
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0, // Add spacing between wrapped items
        children: [
          Text(
            'Total - Discount: ${totalAfterDiscountAndShipping.toRwf()}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            softWrap: true, // Ensure text wraps if needed
          ),
          Row(
            mainAxisSize: MainAxisSize.min, // Make row take minimum space
            children: [
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: displayId));
                  ProxyService.strategy.notify(
                    notification: AppNotification(
                      identifier: ProxyService.box.getBranchId(),
                      type: "internal",
                      completed: false,
                      message: "TransactionId copied to keypad",
                    ),
                  );
                },
                constraints: BoxConstraints.tightFor(
                    width: 40), // Slightly smaller icon button
              ),
              Flexible(
                // Added Flexible to allow text to shrink if needed
                child: Text(
                  "ID: $displayId",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Handle text overflow gracefully
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
