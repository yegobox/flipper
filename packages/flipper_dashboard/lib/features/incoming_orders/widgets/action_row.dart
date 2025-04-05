// ignore_for_file: unused_result

import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import '../providers/incoming_orders_provider.dart';

class ActionRow extends ConsumerWidget
    with StockRequestApprovalLogic, SnackBarMixin {
  final InventoryRequest request;

  const ActionRow({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(transactionItemsProvider(request.id));

    return itemsAsync.when(
      loading: () => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildActionButton(
            onPressed: null,
            icon: Icons.check_circle_outline,
            label: 'Approve',
            color: Colors.green[600]!,
            isDisabled: true,
          ),
          SizedBox(width: 12),
          _buildActionButton(
            onPressed: null,
            icon: Icons.cancel_outlined,
            label: 'Void',
            color: Colors.red[600]!,
            isDisabled: true,
          ),
        ],
      ),
      error: (error, stack) => SizedBox(), // Hide buttons if there's an error
      data: (items) {
        final bool hasApprovedItems =
            items.any((item) => (item.quantityApproved ?? 0) > 0);
        final bool isFullyApproved = request.status == RequestStatus.approved;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildActionButton(
              onPressed: isFullyApproved
                  ? null
                  : () => _handleApproveRequest(context, ref, request),
              icon: Icons.check_circle_outline,
              label: 'Approve',
              color: Colors.green[600]!,
              isDisabled: isFullyApproved,
            ),
            SizedBox(width: 12),
            _buildActionButton(
              onPressed:
                  hasApprovedItems ? null : () => _voidRequest(context, ref),
              icon: Icons.cancel_outlined,
              label: 'Void',
              color: Colors.red[600]!,
              isDisabled: hasApprovedItems,
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required bool isDisabled,
  }) {
    return Material(
      color: isDisabled ? Colors.grey[100] : color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isDisabled ? Colors.grey[400] : color,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDisabled ? Colors.grey[400] : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleApproveRequest(
      BuildContext context, WidgetRef ref, InventoryRequest request) async {
    final bool? confirmApprove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle_outline,
                color: Colors.green[600], size: 24),
            SizedBox(width: 12),
            Text(
              'Approve Request',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to approve all items in this request?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Approve All',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmApprove == true) {
      try {
        await approveRequest(request: request, context: context);
        final stringValue = ref.watch(stringProvider);
        ref.refresh(stockRequestsProvider((filter: stringValue)));
      } catch (e) {
        // Error handling is already done in approveRequest
      }
    }
  }

  void _voidRequest(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.red[400], size: 24),
              SizedBox(width: 12),
              Text(
                'Void Request',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to void this request?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // First update the request status to voided
                  await ProxyService.strategy.updateStockRequest(
                    stockRequestId: request.id,
                    status: RequestStatus.voided,
                  );

                  // Then delete the request
                  await ProxyService.strategy.delete(
                    id: request.id,
                    endPoint: 'stockRequest',
                  );

                  // Send SMS notification to requester
                  try {
                    final requesterConfig =
                        await SmsNotificationService.getBranchSmsConfig(
                      request.branch!.serverId!,
                    );
                    if (requesterConfig?.smsPhoneNumber != null) {
                      await SmsNotificationService.sendOrderRequestNotification(
                        receiverBranchId: request.branch!.serverId!,
                        orderDetails:
                            'Your stock request #${request.id.substring(0, 5)} has been declined.',
                        requesterPhone: requesterConfig!.smsPhoneNumber!,
                      );
                    }
                  } catch (smsError) {
                    talker.error('Failed to send SMS notification: $smsError');
                    // Don't show error to user as the main operation succeeded
                  }

                  final stringValue = ref.watch(stringProvider);
                  ref.refresh(stockRequestsProvider((filter: stringValue)));
                  Navigator.of(context).pop();
                  showCustomSnackBar(context, 'Request voided successfully');
                } catch (e, s) {
                  talker.error(s);
                  showCustomSnackBar(
                    context,
                    'Failed to void request: ${e.toString()}',
                    backgroundColor: Colors.red[600],
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Void Request',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
