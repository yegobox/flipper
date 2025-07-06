import 'dart:convert';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'dart:math';
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

    final String currencyCode =
        data['currencyCode'] ?? '${ProxyService.box.defaultCurrency()}';

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
    final String date = data['date'] ?? 'Today';

    // Format values with commas for large numbers
    String formatNumber(double value) {
      return value.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }

    final formattedRevenue = '$currencyCode ${formatNumber(revenue)}';
    final formattedProfit = '$currencyCode ${formatNumber(profit)}';
    final formattedUnitsSold = formatNumber(unitsSold);

    // Determine if we need to scale values for visualization
    bool needsScaling =
        revenue > 1000000 || profit > 1000000 || unitsSold > 1000;
    double revenueDisplay = revenue;
    double profitDisplay = profit;
    double unitsDisplay = unitsSold;
    String scaleSuffix = '';

    if (needsScaling) {
      if (revenue > 1000000) {
        // Scale to millions
        revenueDisplay = revenue / 1000000;
        profitDisplay = profit / 1000000;
        scaleSuffix = ' (in millions)';
      } else if (revenue > 1000) {
        // Scale to thousands
        revenueDisplay = revenue / 1000;
        profitDisplay = profit / 1000;
        scaleSuffix = ' (in thousands)';
      }

      if (unitsSold > 1000) {
        unitsDisplay = unitsSold / 1000;
      }
    }

    final title = 'Business Analytics for $date';

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Summary cards in a row
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Revenue',
                    formattedRevenue,
                    Colors.blue.shade100,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Profit',
                    formattedProfit,
                    Colors.green.shade100,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Units Sold',
                    formattedUnitsSold,
                    Colors.orange.shade100,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (needsScaling)
              Text(
                'Chart values$scaleSuffix',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: [revenueDisplay, profitDisplay, unitsDisplay]
                          .reduce(max) *
                      1.2,
                  barGroups: [
                    _createBarGroup(0, revenueDisplay),
                    _createBarGroup(1, profitDisplay),
                    _createBarGroup(2, unitsDisplay),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final titles = ['Revenue', 'Profit', 'Units'];
                          return Text(
                            titles[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300],
                      strokeWidth: 1,
                    ),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build summary cards
  Widget _buildSummaryCard(
      String title, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
