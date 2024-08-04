// ignore_for_file: unused_result

import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IncomingOrdersWidget extends HookConsumerWidget
    with StockRequestApprovalLogic {
  const IncomingOrdersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(stockRequestsProvider);
    final stockRequests = ref.watch(stockRequestsProvider);
    ref.refresh(stockRequestsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stockRequests.asMap().entries.map((entry) {
          int index = entry.key;
          var request = entry.value;

          int totalQuantity = request.items.fold<int>(
            0,
            (sum, item) => sum + (item.quantityRequested ?? 0),
          );

          return Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Request #${request.id ?? index}',
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
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Branch ID: ${request.mainBranchId}-${request.subBranchId}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Items:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.0),
                  ...request.items.map((item) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle,
                                size: 8, color: Colors.blue[700]),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text('${item.name} (Qty: ${item.qty})',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 8.0),
                  Text(
                    'Status: ${request.status ?? "Unknown"}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700]),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(request.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${request.status ?? "Unknown"}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: request.status == RequestStatus.approved
                            ? null
                            : () {
                                approveRequest(
                                    request: request, context: context);
                                ref.refresh(stockRequestsProvider);
                              },
                        child: Text(
                          'Approve Request',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.disabled)) {
                                return Colors.grey[400];
                              }
                              return Colors.blue[700];
                            },
                          ),
                          foregroundColor:
                              WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange[100]!;
      case 'approved':
        return Colors.green[100]!;
      case 'rejected':
        return Colors.red[100]!;
      default:
        return Colors.grey[300]!;
    }
  }
}
