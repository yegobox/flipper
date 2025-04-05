import 'package:flipper_dashboard/features/inventory_dashboard/models/inventory_models.dart';
import 'package:flipper_dashboard/features/inventory_dashboard/services/inventory_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Service provider for inventory operations
final inventoryServiceProvider = Provider<InventoryService>((ref) {
  return InventoryService();
});

/// Provider for expired items
final expiredItemsProvider = FutureProvider.family<List<InventoryItem>, ExpiredItemsParams>((ref, params) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getExpiredItems(
    branchId: params.branchId,
    daysToExpiry: params.daysToExpiry,
    limit: params.limit,
  );
});

/// Provider for near expiry items
final nearExpiryItemsProvider = FutureProvider.family<List<InventoryItem>, NearExpiryItemsParams>((ref, params) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getNearExpiryItems(
    branchId: params.branchId,
    daysToExpiry: params.daysToExpiry,
    limit: params.limit,
  );
});

/// Provider for total items count and trend
final totalItemsProvider = FutureProvider<TotalItemsData>((ref) async {
  final service = ref.watch(inventoryServiceProvider);
  return service.getTotalItems();
});

/// Parameters for expired items provider
class ExpiredItemsParams {
  final int? branchId;
  final int? daysToExpiry;
  final int? limit;
  
  const ExpiredItemsParams({
    this.branchId,
    this.daysToExpiry,
    this.limit,
  });
}

/// Parameters for near expiry items provider
class NearExpiryItemsParams {
  final int? branchId;
  final int daysToExpiry;
  final int? limit;
  
  const NearExpiryItemsParams({
    this.branchId,
    this.daysToExpiry = 7,
    this.limit,
  });
}

/// Data class for total items count and trend
class TotalItemsData {
  final int totalCount;
  final double trendPercentage;
  final bool isPositive;
  final String formattedCount;
  
  TotalItemsData({
    required this.totalCount,
    required this.trendPercentage,
    required this.isPositive,
  }) : formattedCount = NumberFormat('#,###').format(totalCount);
}
