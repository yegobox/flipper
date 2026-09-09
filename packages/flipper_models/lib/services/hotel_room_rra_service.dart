import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/sync/utils/hotel_room_rra.dart';
import 'package:flipper_models/sync/utils/rra_new_variant_register.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:uuid/uuid.dart';

/// Registers hotel rooms with RRA as tourism-tax service items.
///
/// Rooms sold without this are invoiced as ordinary goods at VAT, not as
/// accommodation at 3% TT, so registration is part of creating a room rather
/// than an optional extra.
abstract final class HotelRoomRraService {
  static dynamic get _sync => ProxyService.getStrategy(Strategy.capella);

  /// Registers [room] and returns it carrying its new `variantId`.
  ///
  /// Idempotent: a room that already has a live registration is returned
  /// unchanged, so re-running never mints a second item for the same room.
  static Future<HotelRoom> registerRoom(HotelRoom room) async {
    if (room.isRegisteredWithRra) {
      final existing = await _sync.getVariant(id: room.variantId!) as Variant?;
      if (isHotelRoomVariantRegistered(existing)) return room;
    }

    final branchId = room.branchId;
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) {
      throw StateError('No active business; cannot register room ${room.name}');
    }

    final ebm = await _sync.ebm(branchId: branchId) as Ebm?;
    if (ebm == null) {
      throw StateError(
        'Branch $branchId has no EBM configuration, so room ${room.name} '
        'cannot be registered with RRA.',
      );
    }

    final business = await _sync.getBusiness(businessId: businessId)
        as Business?;

    // Rooms are exempt-or-VAT coded the same way AddRoomDialog codes them;
    // the 3% tourism tax rides on ttCatCd, not on taxTyCd.
    final vatEnabled = business?.tinNumber != null && ebm.tinNumber != 0;
    final taxTyCd = vatEnabled ? 'B' : 'D';

    final product = await _sync.createProduct(
      product: Product(
        id: const Uuid().v4(),
        name: room.name,
        lastTouched: DateTime.now().toUtc(),
        branchId: branchId,
        businessId: businessId,
        createdAt: DateTime.now().toUtc(),
        spplrNm: room.name,
        color: '#2C6BF0',
      ),
      businessId: businessId,
      branchId: branchId,
      tinNumber: ebm.tinNumber,
      bhFId: ebm.bhfId,
      createItemCode: false,
    ) as Product?;

    if (product == null) {
      throw StateError('Could not create a product for room ${room.name}');
    }

    final variant = await buildHotelRoomVariant(
      product: product,
      room: room,
      branchId: branchId,
      taxTyCd: taxTyCd,
      sku: DateTime.now().millisecondsSinceEpoch % 100000,
      business: business,
    );

    final repository = Repository();
    await repository.upsert<Variant>(variant);

    final serverUrl = await ProxyService.box.getServerUrl() ?? '';

    await registerVariantWithRraForAdd(
      repository: repository,
      branchId: branchId,
      variantToSave: variant,
      variantInput: variant,
      serverUrl: serverUrl,
      ebm: ebm,
    );

    final registered = room.copyWith(variantId: variant.id);
    await _sync.saveHotelRoom(registered);
    talker.info(
      'hotel: room ${room.name} registered with RRA as ${variant.itemCd} '
      '(TT, roomTypeCd ${variant.roomTypeCd})',
    );
    return registered;
  }

  /// Pushes a rename or a rate change onto the room's registered item.
  ///
  /// RRA holds the room's name and price, so leaving them stale would invoice
  /// the old ones.
  static Future<void> syncRoomToRra(HotelRoom room) async {
    if (!room.isRegisteredWithRra) return;

    final variant = await _sync.getVariant(id: room.variantId!) as Variant?;
    if (variant == null) return;

    applyHotelRoomRraFields(variant: variant, room: room);
    await Repository().upsert<Variant>(variant);

    final ebm = await _sync.ebm(branchId: room.branchId) as Ebm?;
    if (ebm == null) return;

    final serverUrl = await ProxyService.box.getServerUrl() ?? '';
    await retryTransientRraCall(
      () => ProxyService.tax.saveItem(variation: variant, URI: serverUrl),
    );
  }
}
