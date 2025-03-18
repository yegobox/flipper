import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin VariantMixin implements VariantInterface {
  Repository get repository;

  @override
  Future<Variant?> getVariant({required String id}) async {
    return (await repository.get<Variant>(
      query: Query(where: [Where('id').isExactly(id)]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    )).firstOrNull;
  }

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
    final query = Query(where: [
      Where('branchId').isExactly(branchId),
      if (productId != null) Where('productId').isExactly(productId),
      if (variantId != null) Where('id').isExactly(variantId),
      if (name != null) Where('name').isExactly(name),
      if (bcd != null) Where('barCode').isExactly(bcd),
      if (purchaseId != null) Where('purchaseId').isExactly(purchaseId),
    ]);

    return await repository.get<Variant>(query: query);
  }

  @override
  Future<int> addVariant({
    required List<Variant> variations,
    required int branchId,
  }) async {
    for (var variant in variations) {
      variant.branchId = branchId;
      await repository.upsert<Variant>(variant);
    }
    return variations.length;
  }

  @override
  Future<List<IUnit>> units({required int branchId}) async {
    return await repository.get<IUnit>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) async {
    final branchId = ProxyService.box.getBranchId()!;

    try {
      for (Map map in units) {
        final existingUnit = (await repository.get<IUnit>(
                query: Query(where: [
          Where('name').isExactly(map['name']),
          Where('branchId').isExactly(branchId),
        ])))
            .firstOrNull;

        if (existingUnit == null) {
          final unit = IUnit(
              active: map['active'],
              branchId: branchId,
              name: map['name'],
              lastTouched: DateTime.now(),
              value: map['value']);

          // Add the unit to db
          await repository.upsert<IUnit>(unit);
        }
      }

      return 200;
    } catch (e) {
      rethrow;
    }
  }
}
