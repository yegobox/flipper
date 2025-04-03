import 'dart:async';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaVariantMixin implements VariantInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
    String? variantId,
    int? page,
    String? purchaseId,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    int? itemsPerPage,
    String? name,
    String? bcd,
    String? imptItemsttsCd,
    bool fetchRemote = false,
  }) async {
    throw UnimplementedError('variants needs to be implemented for Capella');
  }

  @override
  Future<Variant?> getVariant({required String id}) async {
    throw UnimplementedError('getVariant needs to be implemented for Capella');
  }

  @override
  Future<int> addVariant({
    required List<Variant> variations,
    required int branchId,
  }) async {
    throw UnimplementedError('addVariant needs to be implemented for Capella');
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    throw UnimplementedError('units needs to be implemented for Capella');
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    throw UnimplementedError('addUnits needs to be implemented for Capella');
  }

  @override
  FutureOr<Variant> addStockToVariant(
      {required Variant variant, Stock? stock}) {
    throw UnimplementedError(
        'addStockToVariant needs to be implemented for Capella');
  }

  @override
  FutureOr<void> updateVariant(
      {required List<Variant> updatables,
      String? color,
      String? taxTyCd,
      String? variantId,
      double? newRetailPrice,
      double? retailPrice,
      Map<String, String>? rates,
      double? supplyPrice,
      String? categoryId,
      Map<String, String>? dates,
      String? selectedProductType,
      String? productId,
      String? productName,
      String? unit,
      String? pkgUnitCd,
      DateTime? expirationDate,
      bool? ebmSynced}) {
    throw UnimplementedError(
        'updateVariant needs to be implemented for Capella');
  }
  
  @override
  Future<List<Variant>> getExpiredItems({
    required int branchId,
    int? daysToExpiry,
    int? limit,
  }) async {
    try {
      talker.debug('Fetching expired items for branch $branchId');
      
      // Calculate the date threshold for expiring soon items
      final now = DateTime.now();
      final expiryThreshold = daysToExpiry != null
          ? now.add(Duration(days: daysToExpiry))
          : now;
      
      // Create a query to find variants with expiration dates before or on the threshold
      // We can't directly query by date comparison, so we'll get all variants with expiration dates
      // and filter them in memory
      final query = Query(where: [
        Where('branchId').isExactly(branchId),
        Where('expirationDate').isNot(null),
      ]);
      
      // Get variants from the repository
      final variants = await repository.get<Variant>(
        query: query,
        // Use localOnly policy for better performance, or change to alwaysHydrate if remote data is needed
        policy: OfflineFirstGetPolicy.localOnly,
      );
      
      // Filter variants by expiration date
      final filteredVariants = variants.where((variant) => 
        variant.expirationDate != null && 
        variant.expirationDate!.isBefore(expiryThreshold) || 
        variant.expirationDate!.isAtSameMomentAs(expiryThreshold)
      ).toList();
      
      // Apply limit if specified
      final limitedVariants = limit != null && limit < filteredVariants.length
          ? filteredVariants.take(limit).toList()
          : filteredVariants;
      
      // Fetch stock data for each variant if needed
      for (final variant in limitedVariants) {
        if (variant.stockId != null && variant.stock == null) {
          try {
            final stockResult = await repository.get<Stock>(
              query: Query(where: [Where('id').isExactly(variant.stockId!)]),
              policy: OfflineFirstGetPolicy.localOnly,
            );
            
            if (stockResult.isNotEmpty) {
              variant.stock = stockResult.first;
            }
          } catch (e) {
            talker.warning('Could not load stock for variant ${variant.id}: $e');
          }
        }
      }
      
      talker.debug('Found ${limitedVariants.length} expired or expiring items');
      return limitedVariants;
    } catch (e, stackTrace) {
      talker.error('Error fetching expired items: $e', e, stackTrace);
      return [];
    }
  }
}
