import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'visualization_interface.dart';

/// QuickBooks-inspired Tax Visualization with modern design and enhanced features
class TaxVisualization implements VisualizationInterface {
  final String data;
  final dynamic currencyService;
  final GlobalKey cardKey;
  final VoidCallback onCopyGraph;

  TaxVisualization(this.data, this.currencyService,
      {required this.cardKey, required this.onCopyGraph});

  /// Color palette inspired by QuickBooks
  static const List<Color> _qbColors = [
    Color(0xFF0077C5), // QuickBooks Blue
    Color(0xFF2CA01C), // Success Green
    Color(0xFFFF6B35), // Warning Orange
    Color(0xFF6B46C1), // Purple
    Color(0xFF059669), // Emerald
    Color(0xFFDC2626), // Red
    Color(0xFF7C3AED), // Violet
    Color(0xFF0891B2), // Cyan
  ];

  /// Enhanced legend with QuickBooks styling
  Widget _buildModernLegend(ThemeData theme,
      List<MapEntry<String, double>> sortedItems, List<Color> colors,
      {required double totalTax}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0077C5).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'TAX BREAKDOWN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0077C5),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            math.min(sortedItems.length, 8),
            (index) {
              final item = sortedItems[index];
              final percentage = totalTax > 0
                  ? ((item.value / totalTax) * 100).toStringAsFixed(1)
                  : '0.0';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors[index % colors.length].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors[index % colors.length],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.key,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$percentage% of total',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'RWF ${_formatCurrency(item.value)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          if (sortedItems.length > 8)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '+ ${sortedItems.length - 8} more categories',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Enhanced summary cards
  Widget _buildSummaryCard(
      String title, String value, String subtitle, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Enhanced donut chart
  Widget _buildDonutChart(
      List<MapEntry<String, double>> sortedItems, double totalTax) {
    final pieChartSections = <PieChartSectionData>[];

    for (int i = 0; i < sortedItems.length && i < 8; i++) {
      final item = sortedItems[i];
      final percentage = (item.value / totalTax) * 100;

      pieChartSections.add(
        PieChartSectionData(
          color: _qbColors[i % _qbColors.length],
          value: item.value,
          title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
          radius: 45,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: percentage > 15
              ? Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                )
              : null,
          badgePositionPercentageOffset: 1.2,
        ),
      );
    }

    return Container(
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              borderData: FlBorderData(show: false),
              sections: pieChartSections,
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TOTAL TAX',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'RWF ${_formatCurrency(totalTax)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0077C5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Currency formatting helper
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  /// Extract and parse tax data with enhanced regex patterns
  Map<String, dynamic> _parseTaxData() {
    // Extract total tax
    double totalTax = 0.0;
    String? totalTaxStr;

    // Multiple regex patterns for total tax extraction
    final totalTaxPatterns = [
      RegExp(r'Total Tax Collected.*?\*\*RWF ([\d,\.]+)\*\*'),
      RegExp(r'Total Tax Payable.*?\*\*RWF ([\d,\.]+)\*\*'),
      RegExp(r'Total:\s*RWF\s*([\d,\.]+)'),
      RegExp(r'Grand Total.*?RWF\s*([\d,\.]+)'),
    ];

    for (final pattern in totalTaxPatterns) {
      final match = pattern.firstMatch(data);
      if (match != null) {
        totalTaxStr = match.group(1);
        break;
      }
    }

    if (totalTaxStr != null) {
      totalTax = double.tryParse(totalTaxStr.replaceAll(',', '')) ?? 0.0;
    }

    // Extract date
    String dateStr = 'Today';
    final datePatterns = [
      RegExp(r'Detailed Tax Breakdown for (\d{2}/\d{2}/\d{4})'),
      RegExp(r'Tax Summary for\s*(\d{2}/\d{2}/\d{4})'),
      RegExp(r'Date:\s*(\d{2}/\d{2}/\d{4})'),
    ];

    for (final pattern in datePatterns) {
      final match = pattern.firstMatch(data);
      if (match != null) {
        dateStr = match.group(1) ?? dateStr;
        break;
      }
    }

    // Extract tax breakdown items
    final Map<String, double> itemTaxContributions = {};
    final taxBreakdownRegex = RegExp(
        r'\|\s*([^|]+)\s*\|\s*(?:[\d,\.]+)\s*\|\s*(?:\d+)\s*\|\s*(?:\d+%)\s*\|\s*RWF\s*([\d,\.]+)\s*\|',
        multiLine: true);

    final matches = taxBreakdownRegex.allMatches(data);

    for (final match in matches) {
      final itemName = match.group(1)?.trim() ?? 'Unknown';
      final taxAmountStr = match.group(2)?.replaceAll(',', '') ?? '0';
      final taxAmount = double.tryParse(taxAmountStr) ?? 0.0;

      if (!itemName.toLowerCase().contains('total') && taxAmount > 0) {
        final cleanName = itemName.split(',').first.trim();
        itemTaxContributions[cleanName] =
            (itemTaxContributions[cleanName] ?? 0) + taxAmount;
      }
    }

    // Calculate total if not found
    if (totalTax == 0 && itemTaxContributions.isNotEmpty) {
      totalTax = itemTaxContributions.values.reduce((a, b) => a + b);
    }

    return {
      'totalTax': totalTax,
      'dateStr': dateStr,
      'itemTaxContributions': itemTaxContributions,
    };
  }

  @override
  Widget build(BuildContext context, {String? currency}) {
    final theme = Theme.of(context);
    final parsedData = _parseTaxData();
    final totalTax = parsedData['totalTax'] as double;
    final dateStr = parsedData['dateStr'] as String;
    final itemTaxContributions =
        parsedData['itemTaxContributions'] as Map<String, double>;

    // Sort items by contribution
    final sortedItems = itemTaxContributions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return RepaintBoundary(
      key: cardKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with QuickBooks styling
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0077C5).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: Color(0xFF0077C5),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tax Summary Report',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onCopyGraph,
                        icon: const Icon(Icons.copy_outlined),
                        tooltip: 'Copy Report',
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F4F6),
                          foregroundColor: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Summary cards section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildSummaryCard(
                        'Total Tax Collected',
                        'RWF ${_formatCurrency(totalTax)}',
                        '${sortedItems.length} categories',
                        const Color(0xFF0077C5),
                      ),
                      const SizedBox(width: 16),
                      _buildSummaryCard(
                        'Largest Category',
                        sortedItems.isNotEmpty ? sortedItems.first.key : 'N/A',
                        sortedItems.isNotEmpty
                            ? 'RWF ${_formatCurrency(sortedItems.first.value)}'
                            : '',
                        const Color(0xFF2CA01C),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Chart and legend section
                  if (itemTaxContributions.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFE5E7EB), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 600;

                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child:
                                      _buildDonutChart(sortedItems, totalTax),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 3,
                                  child: _buildModernLegend(
                                      theme, sortedItems, _qbColors,
                                      totalTax: totalTax),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                _buildDonutChart(sortedItems, totalTax),
                                const SizedBox(height: 24),
                                _buildModernLegend(
                                    theme, sortedItems, _qbColors,
                                    totalTax: totalTax),
                              ],
                            );
                          }
                        },
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
    // Enhanced detection patterns
    final taxKeywords = [
      'tax summary',
      'tax payable',
      'tax collected',
      'detailed tax breakdown',
      'tax breakdown',
      'tax report',
    ];

    final lowerData = data.toLowerCase();
    return taxKeywords.any((keyword) => lowerData.contains(keyword)) ||
        (lowerData.contains('tax rate') && lowerData.contains('total tax')) ||
        RegExp(r'rwf\s*[\d,\.]+.*tax', caseSensitive: false).hasMatch(data);
  }
}
