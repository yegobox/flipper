// ignore_for_file: unused_result

import 'package:feather_icons/feather_icons.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/previewCart.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/DeviceType.dart';
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
    with TransactionMixin, TextEditingControllersMixin, PreviewcartMixin {
  String _selectedPaymentMethod = 'Cash';
  List<TransactionItem> transactionItems = [];

  // Calculation methods
  double get grandTotal {
    double total = 0.0;
    double compositeTotal = 0.0;
    int compositeCount = 0;

    for (final item in transactionItems) {
      if (!item.isValid) continue;
      if (item.compositePrice != 0) {
        compositeTotal = item.compositePrice;
        compositeCount++;
      } else {
        total += item.price * item.qty;
      }
    }

    return compositeCount == transactionItems.length
        ? compositeTotal
        : total + compositeTotal;
  }

  double get totalAfterDiscountAndShipping {
    final discount = double.tryParse(widget.discountController.text) ?? 0.0;
    return grandTotal - discount;
  }

  String _getDeviceType(BuildContext context) {
    return DeviceType.getDeviceType(context);
  }

  // UI Components
  TableRow _buildTableHeader() {
    return TableRow(
      children: ['Name', 'Price', '', 'Total', '']
          .map((title) => Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ))
          .toList(),
    );
  }

  TableRow _buildTableRow(TransactionItem item, bool isOrdering) {
    // Check if the item is valid before accessing its properties
    if (!item.isValid) {
      return TableRow(
        children: [
          _buildTableCell("Invalid Item"),
          _buildTableCell(""),
          _buildTableCell(""),
          _buildTableCell(""),
          _buildDeleteButton(item, isOrdering),
        ],
      );
    }

    // If the item is valid, proceed with building the row
    return TableRow(
      children: [
        _buildTableCell(_getItemName(item)),
        _buildTableCell(_getItemPrice(item)),
        _buildQuantityCell(item, isOrdering),
        _buildTableCell(_getItemTotal(item)),
        _buildDeleteButton(item, isOrdering),
      ],
    );
  }

// Helper function to safely get the item name
  String _getItemName(TransactionItem item) {
    if (item.isValid && item.name != null) {
      return item.name!.extractNameAndNumber();
    }
    return "";
  }

// Helper function to safely get the item price
  String _getItemPrice(TransactionItem item) {
    if (item.isValid) {
      return item.price.toStringAsFixed(0);
    }
    return "";
  }

// Helper function to safely calculate the total price
  String _getItemTotal(TransactionItem item) {
    if (item.isValid) {
      return (item.price * item.qty).toStringAsFixed(0);
    }
    return "";
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildQuantityCell(TransactionItem item, bool isOrdering) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQuantityButton(Icons.remove, Colors.red,
              () => _decrementQuantity(item, isOrdering)),
          SizedBox(width: 8),
          _buildQuantityField(item, isOrdering),
          SizedBox(width: 8),
          _buildQuantityButton(Icons.add, Colors.blue,
              () => _incrementQuantity(item, isOrdering)),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildQuantityField(TransactionItem item, bool isOrdering) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        key: ValueKey(item.qty),
        initialValue: item.qty.toString(),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4),
          ),
          fillColor: Colors.grey[200],
          filled: true,
        ),
        onChanged: (value) => _updateQuantity(item, value, isOrdering),
      ),
    );
  }

  Widget _buildDeleteButton(TransactionItem item, bool isOrdering) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _deleteItem(item, isOrdering),
      ),
    );
  }

  // Item manipulation methods
  void _decrementQuantity(TransactionItem item, bool isOrdering) {
    if (!item.partOfComposite && item.isValid) {
      ProxyService.realm.realm!.write(() {
        if (item.qty > 0) {
          item.qty--;
          item.quantityRequested = item.qty.toInt();
        }
      });
      _refreshTransactionItems(isOrdering);
    }
  }

  void _incrementQuantity(TransactionItem item, bool isOrdering) {
    if (!item.partOfComposite && item.isValid) {
      ProxyService.realm.realm!.write(() {
        item.qty++;
        item.quantityRequested = item.qty.toInt();
      });
      _refreshTransactionItems(isOrdering);
    }
  }

  void _updateQuantity(TransactionItem item, String value, bool isOrdering) {
    if (!item.partOfComposite && item.isValid) {
      final trimmedValue = value.trim();
      final doubleValue = double.tryParse(trimmedValue) ??
          int.tryParse(trimmedValue)?.toDouble();
      if (doubleValue != null) {
        final newQty = doubleValue.toInt();
        if (doubleValue == newQty.toDouble() && newQty >= 0) {
          ProxyService.realm.realm!.write(() {
            item.qty = doubleValue;
            item.quantityRequested = newQty;
          });
          _refreshTransactionItems(isOrdering);
        }
      }
    }
  }

  void _deleteItem(TransactionItem item, bool isOrdering) {
    if (!item.isValid) return;

    if (!item.partOfComposite) {
      _deleteSingleItem(item, isOrdering);
    } else {
      _deleteCompositeItems(item, isOrdering);
    }
  }

  void _deleteSingleItem(TransactionItem item, bool isOrdering) {
    try {
      ProxyService.realm.realm!.write(() {
        ProxyService.realm.realm!.delete(item);
      });
      _refreshTransactionItems(isOrdering);
    } catch (e) {
      talker.error(e);
    }
  }

  void _deleteCompositeItems(TransactionItem item, bool isOrdering) {
    final coo = ProxyService.realm.composite(variantId: item.variantId!);
    final composites = ProxyService.realm.composites(productId: coo.productId!);

    for (final composite in composites) {
      final deletableItem = ProxyService.realm
          .getTransactionItemByVariantId(variantId: composite.variantId!);
      if (deletableItem != null && deletableItem.isValid) {
        ProxyService.realm.realm!.write(() {
          ProxyService.realm.realm!.delete(deletableItem);
        });
      }
    }
    _refreshTransactionItems(isOrdering);
  }

  void _refreshTransactionItems(bool isOrdering) {
    ref.refresh(transactionItemsProvider((isExpense: isOrdering)));
    setState(() {});
  }

  // Main build method
  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering() ?? false;
    final transactionItemsAsyncValue =
        ref.watch(transactionItemsProvider((isExpense: isOrdering)));
    final transactionAsyncValue = ref.watch(pendingTransactionProvider(
        (mode: TransactionType.sale, isExpense: false)));
    final deviceType = _getDeviceType(context);
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
      appBar: CustomAppBar(
        onPop: () async {
          ref.read(previewingCart.notifier).state = false;
        },
        multi: 3,
        bottomSpacer: 88.99,
      ),
      floatingActionButton: PayableView(
        wording: "Pay ${getSumOfItems().toRwf()}",
        mode: SellingMode.forSelling,
        completeTransaction: () {
          talker.warning("We are about to complete a sale");
          transactionAsyncValue.whenData((ITransaction transaction) {
            handleCompleteTransaction(transaction, model);
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
      ),
      body: _buildSharedView(transactionAsyncValue, true, isOrdering),
    );
  }

  // Shared view for both small and large devices
  Widget _buildSharedView(AsyncValue<ITransaction> transactionAsyncValue,
      bool isSmallDevice, bool isOrdering) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTransactionItemsTable(isOrdering),
            SizedBox(height: 20),
            _buildTotalRow(),
            SizedBox(height: 20),
            _buildForm(isOrdering),
            SizedBox(height: 20),
            _buildFooter(transactionAsyncValue),
          ],
        ),
      ),
    );
  }

  // UI Component builders
  Widget _buildTransactionItemsTable(bool isOrdering) {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        _buildTableHeader(),
        if (transactionItems.isEmpty)
          TableRow(children: [
            _buildTableCell('No data available'),
            _buildTableCell(''),
            _buildTableCell(''),
            _buildTableCell(''),
            _buildTableCell(''),
          ])
        else
          ...transactionItems.map((item) => _buildTableRow(item, isOrdering)),
      ],
    );
  }

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
