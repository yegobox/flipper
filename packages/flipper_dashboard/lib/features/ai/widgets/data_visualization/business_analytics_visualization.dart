import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'visualization_interface.dart';

/// Visualization for business analytics data
class BusinessAnalyticsVisualization implements VisualizationInterface {
  final String data;
  final dynamic currencyService;
  final GlobalKey cardKey;
  final VoidCallback onCopyGraph;

  BusinessAnalyticsVisualization(this.data, this.currencyService, {required this.cardKey, required this.onCopyGraph});

  @override
  Widget build(BuildContext context, {String? currency}) {
    final theme = Theme.of(context);

    // Extract summary section for standard business analytics
    final summaryMatch =
        RegExp(r'\*\*\[SUMMARY\]\*\*(.*?)\*\*\[DETAILS\]\*\*', dotAll: true)
            .firstMatch(data);
    if (summaryMatch == null) return const SizedBox.shrink();

    final summaryText = summaryMatch.group(1)?.trim() ?? '';
    if (summaryText.isEmpty) return const SizedBox.shrink();

    // Parse values from summary
    final revenue = _extractValue(summaryText, 'Total Revenue');
    final profit = _extractValue(summaryText, 'Total Profit');
    final unitsSold = _extractValue(summaryText, 'Total Units Sold');

    if (revenue == null || profit == null || unitsSold == null) {
      return const SizedBox.shrink();
    }

    final formattedRevenue =
        currencyService.formatCurrencyValue(revenue, currency: currency);
    final formattedProfit =
        currencyService.formatCurrencyValue(profit, currency: currency);
    final formattedUnitsSold = unitsSold.toStringAsFixed(0);

    final summaryDisplay =
        'Summary: Total Revenue: $formattedRevenue, Total Profit: $formattedProfit, Total Units Sold: $formattedUnitsSold';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summaryDisplay,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black.withOpacity(0.87),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: revenue * 1.2,
                  barGroups: [
                    _createBarGroup(0, revenue),
                    _createBarGroup(1, profit),
                    _createBarGroup(2, unitsSold),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final titles = [
                            'Total Revenue',
                            'Total Profit',
                            'Total Units Sold'
                          ];
                          return Text(
                            titles[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool canVisualize(String data) {
    // Check if data contains business analytics summary section
    return RegExp(r'\*\*\[SUMMARY\]\*\*(.*?)\*\*\[DETAILS\]\*\*', dotAll: true)
        .hasMatch(data);
  }

  double? _extractValue(String text, String label) {
    final pattern = RegExp(
        r'^' + RegExp.escape(label) + r': \$?(\d+(?:,\d{3})*(?:\.\d+)?)',
        multiLine: true);
    final match = pattern.firstMatch(text);
    if (match == null) return null;
    return double.tryParse(match.group(1)?.replaceAll(',', '') ?? '');
  }

  BarChartGroupData _createBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          color: Colors.blue,
        ),
      ],
    );
  }
}
