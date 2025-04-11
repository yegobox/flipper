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
  static void edit({
    required BuildContext context,
    required WidgetRef ref,
    required TransactionItem transactionItem,
    required Function doneDelete,
    required String transactionId,
  }) {
    TextEditingController newQtyController = TextEditingController();
    newQtyController.text = transactionItem.qty.toString();
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: newQtyController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
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
                        'Total: ${0.toRwf()}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  FlipperButton(
                    color: Colors.blue,
                    width: double.infinity,
                    text: 'Done',
                    onPressed: () {
                      if (double.tryParse(newQtyController.text) != null &&
                          double.tryParse(newQtyController.text) != 0) {
                        ProxyService.strategy.updateTransactionItem(
                            qty: double.tryParse(newQtyController.text),
                            transactionItemId: transactionItem.id);

                        ref.refresh(transactionItemsProvider(
                            transactionId: transactionId,
                            branchId: ProxyService.box.getBranchId()!));
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
              ),
            ),
          )
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(transactionItemsProvider(
        transactionId: widget.transactionIdInt,
        branchId: ProxyService.box.getBranchId()!));

    double calculateTotal(List<TransactionItem> items) {
      return items.fold(0, (sum, item) => sum + item.price);
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

    Widget _buildContent(List<TransactionItem> items) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchInputWithDropdown(),
          SizedBox(height: 16),
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
                'Total: ${calculateTotal(items).toRwf()}',
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
            text: 'Charge ${calculateTotal(items).toRwf()}',
            onPressed: () {
              widget.onCharge(
                  widget.transactionIdInt.toString(), calculateTotal(items));
            },
          ),
        ],
      );
    }

    return itemsAsync.when(
      data: (items) => _buildContent(items),
      loading: () => Center(child: Text("Loading...")),
      error: (error, stack) => Center(
        child: Text(
          'Error loading items: ${error.toString()}',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
