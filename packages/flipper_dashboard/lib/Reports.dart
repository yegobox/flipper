// ignore_for_file: unused_result

import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/business_analytic_provider.dart';
import 'package:flipper_models/providers/metric_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsDashboard extends HookConsumerWidget {
  final bool isInDialog;
  const ReportsDashboard({Key? key, this.isInDialog = false}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId()!;
    final analytics = ref.watch(fetchStockPerformanceProvider(branchId));

    // Calculate all metrics from single analytics data
    final totalSales = analytics.when<AsyncValue<double>>(
      data: (data) =>
          AsyncValue.data(data.fold<double>(0, (sum, a) => sum + a.value!)),
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
    );
    final stockValue = analytics.when<AsyncValue<double>>(
      data: (data) => AsyncValue.data(
        data.fold<double>(0, (sum, a) => sum + a.stockValue!),
      ),
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
    );
    final profitVsCost = analytics.when<AsyncValue<double>>(
      data: (data) =>
          AsyncValue.data(data.fold<double>(0, (sum, a) => sum + a.profit!)),
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
    );

    if (!isInDialog) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: const Text(
            'Business Analytics',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _refreshData(ref),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _showDateRangePicker(context, ref),
            ),
          ],
        ),
        body: _buildContent(
          context,
          ref,
          totalSales,
          stockValue,
          profitVsCost,
          analytics,
        ),
      );
    }
    return _buildContent(
      context,
      ref,
      totalSales,
      stockValue,
      profitVsCost,
      analytics,
    );
  }

  void _refreshData(WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId()!;
    ref.refresh(fetchStockPerformanceProvider(branchId));
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<double> totalSales,
    AsyncValue<double> stockValue,
    AsyncValue<double> profitVsCost,
    AsyncValue<List<BusinessAnalytic>> stockPerformance,
  ) {
    return RefreshIndicator(
      onRefresh: () async => _refreshData(ref),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsCards(totalSales, stockValue, profitVsCost),
            const SizedBox(height: 20),
            _buildStockPerformanceChart(stockPerformance),
            const SizedBox(height: 20),
            _buildDetailedMetrics(ref),
          ],
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

  Widget _buildMetricsCards(
    AsyncValue<double> totalSales,
    AsyncValue<double> stockValue,
    AsyncValue<double> profitVsCost,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Stock Value',
            value:
                stockValue.asData?.value.toCurrencyFormatted() ?? 'Loading...',
            icon: Icons.inventory_2_rounded,
            color: const Color(0xFF0078D4),
            isLoading: stockValue.isLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Total Sales',
            value:
                totalSales.asData?.value.toCurrencyFormatted() ?? 'Loading...',
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF10B981),
            isLoading: totalSales.isLoading,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            title: 'Profit',
            value:
                profitVsCost.asData?.value.toCurrencyFormatted() ??
                'Loading...',
            icon: Icons.account_balance_wallet_rounded,
            color: const Color(0xFF8B5CF6),
            isLoading: profitVsCost.isLoading,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          isLoading
              ? SizedBox(
                  height: 22,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Loading...',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildStockPerformanceChart(
    AsyncValue<List<BusinessAnalytic>> stockPerformance,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0078D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF0078D4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Stock Performance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          stockPerformance.when(
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Error loading chart data',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            data: (analytics) {
              if (analytics.length < 2) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'Insufficient data for chart',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                );
              }
              final spots = analytics.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.value!.toDouble(),
                );
              }).toList();
              return SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: const Color(0xFF0078D4),
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF0078D4).withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics(WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId()!;
    final metricsAsync = ref.watch(fetchMetricsProvider(branchId));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0078D4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Color(0xFF0078D4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Detailed Metrics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          metricsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading metrics',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            data: (metrics) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: metrics.length,
              itemBuilder: (context, index) {
                final metric = metrics[index];
                return _buildDetailMetricCard(
                  title: metric.title,
                  value: metric.value,
                  icon: metric.icon,
                  color: metric.color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

void preloadReportsData(WidgetRef ref) {
  final branchId = ProxyService.box.getBranchId()!;
  ref.read(fetchStockPerformanceProvider(branchId));
  ref.read(fetchMetricsProvider(branchId));
}

class FastReportsDialog extends StatefulWidget {
  const FastReportsDialog({Key? key}) : super(key: key);

  @override
  State<FastReportsDialog> createState() => _FastReportsDialogState();
}

class _FastReportsDialogState extends State<FastReportsDialog> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    // Show content after a minimal delay to ensure dialog appears first
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 700, maxWidth: 800),
        child: _showContent
            ? const ReportsDashboard(isInDialog: true)
            : Container(
                height: 400,
                padding: const EdgeInsets.all(20),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading Reports...'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
