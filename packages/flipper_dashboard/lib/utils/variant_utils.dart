import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// Shared utility functions for variant operations
class VariantUtils {
  /// Search for variants globally, similar to search_field.dart functionality
  static Future<List<Variant>> searchVariants(String filter) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return [];

    if (filter.isEmpty) {
      // Return initial variants when no search filter
      final variants =
          await ProxyService.getStrategy(Strategy.capella).variants(
        name: '',
        fetchRemote: false,
        branchId: branchId,
        page: 0,
        itemsPerPage: 20,
        taxTyCds: ['A', 'B', 'C', 'D', 'TT'],
        scanMode: false,
      );
      return variants.variants
          .where((v) => v.itemTyCd != '3')
          .cast<Variant>()
          .toList();
    }

    // Perform global search similar to search_field.dart
    final variants = await ProxyService.getStrategy(Strategy.capella).variants(
      name: filter.toLowerCase(),
      fetchRemote: true, // Always fetch remote for searches
      branchId: branchId,
      page: 0,
      itemsPerPage: 50, // Larger page size for search results
      taxTyCds: ['A', 'B', 'C', 'D', 'TT'],
      scanMode: false,
    );

    return variants.variants
        .where((v) => v.itemTyCd != '3')
        .cast<Variant>()
        .toList();
  }
}
