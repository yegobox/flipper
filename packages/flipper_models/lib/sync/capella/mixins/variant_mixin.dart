import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaVariantMixin implements VariantInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
    int? page,
    bool forImportScreen = false,
    String? variantId,
    String? name,
    String? pchsSttsCd,
    String? bcd,
    String? purchaseId,
    int? itemsPerPage,
    String? imptItemSttsCd,
    bool forPurchaseScreen = false,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    bool fetchRemote = false,
  }) async {
    throw UnimplementedError('variants needs to be implemented for Capella');
  }

  @override
  Future<Variant?> getVariant({required String id}) async {
    throw UnimplementedError('getVariant needs to be implemented for Capella');
  }

  @override
  Future<int> addVariant(
      {required List<Variant> variations, required int branchId}) {
    throw UnimplementedError('addVariant needs to be implemented for Capella');
  }

  @override
  Future<List<IUnit>> units({required int branchId}) {
    throw UnimplementedError('units needs to be implemented for Capella');
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) {
    throw UnimplementedError('addUnits needs to be implemented for Capella');
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
      DateTime? expirationDate,
      String? selectedProductType,
      String? productId,
      String? categoryId,
      String? productName,
      double? prc,
      double? dftPrc,
      String? unit,
      String? pkgUnitCd,
      double? dcRt,
      bool? ebmSynced,
      Map<String, String>? dates}) {
    throw UnimplementedError(
        'updateVariant needs to be implemented for Capella');
  }

  @override
  FutureOr<Variant> addStockToVariant(
      {required Variant variant, Stock? stock}) {
    throw UnimplementedError(
        'addStockToVariant needs to be implemented for Capella');
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
