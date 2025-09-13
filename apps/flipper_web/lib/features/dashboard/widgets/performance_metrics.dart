
import 'package:flutter/material.dart';

class PerformanceMetrics extends StatelessWidget {
  const PerformanceMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMetric(title: 'Gross sales', value: 'RWF 0'),
        _buildMetric(title: 'Transactions', value: '0'),
        _buildMetric(title: 'Labor % of net sales', value: '0.00%'),
        _buildMetric(title: 'Average sale', value: 'RWF 0'),
        _buildMetric(title: 'Comps & discounts', value: 'RWF 0'),
        _buildMetric(title: 'Tips', value: 'RWF 0'),
      ],
    );
  }

  Widget _buildMetric({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Chip(
          label: const Text('N/A'),
          avatar: const Icon(Icons.arrow_upward, size: 16),
          backgroundColor: Colors.grey.shade200,
        ),
      ],
    );
  }
}
