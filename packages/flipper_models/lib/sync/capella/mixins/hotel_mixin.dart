import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/interfaces/hotel_interface.dart';
import 'package:flipper_models/sync/utils/cart_line_doc_cache.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_models/sync/utils/hotel_room_rra.dart';
import 'package:flipper_models/sync/utils/rra_line_utils.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';

TransactionItem? _hotelFindLine(List<TransactionItem> lines, String lineId) {
  for (final line in lines) {
    if (line.id == lineId) return line;
  }
  return null;
}

/// Keys of Ditto sync subscriptions already registered for hotel collections,
/// **per Ditto instance**.
///
/// Store queries/observers only read locally; without these subscriptions a
/// fresh device never replicates hotel documents from the mesh/cloud. A single
/// process-wide set looked safe but was not: subscriptions live on the Ditto
/// instance, so when [DittoService] rebuilds one — a re-login, say — the keys
/// survived, every registration was skipped as already-done, and replication
/// silently stopped. An [Expando] ties the bookkeeping to the instance it
/// actually describes, so a new instance subscribes again.
final Expando<Set<String>> _hotelSyncSubscriptionKeys = Expando(
  'hotelSyncSubscriptionKeys',
);

Set<String> _subscriptionKeysFor(Object ditto) =>
    _hotelSyncSubscriptionKeys[ditto] ??= <String>{};

mixin CapellaHotelMixin implements HotelInterface {
  DittoService get dittoService;
  Talker get talker;

  /// The Ditto instance every query in this mixin runs against.
  ///
  /// A seam, not indirection for its own sake: [DittoService.dittoInstance] is
  /// typed to the real `Ditto`, which cannot be constructed in a unit test, so
  /// tests override this with an in-memory store. Production keeps the single
  /// implementation below.
  dynamic get dittoHandle => dittoService.dittoInstance;

  static const _hotelBranchSettingsSql =
      'SELECT * FROM hotel_branch_settings WHERE branchId = :branchId LIMIT 1';
  static const _hotelRoomsSql =
      'SELECT * FROM hotel_rooms WHERE branchId = :branchId ORDER BY ordinal ASC';
  static const _hotelOpenStaysSql =
      "SELECT * FROM hotel_stays WHERE branchId = :branchId AND status IN ('inHouse', 'reserved')";
  static const _hotelQuotationsSql =
      'SELECT * FROM hotel_quotations WHERE branchId = :branchId';
  static const _hotelOpenFoliosSql =
      'SELECT * FROM transactions WHERE branchId = :branchId AND status = :status';
  static const _hotelFolioLinesSql =
      'SELECT * FROM transaction_items WHERE transactionId = :transactionId';

  void _ensureHotelSyncSubscription(
    dynamic ditto,
    String key,
    String sql,
    Map<String, dynamic>? args,
  ) {
    // Bound separately: casting `ditto` in place would narrow it to Object
    // for the rest of this method, where it is used dynamically.
    final Object handle = ditto;
    final registered = _subscriptionKeysFor(handle);
    if (registered.contains(key)) return;
    try {
      final prepared = prepareDqlSyncSubscription(sql, args);
      ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      registered.add(key);
      talker.debug('hotel: registered sync subscription $key');
    } catch (e, s) {
      talker.warning('hotel: sync subscription failed ($key): $e\n$s');
    }
  }

  void _ensureHotelSettingsSync(dynamic ditto, String branchId) {
    // Collection-wide first: fresh devices can fail to pull with filtered
    // subscriptions (known Ditto issue, see customer_mixin). The collection
    // holds one small doc per branch, so this is cheap.
    _ensureHotelSyncSubscription(
      ditto,
      'hotel_branch_settings|all',
      'SELECT * FROM hotel_branch_settings',
      null,
    );
    _ensureHotelSyncSubscription(
      ditto,
      'hotel_branch_settings|$branchId',
      _hotelBranchSettingsSql,
      {'branchId': branchId},
    );
  }

  void _ensureHotelRoomsSync(dynamic ditto, String branchId) {
    _ensureHotelSyncSubscription(ditto, 'hotel_rooms|$branchId', _hotelRoomsSql, {
      'branchId': branchId,
    });
  }

  void _ensureHotelStaysSync(dynamic ditto, String branchId) {
    // Unfiltered on status: a stay flips to `checkedOut` on another device and
    // the desk must see that transition, not just lose the document.
    _ensureHotelSyncSubscription(
      ditto,
      'hotel_stays|$branchId',
      'SELECT * FROM hotel_stays WHERE branchId = :branchId',
      {'branchId': branchId},
    );
    _ensureHotelSyncSubscription(
      ditto,
      'hotel_folios|$branchId',
      'SELECT * FROM transactions WHERE branchId = :branchId',
      {'branchId': branchId},
    );
    _ensureHotelSyncSubscription(
      ditto,
      'hotel_quotations|$branchId',
      _hotelQuotationsSql,
      {'branchId': branchId},
    );
    _ensureHotelSyncSubscription(
      ditto,
      'hotel_folio_lines|$branchId',
      'SELECT * FROM transaction_items WHERE branchId = :branchId',
      {'branchId': branchId},
    );
  }

  // --- Result mapping -------------------------------------------------------

  List<HotelRoom> _roomsFromResult(dynamic queryResult) {
    final list = <HotelRoom>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          HotelRoom.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (e) {
        talker.error('hotel_rooms map error: $e');
      }
    }
    return list;
  }

  List<HotelStay> _staysFromResult(dynamic queryResult) {
    final list = <HotelStay>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          HotelStay.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (e) {
        talker.error('hotel_stays map error: $e');
      }
    }
    return list;
  }

  List<HotelQuotation> _quotationsFromResult(dynamic queryResult) {
    final list = <HotelQuotation>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          HotelQuotation.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (e) {
        talker.error('hotel_quotations map error: $e');
      }
    }
    return list;
  }

  HotelBranchSettings? _settingsFromResult(dynamic queryResult) {
    try {
      final items = queryResult.items as Iterable<dynamic>;
      if (items.isEmpty) return null;
      final raw = Map<String, dynamic>.from(items.first.value as Map);
      return HotelBranchSettings.fromJson(raw);
    } catch (e) {
      talker.error('hotel_branch_settings map error: $e');
      return null;
    }
  }

  List<TransactionItem> _linesFromResult(dynamic queryResult) {
    final lines = <TransactionItem>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        final data = Map<String, dynamic>.from(item.value as Map);
        final line = hotelFolioLineFromDitto(data);
        if (line != null) lines.add(line);
      } catch (e) {
        talker.error('hotelFolioLines map: $e');
      }
    }
    return lines;
  }

  /// Initial `execute` + `registerObserver` on the same query, bridged to a
  /// broadcast-free stream that cancels the observer on unsubscribe.
  Stream<T> _observed<T>({
    required String sql,
    required Map<String, dynamic> args,
    required T Function(dynamic result) map,
    required T empty,
    required String label,
  }) {
    final controller = StreamController<T>();
    dynamic observer;
    final ditto = dittoHandle;
    if (ditto == null) return Stream.value(empty);

    unawaited(() async {
      try {
        final initial = await ditto.store.execute(sql, arguments: args);
        if (controller.isClosed) return;
        controller.add(map(initial));
        if (controller.isClosed) return;
        observer = ditto.store.registerObserver(
          sql,
          arguments: args,
          onChange: (r) {
            if (!controller.isClosed) controller.add(map(r));
          },
        );
      } catch (e, s) {
        talker.error('$label: $e\n$s');
        if (!controller.isClosed) controller.add(empty);
      }
    }());

    controller.onCancel = () async {
      try {
        await observer?.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
  }

  // --- Branch settings ------------------------------------------------------

  @override
  Future<HotelBranchSettings?> hotelBranchSettings({
    required String branchId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return null;
    _ensureHotelSettingsSync(ditto, branchId);
    final result = await ditto.store.execute(
      _hotelBranchSettingsSql,
      arguments: {'branchId': branchId},
    );
    return _settingsFromResult(result);
  }

  @override
  Stream<HotelBranchSettings?> hotelBranchSettingsStream({
    required String branchId,
  }) {
    final ditto = dittoHandle;
    if (ditto == null) return Stream.value(null);
    _ensureHotelSettingsSync(ditto, branchId);
    return _observed<HotelBranchSettings?>(
      sql: _hotelBranchSettingsSql,
      args: {'branchId': branchId},
      map: _settingsFromResult,
      empty: null,
      label: 'hotelBranchSettingsStream',
    );
  }

  @override
  Future<void> saveHotelBranchSettings(HotelBranchSettings settings) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');
    final doc = settings.copyWith(updatedAt: DateTime.now().toUtc()).toJson();
    await ditto.store.execute(
      'INSERT INTO hotel_branch_settings DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  // --- Rooms ----------------------------------------------------------------

  @override
  Future<List<HotelRoom>> hotelRooms({required String branchId}) async {
    final ditto = dittoHandle;
    if (ditto == null) return [];
    _ensureHotelRoomsSync(ditto, branchId);
    final result = await ditto.store.execute(
      _hotelRoomsSql,
      arguments: {'branchId': branchId},
    );
    return _roomsFromResult(result);
  }

  @override
  Stream<List<HotelRoom>> hotelRoomsStream({required String branchId}) {
    final ditto = dittoHandle;
    if (ditto == null) return Stream.value(<HotelRoom>[]);
    _ensureHotelRoomsSync(ditto, branchId);
    return _observed<List<HotelRoom>>(
      sql: _hotelRoomsSql,
      args: {'branchId': branchId},
      map: _roomsFromResult,
      empty: const <HotelRoom>[],
      label: 'hotelRoomsStream',
    );
  }

  @override
  Future<void> saveHotelRoom(HotelRoom room) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');
    await ditto.store.execute(
      'INSERT INTO hotel_rooms DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': room.toJson()},
    );
  }

  @override
  Future<void> deleteHotelRoom({
    required String id,
    required String branchId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return;
    await ditto.store.execute(
      'DELETE FROM hotel_rooms WHERE (_id = :id OR id = :id) AND branchId = :branchId',
      arguments: {'id': id, 'branchId': branchId},
    );
  }

  @override
  Future<void> seedDefaultRooms({required String branchId}) async {
    final existing = await hotelRooms(branchId: branchId);
    if (existing.isNotEmpty) return;
    for (final room in defaultHotelRoomPlan(branchId: branchId)) {
      await saveHotelRoom(room);
    }
  }

  @override
  Future<void> setHotelRoomHousekeeping({
    required String roomId,
    required String branchId,
    required HotelHousekeeping housekeeping,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return;
    await ditto.store.execute(
      'UPDATE hotel_rooms SET housekeeping = :housekeeping '
      'WHERE (_id = :id OR id = :id) AND branchId = :branchId',
      arguments: {
        'id': roomId,
        'branchId': branchId,
        'housekeeping': hotelHousekeepingToString(housekeeping),
      },
    );
  }

  // --- Stays ----------------------------------------------------------------

  @override
  Future<List<HotelStay>> hotelStays({required String branchId}) async {
    final ditto = dittoHandle;
    if (ditto == null) return [];
    _ensureHotelStaysSync(ditto, branchId);
    final result = await ditto.store.execute(
      _hotelOpenStaysSql,
      arguments: {'branchId': branchId},
    );
    return _staysFromResult(result);
  }

  @override
  Stream<List<HotelStay>> hotelStaysStream({required String branchId}) {
    final ditto = dittoHandle;
    if (ditto == null) return Stream.value(<HotelStay>[]);
    _ensureHotelStaysSync(ditto, branchId);
    return _observed<List<HotelStay>>(
      sql: _hotelOpenStaysSql,
      args: {'branchId': branchId},
      map: _staysFromResult,
      empty: const <HotelStay>[],
      label: 'hotelStaysStream',
    );
  }

  @override
  Future<HotelStay?> hotelStayForRoom({
    required String branchId,
    required String roomId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      "SELECT * FROM hotel_stays WHERE branchId = :branchId AND roomId = :roomId "
      "AND status IN ('inHouse', 'reserved') LIMIT 1",
      arguments: {'branchId': branchId, 'roomId': roomId},
    );
    final stays = _staysFromResult(result);
    return stays.isEmpty ? null : stays.first;
  }

  @override
  Future<HotelStay?> hotelStayById({required String id}) async {
    final ditto = dittoHandle;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM hotel_stays WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': id},
    );
    final stays = _staysFromResult(result);
    return stays.isEmpty ? null : stays.first;
  }

  @override
  Future<void> saveHotelStay(HotelStay stay) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');
    final doc = stay.copyWith(updatedAt: DateTime.now().toUtc()).toJson();
    await ditto.store.execute(
      'INSERT INTO hotel_stays DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  @override
  Future<HotelStay> checkInGuest({
    required String branchId,
    required HotelRoom room,
    required String guestName,
    required DateTime checkInAt,
    required DateTime expectedCheckOutAt,
    required double nightlyRate,
    required String clerkTenantId,
    required String clerkName,
    String? guestPhone,
    int adults = 1,
    int children = 0,
    String? note,
  }) async {
    // Idempotent per room: a double tap at the desk must not open a second
    // folio against the same room.
    final existing = await hotelStayForRoom(
      branchId: branchId,
      roomId: room.id,
    );
    if (existing != null) return existing;

    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');

    final now = DateTime.now().toUtc();
    final ref = const Uuid().v4().substring(0, 8);

    final folio = ITransaction(
      branchId: branchId,
      status: PARKED,
      transactionType: SALE,
      subTotal: 0,
      cashReceived: 0,
      customerChangeDue: 0,
      paymentType: ProxyService.box.paymentType() ?? 'Cash',
      isIncome: true,
      isExpense: false,
      agentId: clerkTenantId,
      cashierName: clerkName,
      customerName: guestName,
      customerPhone: guestPhone,
      ticketName: 'Room ${room.name} · $guestName',
      note: note ?? 'Checked in by $clerkName',
      createdAt: now,
      updatedAt: now,
      lastTouched: now,
      reference: ref,
      transactionNumber: ref,
    );

    final folioDoc = await ITransactionDittoAdapter.instance.toDittoDocument(
      folio,
    );
    await ditto.store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc)',
      arguments: {'doc': folioDoc},
    );

    final stay = HotelStay(
      id: const Uuid().v4(),
      branchId: branchId,
      roomId: room.id,
      roomName: room.name,
      transactionId: folio.id,
      guestName: guestName,
      guestPhone: guestPhone,
      adults: adults,
      children: children,
      checkInAt: checkInAt.toUtc(),
      expectedCheckOutAt: expectedCheckOutAt.toUtc(),
      nightlyRate: nightlyRate,
      status: HotelStayStatus.inHouse,
      openedByTenantId: clerkTenantId,
      openedByName: clerkName,
      note: note,
      createdAt: now,
      updatedAt: now,
    );
    await saveHotelStay(stay);

    // Housekeeping is deliberately untouched: occupancy is derived from the
    // open stay ([hotelRoomState]), so a room does not need a status write to
    // stop being sellable. It flips to `dirty` at checkout instead.
    return stay;
  }

  @override
  Future<void> cancelHotelStay({required HotelStay stay}) async {
    await saveHotelStay(stay.copyWith(status: HotelStayStatus.cancelled));

    final ditto = dittoHandle;
    if (ditto != null) {
      // Drop the empty folio so cancelled bookings never surface as tickets.
      await ditto.store.execute(
        'DELETE FROM transactions WHERE (_id = :id OR id = :id) AND status = :status',
        arguments: {'id': stay.transactionId, 'status': PARKED},
      );
    }
    cartLineDocCache.forget(stay.transactionId);

    await setHotelRoomHousekeeping(
      roomId: stay.roomId,
      branchId: stay.branchId,
      housekeeping: HotelHousekeeping.clean,
    );
  }


  @override
  Future<List<HotelStay>> hotelStaysInRange({
    required String branchId,
    required DateTime from,
    required DateTime to,
  }) async {
    // Ditto has no date arithmetic in DQL, so the overlap test is applied in
    // Dart over the branch's open stays — a bounded set (one row per held room).
    final open = await hotelStays(branchId: branchId);
    return open
        .where((stay) => hotelStayOverlapsRange(stay, from, to))
        .toList();
  }

  @override
  Future<HotelStay> reserveRoom({
    required String branchId,
    required HotelRoom room,
    required String guestName,
    required DateTime checkInAt,
    required DateTime expectedCheckOutAt,
    required double nightlyRate,
    required String clerkTenantId,
    required String clerkName,
    String? guestPhone,
    int adults = 1,
    int children = 0,
    String? note,
  }) async {
    final clashes = await hotelStaysInRange(
      branchId: branchId,
      from: checkInAt,
      to: expectedCheckOutAt,
    );
    if (!hotelRoomAvailableForRange(
      room: room,
      stays: clashes,
      from: checkInAt,
      to: expectedCheckOutAt,
    )) {
      throw StateError(
        'Room ${room.name} is not available for those dates.',
      );
    }

    final now = DateTime.now().toUtc();
    final stay = HotelStay(
      id: const Uuid().v4(),
      branchId: branchId,
      roomId: room.id,
      roomName: room.name,
      // No folio until arrival — see [HotelInterface.reserveRoom].
      transactionId: '',
      guestName: guestName,
      guestPhone: guestPhone,
      adults: adults,
      children: children,
      checkInAt: checkInAt.toUtc(),
      expectedCheckOutAt: expectedCheckOutAt.toUtc(),
      nightlyRate: nightlyRate,
      status: HotelStayStatus.reserved,
      openedByTenantId: clerkTenantId,
      openedByName: clerkName,
      note: note,
      createdAt: now,
      updatedAt: now,
    );
    await saveHotelStay(stay);
    return stay;
  }

  @override
  Future<HotelStay> checkInReservation({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    if (stay.status != HotelStayStatus.reserved) return stay;

    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');

    final now = DateTime.now().toUtc();
    final ref = const Uuid().v4().substring(0, 8);

    final folio = ITransaction(
      branchId: stay.branchId,
      status: PARKED,
      transactionType: SALE,
      subTotal: 0,
      cashReceived: 0,
      customerChangeDue: 0,
      paymentType: ProxyService.box.paymentType() ?? 'Cash',
      isIncome: true,
      isExpense: false,
      agentId: clerkTenantId,
      cashierName: clerkName,
      customerName: stay.guestName,
      customerPhone: stay.guestPhone,
      ticketName: 'Room ${stay.roomName} · ${stay.guestName}',
      note: stay.note ?? 'Checked in by $clerkName',
      createdAt: now,
      updatedAt: now,
      lastTouched: now,
      reference: ref,
      transactionNumber: ref,
    );

    final doc = await ITransactionDittoAdapter.instance.toDittoDocument(folio);
    await ditto.store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc)',
      arguments: {'doc': doc},
    );

    final arrived = stay.copyWith(
      transactionId: folio.id,
      status: HotelStayStatus.inHouse,
      checkInAt: now,
      updatedAt: now,
    );
    await saveHotelStay(arrived);
    return arrived;
  }

  // --- Charging other outlets to a room -------------------------------------

  @override
  Future<List<HotelStay>> chargeableStays({required String branchId}) async {
    final stays = await hotelStays(branchId: branchId);
    // A reservation has no folio until the guest arrives, so it cannot take a
    // bar tab.
    return stays
        .where((stay) => stay.status == HotelStayStatus.inHouse && stay.hasFolio)
        .toList();
  }

  @override
  Future<int> transferCartToFolio({
    required String cartTransactionId,
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');

    if (!stay.hasFolio) {
      throw StateError(
        '${stay.guestName} has not checked into room ${stay.roomName} yet, '
        'so there is no folio to charge.',
      );
    }
    if (cartTransactionId == stay.transactionId) return 0;

    // Refuse a settled sale outright. This deletes the source transaction, and
    // doing that to something already invoiced would destroy a revenue row and
    // its RRA receipt.
    final cartResult = await ditto.store.execute(
      'SELECT * FROM transactions WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': cartTransactionId},
    );
    final cartItems = cartResult.items as Iterable<dynamic>;
    if (cartItems.isNotEmpty) {
      final cartDoc = Map<String, dynamic>.from(cartItems.first.value as Map);
      if (cartDoc['status'] == COMPLETE) {
        throw StateError(
          'That sale is already settled and cannot be moved onto a folio.',
        );
      }
    }

    final lines = await hotelFolioLines(transactionId: cartTransactionId);
    if (lines.isEmpty) return 0;

    final nowIso = DateTime.now().toUtc().toIso8601String();

    // Re-point the lines rather than re-creating them: they already carry the
    // itemCd and tax amounts the selling outlet computed, and recomputing here
    // would risk a different answer for the same sale.
    await ditto.store.execute(
      'UPDATE transaction_items SET transactionId = :folioId, '
      'updatedAt = :updatedAt, lastTouched = :lastTouched '
      'WHERE transactionId = :cartId',
      arguments: {
        'folioId': stay.transactionId,
        'cartId': cartTransactionId,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
    cartLineDocCache.forget(cartTransactionId);
    cartLineDocCache.forget(stay.transactionId);

    // The cart was never a sale — it becomes part of the stay's single
    // invoice — so it must not survive as a ticket or a second revenue row.
    await ditto.store.execute(
      'DELETE FROM transactions WHERE _id = :id OR id = :id',
      arguments: {'id': cartTransactionId},
    );

    await refreshFolioSubTotal(transactionId: stay.transactionId);

    talker.info(
      'hotel: moved ${lines.length} line(s) from cart $cartTransactionId to '
      'room ${stay.roomName} folio ${stay.transactionId} by $clerkName',
    );
    return lines.length;
  }

  // --- Quotations -----------------------------------------------------------

  @override
  Future<List<HotelQuotation>> hotelQuotations({
    required String branchId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return [];
    _ensureHotelStaysSync(ditto, branchId);
    final result = await ditto.store.execute(
      _hotelQuotationsSql,
      arguments: {'branchId': branchId},
    );
    return _quotationsFromResult(result);
  }

  @override
  Stream<List<HotelQuotation>> hotelQuotationsStream({
    required String branchId,
  }) {
    final ditto = dittoHandle;
    if (ditto == null) return Stream.value(const <HotelQuotation>[]);
    _ensureHotelStaysSync(ditto, branchId);
    return _observed<List<HotelQuotation>>(
      sql: _hotelQuotationsSql,
      args: {'branchId': branchId},
      map: _quotationsFromResult,
      empty: const <HotelQuotation>[],
      label: 'hotelQuotationsStream',
    );
  }

  @override
  Future<void> saveHotelQuotation(HotelQuotation quotation) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');
    final doc = quotation.copyWith(updatedAt: DateTime.now().toUtc()).toJson();
    await ditto.store.execute(
      'INSERT INTO hotel_quotations DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  @override
  Future<void> deleteHotelQuotation({
    required String id,
    required String branchId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return;
    await ditto.store.execute(
      'DELETE FROM hotel_quotations WHERE (_id = :id OR id = :id) '
      'AND branchId = :branchId',
      arguments: {'id': id, 'branchId': branchId},
    );
  }

  @override
  Future<HotelStay> convertQuotationToReservation({
    required HotelQuotation quotation,
    required HotelRoom room,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    if (!hotelQuotationCanConvert(quotation)) {
      throw StateError(
        'Quotation ${quotation.reference} can no longer be converted.',
      );
    }

    // reserveRoom re-checks availability, so a room sold between quoting and
    // accepting fails here rather than double-booking.
    final stay = await reserveRoom(
      branchId: quotation.branchId,
      room: room,
      guestName: quotation.guestName,
      checkInAt: quotation.checkInAt,
      expectedCheckOutAt: quotation.checkOutAt,
      nightlyRate: quotation.nightlyRate,
      clerkTenantId: clerkTenantId,
      clerkName: clerkName,
      guestPhone: quotation.guestPhone,
      adults: quotation.adults,
      children: quotation.children,
      note: quotation.note ?? 'From quotation ${quotation.reference}',
    );

    await saveHotelQuotation(
      quotation.copyWith(
        status: HotelQuotationStatus.converted,
        convertedStayId: stay.id,
      ),
    );

    return stay;
  }

  // --- Folio ----------------------------------------------------------------

  @override
  Future<ITransaction?> hotelFolio({required String transactionId}) async {
    final ditto = dittoHandle;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM transactions WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': transactionId},
    );
    if (result.items.isEmpty) return null;
    return await ITransactionDittoAdapter.instance.fromDittoDocument(
      Map<String, dynamic>.from(result.items.first.value),
    );
  }

  Future<List<ITransaction>> _foliosFromResult(dynamic queryResult) async {
    final list = <ITransaction>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        final data = Map<String, dynamic>.from(item.value as Map);
        final txn = await ITransactionDittoAdapter.instance.fromDittoDocument(
          data,
        );
        if (txn != null) list.add(txn);
      } catch (e) {
        talker.error('hotel open folio map error: $e');
      }
    }
    return list;
  }

  @override
  Future<List<ITransaction>> hotelOpenFolios({
    required String branchId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return [];
    _ensureHotelStaysSync(ditto, branchId);
    final result = await ditto.store.execute(
      _hotelOpenFoliosSql,
      arguments: {'branchId': branchId, 'status': PARKED},
    );
    return _foliosFromResult(result);
  }

  @override
  Stream<List<ITransaction>> hotelOpenFoliosStream({
    required String branchId,
  }) {
    final ditto = dittoHandle;
    if (ditto == null) return Stream.value(const <ITransaction>[]);
    _ensureHotelStaysSync(ditto, branchId);

    final controller = StreamController<List<ITransaction>>();
    final args = {'branchId': branchId, 'status': PARKED};
    dynamic observer;

    unawaited(() async {
      try {
        final initial = await ditto.store.execute(
          _hotelOpenFoliosSql,
          arguments: args,
        );
        if (!controller.isClosed) {
          controller.add(await _foliosFromResult(initial));
        }
        observer = ditto.store.registerObserver(
          _hotelOpenFoliosSql,
          arguments: args,
          onChange: (r) async {
            if (!controller.isClosed) {
              controller.add(await _foliosFromResult(r));
            }
          },
        );
      } catch (e, s) {
        talker.error('hotelOpenFoliosStream: $e\n$s');
        if (!controller.isClosed) controller.add(const []);
      }
    }());

    controller.onCancel = () async {
      try {
        await observer?.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Future<List<TransactionItem>> hotelFolioLines({
    required String transactionId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return [];
    final result = await ditto.store.execute(
      _hotelFolioLinesSql,
      arguments: {'transactionId': transactionId},
    );
    return _linesFromResult(result);
  }

  @override
  Stream<List<TransactionItem>> hotelFolioLinesStream({
    required String transactionId,
  }) {
    final ditto = dittoHandle;
    if (ditto == null) return Stream.value(<TransactionItem>[]);
    return _observed<List<TransactionItem>>(
      sql: _hotelFolioLinesSql,
      args: {'transactionId': transactionId},
      map: _linesFromResult,
      empty: const <TransactionItem>[],
      label: 'hotelFolioLinesStream',
    );
  }

  /// Rewrites a line's qty, price and every RRA amount derived from them.
  ///
  /// `taxblAmt`, `taxAmt`, `totAmt` and the discount fields are functions of
  /// qty x price. Changing either without recomputing leaves a folio whose tax
  /// figures contradict its own lines, and [checkOutGuest] would invoice that.
  Future<void> _repriceLine({
    required TransactionItem line,
    required num qty,
    required num unitPrice,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return;

    final taxTyCd = line.taxTyCd ?? 'B';
    final taxPct = (line.taxPercentage ?? 18.0).toDouble();
    final pricing = SaleLinePricing.compute(
      unitPrice: unitPrice.toDouble(),
      qty: qty.toDouble(),
      dcRt: (line.dcRt ?? 0).toDouble(),
      taxTyCd: taxTyCd,
      taxPercentage: taxPct,
    );

    final nowIso = DateTime.now().toUtc().toIso8601String();
    await ditto.store.execute(
      'UPDATE transaction_items SET qty = :qty, price = :price, prc = :price, '
      'discount = :discount, dcRt = :dcRt, dcAmt = :dcAmt, '
      'taxblAmt = :taxblAmt, taxAmt = :taxAmt, totAmt = :totAmt, '
      'updatedAt = :updatedAt, lastTouched = :lastTouched '
      'WHERE _id = :id OR id = :id',
      arguments: {
        'id': line.id,
        'qty': qty,
        'price': unitPrice,
        'discount': pricing.discount,
        'dcRt': pricing.dcRt,
        'dcAmt': pricing.dcAmt,
        'taxblAmt': pricing.taxblAmt,
        'taxAmt': pricing.taxAmt,
        'totAmt': pricing.totAmt,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
  }

  @override
  Future<void> addChargeToFolio({
    required String transactionId,
    required String branchId,
    required String variantId,
    required String productName,
    required num defaultPrice,
    required num stock,
    required String clerkTenantId,
    required String clerkName,
    num qty = 1,
    String? color,
    String? sku,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');
    if (qty <= 0) return;

    final lines = await hotelFolioLines(transactionId: transactionId);
    TransactionItem? mergeTarget;
    for (final line in lines) {
      if (lineMatchesMerge(
        line: line,
        variantId: variantId,
        loggedByTenantId: clerkTenantId,
        defaultPrice: defaultPrice,
      )) {
        mergeTarget = line;
        break;
      }
    }

    if (mergeTarget != null) {
      final newQty = mergeTarget.qty + qty;
      if (newQty > stock) return;
      await setFolioLineQty(
        lineId: mergeTarget.id,
        transactionId: transactionId,
        qty: newQty,
        stockCap: stock,
      );
      return;
    }

    if (qty > stock) return;

    final variant = await ProxyService.getStrategy(
      Strategy.capella,
    ).getVariant(id: variantId);
    final taxTyCd = variant?.taxTyCd ?? 'B';
    final taxPct = (variant?.taxPercentage ?? 18.0).toDouble();
    final dcRt = (variant?.dcRt ?? 0).toDouble();
    final pricing = SaleLinePricing.compute(
      unitPrice: defaultPrice.toDouble(),
      qty: qty.toDouble(),
      dcRt: dcRt,
      taxTyCd: taxTyCd,
      taxPercentage: taxPct,
    );

    final itemCd = rraItemCd(
      variant: variant,
      sku: sku ?? variant?.sku,
      variantId: variantId,
    );
    if (itemCd == null) {
      throw StateError(
        'Cannot post "$productName" to the folio: no RRA itemCd on variant. '
        'Register the product with RRA first.',
      );
    }

    final line = TransactionItem(
      name: productName,
      itemNm: variant?.itemNm ?? productName,
      variantId: variantId,
      transactionId: transactionId,
      branchId: branchId,
      qty: qty,
      price: defaultPrice,
      prc: variant?.retailPrice ?? defaultPrice,
      discount: pricing.discount,
      dcRt: pricing.dcRt,
      dcAmt: pricing.dcAmt,
      taxblAmt: pricing.taxblAmt,
      taxAmt: pricing.taxAmt,
      totAmt: pricing.totAmt,
      ttCatCd: rraTtCatCdForItem(variant: variant),
      itemTyCd: variant?.itemTyCd ?? '2',
      itemCd: itemCd,
      taxTyCd: taxTyCd,
      taxPercentage: taxPct,
      qtyUnitCd: variant?.qtyUnitCd,
      pkgUnitCd: variant?.pkgUnitCd,
      itemClsCd: variant?.itemClsCd,
      bhfId: variant?.bhfId,
      regrNm: variant?.regrNm ?? 'Registrar',
      orgnNatCd: variant?.orgnNatCd ?? 'RW',
      itemSeq: variant?.itemSeq,
      bcd: variant?.bcd,
      color: color,
      sku: sku ?? variant?.sku,
      loggedByTenantId: clerkTenantId,
      loggedByName: clerkName,
    );

    final doc = await TransactionItemDittoAdapter.instance.toDittoDocument(line);
    await ditto.store.execute(
      'INSERT INTO transaction_items DOCUMENTS (:doc)',
      arguments: {'doc': doc},
    );
    cartLineDocCache.forget(transactionId);
    await refreshFolioSubTotal(transactionId: transactionId);
  }

  @override
  Future<void> postRoomCharge({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    // The room's own RRA item first: accommodation is a tourism-tax service,
    // and billing it against some other branch-level product would invoice it
    // as an ordinary good at VAT. The branch fallback only exists for rooms
    // created before rooms carried their own registration.
    final rooms = await hotelRooms(branchId: stay.branchId);
    String? variantId;
    for (final room in rooms) {
      if (room.id == stay.roomId && room.isRegisteredWithRra) {
        variantId = room.variantId;
        break;
      }
    }

    if (variantId == null) {
      // The branch-level product is a fallback for rooms that predate
      // per-room registration. Read it directly rather than through
      // canAutoPostRoomCharge: that flag says whether to post *automatically*,
      // and it must not stop the desk posting the charge by hand.
      final settings = await hotelBranchSettings(branchId: stay.branchId);
      variantId = settings?.roomChargeVariantId;
    }

    if (variantId == null || variantId.isEmpty) {
      // A branch that is not on EBM has no registered items by design, and
      // rooms there are deliberately kept off RRA. It still runs a hotel and
      // still bills guests, so record the nights as a plain line rather than
      // refusing: a folio that can never total anything is worse than one that
      // is simply not fiscalised.
      final ebm = await ProxyService.getStrategy(
        Strategy.capella,
      ).ebm(branchId: stay.branchId);

      if (!hotelBranchSupportsRra(ebm)) {
        await _postUnfiscalisedRoomCharge(
          stay: stay,
          clerkTenantId: clerkTenantId,
          clerkName: clerkName,
        );
        return;
      }

      // On an EBM branch a missing item is a real problem, so say so loudly.
      throw StateError(
        'Room ${stay.roomName} has no RRA item to bill its nights against. '
        'Register the room under Settings → Hotel Mode → Rooms & floors, or '
        'set a room-charge product for the branch.',
      );
    }

    final nights = stay.nights;
    await addChargeToFolio(
      transactionId: stay.transactionId,
      branchId: stay.branchId,
      variantId: variantId,
      productName: hotelRoomChargeName(
        roomName: stay.roomName,
        nights: nights,
      ),
      defaultPrice: stay.nightlyRate,
      // A room night is not stock-controlled; the cap only exists to satisfy
      // the shared line path.
      stock: nights,
      clerkTenantId: clerkTenantId,
      clerkName: clerkName,
      qty: nights,
    );
  }

  /// Bills the nights on a branch that is not registered for EBM.
  ///
  /// No `itemCd`, no tax codes — there is no registered item to carry them and
  /// inventing one would put a fabricated code on a fiscal document. The line
  /// still totals, so the desk can take the money.
  Future<void> _postUnfiscalisedRoomCharge({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');

    final nights = stay.nights;
    final now = DateTime.now().toUtc().toIso8601String();
    final id = const Uuid().v4();

    await ditto.store.execute(
      'INSERT INTO transaction_items DOCUMENTS (:doc)',
      arguments: {
        'doc': {
          '_id': id,
          'id': id,
          'transactionId': stay.transactionId,
          'branchId': stay.branchId,
          'name': hotelRoomChargeName(roomName: stay.roomName, nights: nights),
          'qty': nights,
          'price': stay.nightlyRate,
          'prc': stay.nightlyRate,
          'discount': 0,
          'active': true,
          'loggedByTenantId': clerkTenantId,
          'loggedByName': clerkName,
          'createdAt': now,
          'updatedAt': now,
          'lastTouched': now,
        },
      },
    );
    cartLineDocCache.forget(stay.transactionId);
    await refreshFolioSubTotal(transactionId: stay.transactionId);

    talker.info(
      'hotel: branch ${stay.branchId} is not on EBM — billed room '
      '${stay.roomName} ($nights night(s)) without RRA fields.',
    );
  }

  @override
  Future<void> setFolioLineQty({
    required String lineId,
    required String transactionId,
    required num qty,
    required num stockCap,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return;

    final lines = await hotelFolioLines(transactionId: transactionId);
    final line = _hotelFindLine(lines, lineId);
    if (line == null) return;

    final clamped = qty.clamp(0, stockCap);
    if (clamped <= 0) {
      await deleteFolioLine(lineId: lineId, transactionId: transactionId);
      return;
    }

    await _repriceLine(line: line, qty: clamped, unitPrice: line.price);
    cartLineDocCache.forget(transactionId);
    await refreshFolioSubTotal(transactionId: transactionId);
  }

  @override
  Future<void> setFolioLinePrice({
    required String lineId,
    required String transactionId,
    required num price,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return;

    final lines = await hotelFolioLines(transactionId: transactionId);
    final line = _hotelFindLine(lines, lineId);
    if (line == null) return;

    await _repriceLine(line: line, qty: line.qty, unitPrice: price);
    cartLineDocCache.forget(transactionId);
    await refreshFolioSubTotal(transactionId: transactionId);
  }

  @override
  Future<void> deleteFolioLine({
    required String lineId,
    required String transactionId,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) return;

    final lines = await hotelFolioLines(transactionId: transactionId);
    final line = _hotelFindLine(lines, lineId);
    if (line == null) return;

    await ditto.store.execute(
      'DELETE FROM transaction_items WHERE _id = :id OR id = :id',
      arguments: {'id': lineId},
    );
    cartLineDocCache.forget(transactionId);
    await refreshFolioSubTotal(transactionId: transactionId);
  }

  @override
  Future<void> refreshFolioSubTotal({required String transactionId}) async {
    final ditto = dittoHandle;
    if (ditto == null) return;
    final lines = await hotelFolioLines(transactionId: transactionId);
    final total = hotelFolioTotal(lines);
    final nowIso = DateTime.now().toUtc().toIso8601String();
    await ditto.store.execute(
      'UPDATE transactions SET subTotal = :subTotal, updatedAt = :updatedAt, '
      'lastTouched = :lastTouched WHERE _id = :id OR id = :id',
      arguments: {
        'id': transactionId,
        'subTotal': total,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
  }

  @override
  Future<ITransaction> checkOutGuest({
    required HotelStay stay,
    required ITransaction transaction,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  }) async {
    final ditto = dittoHandle;
    if (ditto == null) throw StateError('Ditto not initialized');

    final now = DateTime.now().toUtc();
    final settled = transaction.copyWith(
      status: COMPLETE,
      paymentType: paymentType,
      cashReceived: cashReceived,
      customerChangeDue: customerChangeDue,
      updatedAt: now,
      lastTouched: now,
    );

    final doc = await ITransactionDittoAdapter.instance.toDittoDocument(settled);
    await ditto.store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
    cartLineDocCache.forget(transaction.id);

    await saveHotelStay(
      stay.copyWith(status: HotelStayStatus.checkedOut, checkedOutAt: now),
    );

    // Released to housekeeping, not straight back to sellable.
    await setHotelRoomHousekeeping(
      roomId: stay.roomId,
      branchId: stay.branchId,
      housekeeping: HotelHousekeeping.dirty,
    );

    return settled;
  }
}
