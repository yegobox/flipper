// ignore_for_file: unused_result

import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/db_model_export.dart';
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
  final bool isInDialog; // Add a flag to indicate if it's in a dialog
  const ReportsDashboard({Key? key, this.isInDialog = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId()!;

    // Fetch data providers
    final totalSales = ref.watch(totalSaleProvider(branchId: branchId));
    final stockValue = ref.watch(stockValueProvider(branchId: branchId));
    final profitVsCost = ref.watch(profitProvider(branchId));
    final stockPerformance = ref.watch(fetchStockPerformanceProvider(branchId));

    // Conditionally return a Scaffold or a Column based on isInDialog
    if (!isInDialog) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Business Analytics',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black26,
          elevation: 1,
          actions: [
            IconButton(
              tooltip: 'Refresh Data',
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                ref.refresh(totalSaleProvider(
                    branchId: ProxyService.box.getBranchId()!));
                ref.refresh(stockValueProvider(
                    branchId: ProxyService.box.getBranchId()!));
                ref.refresh(profitProvider(ProxyService.box.getBranchId()!));
                ref.refresh(fetchStockPerformanceProvider(
                    ProxyService.box.getBranchId()!));
              },
            ),
            IconButton(
              tooltip: 'Select Date Range',
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () => _showDateRangePicker(context, ref),
            ),
          ],
        ),
        body: _buildContent(context, ref, totalSales, stockValue, profitVsCost,
            stockPerformance), // Move the content to a separate method
      );
    } else {
      //Return the content only.
      return _buildContent(context, ref, totalSales, stockValue, profitVsCost,
          stockPerformance); // Move the content to a separate method
    }
  }

  // Extracted content for reusability
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<double> totalSales,
    AsyncValue<double> stockValue,
    AsyncValue<double> profitVsCost,
    AsyncValue<List<BusinessAnalytic>> stockPerformance,
  ) {
    return RefreshIndicator(
      color: Colors.indigo,
      onRefresh: () async {
        ref.refresh(
            totalSaleProvider(branchId: ProxyService.box.getBranchId()!));
        ref.refresh(
            stockValueProvider(branchId: ProxyService.box.getBranchId()!));
        ref.refresh(profitProvider(ProxyService.box.getBranchId()!));
        ref.refresh(
            fetchStockPerformanceProvider(ProxyService.box.getBranchId()!));
      },
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  context: context,
                ),
                const SizedBox(height: 20),

                // Key Metrics Section
                Text(
                  'Key Metrics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 10),

                // Stock Performance Chart
                _buildStockPerformanceChart(stockPerformance, context),

                const SizedBox(height: 20),

                // Detailed Metrics Grid
                _buildDetailedMetricsGrid(
                    ref: ref, constraints: constraints, context: context),
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
      lastDate: DateTime.now().toUtc(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.indigo,
            hintColor: Colors.indigo,
            colorScheme: const ColorScheme.light(primary: Colors.indigo),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
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
    required BuildContext context,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context: context,
                title: 'Stock Value',
                value: stockValue.valueOrNull?.toString() ?? 'N/A',
                icon: Icons.inventory,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                context: context,
                title: 'Total Sales',
                value: totalSales.valueOrNull?.toString() ?? 'N/A',
                icon: Icons.shopping_cart,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context: context,
                title: 'Profit vs Cost',
                value: profitVsCost.valueOrNull?.toString() ?? 'N/A',
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
    required BuildContext context,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
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
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
      AsyncValue<List<BusinessAnalytic>> stockPerformance,
      BuildContext context) {
    return stockPerformance.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ),
            ),
          );
        }

        final spots = analytics.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final analytic = entry.value;
          return FlSpot(index, analytic.price.toDouble());
        }).toList();

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stock Performance Trend',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200, // Reduce chart height for dialog
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true, drawVerticalLine: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
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

  Widget _buildDetailedMetricsGrid(
      {required WidgetRef ref,
      required BoxConstraints constraints,
      required BuildContext context}) {
    final branchId = ProxyService.box.getBranchId()!;
    final metricsAsync = ref.watch(fetchMetricsProvider(branchId));

    return metricsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
      data: (metrics) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return _buildDetailMetricCard(
              title: metric.title,
              value: metric.value,
              icon: metric.icon,
              color: metric.color,
              context: context,
            );
          },
        );
      },
    );
  }

  Widget _buildDetailMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// Wrapper Widget for Dialog
class ReportsDashboardDialogWrapper extends StatelessWidget {
  const ReportsDashboardDialogWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 700),
        child: const ReportsDashboard(isInDialog: true),
      ),
    );
  }
}

//How to call it.
void showMyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ReportsDashboardDialogWrapper();
    },
  );
}
