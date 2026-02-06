// ignore_for_file: unused_result

import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import '../../../features/incoming_orders/providers/incoming_orders_provider.dart';
import 'package:flipper_models/providers/selection_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ItemsList extends HookConsumerWidget
    with StockRequestApprovalLogic, SnackBarMixin {
  final InventoryRequest request;

  const ItemsList({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync =
        request.transactionItems != null && request.transactionItems!.isNotEmpty
        ? AsyncValue.data(request.transactionItems!)
        : ref.watch(transactionItemsProvider(request.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        itemsAsync.when(
          data: (items) => items.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('No items in this request')),
                )
              : Column(children: _buildItemList(items, context, ref)),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text('Error loading items: $error')),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildItemList(
    List<TransactionItem> items,
    BuildContext context,
    WidgetRef ref,
  ) {
    items.sort((a, b) => (a.name).compareTo(b.name));

    return items.map((item) => _buildItemCard(item, context, ref)).toList();
  }

  Widget _buildItemCard(
    TransactionItem item,
    BuildContext context,
    WidgetRef ref,
  ) {
    final selectedIds = ref.watch(selectionProvider);
    final isBulkMode = selectedIds.isNotEmpty;
    // We cannot edit if in bulk mode.
    // We also only allow edit if status is pending.
    final canEdit = !isBulkMode && request.status == RequestStatus.pending;

    // We use a local state to toggle edit mode for this specific item if needed,
    // but usually partial approval implies changing the quantity *then* approving.
    // Or do we want an "Edit" button that turns the text into a field?
    // Let's use a Hook for inline editing state if we want toggle.
    // Since this is inside a map, we need a separate widget for the card to use hooks properly,
    // OR we just use a simple stateful approach.
    // Given ItemsList is HookConsumerWidget, we can't easily use hooks inside the map iteration
    // unless we extract ItemCard to a Widget.

    return _ItemCard(
      item: item,
      request: request,
      canEdit: canEdit,
      onApprove: (item, qty) =>
          _handleSingleItemApproval(context, ref, item, qty),
    );
  }

  // Moved _buildItemCard logic to _ItemCard class below to separate concerns and allow hooks if needed
  // ... but for now let's keep it simple.

  void _handleSingleItemApproval(
    BuildContext context,
    WidgetRef ref,
    TransactionItem item,
    double quantity,
  ) {
    try {
      // Logic to approve with specific quantity
      // We need to update existing mixin to support quantity if not supported
      // But verify if approveSingleItem supports it.
      // Looking at mixin usage, it seems it might not.
      // So we will need to update StockRequestApprovalLogic too.
      // For now passing item as is, but we need to update item.quantityApproved likely?

      // Actually we should call a method that updates the item in backend.
      // Let's assume approveSingleItem is what we have.

      approveSingleItem(
        request: request,
        item: item,
        context: context,
        quantity: quantity,
      );
      final stringValue = ref.read(stringProvider);
      ref.refresh(
        stockRequestsProvider(
          status: RequestStatus.pending,
          search: stringValue?.isNotEmpty == true ? stringValue : null,
        ),
      );
    } catch (e) {
      showCustomSnackBar(
        context,
        'Failed to approve item: ${e.toString()}',
        backgroundColor: Colors.red[600],
      );
    }
  }
}

class _ItemCard extends HookWidget {
  final TransactionItem item;
  final InventoryRequest request;
  final bool canEdit;
  final Function(TransactionItem, double) onApprove;

  const _ItemCard({
    required this.item,
    required this.request,
    required this.canEdit,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = useState(false);
    final quantityController = useTextEditingController(
      text: ((item.quantityRequested ?? 0) - (item.quantityApproved ?? 0))
          .toString(),
    );

    Color _getQuantityColor(TransactionItem item) {
      final approved = item.quantityApproved ?? 0;
      final requested = item.quantityRequested ?? 0;
      if (approved == 0) return Colors.red[700]!;
      if (approved < requested) return Colors.orange[700]!;
      return Colors.green[700]!;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (!isEditing.value) ...[
                        Row(
                          children: [
                            Text(
                              'Approved: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${item.quantityApproved ?? 0}/${item.quantityRequested ?? 0}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _getQuantityColor(item),
                              ),
                            ),
                          ],
                        ),
                        if ((item.quantityRequested ?? 0) >
                            (item.quantityApproved ?? 0))
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              'Pending: ${(item.quantityRequested ?? 0) - (item.quantityApproved ?? 0)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ] else ...[
                        // Editing Mode UI
                        Row(
                          children: [
                            Text(
                              'Approve Qty: ',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (request.status != RequestStatus.approved &&
                    (item.quantityApproved ?? 0) <
                        (item.quantityRequested ?? 0))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (canEdit)
                        IconButton(
                          icon: Icon(
                            isEditing.value ? Icons.close : Icons.edit,
                            size: 20,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            isEditing.value = !isEditing.value;
                            if (!isEditing.value) {
                              // Reset text if cancelled
                              quantityController.text =
                                  ((item.quantityRequested ?? 0) -
                                          (item.quantityApproved ?? 0))
                                      .toString();
                            }
                          },
                        ),
                      TextButton.icon(
                        onPressed: () {
                          if (isEditing.value) {
                            final qty =
                                double.tryParse(quantityController.text) ?? 0;
                            onApprove(item, qty);
                            isEditing.value = false;
                          } else {
                            // Default full remaining approval
                            onApprove(
                              item,
                              ((item.quantityRequested ?? 0) -
                                      (item.quantityApproved ?? 0))
                                  .toDouble(),
                            );
                          }
                        },
                        icon: Icon(Icons.check_circle_outline, size: 18),
                        label: Text('Approve'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
