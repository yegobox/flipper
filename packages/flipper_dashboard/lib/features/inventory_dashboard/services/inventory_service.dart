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

      // Convert variants to InventoryItem objects with branch names
      final List<InventoryItem> result = [];
      for (final variant in variants) {
        final item = await _variantToInventoryItem(variant);
        result.add(item);
      }
      return result;
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

      // Convert variants to InventoryItem objects with branch names
      final List<InventoryItem> result = [];
      for (final variant in nearExpiryVariants) {
        final item = await _variantToInventoryItem(variant);
        result.add(item);
      }
      return result;
    } catch (e) {
      print('Error fetching near expiry items: $e');
      return [];
    }
  }

  /// Converts a Variant to an InventoryItem for dashboard display
  Future<InventoryItem> _variantToInventoryItem(Variant variant) async {
    // Try to get the branch name if branchId is available
    String location = 'Unknown';
    if (variant.branchId != null) {
      print('Fetching branch name for branchId: ${variant.branchId}');
      try {
        final activeBranch =
            await ProxyService.strategy.branch(serverId: variant.branchId!);

        if (activeBranch != null && activeBranch.businessId != null) {
          print(
              'Getting all branches for business: ${activeBranch.businessId}');

          // Get all branches for this business
          final allBranches = await ProxyService.strategy.branches(
            businessId: activeBranch.businessId!,
            includeSelf: true,
          );

          print('Found ${allBranches.length} branches');

          // Find the branch with matching ID
          final matchingBranch = allBranches.firstWhere(
            (b) => b.serverId == variant.branchId,
            orElse: () => Branch(),
          );

          if (matchingBranch.name != null && matchingBranch.name!.isNotEmpty) {
            print('Found matching branch: ${matchingBranch.name}');
            location = matchingBranch.name!;
          } else {
            print(
                'No matching branch found with name for ID: ${variant.branchId}');
            location = 'Branch ${variant.branchId}';
          }
        } else {
          print('Could not get active branch or business ID');
          location = 'Branch ${variant.branchId}';
        }
      } catch (e) {
        print('Error fetching branch: $e');
        location = 'Branch ${variant.branchId}';
      }
    } else {
      print('No branchId available for variant: ${variant.id}');
    }
    print('Final location value: $location');

    return InventoryItem(
      id: variant.id,
      name: variant.name,
      category: variant.categoryName ?? 'Uncategorized',
      quantity: variant.stock?.currentStock?.toInt() ?? 0,
      expiryDate: variant.expirationDate ?? DateTime.now(),
      location: location,
    );
  }
}
