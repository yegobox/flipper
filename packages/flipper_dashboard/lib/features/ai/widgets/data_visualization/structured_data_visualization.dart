import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'visualization_interface.dart';

/// Visualization for structured data returned by AI
class StructuredDataVisualization implements VisualizationInterface {
  final String data;
  final dynamic currencyService;

  StructuredDataVisualization(this.data, this.currencyService);

  @override
  Widget build(BuildContext context, {String? currency}) {
    // Try to extract structured data JSON from the response
    final structuredData = _extractStructuredData(data);
    if (structuredData == null) {
      return const SizedBox.shrink();
    }

    // Check the visualization type
    final String? visualizationType = structuredData['type'];

    switch (visualizationType) {
      case 'tax':
        return _buildTaxVisualization(context, structuredData, currency);
      case 'business_analytics':
        return _buildBusinessAnalyticsVisualization(
            context, structuredData, currency);
      case 'inventory':
        return _buildInventoryVisualization(context, structuredData, currency);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  bool canVisualize(String data) {
    // Check if the data contains structured visualization data
    return _extractStructuredData(data) != null;
  }

  /// Extract structured data from the response
  Map<String, dynamic>? _extractStructuredData(String data) {
    try {
      // Look for JSON data between visualization markers
      final RegExp jsonRegex = RegExp(
          r'\{\{VISUALIZATION_DATA\}\}([\s\S]*?)\{\{\/VISUALIZATION_DATA\}\}');
      final match = jsonRegex.firstMatch(data);

      if (match != null && match.groupCount >= 1) {
        final jsonStr = match.group(1)?.trim();
        if (jsonStr != null && jsonStr.isNotEmpty) {
          return jsonDecode(jsonStr) as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Error extracting structured data: $e');
      return null;
    }
  }

  /// Build tax visualization from structured data
  Widget _buildTaxVisualization(
      BuildContext context, Map<String, dynamic> data, String? currency) {
    // Extract data from the structured format
    final String title = data['title'] ?? 'Tax Summary';
    final String date = data['date'] ?? 'Today';

    // Handle totalTax more robustly to prevent failures
    double totalTax = 0.0;
    final dynamic rawTotalTax = data['totalTax'];
    if (rawTotalTax != null) {
      if (rawTotalTax is num) {
        totalTax = rawTotalTax.toDouble();
      } else if (rawTotalTax is String) {
        // Try to parse string to double, removing any non-numeric characters except decimal point
        final cleanedStr = rawTotalTax.replaceAll(RegExp(r'[^\d.]'), '');
        try {
          totalTax = double.parse(cleanedStr);
        } catch (e) {
          print('Error parsing totalTax: $e');
        }
      }
    }

    final String currencyCode = data['currencyCode'] ?? 'RWF';

    // Include date in title if available
    final String displayTitle = date.isNotEmpty ? '$title for $date' : title;
    final List<dynamic> items = data['items'] ?? [];

    // Prepare data for pie chart
    final pieChartSections = <PieChartSectionData>[];
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    // Group and sort items by tax amount
    final Map<String, double> itemTaxContributions = {};
    for (final item in items) {
      final String name = item['name'] ?? 'Unknown';

      // Handle taxAmount more robustly
      double taxAmount = 0.0;
      final dynamic rawTaxAmount = item['taxAmount'];
      if (rawTaxAmount != null) {
        if (rawTaxAmount is num) {
          taxAmount = rawTaxAmount.toDouble();
        } else if (rawTaxAmount is String) {
          // Try to parse string to double, removing any non-numeric characters except decimal point
          final cleanedStr = rawTaxAmount.replaceAll(RegExp(r'[^\d.]'), '');
          try {
            taxAmount = double.parse(cleanedStr);
          } catch (e) {
            print('Error parsing item taxAmount: $e');
          }
        }
      }

      if (taxAmount > 0) {
        // Group by main product name (before comma if present)
        final mainProductName = name.split(',').first.trim();

        if (itemTaxContributions.containsKey(mainProductName)) {
          itemTaxContributions[mainProductName] =
              (itemTaxContributions[mainProductName] ?? 0) + taxAmount;
        } else {
          itemTaxContributions[mainProductName] = taxAmount;
        }
      }
    }

    // Sort by contribution (highest first)
    final sortedItems = itemTaxContributions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Determine visualization approach based on number of items
    final bool usePieChart = sortedItems.length <= 6;

    // For pie chart, limit to top 5 + Other
    List<MapEntry<String, double>> pieChartItems = [];
    if (usePieChart) {
      pieChartItems = List.from(sortedItems);
      if (pieChartItems.length > 5) {
        // Group smaller items as "Other"
        double otherTaxes = 0.0;
        for (int i = 5; i < pieChartItems.length; i++) {
          otherTaxes += pieChartItems[i].value;
        }

        // Keep only top 5 items
        pieChartItems = pieChartItems.sublist(0, 5);

        // Add "Other" category if needed
        if (otherTaxes > 0) {
          pieChartItems.add(MapEntry('Other Items', otherTaxes));
        }
      }

      // Create pie chart sections
      for (int i = 0; i < pieChartItems.length; i++) {
        final item = pieChartItems[i];
        final percentage = (item.value / totalTax) * 100;

        pieChartSections.add(
          PieChartSectionData(
            color: colors[i % colors.length],
            value: item.value,
            title: percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      }
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total: $currencyCode ${totalTax.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (usePieChart) ...[
              // Pie chart for fewer items
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Legend for pie chart
              Wrap(
                spacing: 16.0,
                runSpacing: 8.0,
                children: [
                  for (int i = 0; i < pieChartItems.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          color: colors[i % colors.length],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${pieChartItems[i].key}: $currencyCode ${pieChartItems[i].value.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                ],
              ),
            ] else ...[
              // Bar chart for many items
              SizedBox(
                height: sortedItems.length *
                    30.0, // Dynamic height based on number of items
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedItems.length,
                  itemBuilder: (context, index) {
                    final item = sortedItems[index];
                    final percentage = (item.value / totalTax) * 100;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item.key,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '$currencyCode ${item.value.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: percentage / 100,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: colors[index % colors.length],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build business analytics visualization from structured data
  Widget _buildBusinessAnalyticsVisualization(
      BuildContext context, Map<String, dynamic> data, String? currency) {
    final theme = Theme.of(context);

    // Extract data from the structured format with robust parsing
    double revenue = 0.0;
    double profit = 0.0;
    double unitsSold = 0.0;

    // Parse revenue safely
    final dynamic rawRevenue = data['revenue'];
    if (rawRevenue != null) {
      if (rawRevenue is num) {
        revenue = rawRevenue.toDouble();
      } else if (rawRevenue is String) {
        final cleanedStr = rawRevenue.replaceAll(RegExp(r'[^\d.]'), '');
        try {
          revenue = double.parse(cleanedStr);
        } catch (e) {
          print('Error parsing revenue: $e');
        }
      }
    }

    // Parse profit safely
    final dynamic rawProfit = data['profit'];
    if (rawProfit != null) {
      if (rawProfit is num) {
        profit = rawProfit.toDouble();
      } else if (rawProfit is String) {
        final cleanedStr = rawProfit.replaceAll(RegExp(r'[^\d.]'), '');
        try {
          profit = double.parse(cleanedStr);
        } catch (e) {
          print('Error parsing profit: $e');
        }
      }
    }

    // Parse units sold safely
    final dynamic rawUnitsSold = data['unitsSold'];
    if (rawUnitsSold != null) {
      if (rawUnitsSold is num) {
        unitsSold = rawUnitsSold.toDouble();
      } else if (rawUnitsSold is String) {
        final cleanedStr = rawUnitsSold.replaceAll(RegExp(r'[^\d.]'), '');
        try {
          unitsSold = double.parse(cleanedStr);
        } catch (e) {
          print('Error parsing unitsSold: $e');
        }
      }
    }
    final String currencyCode = data['currencyCode'] ?? currency ?? 'USD';

    // Format values
    final formattedRevenue =
        currencyService.formatCurrencyValue(revenue, currency: currency) ??
            '$currencyCode ${revenue.toStringAsFixed(2)}';
    final formattedProfit =
        currencyService.formatCurrencyValue(profit, currency: currency) ??
            '$currencyCode ${profit.toStringAsFixed(2)}';
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

  /// Build inventory visualization from structured data
  Widget _buildInventoryVisualization(
      BuildContext context, Map<String, dynamic> data, String? currency) {
    // Implement inventory visualization
    // This is a placeholder for future implementation
    return const Center(child: Text('Inventory Visualization'));
  }

  /// Helper method to create bar chart groups
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
