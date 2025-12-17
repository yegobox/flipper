import 'package:flipper_dashboard/features/inventory_dashboard/models/inventory_models.dart';
import 'package:flipper_dashboard/features/inventory_dashboard/services/inventory_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:equatable/equatable.dart';

part 'inventory_provider.g.dart';

/// Service provider for inventory operations
@riverpod
InventoryService inventoryService(Ref ref) {
  return InventoryService();
}

/// Provider for expired items
@riverpod
Future<List<InventoryItem>> expiredItems(
    Ref ref, ExpiredItemsParams params) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getExpiredItems(
    branchId: params.branchId,
    daysToExpiry: params.daysToExpiry,
    limit: params.limit,
  );
}

/// Provider for near expiry items
@riverpod
Future<List<InventoryItem>> nearExpiryItems(
    Ref ref, NearExpiryItemsParams params) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getNearExpiryItems(
    branchId: params.branchId,
    daysToExpiry: params.daysToExpiry,
    limit: params.limit,
  );
}

/// Provider for total items count and trend
@riverpod
Future<TotalItemsData> totalItems(Ref ref) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getTotalItems();
}

/// Provider for low stock items count and trend
@riverpod
Future<TotalItemsData> lowStockItems(Ref ref) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getLowStockItems();
}

/// Provider for pending orders count and trend
@riverpod
Future<TotalItemsData> pendingOrders(Ref ref) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getPendingOrders();
}

/// Parameters for expired items provider
class ExpiredItemsParams extends Equatable {
  final int? branchId;
  final int? daysToExpiry;
  final int? limit;

  const ExpiredItemsParams({
    this.branchId,
    this.daysToExpiry,
    this.limit,
  });

  @override
  List<Object?> get props => [branchId, daysToExpiry, limit];
}

/// Parameters for near expiry items provider
class NearExpiryItemsParams extends Equatable {
  final int? branchId;
  final int daysToExpiry;
  final int? limit;

  const NearExpiryItemsParams({
    this.branchId,
    this.daysToExpiry = 7,
    this.limit,
  });

  @override
  List<Object?> get props => [branchId, daysToExpiry, limit];
}

/// Data class for total items count and trend
class TotalItemsData {
  final int totalCount;
  final double trendPercentage;
  final bool isPositive;
  final String formattedCount;
  final bool isEstimateUsed;

  TotalItemsData({
    required this.totalCount,
    required this.trendPercentage,
    required this.isPositive,
    required this.isEstimateUsed,
  }) : formattedCount = NumberFormat('#,###').format(totalCount);
}
