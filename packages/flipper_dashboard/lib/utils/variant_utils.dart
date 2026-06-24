import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/utils/pos_catalog_tax_ty_cds.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// Shared utility functions for variant operations
class VariantUtils {
  /// Search for variants globally, similar to search_field.dart functionality
  static Future<List<Variant>> searchVariants(String filter) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return [];

    if (filter.isEmpty) {
      final taxTyCds = posCatalogTaxTyCds(vatEnabled: ProxyService.box.vatEnabled());
      final variants =
          await ProxyService.getStrategy(Strategy.capella).variants(
        name: '',
        fetchRemote: false,
        branchId: branchId,
        page: 0,
        itemsPerPage: 20,
        taxTyCds: taxTyCds,
        scanMode: false,
      );
      return variants.variants
          .where((v) => v.itemTyCd != '3')
          .cast<Variant>()
          .toList();
    }

    final taxTyCds = posCatalogTaxTyCds(vatEnabled: ProxyService.box.vatEnabled());
    final variants = await ProxyService.getStrategy(Strategy.capella).variants(
      name: filter.toLowerCase(),
      fetchRemote: true,
      branchId: branchId,
      page: 0,
      itemsPerPage: 50,
      taxTyCds: taxTyCds,
      scanMode: false,
    );

    return variants.variants
        .where((v) => v.itemTyCd != '3')
        .cast<Variant>()
        .toList();
  }
}
