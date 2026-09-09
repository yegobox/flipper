import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/interfaces/hotel_interface.dart';
import 'package:flipper_models/sync/utils/cart_line_doc_cache.dart';
import 'package:flipper_models/sync/utils/ditto_transaction_line.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
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

/// Keys of Ditto sync subscriptions already registered for hotel collections.
/// Store queries/observers only read locally; without these subscriptions a
/// fresh device never replicates hotel documents from the mesh/cloud.
final Set<String> _hotelSyncSubscriptionKeys = <String>{};

mixin CapellaHotelMixin implements HotelInterface {
  DittoService get dittoService;
  Talker get talker;

  /// The Ditto instance every query in this mixin runs against.
  ///
  /// A seam, not indirection for its own sake: [DittoService.dittoInstance] is
  /// typed to the real `Ditto`, which cannot be constructed in a unit test, so
  /// tests override this with an in-memory store. Production keeps the single
  /// implementation below.
  dynamic get dittoHandle => dittoHandle;

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
    if (_hotelSyncSubscriptionKeys.contains(key)) return;
    try {
      final prepared = prepareDqlSyncSubscription(sql, args);
      ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      _hotelSyncSubscriptionKeys.add(key);
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

  /// Current `subTotal` straight off the folio document.
  ///
  /// Deliberately not [hotelFolio]: hydrating a whole [ITransaction] — which
  /// fetches its relationships — to read one number is wasted work on a path
  /// that runs for every line the desk touches. Returns null when there is no
  /// such document.
  Future<double?> _folioSubTotalRaw(String transactionId) async {
    final ditto = dittoHandle;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM transactions WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': transactionId},
    );
    final items = result.items as Iterable<dynamic>;
    if (items.isEmpty) return null;
    final raw = Map<String, dynamic>.from(items.first.value as Map);
    return dittoOptNum(raw['subTotal'])?.toDouble() ?? 0;
  }

  Future<void> _adjustSubtotal(String transactionId, double delta) async {
    final ditto = dittoHandle;
    if (ditto == null) return;
    final current = await _folioSubTotalRaw(transactionId);
    if (current == null) return;
    final nowIso = DateTime.now().toUtc().toIso8601String();
    await ditto.store.execute(
      'UPDATE transactions SET subTotal = :subTotal, updatedAt = :updatedAt, '
      'lastTouched = :lastTouched WHERE _id = :id OR id = :id',
      arguments: {
        'id': transactionId,
        'subTotal': current + delta,
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
    await _adjustSubtotal(
      transactionId,
      line.price.toDouble() * line.qty.toDouble(),
    );
  }

  @override
  Future<void> postRoomCharge({
    required HotelStay stay,
    required String clerkTenantId,
    required String clerkName,
  }) async {
    final settings = await hotelBranchSettings(branchId: stay.branchId);
    final variantId = settings?.roomChargeVariantId;
    if (settings == null || !settings.canAutoPostRoomCharge) {
      talker.info(
        'hotel: skipping room charge for stay ${stay.id} — '
        'branch ${stay.branchId} has no room-charge product configured.',
      );
      return;
    }

    final nights = stay.nights;
    await addChargeToFolio(
      transactionId: stay.transactionId,
      branchId: stay.branchId,
      variantId: variantId!,
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

    final oldTotal = line.price.toDouble() * line.qty.toDouble();
    final clamped = qty.clamp(0, stockCap);

    if (clamped <= 0) {
      await deleteFolioLine(lineId: lineId, transactionId: transactionId);
      return;
    }

    final nowIso = DateTime.now().toUtc().toIso8601String();
    await ditto.store.execute(
      'UPDATE transaction_items SET qty = :qty, updatedAt = :updatedAt, '
      'lastTouched = :lastTouched WHERE _id = :id OR id = :id',
      arguments: {
        'id': lineId,
        'qty': clamped,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
    cartLineDocCache.forget(transactionId);
    final newTotal = line.price.toDouble() * clamped.toDouble();
    await _adjustSubtotal(transactionId, newTotal - oldTotal);
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

    final oldTotal = line.price.toDouble() * line.qty.toDouble();
    final newTotal = price.toDouble() * line.qty.toDouble();
    final nowIso = DateTime.now().toUtc().toIso8601String();

    await ditto.store.execute(
      'UPDATE transaction_items SET price = :price, prc = :price, '
      'updatedAt = :updatedAt, lastTouched = :lastTouched '
      'WHERE _id = :id OR id = :id',
      arguments: {
        'id': lineId,
        'price': price,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
    cartLineDocCache.forget(transactionId);
    await _adjustSubtotal(transactionId, newTotal - oldTotal);
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

    final lineTotal = line.price.toDouble() * line.qty.toDouble();
    await ditto.store.execute(
      'DELETE FROM transaction_items WHERE _id = :id OR id = :id',
      arguments: {'id': lineId},
    );
    cartLineDocCache.forget(transactionId);
    await _adjustSubtotal(transactionId, -lineTotal);
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
