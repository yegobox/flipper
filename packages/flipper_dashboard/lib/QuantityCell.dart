import 'package:flutter/material.dart';

class QuantityCell extends StatelessWidget {
  final double? quantity;

  /// Null makes the cell read-only (a service carries no stock).
  final VoidCallback? onEdit;

  const QuantityCell({required this.quantity, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        children: [
          Text(quantity.toString()),
          if (onEdit != null) const Icon(Icons.edit),
        ],
      ),
    );
  }
}
