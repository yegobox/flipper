import 'dart:convert';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'visualization_interface.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Enhanced visualization for structured data with adaptive design
class StructuredDataVisualization implements VisualizationInterface {
  final String data;
  final dynamic currencyService;
  final GlobalKey cardKey;
  final VoidCallback onCopyGraph;

  StructuredDataVisualization(this.data, this.currencyService,
      {required this.cardKey, required this.onCopyGraph});

  @override
  Widget build(BuildContext context, {String? currency}) {
    final structuredData = _extractStructuredData(data);
    if (structuredData == null) {
      return const SizedBox.shrink();
    }

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
    return _extractStructuredData(data) != null;
  }

  /// Extract structured data from the response
  Map<String, dynamic>? _extractStructuredData(String data) {
    try {
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

  /// Get responsive breakpoints and sizing
  Map<String, dynamic> _getResponsiveConfig(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 900;

    return {
      'isDesktop': isDesktop,
      'isTablet': isTablet,
      'isMobile': !isTablet,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'cardPadding': isDesktop
          ? 24.0
          : isTablet
              ? 20.0
              : 16.0,
      'chartHeight': isDesktop
          ? 280.0
          : isTablet
              ? 240.0
              : 200.0,
      'titleSize': isDesktop
          ? 20.0
          : isTablet
              ? 18.0
              : 16.0,
      'subtitleSize': isDesktop
          ? 16.0
          : isTablet
              ? 14.0
              : 12.0,
      'legendSize': isDesktop
          ? 14.0
          : isTablet
              ? 12.0
              : 11.0,
      'maxLegendColumns': isDesktop
          ? 3
          : isTablet
              ? 2
              : 1,
      'pieRadius': isDesktop
          ? 80.0
          : isTablet
              ? 70.0
              : 60.0,
      'barWidth': isDesktop
          ? 32.0
          : isTablet
              ? 28.0
              : 24.0,
    };
  }

  /// Enhanced modern color palette inspired by Microsoft/QuickBooks
  List<Color> _getModernColorPalette() {
    return [
      const Color(0xFF0078D4), // Microsoft Blue
      const Color(0xFF107C10), // Success Green
      const Color(0xFFFF8C00), // Vibrant Orange
      const Color(0xFF5C2D91), // Purple
      const Color(0xFF00BCF2), // Cyan
      const Color(0xFFE81123), // Red
      const Color(0xFF00B7C3), // Teal
      const Color(0xFF8764B8), // Lavender
      const Color(0xFF498205), // Forest Green
      const Color(0xFFFF4B4B), // Coral
    ];
  }

  /// Build enhanced tax visualization with adaptive layout
  Widget _buildTaxVisualization(
      BuildContext context, Map<String, dynamic> data, String? currency) {
    final config = _getResponsiveConfig(context);
    final colors = _getModernColorPalette();

    final String title = data['title'] ?? 'Tax Summary';
    final String date = data['date'] ?? 'Today';
    final double totalTax = _parseNumericValue(data['totalTax']);
    final String currencyCode =
        data['currencyCode'] ?? '${ProxyService.box.defaultCurrency()}';
    final List<dynamic> items = data['items'] ?? [];

    // Process and group items
    final Map<String, double> itemTaxContributions = {};
    for (final item in items) {
      final String name = item['name'] ?? 'Unknown';
      final double taxAmount = _parseNumericValue(item['taxAmount']);

      if (taxAmount > 0) {
        final mainProductName = name.split(',').first.trim();
        itemTaxContributions[mainProductName] =
            (itemTaxContributions[mainProductName] ?? 0) + taxAmount;
      }
    }

    final sortedItems = itemTaxContributions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return RepaintBoundary(
      key: cardKey,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(config['cardPadding']),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernHeader(
                  title: date.isNotEmpty ? '$title for $date' : title,
                  subtitle: 'Total: $currencyCode ${_formatCurrency(totalTax)}',
                  config: config,
                ),
                SizedBox(height: config['cardPadding']),
                _buildAdaptiveTaxChart(
                  context,
                  sortedItems,
                  totalTax,
                  currencyCode,
                  colors,
                  config,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build adaptive tax chart (pie for few items, horizontal bars for many)
  Widget _buildAdaptiveTaxChart(
    BuildContext context,
    List<MapEntry<String, double>> sortedItems,
    double totalTax,
    String currencyCode,
    List<Color> colors,
    Map<String, dynamic> config,
  ) {
    final shouldUsePie = sortedItems.length <= 6 && !config['isMobile'];

    if (shouldUsePie) {
      return _buildModernPieChart(
          sortedItems, totalTax, currencyCode, colors, config);
    } else {
      return _buildModernHorizontalBarChart(
          sortedItems, totalTax, currencyCode, colors, config);
    }
  }

  /// Build modern pie chart with enhanced styling
  Widget _buildModernPieChart(
    List<MapEntry<String, double>> items,
    double totalTax,
    String currencyCode,
    List<Color> colors,
    Map<String, dynamic> config,
  ) {
    // Limit to top 5 + Other for clarity
    final displayItems = items.take(5).toList();
    final hasOther = items.length > 5;

    if (hasOther) {
      final otherAmount =
          items.skip(5).fold(0.0, (sum, item) => sum + item.value);
      displayItems.add(MapEntry('Other Items', otherAmount));
    }

    final pieChartSections = displayItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = totalTax > 0 ? (item.value / totalTax) * 100 : 0;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: item.value,
        title: percentage >= 3 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: config['pieRadius'],
        titleStyle: TextStyle(
          fontSize: config['legendSize'],
          fontWeight: FontWeight.w600,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: const Offset(0, 1),
              blurRadius: 2,
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ],
        ),
        badgeWidget: percentage < 3
            ? _buildSmallPercentageBadge(percentage.toDouble())
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: config['chartHeight'],
          child: Row(
            children: [
              Expanded(
                flex: config['isDesktop'] ? 2 : 3,
                child: PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    centerSpaceRadius: config['pieRadius'] * 0.5,
                    sectionsSpace: 2,
                    startDegreeOffset: -90,
                  ),
                ),
              ),
              if (config['isDesktop'] || config['isTablet'])
                Expanded(
                  flex: 2,
                  child: _buildModernLegend(
                      displayItems, currencyCode, colors, config),
                ),
            ],
          ),
        ),
        if (config['isMobile'])
          _buildModernLegend(displayItems, currencyCode, colors, config),
      ],
    );
  }

  /// Build modern horizontal bar chart
  Widget _buildModernHorizontalBarChart(
    List<MapEntry<String, double>> items,
    double totalTax,
    String currencyCode,
    List<Color> colors,
    Map<String, dynamic> config,
  ) {
    final maxValue = items.isEmpty ? 0.0 : items.first.value;

    return Column(
      children: [
        Container(
          height: min(config['chartHeight'], items.length * 50.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final percentage =
                  totalTax > 0 ? (item.value / totalTax) * 100 : 0;
              final barColor = colors[index % colors.length];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.key,
                            style: TextStyle(
                              fontSize: config['legendSize'],
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '$currencyCode ${_formatCurrency(item.value)}',
                          style: TextStyle(
                            fontSize: config['legendSize'],
                            fontWeight: FontWeight.w600,
                            color: barColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: maxValue > 0 ? (item.value / maxValue) : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                barColor.withOpacity(0.7),
                                barColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build enhanced business analytics visualization
  Widget _buildBusinessAnalyticsVisualization(
      BuildContext context, Map<String, dynamic> data, String? currency) {
    final config = _getResponsiveConfig(context);
    final colors = _getModernColorPalette();

    final double revenue = _parseNumericValue(data['revenue']);
    final double profit = _parseNumericValue(data['profit']);
    final double unitsSold = _parseNumericValue(data['unitsSold']);
    final String currencyCode = data['currencyCode'] ?? currency ?? 'USD';
    final String date = data['date'] ?? 'Today';

    return RepaintBoundary(
      key: cardKey,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(config['cardPadding']),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModernHeader(
                  title: 'Business Analytics',
                  subtitle: date,
                  config: config,
                ),
                SizedBox(height: config['cardPadding']),
                _buildMetricCards(
                    revenue, profit, unitsSold, currencyCode, colors, config),
                SizedBox(height: config['cardPadding']),
                _buildModernBarChart(
                    revenue, profit, unitsSold, currencyCode, colors, config),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build modern metric cards
  Widget _buildMetricCards(
    double revenue,
    double profit,
    double unitsSold,
    String currencyCode,
    List<Color> colors,
    Map<String, dynamic> config,
  ) {
    final metrics = [
      {
        'title': 'Revenue',
        'value': '$currencyCode ${_formatCurrency(revenue)}',
        'color': colors[0],
        'icon': Icons.trending_up,
      },
      {
        'title': 'Profit',
        'value': '$currencyCode ${_formatCurrency(profit)}',
        'color': colors[1],
        'icon': Icons.account_balance_wallet,
      },
      {
        'title': 'Units Sold',
        'value': _formatNumber(unitsSold),
        'color': colors[2],
        'icon': Icons.inventory,
      },
    ];

    if (config['isMobile']) {
      return Column(
        children: metrics
            .map(
              (metric) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: _buildMetricCard(metric, config),
              ),
            )
            .toList(),
      );
    } else {
      return Row(
        children: metrics
            .map(
              (metric) => Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: _buildMetricCard(metric, config),
                ),
              ),
            )
            .toList()
          ..removeLast(),
      );
    }
  }

  /// Build individual metric card
  Widget _buildMetricCard(
      Map<String, dynamic> metric, Map<String, dynamic> config) {
    return Container(
      padding: EdgeInsets.all(config['cardPadding'] * 0.75),
      decoration: BoxDecoration(
        color: (metric['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (metric['color'] as Color).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: metric['color'],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              metric['icon'],
              color: Colors.white,
              size: config['legendSize'] + 2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric['title'],
                  style: TextStyle(
                    fontSize: config['legendSize'],
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  metric['value'],
                  style: TextStyle(
                    fontSize: config['subtitleSize'],
                    fontWeight: FontWeight.w700,
                    color: metric['color'],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build modern bar chart
  Widget _buildModernBarChart(
    double revenue,
    double profit,
    double unitsSold,
    String currencyCode,
    List<Color> colors,
    Map<String, dynamic> config,
  ) {
    final maxValue = [revenue, profit, unitsSold * 100].reduce(max);

    return SizedBox(
      height: config['chartHeight'],
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue * 1.1,
          barGroups: [
            _createModernBarGroup(0, revenue, colors[0], config),
            _createModernBarGroup(1, profit, colors[1], config),
            _createModernBarGroup(2, unitsSold * 100, colors[2], config),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final titles = ['Revenue', 'Profit', 'Units×100'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      titles[value.toInt()],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: config['legendSize'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                reservedSize: 24,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatAxisValue(value),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: config['legendSize'] - 1,
                    ),
                  );
                },
                reservedSize: 50,
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
            horizontalInterval: maxValue / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.shade300,
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
            drawVerticalLine: false,
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // tooltipBgColor: Colors.grey.shade800,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final values = [revenue, profit, unitsSold];
                final labels = ['Revenue', 'Profit', 'Units Sold'];
                return BarTooltipItem(
                  '${labels[groupIndex]}\n${_formatCurrency(values[groupIndex])}',
                  TextStyle(
                    color: Colors.white,
                    fontSize: config['legendSize'],
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Build inventory visualization placeholder
  Widget _buildInventoryVisualization(
      BuildContext context, Map<String, dynamic> data, String? currency) {
    final config = _getResponsiveConfig(context);

    return RepaintBoundary(
      key: cardKey,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Container(
          height: config['chartHeight'],
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Inventory Visualization',
                  style: TextStyle(
                    fontSize: config['titleSize'],
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: config['legendSize'],
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods

  /// Build modern header with title and subtitle
  Widget _buildModernHeader({
    required String title,
    required String subtitle,
    required Map<String, dynamic> config,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: config['titleSize'],
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: config['subtitleSize'],
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0078D4),
          ),
        ),
      ],
    );
  }

  /// Build modern legend
  Widget _buildModernLegend(
    List<MapEntry<String, double>> items,
    String currencyCode,
    List<Color> colors,
    Map<String, dynamic> config,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final color = colors[index % colors.length];

          return SizedBox(
            width: config['isMobile']
                ? double.infinity
                : (config['screenWidth'] / config['maxLegendColumns']) - 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${item.key}: $currencyCode ${_formatCurrency(item.value)}',
                    style: TextStyle(
                      fontSize: config['legendSize'],
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build small percentage badge for pie chart
  Widget _buildSmallPercentageBadge(double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${percentage.toStringAsFixed(1)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Create modern bar group with gradient
  BarChartGroupData _createModernBarGroup(
      int x, double y, Color color, Map<String, dynamic> config) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: config['barWidth'],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              color.withOpacity(0.7),
              color,
            ],
          ),
        ),
      ],
    );
  }

  /// Parse numeric value safely
  double _parseNumericValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final cleanedStr = value.replaceAll(RegExp(r'[^\d.]'), '');
      try {
        return double.parse(cleanedStr);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  /// Format currency with proper separators
  String _formatCurrency(double value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Format number with proper separators
  String _formatNumber(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Format axis values
  String _formatAxisValue(double value) {
    if (value == 0) return '0';
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toInt().toString();
  }
}
