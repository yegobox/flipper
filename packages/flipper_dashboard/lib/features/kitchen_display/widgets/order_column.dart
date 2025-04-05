import 'package:flipper_dashboard/features/kitchen_display/providers/kitchen_display_provider.dart';
import 'package:flipper_dashboard/features/kitchen_display/widgets/order_card.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';

class OrderColumn extends StatelessWidget {
  final String title;
  final List<ITransaction> orders;
  final Color color;
  final OrderStatus status;
  final Function(ITransaction, OrderStatus) onOrderAccepted;

  const OrderColumn({
    Key? key,
    required this.title,
    required this.orders,
    required this.color,
    required this.status,
    required this.onOrderAccepted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<Map<String, dynamic>>(
      onAccept: (data) {
        final order = data['order'] as ITransaction;
        final fromStatus = data['fromStatus'] as OrderStatus;
        onOrderAccepted(order, fromStatus);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${orders.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: orders.isEmpty
                    ? Center(
                        child: Text(
                          'No orders',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Draggable<Map<String, dynamic>>(
                            data: {
                              'order': order,
                              'fromStatus': status,
                            },
                            feedback: SizedBox(
                              width: 280,
                              child: OrderCard(
                                order: order,
                                borderColor: color,
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.5,
                              child: OrderCard(
                                order: order,
                                borderColor: color,
                              ),
                            ),
                            child: OrderCard(
                              order: order,
                              borderColor: color,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
