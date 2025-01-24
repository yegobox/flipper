// ignore_for_file: unused_result

import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/stock_value_provider.dart';
import 'package:flipper_models/providers/total_sale_provider.dart';
import 'package:flipper_models/providers/profit_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsDashboard extends HookConsumerWidget {
  const ReportsDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch data providers (adjust according to your actual providers)

    final totalSales =
        ref.watch(totalSaleProvider(branchId: ProxyService.box.getBranchId()!));
    final stockValue = ref
        .watch(stockValueProvider(branchId: ProxyService.box.getBranchId()!));
    final profitVsCost =
        ref.watch(profitProvider(ProxyService.box.getBranchId()!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Business Analytics',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Implement refresh logic
              ref.invalidate(reportsProvider);
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
          ref.invalidate(reportsProvider);
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
                    profitVsCost: profitVsCost),

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
                _buildStockPerformanceChart(),

                SizedBox(height: 20),

                // Detailed Metrics Grid
                _buildDetailedMetricsGrid(),
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
        ref.read(dateRangeProvider.notifier).setStartDate(dateRange.end);
      }
    });
  }

  Widget _buildPerformanceCards(
      {required AsyncValue<double> stockValue,
      required AsyncValue<double> totalSales,
      required AsyncValue<double> profitVsCost}) {
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

  Widget _buildStockPerformanceChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      spots: [
                        FlSpot(0, 3),
                        FlSpot(1, 2),
                        FlSpot(2, 5),
                        FlSpot(3, 3.1),
                        FlSpot(4, 4),
                        FlSpot(5, 3),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                          show: true, color: Colors.blue.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildDetailMetricCard(
          title: 'Inventory Turnover',
          value: '4.5x',
          icon: Icons.loop,
          color: Colors.purple,
        ),
        _buildDetailMetricCard(
          title: 'Gross Margin',
          value: '42%',
          icon: Icons.percent,
          color: Colors.orange,
        ),
        _buildDetailMetricCard(
          title: 'Average Order Value',
          value: '\$85.50',
          icon: Icons.attach_money,
          color: Colors.teal,
        ),
        _buildDetailMetricCard(
          title: 'Stock Days',
          value: '45 days',
          icon: Icons.calendar_today,
          color: Colors.red,
        ),
        _buildDetailMetricCard(
          title: 'Net Profit',
          value: '\$12,500',
          icon: Icons.trending_up,
          color: Colors.green,
        ),
        _buildDetailMetricCard(
          title: 'Customer Acquisition Cost',
          value: '\$50',
          icon: Icons.person_add,
          color: Colors.blue,
        ),
        _buildDetailMetricCard(
          title: 'Customer Lifetime Value',
          value: '\$1,200',
          icon: Icons.people,
          color: Colors.pink,
        ),
      ],
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
