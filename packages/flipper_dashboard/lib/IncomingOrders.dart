// ignore_for_file: unused_result

import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/NoOrderPlaceholder.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';

// Provider to cache transaction items for each request
final transactionItemsProvider =
    FutureProvider.family<List<TransactionItem>, String>(
  (ref, requestId) =>
      ProxyService.strategy.transactionItems(requestId: requestId),
);

class IncomingOrdersWidget extends HookConsumerWidget
    with StockRequestApprovalLogic, SnackBarMixin {
  const IncomingOrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    final stockRequests =
        ref.watch(stockRequestsProvider((filter: stringValue)));
    final incomingBranchAsync = ref.watch(activeBranchProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: stockRequests.when(
          data: (requests) {
            if (requests.isEmpty) {
              return buildNoOrdersPlaceholder();
            }

            return incomingBranchAsync.when(
              data: (incomingBranch) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) => _buildRequestCard(
                    incomingBranch: incomingBranch,
                    context,
                    ref,
                    requests[index],
                  ),
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator()), // Handle loading state
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    SizedBox(height: 16),
                    Text(
                      'Error loading branch',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      err.toString(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ), // Handle error state
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                SizedBox(height: 16),
                Text(
                  'Error loading requests',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  err.toString(),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, WidgetRef ref, InventoryRequest request,
      {required Branch incomingBranch}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          title: _buildRequestHeader(request, context),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBranchInfo(request, ref,
                      incomingBranch: incomingBranch),
                  SizedBox(height: 16.0),
                  _buildItemsList(ref, request: request, context: context),
                  SizedBox(height: 16.0),
                  _buildStatusAndDeliveryInfo(request),
                  if (request.orderNote?.isNotEmpty ?? false) ...[
                    SizedBox(height: 16.0),
                    _buildOrderNote(request),
                  ],
                  SizedBox(height: 20.0),
                  _buildActionRow(context, ref, request),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestHeader(InventoryRequest request, BuildContext context) {
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
                        ClipboardData(text: request.id.toString()));

                    showCustomSnackBar(
                        context, 'Request ID copied to clipboard');
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
                  'Request From ${request.branch?.name}',
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
        Consumer(
          builder: (context, ref, child) {
            final itemsAsync = ref.watch(transactionItemsProvider(request.id));
            return itemsAsync.when(
              loading: () => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Text(
                  '0/${request.itemCounts} Item${request.itemCounts! > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ),
              error: (error, stack) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green[100]!),
                ),
                child: Text(
                  '0/${request.itemCounts} Item${request.itemCounts! > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ),
              data: (items) {
                final totalApproved = items.fold<int>(
                    0, (sum, item) => sum + (item.quantityApproved ?? 0));
                final totalRequested = items.fold<int>(
                    0, (sum, item) => sum + (item.quantityRequested ?? 0));
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green[100]!),
                  ),
                  child: Text(
                    '$totalApproved/$totalRequested Item${totalRequested > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBranchInfo(InventoryRequest request, WidgetRef ref,
      {required Branch incomingBranch}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.swap_horiz, color: Colors.blue[700], size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBranchInfoRow(
                    'From', "${request.branch?.name}", Colors.green[700]!),
                SizedBox(height: 8),
                _buildBranchInfoRow(
                    'To', "${incomingBranch.name}", Colors.blue[700]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchInfoRow(String label, String branch, Color color) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          branch,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(WidgetRef ref,
      {required InventoryRequest request, required BuildContext context}) {
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
            children: _buildItemList(items, request, context, ref),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildItemList(List<TransactionItem> items,
      InventoryRequest request, BuildContext context, WidgetRef ref) {
    // Sort items by name for consistent display
    items.sort((a, b) => (a.name).compareTo(b.name));

    return items
        .map((item) => Card(
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
                        (item.quantityApproved ?? 0) <
                            (item.quantityRequested ?? 0))
                      TextButton.icon(
                        onPressed: () => _handleSingleItemApproval(
                            context, ref, request, item),
                        icon: Icon(Icons.check_circle_outline, size: 18),
                        label: Text('Approve'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.green[600],
                        ),
                      ),
                  ],
                ),
              ),
            ))
        .toList();
  }

  void _handleSingleItemApproval(BuildContext context, WidgetRef ref,
      InventoryRequest request, TransactionItem item) {
    try {
      approveSingleItem(request: request, item: item, context: context);
      final stringValue = ref.watch(stringProvider);
      ref.refresh(stockRequestsProvider((filter: stringValue)));
    } catch (e) {
      showCustomSnackBar(context, 'Failed to approve item: ${e.toString()}',
          backgroundColor: Colors.red[600]);
    }
  }

  Color _getQuantityColor(TransactionItem item) {
    final approved = item.quantityApproved ?? 0;
    final requested = item.quantityRequested ?? 0;

    if (approved == 0) return Colors.red;
    if (approved < requested) return Colors.orange;
    return Colors.green;
  }

  Widget _buildStatusAndDeliveryInfo(InventoryRequest request) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusInfo(request),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildDeliveryInfo(request),
        ),
      ],
    );
  }

  Widget _buildStatusInfo(InventoryRequest request) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(request.status).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: _getStatusColor(request.status).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(request.status),
            color: _getStatusColor(request.status),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  request.status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(request.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(InventoryRequest request) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.grey[600],
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  request.deliveryDate != null
                      ? DateFormat('MMM d, y')
                          .format(request.deliveryDate!.toLocal())
                      : 'Not specified',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNote(InventoryRequest request) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                'Order Note',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            request.orderNote ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
      BuildContext context, WidgetRef ref, InventoryRequest request) {
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
              onPressed: hasApprovedItems
                  ? null
                  : () => _voidRequest(context, ref, request),
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

  void _voidRequest(
      BuildContext context, WidgetRef ref, InventoryRequest request) {
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
                      stockRequestId: request.id, status: RequestStatus.voided);

                  // Then delete the request
                  await ProxyService.strategy.delete(
                    id: request.id,
                    endPoint: 'stockRequest',
                  );

                  // Send SMS notification to requester
                  try {
                    // Get requester's branch SMS config
                    final requesterConfig =
                        await SmsNotificationService.getBranchSmsConfig(
                            request.branch!.serverId!);
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
                  // Show success snackbar
                  showCustomSnackBar(context, 'Request voided successfully');
                } catch (e, s) {
                  talker.error(s);
                  showCustomSnackBar(
                      context, 'Failed to void request: ${e.toString()}',
                      backgroundColor: Colors.red[600]);
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

  void _handleApproveRequest(
      BuildContext context, WidgetRef ref, InventoryRequest request) {
    try {
      approveRequest(request: request, context: context);
      final stringValue = ref.watch(stringProvider);
      ref.refresh(stockRequestsProvider((filter: stringValue)));
    } catch (e) {
      showCustomSnackBar(context, 'Failed to approve request: ${e.toString()}',
          backgroundColor: Colors.red[600]);
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange[700]!;
      case 'approved':
        return Colors.green[600]!;
      case 'partiallyapproved':
        return Colors.amber[700]!;
      case 'rejected':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'approved':
        return Icons.check_circle_rounded;
      case 'partiallyapproved':
        return Icons.remove_circle_outline_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
