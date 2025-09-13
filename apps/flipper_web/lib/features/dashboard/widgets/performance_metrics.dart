import 'package:flutter/material.dart';

class PerformanceMetrics extends StatelessWidget {
  const PerformanceMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            'Performance',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Filter chips row
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

          // Main Net Sales section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Net sales',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'RWF 0',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.arrow_upward, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'N/A',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Chart placeholder section
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No data available for selected timeframe',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                // Time legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('Today', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Fri, Sep 12, 2025',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Time axis
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      '8am',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '9',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '10',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '11',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '12pm',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '1',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '2pm',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Metrics Grid
          GridView.count(
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
          ),
        ],
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

  Widget _buildMetric({required String title, required String value}) {
    return Column(
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
    );
  }
}
