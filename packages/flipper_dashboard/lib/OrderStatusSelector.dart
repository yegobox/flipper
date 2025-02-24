import 'package:flipper_dashboard/checkout.dart';
import 'package:flutter/material.dart';

class OrderStatusSelector extends StatelessWidget {
  final OrderStatus selectedStatus;
  final Function(OrderStatus) onStatusChanged;

  const OrderStatusSelector({
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SegmentedButton<OrderStatus>(
        style: _getButtonStyle(context),
        segments: const [
          ButtonSegment<OrderStatus>(
            value: OrderStatus.pending,
            label: Text('Pending'),
            icon: Icon(Icons.hourglass_empty),
          ),
          ButtonSegment<OrderStatus>(
            value: OrderStatus.approved,
            label: Text('Approved'),
            icon: Icon(Icons.check_circle_outline),
          ),
        ],
        selected: {selectedStatus},
        onSelectionChanged: (newSelection) {
          onStatusChanged(newSelection.first);
        },
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Theme.of(context).colorScheme.primary;
          }
          return Colors.white;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Theme.of(context).colorScheme.primary;
        },
      ),
      side: WidgetStateProperty.all(
        BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
