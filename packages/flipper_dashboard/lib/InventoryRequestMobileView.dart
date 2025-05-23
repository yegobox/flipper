import 'package:flipper_dashboard/NoOrderPlaceholder.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class InventoryRequestMobileView extends ConsumerStatefulWidget {
  const InventoryRequestMobileView({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryRequestMobileView> createState() =>
      _InventoryRequestMobileViewState();
}

class _InventoryRequestMobileViewState
    extends ConsumerState<InventoryRequestMobileView>
    with StockRequestApprovalLogic {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final stockRequests =
        ref.watch(stockRequestsProvider((filter: _selectedFilter)));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stock Requests',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Track request status',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('pending', 'Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('approved', 'Approved'),
                  const SizedBox(width: 8),
                  _buildFilterChip('partiallyApproved', 'Partially'),
                  const SizedBox(width: 8),
                  _buildFilterChip('rejected', 'Rejected'),
                  const SizedBox(width: 8),
                  _buildFilterChip('fulfilled', 'Fulfilled'),
                ],
              ),
            ),
          ),
          Expanded(
            child: stockRequests.when(
              data: (requests) {
                if (requests.isEmpty) {
                  return buildNoOrdersPlaceholder();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: requests.length,
                  itemBuilder: (context, index) =>
                      _buildRequestCard(requests[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    const Text(
                      'Error loading requests',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      selected: isSelected,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.white,
      selectedColor: Theme.of(context).colorScheme.primary,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildRequestCard(InventoryRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Request #${request.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusBadge(request.status ?? 'pending'),
                  ],
                ),
                const SizedBox(height: 12),

                // Branch information
                Row(
                  children: [
                    Icon(Icons.store, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FutureBuilder<Branch?>(
                        future: Future.value(ProxyService.strategy
                            .branch(serverId: request.mainBranchId!)),
                        builder: (context, snapshot) {
                          final mainBranchName =
                              snapshot.data?.name ?? 'Loading...';
                          return Text(
                            'From: $mainBranchName',
                            style: TextStyle(color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.store, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FutureBuilder<Branch?>(
                        future: Future.value(ProxyService.strategy
                            .branch(serverId: request.subBranchId!)),
                        builder: (context, snapshot) {
                          final subBranchName =
                              snapshot.data?.name ?? 'Loading...';
                          return Text(
                            'To: $subBranchName',
                            style: TextStyle(color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Created: ${DateFormat('MMM dd, yyyy').format(request.createdAt ?? DateTime.now())}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),

                if (request.deliveryDate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_shipping,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Delivery: ${DateFormat('MMM dd, yyyy').format(request.deliveryDate!)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],

                // Items count
                const SizedBox(height: 8),
                FutureBuilder<List<TransactionItem>>(
                  future: Future.value(ProxyService.strategy
                      .transactionItems(requestId: request.id)),
                  builder: (context, snapshot) {
                    final itemCount = snapshot.data?.length ?? 0;
                    return Row(
                      children: [
                        Icon(Icons.inventory_2,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Items: $itemCount',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    );
                  },
                ),

                // Note if available
                if (request.orderNote != null &&
                    request.orderNote!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.note, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            request.orderNote!,
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (request.status == 'fulfilled') ...[
                  _buildDeliveryConfirmation(request),
                ] else ...[
                  TextButton(
                    onPressed: () {
                      // View details logic
                    },
                    child: const Text('View Details'),
                  ),
                  const SizedBox(width: 8),
                  if (request.status == 'pending') ...[
                    FilledButton(
                      onPressed: () =>
                          approveRequest(request: request, context: context),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text('Approve'),
                    ),
                  ] else if (request.status == 'partiallyApproved') ...[
                    FilledButton(
                      onPressed: () =>
                          approveRequest(request: request, context: context),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Complete Approval'),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryConfirmation(InventoryRequest request) {
    final isDelivered = request.customerReceivedOrder == true;
    final isConfirmationRequested =
        request.driverRequestDeliveryConfirmation == true;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isDelivered ? Icons.check_circle : Icons.pending,
          color: isDelivered ? Colors.green : Colors.orange,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          isDelivered
              ? 'Delivered'
              : isConfirmationRequested
                  ? 'Awaiting Confirmation'
                  : 'Pending Delivery',
          style: TextStyle(
            color: isDelivered ? Colors.green : Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final colors = {
      'approved': Colors.green,
      'pending': Colors.orange,
      'partiallyApproved': Colors.blue,
      'rejected': Colors.red,
      'fulfilled': Colors.purple,
    };

    final labels = {
      'partiallyApproved': 'PARTIAL',
      'approved': 'APPROVED',
      'pending': 'PENDING',
      'rejected': 'REJECTED',
      'fulfilled': 'FULFILLED',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors[status]?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        labels[status] ?? status.toUpperCase(),
        style: TextStyle(
          color: colors[status],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
