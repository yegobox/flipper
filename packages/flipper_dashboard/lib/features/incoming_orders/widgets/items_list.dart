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
  final bool isIncoming;

  const ItemsList({Key? key, required this.request, this.isIncoming = true})
    : super(key: key);

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

    return _ItemCard(
      item: item,
      request: request,
      canEdit: canEdit,
      isIncoming: isIncoming,
      onApprove: (item, qty) =>
          _handleSingleItemApproval(context, ref, item, qty),
    );
  }

  void _handleSingleItemApproval(
    BuildContext context,
    WidgetRef ref,
    TransactionItem item,
    double quantity,
  ) {
    try {
      if (isIncoming) {
        approveSingleItem(
          request: request,
          item: item,
          context: context,
          quantity: quantity,
        );
      } else {
        updateRequestedQuantity(
          request: request,
          item: item,
          newQuantity: quantity.toInt(),
          context: context,
        );
      }

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
        'Failed to ${isIncoming ? "approve" : "update"} item: ${e.toString()}',
        backgroundColor: Colors.red[600],
      );
    }
  }
}

class _ItemCard extends HookWidget {
  final TransactionItem item;
  final InventoryRequest request;
  final bool canEdit;
  final bool isIncoming;
  final Function(TransactionItem, double) onApprove;

  const _ItemCard({
    required this.item,
    required this.request,
    required this.canEdit,
    this.isIncoming = true,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = useState(false);

    // For incoming: default to remaining (Requested - Approved)
    // For outgoing: default to Requested (since we are editing request)
    final initialQty = isIncoming
        ? ((item.quantityRequested ?? 0) - (item.quantityApproved ?? 0))
        : (item.quantityRequested ?? 0);

    final quantityController = useTextEditingController(
      text: initialQty.toString(),
    );

    // Reset controller text when isEditing changes to false (cancel)
    // or when we assume the initial value might have changed from props (less likely here without key)
    useEffect(() {
      if (!isEditing.value) {
        final currentQty = isIncoming
            ? ((item.quantityRequested ?? 0) - (item.quantityApproved ?? 0))
            : (item.quantityRequested ?? 0);
        quantityController.text = currentQty.toString();
      }
      return null;
    }, [isEditing.value, item.quantityRequested, item.quantityApproved]);

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
                              isIncoming ? 'Approved: ' : 'Requested: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              isIncoming
                                  ? '${item.quantityApproved ?? 0}/${item.quantityRequested ?? 0}'
                                  : '${item.quantityRequested ?? 0}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _getQuantityColor(item),
                              ),
                            ),
                          ],
                        ),
                        if (isIncoming &&
                            (item.quantityRequested ?? 0) >
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
                              isIncoming ? 'Approve Qty: ' : 'Update Qty: ',
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
                // Show action buttons if status is pending
                // For outgoing: always show edit/update if pending
                // For incoming: show if not fully approved
                if (request.status != RequestStatus.approved &&
                    (!isIncoming ||
                        (item.quantityApproved ?? 0) <
                            (item.quantityRequested ?? 0)))
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
                          },
                        ),
                      TextButton.icon(
                        onPressed: () {
                          final qty =
                              double.tryParse(quantityController.text) ?? 0;

                          if (isEditing.value) {
                            onApprove(item, qty);
                            isEditing.value = false;
                          } else {
                            // If not editing, use the current controller value (which is default)
                            onApprove(item, qty);
                          }
                        },
                        icon: Icon(
                          isIncoming ? Icons.check_circle_outline : Icons.save,
                          size: 18,
                        ),
                        label: Text(isIncoming ? 'Approve' : 'Update'),
                        style: TextButton.styleFrom(
                          foregroundColor: isIncoming
                              ? Colors.green[600]
                              : Colors.blue[600],
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
