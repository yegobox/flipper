import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/dashboard/models/performance_data.dart';

final performanceDataProvider = FutureProvider<PerformanceData>((ref) async {
  final dittoService = ref.watch(dittoServiceProvider);
  final selectedBranch = ref.watch(selectedBranchProvider);

  if (selectedBranch == null || !dittoService.isReady()) {
    return PerformanceData(
      netSales: 0,
      grossSales: 0,
      transactionCount: 0,
      previousNetSales: 0,
      previousGrossSales: 0,
      previousTransactionCount: 0,
      hourlySales: [],
    );
  }

  // Register subscriptions for offline data
  dittoService.dittoInstance!.sync.registerSubscription(
    "SELECT * FROM transactions WHERE branchId = :branchId AND isIncome = true",
    arguments: {"branchId": selectedBranch.serverId},
  );

  dittoService.dittoInstance!.sync.registerSubscription(
    "SELECT * FROM transaction_items WHERE branchId = :branchId",
    arguments: {"branchId": selectedBranch.serverId},
  );

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final tomorrow = today.add(const Duration(days: 1));

  // Get today's transactions
  final todayQuery =
      "SELECT * FROM transactions WHERE branchId = :branchId AND lastTouched >= :start AND lastTouched < :end AND isIncome = true";
  final todayArgs = {
    "branchId": selectedBranch.serverId,
    "start": today.toIso8601String(),
    "end": tomorrow.toIso8601String(),
  };
  debugPrint('📊 Today query: $todayQuery');
  debugPrint('📊 Today args: $todayArgs');

  final todayTransactions = await dittoService.store!.execute(
    todayQuery,
    arguments: todayArgs,
  );
  debugPrint('📊 Today transactions found: ${todayTransactions.items.length}');

  // Get yesterday's transactions
  final yesterdayQuery =
      "SELECT * FROM transactions WHERE branchId = :branchId AND lastTouched >= :start AND lastTouched < :end AND isIncome = true";
  final yesterdayArgs = {
    "branchId": selectedBranch.serverId,
    "start": yesterday.toIso8601String(),
    "end": today.toIso8601String(),
  };
  debugPrint('📊 Yesterday query: $yesterdayQuery');
  debugPrint('📊 Yesterday args: $yesterdayArgs');

  final yesterdayTransactions = await dittoService.store!.execute(
    yesterdayQuery,
    arguments: yesterdayArgs,
  );
  debugPrint(
    '📊 Yesterday transactions found: ${yesterdayTransactions.items.length}',
  );

  // Calculate today's metrics
  double todayNetSales = 0;
  double todayGrossSales = 0;
  final Map<int, double> hourlyData = {};

  for (final doc in todayTransactions.items) {
    final transaction = Map<String, dynamic>.from(doc.value);
    final subTotal = (transaction['subTotal'] ?? 0).toDouble();
    final taxAmount = (transaction['taxAmount'] ?? 0).toDouble();

    todayNetSales += subTotal;
    todayGrossSales += subTotal + taxAmount;

    // Group by hour
    final lastTouched = DateTime.parse(transaction['lastTouched']);
    final hour = lastTouched.hour;
    hourlyData[hour] = (hourlyData[hour] ?? 0) + subTotal;
  }

  // Calculate yesterday's metrics
  double yesterdayNetSales = 0;
  double yesterdayGrossSales = 0;

  for (final doc in yesterdayTransactions.items) {
    final transaction = Map<String, dynamic>.from(doc.value);
    final subTotal = (transaction['subTotal'] ?? 0).toDouble();
    final taxAmount = (transaction['taxAmount'] ?? 0).toDouble();

    yesterdayNetSales += subTotal;
    yesterdayGrossSales += subTotal + taxAmount;
  }

  // Create hourly sales data
  final hourlySales = List.generate(
    24,
    (hour) => HourlySales(hour: hour, amount: hourlyData[hour] ?? 0),
  );

  return PerformanceData(
    netSales: todayNetSales,
    grossSales: todayGrossSales,
    transactionCount: todayTransactions.items.length,
    previousNetSales: yesterdayNetSales,
    previousGrossSales: yesterdayGrossSales,
    previousTransactionCount: yesterdayTransactions.items.length,
    hourlySales: hourlySales,
  );
});
