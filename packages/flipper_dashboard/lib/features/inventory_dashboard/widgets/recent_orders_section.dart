import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inventory_models.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({
    Key? key,
    required this.reorderHistory,
  }) : super(key: key);

  final List<ReorderHistory> reorderHistory;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reorderHistory.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = reorderHistory[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        _getStatusColor(order.status).withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(order.status),
                      color: _getStatusColor(order.status),
                    ),
                  ),
                  title: Text(order.itemName),
                  subtitle: Text(
                    'Order #${order.id} - ${DateFormat('MMM dd, yyyy').format(order.date)}',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusText(order.status),
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.inTransit:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Icons.check_circle_outline;
      case OrderStatus.inTransit:
        return Icons.local_shipping_outlined;
      case OrderStatus.processing:
        return Icons.pending_outlined;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
