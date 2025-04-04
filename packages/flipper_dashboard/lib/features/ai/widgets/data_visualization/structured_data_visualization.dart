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
        return _buildBusinessAnalyticsVisualization(context, structuredData, currency);
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
      final RegExp jsonRegex = RegExp(r'\{\{VISUALIZATION_DATA\}\}([\s\S]*?)\{\{\/VISUALIZATION_DATA\}\}');
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
  Widget _buildTaxVisualization(BuildContext context, Map<String, dynamic> data, String? currency) {
    final theme = Theme.of(context);
    
    // Extract data from the structured format
    final String title = data['title'] ?? 'Tax Summary';
    final String date = data['date'] ?? 'Today';
    final double totalTax = data['totalTax']?.toDouble() ?? 0.0;
    final String currencyCode = data['currencyCode'] ?? 'RWF';
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
      final double taxAmount = item['taxAmount']?.toDouble() ?? 0.0;
      
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
    
    // Sort by contribution (highest first) and limit to top 5
    final sortedItems = itemTaxContributions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (sortedItems.length > 5) {
      // Group smaller items as "Other"
      double otherTaxes = 0.0;
      for (int i = 5; i < sortedItems.length; i++) {
        otherTaxes += sortedItems[i].value;
      }
      
      // Keep only top 5 items
      sortedItems.removeRange(5, sortedItems.length);
      
      // Add "Other" category if needed
      if (otherTaxes > 0) {
        sortedItems.add(MapEntry('Other Items', otherTaxes));
      }
    }
    
    // Create pie chart sections
    for (int i = 0; i < sortedItems.length; i++) {
      final item = sortedItems[i];
      final percentage = (item.value / totalTax) * 100;
      
      pieChartSections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: item.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title for $date',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Total: $currencyCode ${totalTax.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (sortedItems.isNotEmpty) // Conditionally show pie chart
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: pieChartSections,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(sortedItems.length, (index) {
                            final item = sortedItems[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    color: colors[index % colors.length],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.key,
                                      style: theme.textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$currencyCode ${item.value.toStringAsFixed(0)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build business analytics visualization from structured data
  Widget _buildBusinessAnalyticsVisualization(BuildContext context, Map<String, dynamic> data, String? currency) {
    final theme = Theme.of(context);
    
    // Extract data from the structured format
    final double revenue = data['revenue']?.toDouble() ?? 0.0;
    final double profit = data['profit']?.toDouble() ?? 0.0;
    final double unitsSold = data['unitsSold']?.toDouble() ?? 0.0;
    final String currencyCode = data['currencyCode'] ?? currency ?? 'USD';
    
    // Format values
    final formattedRevenue = currencyService.formatCurrencyValue(revenue, currency: currency) ?? 
        '$currencyCode ${revenue.toStringAsFixed(2)}';
    final formattedProfit = currencyService.formatCurrencyValue(profit, currency: currency) ?? 
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
  Widget _buildInventoryVisualization(BuildContext context, Map<String, dynamic> data, String? currency) {
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
