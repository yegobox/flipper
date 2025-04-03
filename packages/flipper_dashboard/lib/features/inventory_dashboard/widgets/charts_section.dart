import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartsSection extends StatelessWidget {
  const ChartsSection({
    Key? key,
    required this.inventoryByCategory,
  }) : super(key: key);

  final Map<String, int> inventoryByCategory;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inventory by Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _createPieChartSections(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildLegendItem(context, 'Dairy', Colors.blue),
                      _buildLegendItem(context, 'Bakery', Colors.red),
                      _buildLegendItem(context, 'Meat', Colors.amber),
                      _buildLegendItem(context, 'Produce', Colors.green),
                      _buildLegendItem(context, 'Beverages', Colors.purple),
                      _buildLegendItem(context, 'Frozen', Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stock Levels Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const titles = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun'
                                ];
                                final int index = value.toInt();
                                if (index >= 0 && index < titles.length) {
                                  return Text(titles[index]);
                                }
                                return const Text('');
                              },
                              reservedSize: 22,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(0.2),
                            ),
                            spots: const [
                              FlSpot(0, 300),
                              FlSpot(1, 350),
                              FlSpot(2, 290),
                              FlSpot(3, 320),
                              FlSpot(4, 370),
                              FlSpot(5, 400),
                            ],
                          ),
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.red.withOpacity(0.2),
                            ),
                            spots: const [
                              FlSpot(0, 200),
                              FlSpot(1, 230),
                              FlSpot(2, 210),
                              FlSpot(3, 240),
                              FlSpot(4, 250),
                              FlSpot(5, 270),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildLegendItem(context, 'Dairy Products', Colors.blue),
                      _buildLegendItem(context, 'Meat Products', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createPieChartSections() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.purple,
      Colors.teal,
    ];

    int i = 0;
    return inventoryByCategory.entries.map((entry) {
      final double value = entry.value.toDouble();
      final double total = inventoryByCategory.values
          .fold(0, (sum, value) => sum + value)
          .toDouble();
      final double percentage = value / total * 100;

      return PieChartSectionData(
        color: colors[i++ % colors.length],
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
