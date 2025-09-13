
import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Net sales', style: TextStyle(color: Colors.grey)),
        const Text(
          'RWF 0',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Chip(
          label: const Text('N/A'),
          avatar: Icon(Icons.arrow_upward, size: 16),
          backgroundColor: Colors.grey.shade200,
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text('No data available for selected timeframe'),
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Icon(Icons.circle, color: Colors.blue, size: 12),
            SizedBox(width: 4),
            Text('Today'),
            SizedBox(width: 16),
            Icon(Icons.circle, color: Color(0xFFB3E5FC), size: 12),
            SizedBox(width: 4),
            Text('Fri, Sep 12, 2025'),
          ],
        )
      ],
    );
  }
}
