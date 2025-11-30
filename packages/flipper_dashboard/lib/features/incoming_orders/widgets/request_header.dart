import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestHeader extends ConsumerWidget with SnackBarMixin {
  final InventoryRequest request;

  const RequestHeader({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Material(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: request.id.toString()),
                    );
                    showCustomSnackBar(
                      context,
                      'Request ID copied to clipboard',
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.copy, color: Colors.blue[700], size: 20),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Request From ${request.branch?.name} (${request.itemCounts} items)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        _buildItemCount(ref, transactionItems: request.transactionItems ?? []),
      ],
    );
  }

  Widget _buildItemCount(
    WidgetRef ref, {
    required List<TransactionItem> transactionItems,
  }) {
    final totalApproved = transactionItems.fold<int>(
      0,
      (sum, item) => sum + (item.quantityApproved ?? 0),
    );
    final totalRequested = transactionItems.fold<int>(
      0,
      (sum, item) => sum + (item.quantityRequested ?? 0),
    );
    return _buildItemCountContainer(
      '$totalApproved/$totalRequested',
      totalRequested,
    );
  }

  Widget _buildItemCountContainer(String text, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Text(
        '$text Item${count > 1 ? 's' : ''}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.green[700],
        ),
      ),
    );
  }
}
