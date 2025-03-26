import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
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
    ))
        .firstOrNull;
  }

  @override
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
  }) async {
    try {
      final query = Query(where: [
        if (variantId != null)
          Where('id').isExactly(variantId)
        else if (name != null) ...[
          Where('name').contains(name),
          Where('branchId').isExactly(branchId),
        ] else if (bcd != null) ...[
          Where('bcd').isExactly(bcd),
          Where('branchId').isExactly(branchId),
        ] else if (imptItemsttsCd != null) ...[
          Where('imptItemSttsCd').isExactly(imptItemsttsCd),
          Where('branchId').isExactly(branchId)
        ] else if (productId != null) ...[
          Where('productId').isExactly(productId),
          Where('branchId').isExactly(branchId)
        ] else ...[
          Where('branchId').isExactly(branchId),

          Where('name').isNot(TEMP_PRODUCT),
          Where('productName').isNot(CUSTOM_PRODUCT),
          // Exclude variants with imptItemSttsCd = 2 (waiting) or 4 (canceled),  3 is approved
          if (!excludeApprovedInWaitingOrCanceledItems) ...[
            Where('imptItemSttsCd').isNot("2"),
            Where('imptItemSttsCd').isNot("4"),
            Where('pchsSttsCd').isNot("04"),
            Where('pchsSttsCd').isNot("01"),
          ],

          /// 01 is waiting for approval.
          if (excludeApprovedInWaitingOrCanceledItems)
            Where('pchsSttsCd').isExactly("01"),

          if (purchaseId != null) Where('purchaseId').isExactly(purchaseId),
          // Apply the purchaseId filter only if includePurchases is true
          if (excludeApprovedInWaitingOrCanceledItems)
            Where('purchaseId').isNot(null),
        ]
      ]);
      List<Variant> variants = await repository.get<Variant>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly,
        query: query,
      );

      // Pagination logic (if needed)
      if (page != null && itemsPerPage != null) {
        final offset = page * itemsPerPage;
        return variants
            .where((variant) =>
                variant.pchsSttsCd != "01" &&
                variant.pchsSttsCd != "04" &&
                variant.pchsSttsCd != "1")
            .skip(offset)
            .take(itemsPerPage)
            .toList();
      }

      return variants;
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
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
