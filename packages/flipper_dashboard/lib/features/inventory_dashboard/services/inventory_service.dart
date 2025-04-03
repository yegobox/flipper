import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import '../models/inventory_models.dart';

class InventoryService {
  /// Fetches expired items from the backend
  ///
  /// [branchId] - The branch ID to filter items by
  /// [daysToExpiry] - Optional, include items expiring within this many days
  /// [limit] - Optional, limit the number of results returned
  Future<List<InventoryItem>> getExpiredItems({
    int? branchId,
    int? daysToExpiry,
    int? limit,
  }) async {
    try {
      // Use the branch ID from the proxy service if not provided
      final activeBranchId = branchId ?? ProxyService.box.getBranchId() ?? 0;

      // Call the CoreSync API to get expired variants
      final variants = await ProxyService.strategy.getExpiredItems(
        branchId: activeBranchId,
        daysToExpiry: daysToExpiry,
        limit: limit,
      );

      // Convert variants to InventoryItem objects
      return variants
          .map((variant) => _variantToInventoryItem(variant))
          .toList();
    } catch (e) {
      print('Error fetching expired items: $e');
      return [];
    }
  }

  /// Fetches items that are about to expire
  ///
  /// [branchId] - The branch ID to filter items by
  /// [daysToExpiry] - Items expiring within this many days (default: 7)
  /// [limit] - Optional, limit the number of results returned
  Future<List<InventoryItem>> getNearExpiryItems({
    int? branchId,
    int daysToExpiry = 7,
    int? limit,
  }) async {
    try {
      // Use the branch ID from the proxy service if not provided
      final activeBranchId = branchId ?? ProxyService.box.getBranchId() ?? 0;

      // Call the CoreSync API to get variants that will expire soon
      final variants = await ProxyService.strategy.getExpiredItems(
        branchId: activeBranchId,
        daysToExpiry: daysToExpiry,
        limit: limit,
      );

      // Filter to only include items that haven't expired yet but will soon
      final now = DateTime.now();
      final nearExpiryVariants = variants
          .where((variant) =>
              variant.expirationDate != null &&
              variant.expirationDate!.isAfter(now))
          .toList();

      // Convert variants to InventoryItem objects
      return nearExpiryVariants
          .map((variant) => _variantToInventoryItem(variant))
          .toList();
    } catch (e) {
      print('Error fetching near expiry items: $e');
      return [];
    }
  }

  /// Converts a Variant to an InventoryItem for dashboard display
  InventoryItem _variantToInventoryItem(Variant variant) {
    return InventoryItem(
      id: variant.id,
      name: variant.name,
      category: variant.categoryName ?? 'Uncategorized',
      quantity: variant.stock?.currentStock?.toInt() ?? 0,
      expiryDate: variant.expirationDate ?? DateTime.now(),
      location: variant.branchId?.toString() ?? 'Unknown',
    );
  }
}
