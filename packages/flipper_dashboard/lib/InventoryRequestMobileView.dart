import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InventoryRequestMobileView extends StatefulWidget {
  const InventoryRequestMobileView({Key? key}) : super(key: key);

  @override
  State<InventoryRequestMobileView> createState() =>
      _InventoryRequestMobileViewState();
}

class _InventoryRequestMobileViewState
    extends State<InventoryRequestMobileView> {
  String _selectedFilter = 'all';

  // Mock data focusing on status
  final List<Map<String, dynamic>> requests = [
    {
      'id': 'REQ001',
      'status': 'approved',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'deliveryDate': DateTime.now().add(const Duration(days: 1)),
      'mainBranchId': 1,
      'subBranchId': 2,
      'driverId': 101,
      'customerReceivedOrder': false,
      'driverRequestDeliveryConfirmation': false,
      'financing': {
        'requested': true,
        'status': 'approved',
        'bankName': 'ABC Bank',
        'amount': 50000,
        'approvalDate': DateTime.now().subtract(const Duration(hours: 12)),
        'interestRate': 5.5,
      }
    },
    {
      'id': 'REQ002',
      'status': 'pending',
      'createdAt': DateTime.now().toUtc(),
      'mainBranchId': 3,
      'financing': {
        'requested': true,
        'status': 'pending',
        'bankName': 'XYZ Bank',
        'amount': 75000,
      }
    },
    {
      'id': 'REQ003',
      'status': 'partiallyApproved',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'deliveryDate': DateTime.now().add(const Duration(days: 3)),
      'mainBranchId': 2,
      'financing': {
        'requested': true,
        'status': 'rejected',
        'bankName': 'DEF Bank',
        'amount': 100000,
        'rejectionReason': 'Insufficient credit history'
      }
    }
  ];

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) =>
                  _buildRequestCard(requests[index]),
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

  Widget _buildRequestCard(Map<String, dynamic> request) {
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
                      'Request #${request['id']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildStatusBadge(request['status']),
                  ],
                ),
                const SizedBox(height: 12),

                // ... [Previous request details remain the same] ...

                if (request['financing'] != null &&
                    request['financing']['requested'] == true) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildFinancingInfo(request['financing']),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          OverflowBar(
            //buttonPadding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (request['status'] == 'fulfilled') ...[
                _buildDeliveryConfirmation(request),
              ] else ...[
                if (request['financing']?['status'] == 'approved')
                  _buildFinancingBadge(),
                TextButton(
                  onPressed: () {},
                  child: const Text('View Details'),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Update Status'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancingInfo(Map<String, dynamic> financing) {
    final statusColors = {
      'approved': Colors.green,
      'pending': Colors.orange,
      'rejected': Colors.red,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.account_balance, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Financing',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              financing['bankName'],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColors[financing['status']]?.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                financing['status'].toUpperCase(),
                style: TextStyle(
                  color: statusColors[financing['status']],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Amount: ${NumberFormat.currency(symbol: '\$').format(financing['amount'])}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        if (financing['status'] == 'approved' &&
            financing['interestRate'] != null) ...[
          const SizedBox(height: 4),
          Text(
            'Interest Rate: ${financing['interestRate']}%',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Approved: ${DateFormat('MMM dd, yyyy').format(financing['approvalDate'])}',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
        if (financing['status'] == 'rejected' &&
            financing['rejectionReason'] != null) ...[
          const SizedBox(height: 4),
          Text(
            'Reason: ${financing['rejectionReason']}',
            style: TextStyle(color: Colors.red[300]),
          ),
        ],
      ],
    );
  }

  Widget _buildFinancingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
          const SizedBox(width: 4),
          Text(
            'FINANCED',
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryConfirmation(Map<String, dynamic> request) {
    final isDelivered = request['customerReceivedOrder'] == true;
    final isConfirmationRequested =
        request['driverRequestDeliveryConfirmation'] == true;

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
