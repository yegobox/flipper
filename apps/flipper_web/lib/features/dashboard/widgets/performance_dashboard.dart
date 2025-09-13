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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildFilterChip('Date', 'Sep 13', isSelected: false),
                const SizedBox(width: 12),
                _buildFilterChip('vs', 'Prior day', isSelected: false),
                const SizedBox(width: 12),
                _buildFilterChip('Checks', 'Closed', isSelected: false),
              ],
            ),
            const SizedBox(height: 32),
            const SalesChart(),
            const SizedBox(height: 32),
            const PerformanceMetrics(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value, {
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
        color: isSelected ? Colors.blue[50] : Colors.white,
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
