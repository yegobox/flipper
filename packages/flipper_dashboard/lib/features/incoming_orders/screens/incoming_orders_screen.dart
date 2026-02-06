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

import 'package:flipper_dashboard/features/incoming_orders/widgets/bulk_action_bar.dart';
import 'package:flipper_models/providers/selection_provider.dart';

class IncomingOrdersScreen extends HookConsumerWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stringValue = ref.watch(stringProvider);
    final status = ref.watch(requestStatusProvider);
    final search = stringValue?.isNotEmpty == true ? stringValue : null;

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
        final isMobile = constraints.maxWidth < 600;
        final isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

        return DefaultTabController(
          length: 2,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context, ref, isMobile, isTablet),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildOrdersList(
                          ref,
                          incomingRequestsAsync,
                          incomingBranchAsync,
                          isIncoming: true,
                          status: status,
                          search: search,
                        ),
                        _buildOrdersList(
                          ref,
                          outgoingRequestsAsync,
                          incomingBranchAsync,
                          isIncoming: false,
                          status: status,
                          search: search,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(bottom: 0, left: 0, right: 0, child: BulkActionBar()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 12 : 24,
              isMobile ? 12 : 20,
              isMobile ? 12 : 24,
              isMobile ? 8 : 16,
            ),
            child: Row(
              children: [
                if (isMobile)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.maybePop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (isMobile) const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orders Management',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      if (!isMobile) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Track and manage incoming and outgoing orders',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 16),
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 24,
              vertical: isMobile ? 8 : 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: isMobile ? 44 : 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(isMobile ? 22 : 24),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: const Color(0xFF0078D4),
                        borderRadius: BorderRadius.circular(isMobile ? 22 : 24),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[700],
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 13 : 15,
                      ),
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.move_to_inbox, size: 18),
                              if (!isMobile) ...[
                                const SizedBox(width: 8),
                                const Text('Incoming'),
                              ],
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.outbox, size: 18),
                              if (!isMobile) ...[
                                const SizedBox(width: 8),
                                const Text('Outgoing'),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isMobile) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showMobileFilterSheet(context, ref),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMobileFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            OrderStatusSelector(
              selectedStatus: ref.watch(orderStatusProvider),
              onStatusChanged: (newStatus) {
                ref.read(orderStatusProvider.notifier).state = newStatus;
                ref
                    .read(requestStatusProvider.notifier)
                    .state = newStatus == OrderStatus.approved
                    ? RequestStatus.approved
                    : RequestStatus.pending;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
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
            return LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (isIncoming &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      ref
                          .read(
                            stockRequestsProvider(
                              status: status,
                              search: search,
                            ).notifier,
                          )
                          .loadMore();
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 12 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsCard(requests.length, isIncoming, isMobile),
                        const SizedBox(height: 20),
                        Text(
                          isIncoming ? 'Received Orders' : 'My Requests',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: requests.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: isMobile ? 8 : 12),
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
                  ),
                );
              },
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

  Widget _buildStatsCard(int orderCount, bool isIncoming, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0078D4).withOpacity(0.05),
            const Color(0xFF0078D4).withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0078D4).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0078D4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncoming ? Icons.move_to_inbox : Icons.outbox,
              color: Colors.white,
              size: isMobile ? 20 : 24,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$orderCount',
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  orderCount == 1
                      ? (isIncoming ? 'Pending Request' : 'Sent Request')
                      : (isIncoming ? 'Pending Requests' : 'Sent Requests'),
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12,
              vertical: isMobile ? 5 : 6,
            ),
            decoration: BoxDecoration(
              color: orderCount > 0
                  ? const Color(0xFF58D68D)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              orderCount > 0 ? 'Active' : 'Idle',
              style: TextStyle(
                color: orderCount > 0 ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 11 : 12,
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
