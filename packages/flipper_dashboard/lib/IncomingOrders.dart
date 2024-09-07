// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/NoOrderPlaceholder.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';

class IncomingOrdersWidget extends HookConsumerWidget
    with StockRequestApprovalLogic {
  const IncomingOrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    final stockRequests =
        ref.watch(stockRequestsProvider((filter: stringValue)));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: stockRequests.when(
        data: (requests) {
          if (requests.isEmpty) {
            return buildNoOrdersPlaceholder();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: requests
                .where((request) => request.isValid)
                .map((request) => _buildRequestCard(context, ref, request))
                .toList(),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, WidgetRef ref, StockRequest request) {
    int totalQuantity = _calculateTotalQuantity(request);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: _buildRequestHeader(request, totalQuantity),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBranchInfo(request),
                    SizedBox(height: 12.0),
                    _buildItemsList(request),
                    SizedBox(height: 8.0),
                    _buildStatusInfo(request),
                    SizedBox(height: 16.0),
                    _buildActionRow(context, ref, request),
                  ],
                ),
              ),
            ),
          ],
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.topLeft,
        ),
      ),
    );
  }

  Widget _buildRequestHeader(StockRequest request, int totalQuantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.copy, color: Colors.blue[700]),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: request.id.toString()));
                // Add a snackbar or toast to confirm the copy action
              },
            ),
            Text(
              'Request #${request.id}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700]),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Total: $totalQuantity',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchInfo(StockRequest request) {
    final mainBranch =
        ProxyService.local.branch(serverId: request.mainBranchId!)?.name ??
            'Unknown';
    final subBranch =
        ProxyService.local.branch(serverId: request.subBranchId!)?.name ??
            'Unknown';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                children: [
                  TextSpan(
                      text: 'From: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: mainBranch,
                      style: TextStyle(color: Colors.green[700])),
                  TextSpan(
                      text: '\nTo: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: subBranch,
                      style: TextStyle(color: Colors.blue[700])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(StockRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requested Items:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.0),
        ...request.items.map((item) => _buildItemRow(item)),
      ],
    );
  }

  Widget _buildItemRow(TransactionItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '${item.name}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Qty: ${item.qty}',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(StockRequest request) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: _getStatusColor(request.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getStatusColor(request.status)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(request.status),
              color: _getStatusColor(request.status), size: 20),
          SizedBox(width: 8),
          Text(
            'Status: ${request.status ?? "Unknown"}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _getStatusColor(request.status),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
      BuildContext context, WidgetRef ref, StockRequest request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildApproveButton(context, ref, request),
        SizedBox(width: 12),
        _buildVoidButton(context, ref, request),
      ],
    );
  }

  Widget _buildApproveButton(
      BuildContext context, WidgetRef ref, StockRequest request) {
    return FlipperIconButton(
      icon: Icons.check_circle_outline,
      text: 'Approve',
      iconColor: Colors.green,
      onPressed: request.status == RequestStatus.approved
          ? null
          : () => _handleApproveRequest(context, ref, request),
    );
  }

  Widget _buildVoidButton(
      BuildContext context, WidgetRef ref, StockRequest request) {
    return FlipperIconButton(
      icon: Icons.cancel_outlined,
      iconColor: Colors.red,
      text: 'Void',
      onPressed: () => _voidRequest(context, ref, request),
    );
  }

  void _voidRequest(BuildContext context, WidgetRef ref, StockRequest request) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Void Request'),
          content: Text('Are you sure you want to void this request?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Void'),
              onPressed: () {
                Navigator.of(context).pop();
                ProxyService.realm.realm!.write(() {
                  ProxyService.realm.realm!.delete<StockRequest>(request);
                });
                final stringValue = ref.watch(stringProvider);
                ref.refresh(stockRequestsProvider((filter: stringValue)));
              },
            ),
          ],
        );
      },
    );
  }

  void _handleApproveRequest(
      BuildContext context, WidgetRef ref, StockRequest request) {
    approveRequest(request: request, context: context);
    final stringValue = ref.watch(stringProvider);
    ref.refresh(stockRequestsProvider((filter: stringValue)));
  }

  int _calculateTotalQuantity(StockRequest request) {
    return request.items.fold<int>(
      0,
      (int sum, TransactionItem item) => sum + (item.quantityRequested ?? 0),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'partiallyApproved':
        return Colors.amber;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'partiallyApproved':
        return Icons.remove_circle_outline;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
