// ignore_for_file: unused_result

import 'package:feather_icons/feather_icons.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/TransactionItemTable.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/previewCart.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_ui/style_widget/button.dart';

class PaymentMethod {
  String method;
  double amount;
  TextEditingController controller;

  PaymentMethod(this.method, this.amount)
      : controller = TextEditingController(text: amount.toString());
}

class QuickSellingView extends StatefulHookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController discountController;
  final TextEditingController deliveryNoteCotroller;
  final TextEditingController receivedAmountController;
  final TextEditingController customerPhoneNumberController;
  final TextEditingController paymentTypeController;

  const QuickSellingView({
    Key? key,
    required this.formKey,
    required this.discountController,
    required this.receivedAmountController,
    required this.deliveryNoteCotroller,
    required this.customerPhoneNumberController,
    required this.paymentTypeController,
  }) : super(key: key);

  @override
  _QuickSellingViewState createState() => _QuickSellingViewState();
}

class _QuickSellingViewState extends ConsumerState<QuickSellingView>
    with
        TransactionMixin,
        TextEditingControllersMixin,
        PreviewcartMixin,
        TransactionItemTable,
        DateCoreWidget {
  List<PaymentMethod> _paymentMethods = [PaymentMethod('Cash', 0.0)];

  double get totalAfterDiscountAndShipping {
    final discount = double.tryParse(widget.discountController.text) ?? 0.0;
    return grandTotal - discount;
  }

  @override
  void initState() {
    super.initState();
    _paymentMethods[0].controller.addListener(_updatePaymentAmounts);
  }

  void _updatePaymentAmounts() {
    if (_paymentMethods.length > 1) {
      double remainingAmount = totalAfterDiscountAndShipping;
      for (int i = 0; i < _paymentMethods.length; i++) {
        if (i == 0) {
          double enteredAmount =
              double.tryParse(_paymentMethods[i].controller.text) ?? 0.0;
          remainingAmount -= enteredAmount;
        } else {
          if (i == _paymentMethods.length - 1) {
            _paymentMethods[i].amount = remainingAmount;
            _paymentMethods[i].controller.text =
                remainingAmount.toStringAsFixed(2);
          } else {
            _paymentMethods[i].amount = 0.0;
            _paymentMethods[i].controller.text = '0.00';
          }
        }
      }
      for (PaymentMethod payment in _paymentMethods) {
        ref.read(paymentMethodsProvider.notifier).addPaymentMethod(
            Payment(amount: payment.amount, method: payment.method));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering() ?? false;
    final transactionItemsAsyncValue =
        ref.watch(transactionItemsProvider((isExpense: isOrdering)));
    final transactionAsyncValue = ref.watch(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));
    final deviceType = getDeviceType(context);
    final isSmallDevice = deviceType == "Phone" ||
        deviceType == "Phablet" ||
        deviceType == "Tablet";

    transactionItemsAsyncValue.whenData((items) {
      try {
        setState(() {
          transactionItems = items.where((item) => item.isValid).toList();
        });
        if (items.isNotEmpty && !items.first.isValid) {
          ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
        }
      } catch (e) {
        talker.error(e);
      }
    });

    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          return isSmallDevice
              ? _buildSmallDeviceScaffold(
                  isOrdering, transactionAsyncValue, model)
              : _buildSharedView(
                  transactionAsyncValue, isSmallDevice, isOrdering);
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
              wording: "Pay ${getSumOfItems().toRwf()}",
              mode: SellingMode.forSelling,
              completeTransaction: () {
                talker.warning("We are about to complete a sale");
                transactionAsyncValue.whenData((ITransaction transaction) {
                  handleCompleteTransaction(
                      transaction: transaction,
                      paymentMethods: ref.watch(paymentMethodsProvider));
                });
                ref.read(previewingCart.notifier).state = false;
              },
              ref: ref,
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
          _buildForm(isOrdering),
          SizedBox(height: 20),
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

  Widget _buildForm(bool isOrdering) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: [
              if (!isOrdering) ...[
                Expanded(child: _buildDiscountField()),
                SizedBox(width: 16.0),
                Expanded(child: _buildReceivedAmountField()),
              ],
            ],
          ),
          if (isOrdering) ...[
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
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
            )
          ],
          SizedBox(height: 6.0),
          Row(
            children: [
              if (!isOrdering) Expanded(child: _buildCustomerPhoneField()),
              SizedBox(width: 16.0),
              Expanded(child: _buildPaymentMethodField()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveryNote() {
    return TextFormField(
      controller: widget.deliveryNoteCotroller,
      keyboardType: TextInputType.text,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'Delivery Note',
        hintText: 'Enter any special instructions for delivery',
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon:
            Icon(Icons.local_shipping, color: Theme.of(context).primaryColor),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear, color: Colors.grey),
          onPressed: () => widget.deliveryNoteCotroller.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (value) => null,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        return null;
      },
    );
  }

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
      onChanged: (value) => setState(() {}),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        final number = double.tryParse(value);
        if (number == null) {
          ref.read(loadingProvider.notifier).state = false;
          return 'Please enter a valid number';
        }
        if (number < 0 || number > 100) {
          ref.read(loadingProvider.notifier).state = false;
          return 'Discount must be between 0 and 100';
        }
        return null;
      },
    );
  }

  Widget _buildReceivedAmountField() {
    return TextFormField(
      controller: widget.receivedAmountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Received Amount',
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(FeatherIcons.dollarSign, color: Colors.blue),
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
      onChanged: (value) => setState(() {
        /// always first row in payment type is equal by received amount
        _paymentMethods[0].controller.text = value;
        _updatePaymentAmounts(); // Update payment amounts after received amount changes
      }),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          ref.read(loadingProvider.notifier).state = false;
          return 'Please enter received amount';
        }
        final number = double.tryParse(value);
        if (number == null) {
          ref.read(loadingProvider.notifier).state = false;
          return 'Please enter a valid number';
        }
        if (number < totalAfterDiscountAndShipping) {
          ref.read(loadingProvider.notifier).state = false;
          return 'You are receiving less than the total due';
        }
        return null;
      },
    );
  }

  Widget _buildCustomerPhoneField() {
    return TextFormField(
      controller: widget.customerPhoneNumberController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Customer Phone number',
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(FluentIcons.call_20_regular, color: Colors.blue),
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
      onChanged: (value) => ProxyService.box
          .writeString(key: 'currentSaleCustomerPhoneNumber', value: value),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          ref.read(loadingProvider.notifier).state = false;
          return 'Please enter a phone number';
        }
        final phoneExp = RegExp(r'^[1-9]\d{8}$');
        if (!phoneExp.hasMatch(value)) {
          ref.read(loadingProvider.notifier).state = false;
          return 'Please enter a valid 9-digit phone number without a leading zero';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentMethodField() {
    return Column(
      children: [
        for (int i = 0; i < _paymentMethods.length; i++)
          _buildPaymentMethodRow(i),
        SizedBox(height: 10),
        FlipperButton(
          height: 30,
          onPressed: _addPaymentMethod,
          textColor: Colors.black,
          text: 'Add Payment Method',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow(int index) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButton<String>(
                value: _paymentMethods[index].method,
                items: paymentTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _paymentMethods[index].method = newValue!;
                    // Update the amount if the payment method changes to avoid issues
                    _updatePaymentAmounts();
                  });
                },
              ),
            ),
            SizedBox(width: 10, height: 5),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _paymentMethods[index].controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _paymentMethods[index].amount =
                        double.tryParse(value) ?? 0.0;
                    _updatePaymentAmounts(); // Update payment amounts after amount changes
                  });
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
              onPressed: index == 0 ? null : () => _removePaymentMethod(index),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void _addPaymentMethod() {
    setState(() {
      _paymentMethods.add(PaymentMethod('Cash', 0.0));
      _paymentMethods.last.controller
          .addListener(_updatePaymentAmounts); // Add listener to new controller
      _updatePaymentAmounts(); // Update payment amounts after adding new method
    });
  }

  void _removePaymentMethod(int index) {
    setState(() {
      _paymentMethods[index].controller.removeListener(
          _updatePaymentAmounts); // Remove listener from removed controller
      _paymentMethods.removeAt(index);
      _updatePaymentAmounts(); // Update payment amounts after removing a method
    });
  }

  String? validatePaymentMethods() {
    double total =
        _paymentMethods.fold(0, (sum, method) => sum + method.amount);
    if ((total - totalAfterDiscountAndShipping).abs() > 0.01) {
      return 'Total received amount does not match the total due';
    }
    return null;
  }

  Widget _buildFooter(AsyncValue<ITransaction> transactionAsyncValue) {
    final pendingTransaction = ref.watch(pendingTransactionProvider((
      mode: TransactionType.sale,
      isExpense: false,
    )));

    final transaction = pendingTransaction.asData?.value;

    final displayId = (transaction != null && transaction.isValid)
        ? transaction.id.toString()
        : 'Invalid';
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            Text(
              'Total - Discount: ${totalAfterDiscountAndShipping.toRwf()}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    if (kDebugMode) {
                      talker.info("We are adding dummy data in notification");
                      ProxyService.local.notify(
                        notification: AppNotification(
                          ObjectId(),
                          identifier: ProxyService.box.getBranchId(),
                          type: "internal",
                          id: randomNumber(),
                          completed: false,
                          message: "Sale completed",
                        ),
                      );
                    }

                    Clipboard.setData(ClipboardData(text: displayId));

                    ProxyService.local.notify(
                      notification: AppNotification(
                        ObjectId(),
                        identifier: ProxyService.box.getBranchId(),
                        type: "internal",
                        id: randomNumber(),
                        completed: false,
                        message: "TransactionId copied to keypad",
                      ),
                    );
                  },
                ),
                SizedBox(width: 8),
                Text(
                  "ID: $displayId",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
