import 'package:flipper_web/features/dashboard/widgets/performance_metrics.dart';
import 'package:flipper_web/features/dashboard/widgets/sales_chart.dart';
import 'package:flutter/material.dart';

class PerformanceDashboard extends StatelessWidget {
  const PerformanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildFilterChip(label: 'Date', value: 'Sep 13'),
                const SizedBox(width: 8),
                const Text('vs'),
                const SizedBox(width: 8),
                _buildFilterChip(label: 'Prior day'),
                const SizedBox(width: 16),
                _buildFilterChip(label: 'Checks', value: 'Closed'),
              ],
            ),
            const SizedBox(height: 24),
            const SalesChart(),
            const SizedBox(height: 24),
            const PerformanceMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({required String label, String? value}) {
    return ActionChip(
      label: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: value != null ? '$label: ' : label,
              style: const TextStyle(color: Colors.grey),
            ),
            if (value != null)
              TextSpan(
                text: value,
                style: const TextStyle(color: Colors.black),
              ),
          ],
        ),
      ),
      onPressed: () {},
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
