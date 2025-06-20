// ignore_for_file: unused_result

import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import '../providers/incoming_orders_provider.dart';

class ItemsList extends ConsumerWidget
    with StockRequestApprovalLogic, SnackBarMixin {
  final InventoryRequest request;

  const ItemsList({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(transactionItemsProvider(request.id));

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
          loading: () => Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Text('Error loading items: $error'),
          data: (items) => Column(
            children: _buildItemList(items, context, ref),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildItemList(
      List<TransactionItem> items, BuildContext context, WidgetRef ref) {
    items.sort((a, b) => (a.name).compareTo(b.name));

    return items.map((item) => _buildItemCard(item, context, ref)).toList();
  }

  Widget _buildItemCard(
      TransactionItem item, BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
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
                ],
              ),
            ),
            if (request.status != RequestStatus.approved &&
                (item.quantityApproved ?? 0) < (item.quantityRequested ?? 0))
              TextButton.icon(
                onPressed: () => _handleSingleItemApproval(context, ref, item),
                icon: Icon(Icons.check_circle_outline, size: 18),
                label: Text('Approve'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getQuantityColor(TransactionItem item) {
    final approved = item.quantityApproved ?? 0;
    final requested = item.quantityRequested ?? 0;
    if (approved == 0) return Colors.red[700]!;
    if (approved < requested) return Colors.orange[700]!;
    return Colors.green[700]!;
  }

  void _handleSingleItemApproval(
      BuildContext context, WidgetRef ref, TransactionItem item) {
    try {
      approveSingleItem(request: request, item: item, context: context);
      final stringValue = ref.watch(stringProvider);
      ref.refresh(stockRequestsProvider(
          status: RequestStatus.pending,
          search: stringValue?.isNotEmpty == true ? stringValue : null));
    } catch (e) {
      showCustomSnackBar(
        context,
        'Failed to approve item: ${e.toString()}',
        backgroundColor: Colors.red[600],
      );
    }
  }
}
