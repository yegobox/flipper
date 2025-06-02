// ignore_for_file: unused_result

import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldProvider;
import 'dart:async';

class BottomSheets {
  static void showBottom({
    required BuildContext context,
    required WidgetRef ref,
    required Function doneDelete,
    required Function onCharge,
    String? transactionId,
  }) {
    if (transactionId == null) {
      return; // Handle null case
    }

    // Parse to int

    WoltModalSheet.show<void>(
      onModalDismissedWithBarrierTap: () {
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        // dismiss the modal
        Navigator.of(context).pop();
      },
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _BottomSheetContent(
                transactionIdInt: transactionId,
                doneDelete: doneDelete,
                onCharge: onCharge,
              ),
            ),
          ),
        ];
      },
    );
  }
}

class _BottomSheetContent extends ConsumerStatefulWidget {
  const _BottomSheetContent(
      {required this.transactionIdInt,
      required this.doneDelete,
      required this.onCharge});
  final String transactionIdInt;
  final Function doneDelete;
  final Function onCharge;

  @override
  ConsumerState<_BottomSheetContent> createState() =>
      _BottomSheetContentState();
}

class _BottomSheetContentState extends ConsumerState<_BottomSheetContent> {
  bool _isLoading = false;
  late final TextEditingController _customerPhoneController;
  String? _customerPhoneError;

  @override
  void initState() {
    super.initState();
    _customerPhoneController = TextEditingController(
      text:
          ProxyService.box.readString(key: 'currentSaleCustomerPhoneNumber') ??
              '',
    );
    _customerPhoneController.addListener(() {
      final value = _customerPhoneController.text;
      ProxyService.box
          .writeString(key: 'currentSaleCustomerPhoneNumber', value: value);
      setState(() {}); // To update error message if needed
    });
  }

  @override
  void dispose() {
    _customerPhoneController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    // Must be 9 digits, starting with 7, 8, or 9, and no leading zero
    final phoneExp = RegExp(r'^[7-9]\d{8}$');
    if (!phoneExp.hasMatch(value)) {
      return 'Please enter a valid 9-digit phone number (e.g. 783054874)';
    }
    return null;
  }

  static Future<void> edit({
    required BuildContext context,
    required WidgetRef ref,
    required TransactionItem transactionItem,
    required Function doneDelete,
    required String transactionId,
  }) async {
    TextEditingController newQtyController = TextEditingController();
    newQtyController.text = transactionItem.qty.toString();
    double localQty = transactionItem.qty.toDouble();
    double localTotal = localQty * transactionItem.price;

    // Create a completer to signal when the edit is complete
    final completer = Completer<bool>();

    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: newQtyController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          final qty = double.tryParse(val) ?? 0;
                          setModalState(() {
                            localQty = qty;
                            localTotal = localQty * transactionItem.price;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price: ${transactionItem.price.toString()}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Total: ${localTotal.toCurrencyFormatted()}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      FlipperButton(
                        color: Colors.blue,
                        width: double.infinity,
                        text: 'Done',
                        onPressed: () async {
                          final qty = double.tryParse(newQtyController.text);
                          if (qty != null && qty != 0) {
                            try {
                              await ProxyService.strategy.updateTransactionItem(
                                qty: qty,
                                transactionItemId: transactionItem.id,
                              );

                              // Force refresh the provider
                              await ref.refresh(transactionItemsProvider(
                                transactionId: transactionId,
                                branchId: ProxyService.box.getBranchId()!,
                              ).future);

                              // Complete with success
                              completer.complete(true);

                              if (Navigator.of(context).canPop())
                                Navigator.of(context).pop();
                            } catch (e) {
                              completer.complete(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error updating quantity: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      FlipperIconButton(
                        icon: Icons.delete,
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        text: 'Remove Product',
                        onPressed: () {
                          ProxyService.strategy.deleteItemFromCart(
                            transactionItemId: transactionItem,
                            transactionId: transactionId,
                          );
                          Navigator.of(context).pop();
                          doneDelete();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ];
      },
    );

    // Wait for the edit to complete
    await completer.future;

    // Ensure the parent widget rebuilds with the updated data
    ref.invalidate(transactionItemsProvider(
      transactionId: transactionId,
      branchId: ProxyService.box.getBranchId()!,
    ));
  }

  Future<void> _handleCharge(String transactionId, double total) async {
    // Validate phone before charging
    final phoneError = _validatePhone(_customerPhoneController.text);
    setState(() {
      _customerPhoneError = phoneError;
    });
    if (phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(phoneError)),
      );
      return;
    }
    try {
      // Start loading
      setState(() {
        _isLoading = true;
      });
      ref.read(oldProvider.loadingProvider.notifier).startLoading();

      // Save phone number to ProxyService.box
      ProxyService.box.writeString(
          key: 'currentSaleCustomerPhoneNumber',
          value: _customerPhoneController.text);

      // Call the charge function
      await widget.onCharge(transactionId, total);

      // Stop loading and close modal
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(transactionItemsProvider(
        transactionId: widget.transactionIdInt,
        branchId: ProxyService.box.getBranchId()!));

    double calculateTotal(List<TransactionItem> items) {
      return items.fold(0, (sum, item) => sum + (item.price * item.qty));
    }

    Widget _buildTransactionItem(TransactionItem transactionItem) {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Text(
          transactionItem.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Qty: ${transactionItem.qty}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 16),
            Text(
              transactionItem.price.toString(),
              style: TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                edit(
                  doneDelete: widget.doneDelete,
                  context: context,
                  ref: ref,
                  transactionItem: transactionItem,
                  transactionId: widget.transactionIdInt.toString(),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget _buildPhoneField() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: TextField(
          controller: _customerPhoneController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Customer Phone number',
            hintText: 'Customer Phone number',
            prefixIcon: Icon(Icons.phone, color: Colors.blue),
            errorText: _customerPhoneError,
            border: OutlineInputBorder(),
          ),
          maxLength: 9,
        ),
      );
    }

    Widget _buildContent(List<TransactionItem> items) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchInputWithDropdown(),
          SizedBox(height: 16),
          _buildPhoneField(),
          if (items.isNotEmpty)
            ...items.map((item) => _buildTransactionItem(item)).toList(),
          SizedBox(height: 16),
          Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlipperButtonFlat(
                textColor: Colors.red,
                onPressed: () {
                  for (TransactionItem item in items) {
                    ProxyService.strategy.deleteItemFromCart(
                      transactionItemId: item,
                      transactionId: widget.transactionIdInt.toString(),
                    );
                  }
                  ref.refresh(transactionItemsProvider(
                      transactionId: widget.transactionIdInt,
                      branchId: ProxyService.box.getBranchId()!));
                  widget.doneDelete();
                },
                text: 'Clear All',
              ),
              Text(
                'Total: ${calculateTotal(items).toCurrencyFormatted()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          FlipperButton(
            color: Colors.blue,
            width: double.infinity,
            text: 'Charge ${calculateTotal(items).toCurrencyFormatted()}',
            isLoading: _isLoading,
            onPressed: _isLoading
                ? null
                : () => _handleCharge(
                    widget.transactionIdInt.toString(), calculateTotal(items)),
          ),
        ],
      );
    }

    return itemsAsync.when(
      data: (items) => _buildContent(items),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading items: ${error.toString()}',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
