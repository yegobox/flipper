// ignore_for_file: unused_result

import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IncomingOrdersWidget extends HookConsumerWidget
    with StockRequestApprovalLogic {
  const IncomingOrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockRequests = ref.watch(stockRequestsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: stockRequests.when(
        data: (requests) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: requests.map((request) {
            if (!request.isValid) {
              return SizedBox.shrink(); // Skip invalid requests
            }
            return _buildRequestCard(context, ref, request);
          }).toList(),
        ),
        loading: () => Text("No Orders"),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, WidgetRef ref, dynamic request) {
    int totalQuantity = _calculateTotalQuantity(request);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRequestHeader(request, totalQuantity),
            SizedBox(height: 8.0),
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
    );
  }

  Widget _buildRequestHeader(dynamic request, int totalQuantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Request #${request.id}',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700]),
        ),
        Text(
          totalQuantity.toString(),
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[700]),
        ),
      ],
    );
  }

  Widget _buildBranchInfo(dynamic request) {
    return Text(
      'Branch ID: ${request.mainBranchId}-${request.subBranchId}',
      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
    );
  }

  Widget _buildItemsList(dynamic request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.0),
        ...request.items.map((item) => _buildItemRow(item)),
      ],
    );
  }

  Widget _buildItemRow(dynamic item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.blue[700]),
          SizedBox(width: 8),
          Expanded(
            child: Text('${item.name} (Qty: ${item.qty})',
                style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(dynamic request) {
    return Text(
      'Status: ${request.status ?? "Unknown"}',
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue[700]),
    );
  }

  Widget _buildActionRow(BuildContext context, WidgetRef ref, dynamic request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatusChip(request.status),
        _buildApproveButton(context, ref, request),
      ],
    );
  }

  Widget _buildStatusChip(String? status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${status ?? "Unknown"}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildApproveButton(
      BuildContext context, WidgetRef ref, dynamic request) {
    return ElevatedButton(
      key: Key("ApproveRequest"),
      onPressed: request.status == RequestStatus.approved
          ? null
          : () => _handleApproveRequest(context, ref, request),
      child: Text(
        'Approve Request',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: _approveButtonStyle(),
    );
  }

  void _handleApproveRequest(
      BuildContext context, WidgetRef ref, dynamic request) {
    approveRequest(request: request, context: context);
    ref.refresh(stockRequestsProvider);
  }

  ButtonStyle _approveButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey[400];
          }
          return Colors.blue[700];
        },
      ),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  int _calculateTotalQuantity(dynamic request) {
    return request.items.fold<int>(
      0,
      (int sum, TransactionItem item) => sum + (item.quantityRequested ?? 0),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange[300]!;
      case 'approved':
        return Colors.green[400]!;
      case 'partiallyApproved':
        return Colors.yellow[600]!;
      case 'rejected':
        return Colors.red[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
