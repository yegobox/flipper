import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  Text('9', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                  Text('1', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    '2pm',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
