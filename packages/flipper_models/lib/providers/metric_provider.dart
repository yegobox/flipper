import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'metric_provider.g.dart';

@riverpod
Future<List<Metric>> fetchMetrics(Ref ref, int branchId) async {
  // Fetch necessary data
  final stocks = await ProxyService.strategy.stocks(branchId: branchId);
  final variants = await ProxyService.strategy.variants(branchId: branchId);
  final transactionItems =
      await ProxyService.strategy.transactionItems(branchId: branchId);

  // Debug: Print fetched data
  print('Stocks: $stocks');
  print('Variants: $variants');
  print('Transaction Items: $transactionItems');

  // Calculate metrics
  final totalRevenue = transactionItems.fold<double>(
    0.0,
    (sum, item) => sum + (item.price) * (item.qty),
  );

  final costOfGoodsSold = variants.fold<double>(
    0.0,
    (sum, variant) => sum + (variant.supplyPrice ?? 0.0) * (variant.qty ?? 0.0),
  );

  // Debug: Print COGS
  print('Cost of Goods Sold: $costOfGoodsSold');

  final totalInventory = stocks.fold<double>(
    0.0,
    (sum, stock) => sum + (stock.currentStock ?? 0.0),
  );

  final averageInventory =
      (stocks.isEmpty) ? 0.0 : totalInventory / stocks.length;

  // Debug: Print total and average inventory
  print('Total Inventory: $totalInventory');
  print('Average Inventory: $averageInventory');

  // Handle division by zero for Stock Days and Inventory Turnover
  final inventoryTurnover =
      (averageInventory == 0) ? 0.0 : costOfGoodsSold / averageInventory;

  final stockDays =
      (costOfGoodsSold == 0) ? 0.0 : (averageInventory / costOfGoodsSold) * 365;

  // Debug: Print metrics
  print('Inventory Turnover: $inventoryTurnover');
  print('Stock Days: $stockDays');

  final grossMargin = (totalRevenue == 0)
      ? 0.0
      : (totalRevenue - costOfGoodsSold) / totalRevenue;

  final averageOrderValue =
      (transactionItems.isEmpty) ? 0.0 : totalRevenue / transactionItems.length;

  final netProfit = totalRevenue - costOfGoodsSold; // Simplified calculation
  final customerAcquisitionCost = 50.0; // Placeholder value
  final customerLifetimeValue = 1200.0; // Placeholder value

  // Return metrics as a list of Metric objects
  return [
    Metric(
      title: 'Inventory Turnover',
      value: (inventoryTurnover.isInfinite || inventoryTurnover.isNaN)
          ? 'N/A'
          : '${inventoryTurnover.toStringAsFixed(1)}x',
      icon: Icons.loop,
      color: Colors.purple,
    ),
    Metric(
      title: 'Gross Margin',
      value: (grossMargin.isInfinite || grossMargin.isNaN)
          ? 'N/A'
          : '${(grossMargin * 100).toStringAsFixed(0)}%',
      icon: Icons.percent,
      color: Colors.orange,
    ),
    Metric(
      title: 'Average Order Value',
      value: (averageOrderValue.isInfinite || averageOrderValue.isNaN)
          ? 'N/A'
          : averageOrderValue.toRwf(),
      icon: Icons.attach_money,
      color: Colors.teal,
    ),
    Metric(
      title: 'Stock Days',
      value: (stockDays.isInfinite || stockDays.isNaN)
          ? 'N/A'
          : '${stockDays.toStringAsFixed(0)} days',
      icon: Icons.calendar_today,
      color: Colors.red,
    ),
    Metric(
      title: 'Net Profit',
      value:
          (netProfit.isInfinite || netProfit.isNaN) ? 'N/A' : netProfit.toRwf(),
      icon: Icons.trending_up,
      color: Colors.green,
    ),
    Metric(
      title: 'Customer Acquisition Cost',
      value:
          (customerAcquisitionCost.isInfinite || customerAcquisitionCost.isNaN)
              ? 'N/A'
              : customerAcquisitionCost.toRwf(),
      icon: Icons.person_add,
      color: Colors.blue,
    ),
    Metric(
      title: 'Customer Lifetime Value',
      value: (customerLifetimeValue.isInfinite || customerLifetimeValue.isNaN)
          ? 'N/A'
          : customerLifetimeValue.toRwf(),
      icon: Icons.people,
      color: Colors.pink,
    ),
  ];
}
