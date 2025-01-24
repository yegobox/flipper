// ignore_for_file: unused_result

import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/stock_value_provider.dart';
import 'package:flipper_models/providers/total_sale_provider.dart';
import 'package:flipper_models/providers/profit_provider.dart';
import 'package:flipper_models/providers/business_analytic_provider.dart';
import 'package:flipper_models/providers/metric_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsDashboard extends HookConsumerWidget {
  const ReportsDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId()!;

    // Fetch data providers
    final totalSales = ref.watch(totalSaleProvider(branchId: branchId));
    final stockValue = ref.watch(stockValueProvider(branchId: branchId));
    final profitVsCost = ref.watch(profitProvider(branchId));
    final stockPerformance = ref.watch(fetchStockPerformanceProvider(branchId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Business Analytics',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh all providers
              ref.invalidate(totalSaleProvider);
              ref.invalidate(stockValueProvider);
              ref.invalidate(profitProvider);
              ref.invalidate(fetchStockPerformanceProvider);
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              // Open date range picker
              _showDateRangePicker(context, ref);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh all providers
          ref.invalidate(totalSaleProvider);
          ref.invalidate(stockValueProvider);
          ref.invalidate(profitProvider);
          ref.invalidate(fetchStockPerformanceProvider);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Performance Overview Cards
                _buildPerformanceCards(
                  stockValue: stockValue,
                  totalSales: totalSales,
                  profitVsCost: profitVsCost,
                ),

                SizedBox(height: 20),

                // Key Metrics Section
                Text(
                  'Key Metrics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 10),

                // Stock Performance Chart
                _buildStockPerformanceChart(stockPerformance),

                SizedBox(height: 20),

                // Detailed Metrics Grid
                _buildDetailedMetricsGrid(ref: ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context, WidgetRef ref) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((dateRange) {
      if (dateRange != null) {
        ref.read(dateRangeProvider.notifier).setStartDate(dateRange.start);
        ref.read(dateRangeProvider.notifier).setEndDate(dateRange.end);
      }
    });
  }

  Widget _buildPerformanceCards({
    required AsyncValue<double> stockValue,
    required AsyncValue<double> totalSales,
    required AsyncValue<double> profitVsCost,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Stock Value',
                value: stockValue.valueOrNull?.toRwf() ?? 'N/A',
                icon: Icons.inventory,
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                title: 'Total Sales',
                value: totalSales.valueOrNull?.toRwf() ?? 'N/A',
                icon: Icons.shopping_cart,
                color: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Profit vs Cost',
                value: profitVsCost.valueOrNull?.toRwf() ?? 'N/A',
                icon: Icons.trending_up,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockPerformanceChart(
      AsyncValue<List<BusinessAnalytic>> stockPerformance) {
    return stockPerformance.when(
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            strokeWidth: 4.0, // Adjust the thickness of the indicator
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Set color
          ),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: $error',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
        ),
      ),
      data: (analytics) {
        // Check if there are at least 2 data points
        if (analytics.length < 2) {
          return Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Insufficient data to display the chart',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        }

        // Transform analytics data into FlSpot objects
        final spots = analytics.asMap().entries.map((entry) {
          final index = entry.key.toDouble(); // Cast index to double
          final analytic = entry.value;
          return FlSpot(
              index, analytic.value.toDouble()); // Cast value to double
        }).toList();

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Performance Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailedMetricsGrid({required WidgetRef ref}) {
    final branchId = ProxyService.box.getBranchId()!;
    final metricsAsync = ref.watch(fetchMetricsProvider(branchId));

    return metricsAsync.when(
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
      data: (metrics) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: metrics.map((metric) {
            return _buildDetailMetricCard(
              title: metric.title,
              value: metric.value,
              icon: metric.icon,
              color: metric.color,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDetailMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
