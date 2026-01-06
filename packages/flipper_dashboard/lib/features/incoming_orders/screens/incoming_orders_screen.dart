// import 'package:flipper_dashboard/OrderStatusSelector.dart';
// ignore_for_file: unused_result

import 'package:flipper_dashboard/OrderStatusSelector.dart';
import 'package:flipper_dashboard/checkout.dart' show OrderStatus;
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_card.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IncomingOrdersScreen extends HookConsumerWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    final refreshedOnce = useState(false);
    final status = ref.watch(requestStatusProvider);
    final search = stringValue?.isNotEmpty == true ? stringValue : null;
    final stockRequests = ref.watch(
      stockRequestsProvider(status: status, search: search),
    );
    final incomingBranchAsync = ref.watch(activeBranchProvider);

    useEffect(() {
      stockRequests.whenData((requests) {
        if (!refreshedOnce.value && requests.isNotEmpty) {
          final needsRefresh = requests.any(
            (request) =>
                (request.transactionItems == null ||
                    request.transactionItems!.isEmpty) &&
                (request.itemCounts ?? 0) > 0,
          );

          if (needsRefresh) {
            refreshedOnce.value = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              ref.refresh(
                stockRequestsProvider(status: status, search: search),
              );
            });
          }
        }
      });
      return null;
    }, [stockRequests, refreshedOnce.value]);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Incoming Orders',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              OrderStatusSelector(
                selectedStatus: ref.watch(orderStatusProvider),
                onStatusChanged: (newStatus) {
                  ref.read(orderStatusProvider.notifier).state = newStatus;
                  ref
                      .read(requestStatusProvider.notifier)
                      .state = newStatus == OrderStatus.approved
                      ? RequestStatus.approved
                      : RequestStatus.pending;
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: stockRequests.when(
              data: (requests) {
                if (requests.isEmpty) {
                  return _buildEmptyState(ref);
                }

                return incomingBranchAsync.when(
                  data: (incomingBranch) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsCard(requests.length),
                          const SizedBox(height: 20),
                          const Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: requests.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 15,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: RequestCard(
                                request: requests[index],
                                incomingBranch: incomingBranch,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => _buildLoadingState(),
                  error: (err, stack) => _buildErrorState(
                    'Error loading branch',
                    err.toString(),
                    Icons.business_center_outlined,
                  ),
                );
              },
              loading: () => _buildLoadingState(),
              error: (err, stack) => _buildErrorState(
                'Error loading requests',
                err.toString(),
                Icons.error_outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(int orderCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0078D4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.pending_actions,
              color: const Color(0xFF0078D4),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$orderCount',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  orderCount == 1 ? 'Pending Request' : 'Pending Requests',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: orderCount > 0
                  ? const Color(0xFF58D68D)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              orderCount > 0 ? 'Active' : 'No Orders',
              style: TextStyle(
                color: orderCount > 0 ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF58D68D), Color(0xFF48C9B0)],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No pending orders at the moment.\nNew requests will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withOpacity(0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.refresh(
                stockRequestsProvider(
                  status: ref.read(requestStatusProvider),
                  search: ref.read(stringProvider)?.isNotEmpty == true
                      ? ref.read(stringProvider)
                      : null,
                ),
              );
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0078D4),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLoadingState() {
  return const Center(child: CircularProgressIndicator());
}

Widget _buildErrorState(String title, String message, IconData icon) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE74C3C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 32, color: const Color(0xFFE74C3C)),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.withOpacity(0.6),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Add retry functionality, maybe ref.refresh like above
          },
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Try Again'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0078D4),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}
