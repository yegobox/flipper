import 'package:flutter/material.dart';

class PerformanceMetrics extends StatelessWidget {
  const PerformanceMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      mainAxisSpacing: 24,
      crossAxisSpacing: 24,
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
    return InkWell(
      onTap: () {},
      hoverColor: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.arrow_upward, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'N/A',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
