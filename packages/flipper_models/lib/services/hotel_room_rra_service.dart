import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/services/hotel_rra_capability.dart';
import 'package:flipper_models/sync/utils/hotel_room_rra.dart';
import 'package:flipper_models/sync/utils/rra_new_variant_register.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:uuid/uuid.dart';

/// Registers hotel rooms with RRA as tourism-tax service items.
///
/// Rooms sold without this are invoiced as ordinary goods at VAT, not as
/// accommodation at 3% TT, so registration is part of creating a room rather
/// than an optional extra.
abstract final class HotelRoomRraService {
  // Typed, not dynamic: this runs on the check-in path now, and a wrong
  // method name here would surface as a NoSuchMethodError in front of a
  // guest rather than as a compile error.
  static DatabaseSyncInterface get _sync =>
      ProxyService.getStrategy(Strategy.capella);

  /// Whether [branchId] files with RRA at all.
  ///
  /// A property that is not on EBM has no room items to register, so the desk
  /// should not offer it and nothing should warn about it.
  static Future<bool> branchSupportsRra(String branchId) =>
      HotelRraCapability.supports(branchId);

  /// Branches whose sweep is already running, so the four places that seed
  /// rooms cannot start four overlapping sweeps against the same branch.
  static final Set<String> _sweepsInFlight = <String>{};

  /// Consecutive non-configuration failures before giving up. RRA being down
  /// fails every room the same way; fifteen doomed round trips help nobody.
  static const int _maxConsecutiveFailures = 3;

  /// Registers every room on [branchId] that has no RRA item yet.
  ///
  /// Exists because `seedDefaultRooms` writes fifteen rooms straight to Ditto
  /// with no registration, so the first guest in a seeded room used to pay for
  /// it at the counter — a multi-step RRA round trip while a clerk waited.
  /// Rooms created through Rooms & floors are registered on creation and are
  /// skipped here.
  ///
  /// Call it unawaited on entry to Hotel Mode. Idempotent and self-disabling:
  /// once every room carries a `variantId` this costs one cached EBM read and
  /// one Ditto query, and returns.
  ///
  /// Returns how many rooms it registered.
  static Future<int> registerUnregisteredRooms(String branchId) async {
    if (branchId.isEmpty) return 0;
    if (!_sweepsInFlight.add(branchId)) return 0;

    try {
      // A branch that does not file with RRA has nothing to register, and
      // this is the cheap cached read.
      if (!await branchSupportsRra(branchId)) return 0;

      final rooms = await _sync.hotelRooms(branchId: branchId);
      final pending = roomsNeedingRegistration(
        rooms,
        await _resolveRoomVariants(rooms),
      );
      if (pending.isEmpty) return 0;

      talker.info(
        'hotel: registering ${pending.length} unregistered room(s) on branch '
        '$branchId in the background',
      );

      var registered = 0;
      var consecutiveFailures = 0;

      // Sequential on purpose: each registration mints a product and an RRA
      // item, and firing fifteen at once at the tax server is a good way to be
      // rate-limited into a half-registered floor plan.
      for (final room in pending) {
        try {
          await registerRoom(room);
          registered++;
          consecutiveFailures = 0;
        } on StateError catch (e) {
          // Branch-wide configuration — no business, or no tax server URL.
          // Every remaining room fails identically, so stop.
          talker.warning(
            'hotel: stopping room registration sweep on branch $branchId — '
            '${e.message}',
          );
          break;
        } catch (e, st) {
          consecutiveFailures++;
          talker.warning(
            'hotel: could not register room ${room.name} on branch $branchId '
            '($consecutiveFailures in a row): $e\n$st',
          );
          if (consecutiveFailures >= _maxConsecutiveFailures) {
            talker.warning(
              'hotel: giving up the registration sweep on branch $branchId '
              'after $consecutiveFailures consecutive failures',
            );
            break;
          }
        }
      }

      if (registered > 0) {
        talker.info(
          'hotel: registered $registered room(s) with RRA on branch $branchId',
        );
      }
      return registered;
    } catch (e, st) {
      // Never surfaced: this is background work, and a property must be able
      // to open its front desk whether or not RRA is reachable.
      talker.warning('hotel: room registration sweep failed on $branchId: $e\n$st');
      return 0;
    } finally {
      _sweepsInFlight.remove(branchId);
    }
  }

  /// The rooms a sweep would touch.
  ///
  /// A `variantId` alone does not mean registered. When `saveItems` reaches
  /// RRA but the attempt fails afterwards, [_recoverFailedRegistration]
  /// deliberately points the room at that variant so the next run can resume
  /// it — and filtering on `variantId` alone skipped exactly those rooms
  /// forever, leaving them to bill against a variant with no `itemCd`.
  ///
  /// [variantsById] holds the resolved variant for every room that names one;
  /// a missing entry reads as unfinished, which is the safe direction —
  /// [registerRoom] is idempotent and returns a genuinely registered room
  /// untouched.
  ///
  /// Pure, so the rule is testable without a tax server.
  @visibleForTesting
  static List<HotelRoom> roomsNeedingRegistration(
    List<HotelRoom> rooms,
    Map<String, Variant?> variantsById,
  ) {
    return rooms.where((room) {
      // No variant named at all: never started.
      if (!room.isRegisteredWithRra) return true;
      return !isHotelRoomVariantRegistered(variantsById[room.variantId]);
    }).toList(growable: false);
  }

  /// Loads the variants named by [rooms], so the filter above can judge them.
  ///
  /// Only rooms that name one are looked up, and a lookup that fails maps to
  /// null rather than aborting the sweep.
  static Future<Map<String, Variant?>> _resolveRoomVariants(
    List<HotelRoom> rooms,
  ) async {
    final ids = rooms
        .where((room) => room.isRegisteredWithRra)
        .map((room) => room.variantId!)
        .toSet();

    final resolved = <String, Variant?>{};
    for (final id in ids) {
      try {
        resolved[id] = await _sync.getVariant(id: id);
      } catch (e) {
        talker.warning('hotel: could not read variant $id: $e');
        resolved[id] = null;
      }
    }
    return resolved;
  }

  /// Products on [branchId] that carry a room item ([isHotelRoomItem]) —
  /// linked to a room or not. Repeated registrations left several room items
  /// per room, and only the newest is on the room doc.
  static Future<Set<String>> _roomProductIds(
    Ditto ditto,
    String branchId,
  ) async {
    final result = await ditto.store.execute(
      'SELECT productId FROM variants WHERE branchId = :branchId '
      'AND itemTyCd = :itemTyCd AND pkgUnitCd = :pkgUnitCd',
      arguments: {
        'branchId': branchId,
        'itemTyCd': '3',
        'pkgUnitCd': hotelRraPackagingUnit,
      },
    );
    return {
      for (final doc in result.items)
        if (doc.value['productId'] case final String id when id.isNotEmpty) id,
    };
  }

  /// Every variant the POS grid must not list on [branchId]: room items and
  /// anything else on a room's product (the old price-0 placeholders).
  ///
  /// Rooms are sold at the front desk, never rung up at the till. Two
  /// queries, once per catalog load; a branch with no rooms answers from the
  /// first and returns nothing. Never throws — a failure lists everything
  /// rather than blanking the POS.
  static Future<List<String>> posHiddenVariantIds(String branchId) async {
    if (branchId.isEmpty) return const [];
    try {
      final ditto = DittoService.instance.dittoInstance;
      if (ditto == null) return const [];

      final productIds = await _roomProductIds(ditto, branchId);
      if (productIds.isEmpty) return const [];

      final result = await ditto.store.execute(
        'SELECT _id FROM variants WHERE branchId = :branchId '
        'AND productId IN :productIds',
        arguments: {'branchId': branchId, 'productIds': productIds.toList()},
      );
      return [
        for (final doc in result.items)
          if (doc.value['_id'] case final String id) id,
      ];
    } catch (e) {
      talker.warning('hotel: POS room lookup failed on $branchId: $e');
      return const [];
    }
  }

  /// Deletes the "Regular" placeholder variants earlier room registrations
  /// left on [branchId] — the price-0 tiles named after rooms that showed up
  /// on the POS grid. See [isHotelRoomPlaceholderVariant] for what qualifies.
  ///
  /// Call it unawaited on entry to Hotel Mode. Registration no longer mints
  /// placeholders, so once a branch is clean this is a few queries that match
  /// nothing. The duplicate room items themselves are kept: each holds an
  /// `itemCd` RRA knows, and [posHiddenVariantIds] keeps them off the POS.
  ///
  /// Returns how many variants it deleted.
  static Future<int> purgeRoomPlaceholderVariants(String branchId) async {
    if (branchId.isEmpty) return 0;
    try {
      final ditto = DittoService.instance.dittoInstance;
      if (ditto == null) return 0;

      final rooms = await _sync.hotelRooms(branchId: branchId);
      final roomProductIds = await _roomProductIds(ditto, branchId);
      final names = {
        for (final room in rooms)
          if (room.name.trim().isNotEmpty) room.name.trim(),
      }.toList();
      if (roomProductIds.isEmpty && names.isEmpty) return 0;

      final matches = [
        if (roomProductIds.isNotEmpty) 'productId IN :productIds',
        if (names.isNotEmpty) 'name IN :names',
      ].join(' OR ');
      final found = await ditto.store.execute(
        'SELECT * FROM variants WHERE branchId = :branchId AND ($matches)',
        arguments: {
          'branchId': branchId,
          if (roomProductIds.isNotEmpty) 'productIds': roomProductIds.toList(),
          if (names.isNotEmpty) 'names': names,
        },
      );
      final candidates = found.items
          .map((d) => Variant.fromJson(Map<String, dynamic>.from(d.value)))
          .where((v) => v.itemTyCd != '3')
          .toList();
      if (candidates.isEmpty) return 0;

      // Which candidates' products still exist, for the rolled-back case.
      final candidateProductIds = {
        for (final v in candidates)
          if (v.productId?.isNotEmpty == true) v.productId!,
      }.toList();
      final existingProductIds = <String>{};
      if (candidateProductIds.isNotEmpty) {
        final products = await ditto.store.execute(
          'SELECT _id FROM products WHERE _id IN :ids',
          arguments: {'ids': candidateProductIds},
        );
        for (final doc in products.items) {
          final id = doc.value['_id'];
          if (id is String) existingProductIds.add(id);
        }
      }

      var deleted = 0;
      for (final variant in candidates) {
        if (!isHotelRoomPlaceholderVariant(
          variant: variant,
          rooms: rooms,
          roomProductIds: roomProductIds,
          existingProductIds: existingProductIds,
        )) {
          continue;
        }
        final stockId = variant.stockId;
        if (stockId != null && stockId.isNotEmpty) {
          await ditto.store.execute(
            'DELETE FROM stocks WHERE _id = :id',
            arguments: {'id': stockId},
          );
        }
        await ditto.store.execute(
          'DELETE FROM variants WHERE _id = :id',
          arguments: {'id': variant.id},
        );
        deleted++;
      }

      if (deleted > 0) {
        talker.info(
          'hotel: removed $deleted room placeholder variant(s) from the POS '
          'catalog on branch $branchId',
        );
      }
      return deleted;
    } catch (e, st) {
      // Housekeeping only; the desk must open whatever happens here.
      talker.warning(
        'hotel: room placeholder purge failed on $branchId: $e\n$st',
      );
      return 0;
    }
  }

  /// Visible for tests.
  @visibleForTesting
  static void resetSweepState() {
    _sweepsInFlight.clear();
    _registrationsInFlight.clear();
  }

  /// Registers [room] and returns it carrying its new `variantId`.
  ///
  /// Idempotent: a room that already has a live registration is returned
  /// unchanged, so re-running never mints a second item for the same room.
  ///
  /// A branch that is not on EBM is returned unchanged too. That is not a
  /// failure — there is no tax authority to register with — so it neither
  /// throws nor leaves a half-built product behind.
  /// In-flight registrations, keyed by room id.
  ///
  /// The background sweep and the folio's own charge can both reach the same
  /// room — the sweep's branch guard only stops sweep-versus-sweep. Two
  /// concurrent runs would each mint a product, a variant and an RRA item for
  /// one room, and RRA would hold two live items for the same bed.
  static final Map<String, Future<HotelRoom>> _registrationsInFlight =
      <String, Future<HotelRoom>>{};

  static Future<HotelRoom> registerRoom(HotelRoom room) {
    final existing = _registrationsInFlight[room.id];
    if (existing != null) return existing;

    final run = _registerRoom(room).whenComplete(() {
      _registrationsInFlight.remove(room.id);
    });
    _registrationsInFlight[room.id] = run;
    return run;
  }

  static Future<HotelRoom> _registerRoom(HotelRoom room) async {
    // A half-finished attempt to resume, if there is one. Registration is
    // several persisted steps, and a room whose variant exists but never
    // reached RRA must finish that variant rather than mint a second one.
    Variant? pending;
    if (room.isRegisteredWithRra) {
      final existing = await _sync.getVariant(id: room.variantId!);
      if (isHotelRoomVariantRegistered(existing)) return room;
      pending = existing;
    }

    final branchId = room.branchId;
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) {
      throw StateError('No active business; cannot register room ${room.name}');
    }

    // Two reads on purpose. The cached one answers "does this branch file with
    // RRA at all", which is the common case for a non-EBM property and must
    // not cost a network round trip on every room charge. Only once we know we
    // are actually registering do we pay for the authoritative copy — the
    // tinNumber and bhfId below go onto a fiscal item, so those may not be
    // stale.
    if (!await HotelRraCapability.supports(branchId)) {
      talker.info(
        'hotel: branch $branchId is not on EBM, so room ${room.name} is kept '
        'as an unregistered room rather than sent to RRA.',
      );
      return room;
    }

    final branchEbm = await _sync.ebm(branchId: branchId);
    if (!hotelBranchSupportsRra(branchEbm)) {
      talker.info(
        'hotel: branch $branchId dropped off EBM between the cached and live '
        'reads; keeping room ${room.name} unregistered.',
      );
      return room;
    }
    final ebm = branchEbm!;
    // RRA rejects saveItems with 603 <ttCatCd> unless it registered this
    // taxpayer for tourism tax; the room registers as a plain service then.
    final tourismTax = hotelBranchSupportsTourismTax(branchEbm);

    final business = await _sync.getBusiness(businessId: businessId)
       ;

    // Rooms are exempt-or-VAT coded the same way AddRoomDialog codes them;
    // the 3% tourism tax rides on ttCatCd, not on taxTyCd.
    final vatEnabled = business?.tinNumber != null && ebm.tinNumber != 0;
    final taxTyCd = vatEnabled ? 'B' : 'D';

    final repository = Repository();

    // Only what this attempt mints is ours to undo.
    Product? mintedProduct;
    Variant variant;

    if (pending != null) {
      variant = applyHotelRoomRraFields(
        variant: pending,
        room: room,
        tourismTaxEnabled: tourismTax,
      );
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
        // The room's variant is registered below through
        // registerVariantWithRraForAdd, which skips the stock steps for an
        // itemTyCd '3' service. Letting createProduct call RRA as well would
        // register the placeholder product as a second item.
        skipRRaCall: true,
        // The room's own variant is built below. Without this createProduct
        // also mints a "Regular" variant (price 0, qty 1) named after the
        // room, which lands on the POS grid as a sellable tile — and a
        // rolled-back attempt used to leave one behind every retry.
        skipRegularVariant: true,
      );

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
        tourismTaxEnabled: tourismTax,
      );
      await repository.upsert<Variant>(variant);
    }

    final serverUrl = await _rraServerUrl(ebm);
    if (serverUrl.isEmpty) {
      // Surfaced as a toast at the desk, so it says what to do rather than
      // naming a branch id nobody there can act on.
      talker.error(
        'hotel: branch $branchId has no taxServerUrl on its EBM row and none '
        'in the box, so room ${room.name} cannot be registered.',
      );
      throw StateError(
        'No RRA tax server URL for this branch — set it in Tax configuration.',
      );
    }

    try {
      await registerVariantWithRraForAdd(
        repository: repository,
        branchId: branchId,
        variantToSave: variant,
        variantInput: variant,
        serverUrl: serverUrl,
        ebm: ebm,
      );
    } catch (error) {
      await _recoverFailedRegistration(
        repository: repository,
        room: room,
        variant: variant,
        mintedProduct: mintedProduct,
        error: error,
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
    required Object error,
  }) async {
    try {
      // RRA turning the item down is deterministic, and it holds nothing, so
      // the attempt is undone rather than parked for a resume that would
      // replay the same payload for the same answer forever.
      if (hotelRraRejectedRegistration(error)) {
        if (mintedProduct != null) {
          await repository.delete<Variant>(variant);
          await repository.delete<Product>(mintedProduct);
        }
        talker.error(
          'hotel: RRA rejected room ${room.name} — $error. The room is left '
          'unregistered; it will not be retried until the cause is fixed.',
        );
        return;
      }

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

  /// The branch's RRA endpoint, taken from its EBM row rather than the box.
  ///
  /// `ProxyService.box.getServerUrl()` is only populated once something has
  /// visited tax configuration on this device, so the front desk could reach a
  /// room registration with it still empty — `saveItem` then posted to the bare
  /// path `items/saveItems` and Dio failed with "No host specified in URI",
  /// three times over, with nothing naming the real cause.
  ///
  /// Seeds the box on the way through, the way bar mode's settle does, so the
  /// rest of the tax stack sees the same endpoint.
  ///
  /// On a phone the VSDC is not on this device, so [Ebm.remoteServerUrl] wins
  /// where it is set — matching what `addVariant` does for every other product.
  static Future<String> _rraServerUrl(Ebm ebm) async {
    var fromEbm = ebm.taxServerUrl?.trim() ?? '';
    if (isAndroid || isIos) {
      final remote = ebm.remoteServerUrl?.trim() ?? '';
      if (remote.isNotEmpty) fromEbm = remote;
    }
    if (fromEbm.isNotEmpty) {
      await ProxyService.box.writeString(key: 'getServerUrl', value: fromEbm);
      await ProxyService.box.writeString(key: 'bhfId', value: ebm.bhfId);
      return fromEbm;
    }
    return (await ProxyService.box.getServerUrl() ?? '').trim();
  }

  /// Pushes a rename or a rate change onto the room's registered item.
  ///
  /// RRA holds the room's name and price, so leaving them stale would invoice
  /// the old ones.
  static Future<void> syncRoomToRra(HotelRoom room) async {
    if (!room.isRegisteredWithRra) return;

    final variant = await _sync.getVariant(id: room.variantId!);
    if (variant == null) return;

    final ebm = await _sync.ebm(branchId: room.branchId);
    applyHotelRoomRraFields(
      variant: variant,
      room: room,
      tourismTaxEnabled: hotelBranchSupportsTourismTax(ebm),
    );
    await Repository().upsert<Variant>(variant);

    if (!hotelBranchSupportsRra(ebm)) return;

    final serverUrl = await _rraServerUrl(ebm!);
    if (serverUrl.isEmpty) {
      talker.warning(
        'hotel: no RRA tax server URL for branch ${room.branchId}; room '
        '${room.name} keeps its old name/rate with RRA.',
      );
      return;
    }
    await retryTransientRraCall(
      () => ProxyService.tax.saveItem(variation: variant, URI: serverUrl),
    );
  }
}
