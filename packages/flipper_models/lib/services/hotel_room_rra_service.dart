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

  /// Whether [branchId] files with RRA at all.
  ///
  /// A property that is not on EBM has no room items to register, so the desk
  /// should not offer it and nothing should warn about it.
  static Future<bool> branchSupportsRra(String branchId) async {
    try {
      final ebm = await _sync.ebm(branchId: branchId) as Ebm?;
      return hotelBranchSupportsRra(ebm);
    } catch (e) {
      talker.warning('hotel: could not read EBM for branch $branchId: $e');
      return false;
    }
  }

  /// Registers [room] and returns it carrying its new `variantId`.
  ///
  /// Idempotent: a room that already has a live registration is returned
  /// unchanged, so re-running never mints a second item for the same room.
  ///
  /// A branch that is not on EBM is returned unchanged too. That is not a
  /// failure — there is no tax authority to register with — so it neither
  /// throws nor leaves a half-built product behind.
  static Future<HotelRoom> registerRoom(HotelRoom room) async {
    // A half-finished attempt to resume, if there is one. Registration is
    // several persisted steps, and a room whose variant exists but never
    // reached RRA must finish that variant rather than mint a second one.
    Variant? pending;
    if (room.isRegisteredWithRra) {
      final existing = await _sync.getVariant(id: room.variantId!) as Variant?;
      if (isHotelRoomVariantRegistered(existing)) return room;
      pending = existing;
    }

    final branchId = room.branchId;
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) {
      throw StateError('No active business; cannot register room ${room.name}');
    }

    final branchEbm = await _sync.ebm(branchId: branchId) as Ebm?;
    if (!hotelBranchSupportsRra(branchEbm)) {
      talker.info(
        'hotel: branch $branchId is not on EBM, so room ${room.name} is kept '
        'as an unregistered room rather than sent to RRA.',
      );
      return room;
    }
    final ebm = branchEbm!;

    final business = await _sync.getBusiness(businessId: businessId)
        as Business?;

    // Rooms are exempt-or-VAT coded the same way AddRoomDialog codes them;
    // the 3% tourism tax rides on ttCatCd, not on taxTyCd.
    final vatEnabled = business?.tinNumber != null && ebm.tinNumber != 0;
    final taxTyCd = vatEnabled ? 'B' : 'D';

    final repository = Repository();

    // Only what this attempt mints is ours to undo.
    Product? mintedProduct;
    Variant variant;

    if (pending != null) {
      variant = applyHotelRoomRraFields(variant: pending, room: room);
      await repository.upsert<Variant>(variant);
    } else {
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
      mintedProduct = product;

      variant = await buildHotelRoomVariant(
        product: product,
        room: room,
        branchId: branchId,
        taxTyCd: taxTyCd,
        sku: DateTime.now().millisecondsSinceEpoch % 100000,
        business: business,
      );
      await repository.upsert<Variant>(variant);
    }

    final serverUrl = await ProxyService.box.getServerUrl() ?? '';

    try {
      await registerVariantWithRraForAdd(
        repository: repository,
        branchId: branchId,
        variantToSave: variant,
        variantInput: variant,
        serverUrl: serverUrl,
        ebm: ebm,
      );
    } catch (_) {
      await _recoverFailedRegistration(
        repository: repository,
        room: room,
        variant: variant,
        mintedProduct: mintedProduct,
      );
      rethrow;
    }

    final registered = room.copyWith(variantId: variant.id);
    await _sync.saveHotelRoom(registered);
    talker.info(
      'hotel: room ${room.name} registered with RRA as ${variant.itemCd} '
      '(TT, roomTypeCd ${variant.roomTypeCd})',
    );
    return registered;
  }

  /// Leaves a failed attempt in a state the next tap can finish.
  ///
  /// Without this, a room whose RRA call failed kept an orphan product and
  /// variant while still reading as unregistered, so every retry minted
  /// another pair.
  ///
  /// Two cases, and they are not symmetrical:
  ///
  /// * The item never reached RRA — drop what this attempt persisted, so the
  ///   retry starts clean.
  /// * `saveItems` already answered and the `itemCd` is live at RRA — keep the
  ///   variant and point the room at it, so the retry resumes that
  ///   registration instead of registering the same room a second time.
  static Future<void> _recoverFailedRegistration({
    required Repository repository,
    required HotelRoom room,
    required Variant variant,
    required Product? mintedProduct,
  }) async {
    try {
      if (hotelRoomRegistrationCanRollBack(variant)) {
        if (mintedProduct != null) {
          await repository.delete<Variant>(variant);
          await repository.delete<Product>(mintedProduct);
        }
        return;
      }

      await _sync.saveHotelRoom(room.copyWith(variantId: variant.id));
      talker.warning(
        'hotel: room ${room.name} holds RRA item ${variant.itemCd} but its '
        'registration did not finish; the next attempt resumes it.',
      );
    } catch (e) {
      // Never let cleanup mask why registration failed.
      talker.error('hotel: could not tidy up after a failed registration: $e');
    }
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
    if (!hotelBranchSupportsRra(ebm)) return;

    final serverUrl = await ProxyService.box.getServerUrl() ?? '';
    await retryTransientRraCall(
      () => ProxyService.tax.saveItem(variation: variant, URI: serverUrl),
    );
  }
}
