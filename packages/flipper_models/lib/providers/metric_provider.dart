import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'metric_provider.g.dart';

@riverpod
Future<List<Metric>> fetchMetrics(Ref ref, int branchId) async {
  // Fetch analytics data - now everything is in one table
  final analytics = await ProxyService.getStrategy(Strategy.capella)
      .analytics(branchId: branchId);

  if (analytics.isEmpty) {
    return [];
  }

  // Calculate metrics from analytics data
  final totalRevenue = analytics.fold<double>(0.0, (sum, a) => sum + a.value);
  final totalCOGS = analytics.fold<double>(0.0, (sum, a) => sum + (a.supplyPrice * a.unitsSold));
  final totalInventory = analytics.fold<double>(0.0, (sum, a) => sum + a.currentStock);
  final totalStockValue = analytics.fold<double>(0.0, (sum, a) => sum + a.stockValue);
  final totalProfit = analytics.fold<double>(0.0, (sum, a) => sum + a.profit);
  final totalTransactions = analytics.length;

  // Calculate average inventory
  final averageInventory = totalInventory / analytics.length;

  // Calculate inventory turnover
  final inventoryTurnover = (averageInventory > 0 && totalCOGS > 0) 
      ? totalCOGS / averageInventory 
      : 0.0;

  // Calculate stock days
  final stockDays = (totalCOGS > 0) 
      ? (averageInventory / totalCOGS) * 365 
      : 0.0;

  // Calculate gross margin
  final grossMargin = (totalRevenue > 0) 
      ? (totalRevenue - totalCOGS) / totalRevenue 
      : 0.0;

  // Calculate average order value
  final averageOrderValue = (totalTransactions > 0) 
      ? totalRevenue / totalTransactions 
      : 0.0;

  // Calculate net profit (same as total profit from analytics)
  final netProfit = totalProfit;

  // Simple customer metrics (can be enhanced with more data)
  final customerAcquisitionCost = 500.0 / totalTransactions; // Placeholder
  final customerLifetimeValue = averageOrderValue * 3 * 2; // Placeholder

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
          : averageOrderValue.toCurrencyFormatted(
              symbol: ProxyService.box.defaultCurrency()),
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
      value: (netProfit.isInfinite || netProfit.isNaN)
          ? 'N/A'
          : netProfit.toCurrencyFormatted(
              symbol: ProxyService.box.defaultCurrency()),
      icon: Icons.trending_up,
      color: Colors.green,
    ),
    Metric(
      title: 'Customer Acquisition Cost',
      value:
          (customerAcquisitionCost.isInfinite || customerAcquisitionCost.isNaN)
              ? 'N/A'
              : customerAcquisitionCost.toCurrencyFormatted(
                  symbol: ProxyService.box.defaultCurrency()),
      icon: Icons.person_add,
      color: Colors.blue,
    ),
    Metric(
      title: 'Customer Lifetime Value',
      value: (customerLifetimeValue.isInfinite || customerLifetimeValue.isNaN)
          ? 'N/A'
          : customerLifetimeValue.toCurrencyFormatted(
              symbol: ProxyService.box.defaultCurrency()),
      icon: Icons.people,
      color: Colors.pink,
    ),
  ];
}


