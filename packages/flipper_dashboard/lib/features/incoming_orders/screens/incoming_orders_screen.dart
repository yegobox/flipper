// import 'package:flipper_dashboard/OrderStatusSelector.dart';
// ignore_for_file: unused_result

import 'package:flipper_dashboard/OrderStatusSelector.dart';
import 'package:flipper_dashboard/checkout.dart' show OrderStatus;
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_card.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IncomingOrdersScreen extends HookConsumerWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    final status = ref.watch(requestStatusProvider);
    final search = stringValue?.isNotEmpty == true ? stringValue : null;

    // Providers for Received and Sent orders
    final incomingRequestsAsync = ref.watch(
      stockRequestsProvider(status: status, search: search),
    );
    final outgoingRequestsAsync = ref.watch(
      outgoingStockRequestsProvider(status: status, search: search),
    );

    final incomingBranchAsync = ref.watch(activeBranchProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth == 0 || constraints.maxHeight == 0) {
          return const SizedBox.shrink();
        }
        return DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (MediaQuery.of(context).size.width < 600)
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                    const Text(
                      'Orders',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: const Color(0xFF0078D4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[700],
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: "Incoming (Received)"),
                      Tab(text: "Outgoing (Sent)"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OrderStatusSelector(
                      selectedStatus: ref.watch(orderStatusProvider),
                      onStatusChanged: (newStatus) {
                        ref.read(orderStatusProvider.notifier).state =
                            newStatus;
                        ref
                            .read(requestStatusProvider.notifier)
                            .state = newStatus == OrderStatus.approved
                            ? RequestStatus.approved
                            : RequestStatus.pending;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    children: [
                      // TAB 1: Received Orders (Existing Logic)
                      _buildOrdersList(
                        ref,
                        incomingRequestsAsync,
                        incomingBranchAsync,
                        isIncoming: true,
                        status: status,
                        search: search,
                      ),
                      // TAB 2: Sent Orders (New Logic)
                      _buildOrdersList(
                        ref,
                        outgoingRequestsAsync,
                        incomingBranchAsync, // Using same branch context for now
                        isIncoming: false,
                        status: status,
                        search: search,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(
    WidgetRef ref,
    AsyncValue<List<InventoryRequest>> requestsAsync,
    AsyncValue<Branch?> branchAsync, {
    required bool isIncoming,
    required String status,
    String? search,
  }) {
    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return _buildEmptyState(ref, isIncoming, status, search);
        }

        return branchAsync.when(
          data: (currentBranch) {
            if (currentBranch == null) {
              return _buildErrorState(
                'Branch not found',
                'Could not load active branch',
                Icons.business,
                () => ref.refresh(activeBranchProvider),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCard(requests.length, isIncoming),
                  const SizedBox(height: 20),
                  Text(
                    isIncoming ? 'Received Orders' : 'My Requests',
                    style: const TextStyle(
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
                        incomingBranch: currentBranch,
                        isIncoming: isIncoming,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: _buildLoadingState,
          error: (err, stack) => _buildErrorState(
            'Error loading branch',
            err.toString(),
            Icons.business_center_outlined,
            () => ref.refresh(activeBranchProvider),
          ),
        );
      },
      loading: _buildLoadingState,
      error: (err, stack) => _buildErrorState(
        'Error loading requests',
        err.toString(),
        Icons.error_outline,
        () {
          ref.refresh(
            isIncoming
                ? stockRequestsProvider(status: status, search: search)
                : outgoingStockRequestsProvider(status: status, search: search),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(int orderCount, bool isIncoming) {
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
              isIncoming ? Icons.move_to_inbox : Icons.outbox,
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
                  orderCount == 1
                      ? (isIncoming ? 'Pending Request' : 'Sent Request')
                      : (isIncoming ? 'Pending Requests' : 'Sent Requests'),
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

  Widget _buildEmptyState(
    WidgetRef ref,
    bool isIncoming,
    String status,
    String? search,
  ) {
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
            child: Icon(
              isIncoming ? Icons.inbox_outlined : Icons.outbox_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isIncoming ? 'All caught up!' : 'No outgoing orders',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isIncoming
                ? 'No pending orders at the moment.\nNew requests will appear here.'
                : 'You haven\'t placed any orders yet.\nYour requests will appear here.',
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
                isIncoming
                    ? stockRequestsProvider(status: status, search: search)
                    : outgoingStockRequestsProvider(
                        status: status,
                        search: search,
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

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(
    String title,
    String message,
    IconData icon,
    VoidCallback onRetry,
  ) {
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
            onPressed: onRetry,
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
}
