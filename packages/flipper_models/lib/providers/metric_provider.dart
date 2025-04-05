import 'package:flipper_models/db_model_export.dart';
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

  // More robust COGS calculation
  double calculateTotalCOGS(
      List<Variant> variants, List<TransactionItem> transactions) {
    // Create a map of variant IDs to their supply prices
    final variantPrices = {
      for (var variant in variants) variant.id: variant.supplyPrice ?? 0.0
    };

    // Calculate total COGS by summing up (supplyPrice * quantity) for each transaction
    return transactions.fold<double>(0.0, (sum, item) {
      final supplyPrice = variantPrices[item.variantId] ?? 0.0;
      return sum + (supplyPrice * item.qty);
    });
  }

  // Calculate total inventory with null safety
  final totalInventory = stocks.fold<double>(
    0.0,
    (sum, stock) => sum + (stock.currentStock ?? 0.0),
  );

  // More accurate COGS calculation
  final costOfGoodsSold = calculateTotalCOGS(variants, transactionItems);

  // Calculate total revenue
  final totalRevenue = transactionItems.fold<double>(
    0.0,
    (sum, item) => sum + (item.price * item.qty),
  );

  // Calculate average inventory
  final averageInventory =
      (stocks.isEmpty) ? 0.0 : totalInventory / stocks.length;

  // Improved Inventory Turnover calculation with robust error handling
  double calculateInventoryTurnover(double avgInventory, double cogs) {
    if (avgInventory <= 0) return 0.0;
    if (cogs <= 0) return 0.0;
    return cogs / avgInventory;
  }

  final inventoryTurnover =
      calculateInventoryTurnover(averageInventory, costOfGoodsSold);

  // Calculate stock days with improved error handling
  double calculateStockDays(double avgInventory, double cogs) {
    if (cogs <= 0) return 0.0;
    return (avgInventory / cogs) * 365;
  }

  final stockDays = calculateStockDays(averageInventory, costOfGoodsSold);

  // Calculate gross margin with null safety
  final grossMargin = (totalRevenue == 0)
      ? 0.0
      : (totalRevenue - costOfGoodsSold) / totalRevenue;

  // Calculate average order value
  final averageOrderValue =
      (transactionItems.isEmpty) ? 0.0 : totalRevenue / transactionItems.length;

  // Calculate net profit
  final netProfit = totalRevenue - costOfGoodsSold;

  // Improved customer metrics calculations
  final customerAcquisitionCost =
      calculateCustomerAcquisitionCost(transactionItems);
  final customerLifetimeValue =
      calculateCustomerLifetimeValue(transactionItems);

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

// Helper functions for customer metrics calculations
double calculateCustomerAcquisitionCost(List<TransactionItem> transactions) {
  // Replace with actual calculation based on your business logic
  // This is a placeholder implementation
  final totalTransactions = transactions.length;
  final totalCost =
      500.0; //TODO: replace this wil total expenses Example marketing spend
  return totalTransactions > 0 ? totalCost / totalTransactions : 0.0;
}

double calculateCustomerLifetimeValue(List<TransactionItem> transactions) {
  // Replace with actual calculation based on your business logic
  // This is a placeholder implementation
  final averageOrderValue = transactions.isEmpty
      ? 0.0
      : transactions.fold<double>(
              0.0, (sum, item) => sum + item.price * item.qty) /
          transactions.length;
  final estimatedPurchaseFrequency = 3; // Average number of purchases per year
  final customerRetentionPeriod = 2; // Estimated years a customer stays active

  return averageOrderValue *
      estimatedPurchaseFrequency *
      customerRetentionPeriod;
}
