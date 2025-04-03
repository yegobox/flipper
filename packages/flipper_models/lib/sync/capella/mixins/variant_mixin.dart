import 'dart:async';

import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
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
    throw UnimplementedError(
        'getExpiredItems needs to be implemented for Capella');
  }
}
