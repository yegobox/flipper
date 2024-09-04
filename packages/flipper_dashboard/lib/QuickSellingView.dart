// ignore_for_file: unused_result

import 'package:feather_icons/feather_icons.dart';
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

class QuickSellingView extends StatefulHookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController discountController;
  final TextEditingController receivedAmountController;
  final TextEditingController customerPhoneNumberController;
  final TextEditingController paymentTypeController;

  const QuickSellingView({
    Key? key,
    required this.formKey,
    required this.discountController,
    required this.receivedAmountController,
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
        TransactionItemTable {
  String _selectedPaymentMethod = 'Cash';

  double get totalAfterDiscountAndShipping {
    final discount = double.tryParse(widget.discountController.text) ?? 0.0;
    return grandTotal - discount;
  }

  // Main build method
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

  // Device-specific builds
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
        // actions: [datePicker()],
        title: Text('Orders'),
      ),
      floatingActionButton: !(ProxyService.box.isOrdering() ?? false)
          ? PayableView(
              wording: "Pay ${getSumOfItems().toRwf()}",
              mode: SellingMode.forSelling,
              completeTransaction: () {
                talker.warning("We are about to complete a sale");
                transactionAsyncValue.whenData((ITransaction transaction) {
                  handleCompleteTransaction(transaction);
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

  // Shared view for both small and large devices
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

  // UI Component builders

  Widget _buildTotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Grand Total: \ ${grandTotal.toRwf()}',
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
      onChanged: (value) => null,
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
      onChanged: (value) => null,
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
        if (number < grandTotal) {
          ref.read(loadingProvider.notifier).state = false;
          return 'You are receiving less compared';
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
    return TextFormField(
      controller: widget.paymentTypeController,
      keyboardType: TextInputType.text,
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          ref.read(loadingProvider.notifier).state = false;
          return 'Please select or enter a payment method';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Payment Method',
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DropdownButton<String>(
              isDense: true,
              alignment: AlignmentDirectional.topStart,
              value: _selectedPaymentMethod,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue!;
                  ProxyService.box
                      .writeString(key: "paymentType", value: newValue);
                  widget.paymentTypeController.text = newValue;
                });
              },
              items: paymentTypes.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(FluentIcons.credit_card_clock_20_regular,
                  color: Colors.blue),
            ),
          ],
        ),
      ),
    );
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
              'Total - Discount: \ ${totalAfterDiscountAndShipping.toRwf()}',
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
