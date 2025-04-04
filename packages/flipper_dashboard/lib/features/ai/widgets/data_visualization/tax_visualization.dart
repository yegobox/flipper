import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'visualization_interface.dart';

/// Visualization for tax data
class TaxVisualization implements VisualizationInterface {
  final String data;
  final dynamic currencyService;

  TaxVisualization(this.data, this.currencyService);

  @override
  Widget build(BuildContext context, {String? currency}) {
    final theme = Theme.of(context);

    // Attempt to extract total tax from the "Total Tax Payable" format
    final totalTaxPayableMatch =
        RegExp(r'Total Tax Payable .*?\*\*RWF ([\d,\.]+)\*\*').firstMatch(data);

    // Attempt to extract total tax from the "Total: RWF" format
    final totalTaxMatch =
        RegExp(r'Total: RWF\s*([\d,\.]+)\s*').firstMatch(data);

    final totalTaxStr = totalTaxPayableMatch?.group(1)?.replaceAll(',', '') ??
        totalTaxMatch?.group(1)?.replaceAll(',', '');

    final totalTax =
        totalTaxStr != null ? double.tryParse(totalTaxStr) ?? 0.0 : 0.0;

    // Extract date information
    final dateMatch =
        RegExp(r'Tax Summary for\s*(\d{2}/\d{2}/\d{4})').firstMatch(data);
    final dateStr = dateMatch?.group(1) ?? 'Today';

    // Attempt to extract tax breakdown by item
    final taxBreakdownRegex = RegExp(
        r'\|\s*([^|]+)\s*\|\s*([\d,.]+)\s*\|\s*(\d+)\s*\|\s*(\d+)%\s*\|\s*([\d,.]+)\s*\|');
    final matches = taxBreakdownRegex.allMatches(data);

    // Group similar items and calculate their tax contributions
    final Map<String, double> itemTaxContributions = {};
    double otherTaxes = 0.0;

    for (final match in matches) {
      final itemName = match.group(1)?.trim() ?? 'Unknown';
      final taxAmountStr = match.group(5)?.replaceAll(',', '') ?? '0';
      final taxAmount = double.tryParse(taxAmountStr) ?? 0.0;

      // Skip the total row
      if (itemName.toLowerCase().contains('total')) continue;

      // Group by main product name (before comma if present)
      final mainProductName = itemName.split(',').first.trim();

      if (taxAmount > 0) {
        if (itemTaxContributions.containsKey(mainProductName)) {
          itemTaxContributions[mainProductName] =
              (itemTaxContributions[mainProductName] ?? 0) + taxAmount;
        } else {
          // Only keep top 4 items separately, group others as 'Other'
          if (itemTaxContributions.length < 4) {
            itemTaxContributions[mainProductName] = taxAmount;
          } else {
            otherTaxes += taxAmount;
          }
        }
      }
    }

    // Add 'Other' category if needed
    if (otherTaxes > 0) {
      itemTaxContributions['Other Items'] = otherTaxes;
    }

    // Sort by contribution (highest first)
    final sortedItems = itemTaxContributions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Prepare data for pie chart
    final pieChartSections = <PieChartSectionData>[];
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

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
                  'Tax Summary for $dateStr',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Total: RWF ${totalTax.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (itemTaxContributions.isNotEmpty) // Conditionally show pie chart
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
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
                                    'RWF ${item.value.toStringAsFixed(0)}',
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

  @override
  bool canVisualize(String data) {
    // Check for tax-related keywords in the response
    return data.contains('Tax Summary') || data.contains('Tax Payable');
  }
}
