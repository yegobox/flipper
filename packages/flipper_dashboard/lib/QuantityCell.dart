import 'package:flutter/material.dart';

class QuantityCell extends StatelessWidget {
  final double? quantity;
  final VoidCallback onEdit;

  const QuantityCell({required this.quantity, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Row(
        children: [
          Text(quantity.toString()),
          const Icon(Icons.edit),
        ],
      ),
    );
  }
}
