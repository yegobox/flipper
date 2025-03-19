import 'package:flipper_models/realm_model_export.dart';

abstract class VariantInterface {
  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
    int? page,
    String? variantId,
    String? name,
    String? bcd,
    String? purchaseId,
    int? itemsPerPage,
    String? imptItemsttsCd,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    bool fetchRemote = false,
  });
  Future<Variant?> getVariant({required String id});

  Future<int> addVariant({
    required List<Variant> variations,
    required int branchId,
  });

  Future<List<IUnit>> units({required int branchId});

  Future<int> addUnits<T>({required List<Map<String, dynamic>> units});
}
