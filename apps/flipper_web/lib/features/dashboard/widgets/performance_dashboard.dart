import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/dashboard/providers/performance_provider.dart';
import 'package:intl/intl.dart';

class PerformanceDashboard extends ConsumerWidget {
  const PerformanceDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceAsync = ref.watch(performanceDataProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Date and comparison info
          Row(
            children: [
              Text(
                'Date ${DateFormat('MMM dd').format(DateTime.now())}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              const Text(
                'vs Prior day',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              const Text(
                'Checks Closed',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),

          performanceAsync.when(
            data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Net sales
                const Text(
                  'Net sales',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'RWF ${NumberFormat('#,###').format(data.netSales)}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      data.netSalesChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                      color: data.netSalesChange >= 0 ? Colors.green : Colors.red,
                    ),
                    Text(
                      data.netSalesChange == 0 ? 'N/A' : '${data.netSalesChange.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: data.netSalesChange >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Chart placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: data.hourlySales.any((h) => h.amount > 0)
                      ? _buildChart(data.hourlySales)
                      : const Center(
                          child: Text(
                            'No data available for selected timeframe',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Bottom metrics
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gross sales',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'RWF ${NumberFormat('#,###').format(data.grossSales)}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                data.grossSalesChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                size: 16,
                                color: data.grossSalesChange >= 0 ? Colors.green : Colors.red,
                              ),
                              Text(
                                data.grossSalesChange == 0 ? 'N/A' : '${data.grossSalesChange.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: data.grossSalesChange >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Transactions',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${data.transactionCount}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                data.transactionChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                                size: 16,
                                color: data.transactionChange >= 0 ? Colors.green : Colors.red,
                              ),
                              Text(
                                data.transactionChange == 0 ? 'N/A' : '${data.transactionChange.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: data.transactionChange >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading performance data: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<dynamic> hourlySales) {
    final maxAmount = hourlySales.map((h) => h.amount).reduce((a, b) => a > b ? a : b);
    if (maxAmount == 0) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: hourlySales.map((hourly) {
          final height = (hourly.amount / maxAmount) * 150;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0070F2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${hourly.hour}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}