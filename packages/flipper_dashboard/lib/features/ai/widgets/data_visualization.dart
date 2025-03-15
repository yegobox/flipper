import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Created a new DataVisualization widget that:
// Detects structured data in the message format **[SUMMARY]** followed by key-value pairs
// Automatically parses numerical data from the summary section
// Renders a beautiful bar chart using fl_chart for easy data visualization
// Updated the MessageBubble widget to:
// Include data visualization support for AI responses (non-user messages)
// Maintain the existing message styling and functionality
// Automatically show charts when structured data is detected
// The visualization will automatically appear when the AI response contains data in this format:
// **[SUMMARY]**
// Total Revenue: $3,002,663.24
// Total Profit: $576,784.92
// Total Units Sold: 83,621
// **[DETAILS]**
// ...
class DataVisualization extends StatelessWidget {
  final String data;

  const DataVisualization({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      if (data.contains('**[SUMMARY]**')) {
        return _buildSummaryChart(data, context);
      }
      return const SizedBox.shrink();
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildSummaryChart(String data, BuildContext context) {
    try {
      // Extract summary data
      final summaryMatch =
          RegExp(r'\*\*\[SUMMARY\]\*\*(.*?)\*\*\[DETAILS\]\*\*', dotAll: true)
              .firstMatch(data);

      if (summaryMatch == null) return const SizedBox.shrink();

      final summaryText = summaryMatch.group(1)?.trim() ?? '';
      final lines = summaryText.split('\n');

      // Parse values
      final values = <String, double>{};
      for (var line in lines) {
        if (line.isEmpty) continue;
        final parts = line.split(':');
        if (parts.length != 2) continue;

        final key = parts[0].trim();
        final valueStr = parts[1].trim().replaceAll(RegExp(r'[^\d.]'), '');
        final value = double.tryParse(valueStr);
        if (value != null) {
          values[key] = value;
        }
      }

      if (values.isEmpty) return const SizedBox.shrink();

      return Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: values.values.reduce((a, b) => a > b ? a : b) * 1.2,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value < 0 || value >= values.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                values.keys.elementAt(value.toInt()),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    barGroups: values.entries
                        .map(
                          (e) => BarChartGroupData(
                            x: values.keys.toList().indexOf(e.key),
                            barRods: [
                              BarChartRodData(
                                toY: e.value,
                                color: Theme.of(context).primaryColor,
                                width: 20,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
