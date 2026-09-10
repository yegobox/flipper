import 'package:flipper_services/constants.dart';
import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/capella/mixins/hotel_mixin.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/ebm.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker/talker.dart';

import 'support/fake_ditto.dart';

/// Exercises [CapellaHotelMixin] against an in-memory store.
class _HotelSync with CapellaHotelMixin {
  _HotelSync(this.fake);

  final FakeDitto fake;

  @override
  dynamic get dittoHandle => fake;

  /// Never reached: [dittoHandle] is overridden above.
  @override
  DittoService get dittoService =>
      throw UnimplementedError('tests go through dittoHandle');

  @override
  final Talker talker = Talker();
}

/// A [DittoService] that has no instance yet — what the app looks like before
/// Ditto finishes starting up.
class _OfflineDittoService implements DittoService {
  @override
  Ditto? get dittoInstance => null;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

/// Uses the mixin's *own* [CapellaHotelMixin.dittoHandle], unlike [_HotelSync]
/// which overrides it. Every other test would pass with a handle that never
/// reaches `dittoService`, so this is the one that pins production wiring.
class _RealHandleHotelSync with CapellaHotelMixin {
  @override
  final DittoService dittoService = _OfflineDittoService();

  @override
  final Talker talker = Talker();
}

/// Minimal box: the mixin only asks it for the branch and the default payment
/// type when it mints a folio.
class _FakeBox extends Mock implements LocalStorage {
  @override
  String? getBranchId() => _branch;
  @override
  String? getBusinessId() => 'biz1';
  @override
  String? paymentType() => 'Cash';
}

/// Strategy stub for the one call the mixin makes outward: looking up the
/// variant behind a charge.
class _FakeStrategy extends Mock implements DatabaseSyncInterface {
  _FakeStrategy(this._byId, {this.branchEbm});

  final Map<String, Variant> _byId;

  /// null means the branch is not registered for EBM, which is what decides
  /// whether a room charge can carry RRA fields at all.
  final Ebm? branchEbm;

  @override
  Future<Ebm?> ebm({required String branchId, bool fetchRemote = true}) async =>
      branchEbm;

  @override
  Future<Variant?> getVariant({
    String? id,
    String? modrId,
    String? name,
    String? bcd,
    String? stockId,
    String? taskCd,
    String? itemClsCd,
    String? itemNm,
    String? itemCd,
    String? productId,
    String? branchId,
    String? sku,
    String? variantId,
    String? imptItemSttsCd,
    String? pchsSttsCd,
    String? purchaseId,
    bool fetchRemote = false,
  }) async => id == null ? null : _byId[id];
}

const _branch = 'b1';

HotelRoom _room({
  String id = 'r1',
  String name = '101',
  int capacity = 2,
  HotelHousekeeping housekeeping = HotelHousekeeping.clean,
}) => HotelRoom(
  id: id,
  branchId: _branch,
  floorId: 'ground',
  floorName: 'Ground Floor',
  name: name,
  roomType: 'Double',
  capacity: capacity,
  nightlyRate: 50000,
  housekeeping: housekeeping,
);

HotelStay _stay({
  String id = 's1',
  String roomId = 'r1',
  String transactionId = 't1',
  HotelStayStatus status = HotelStayStatus.inHouse,
  DateTime? checkIn,
  DateTime? checkOut,
}) => HotelStay(
  id: id,
  branchId: _branch,
  roomId: roomId,
  roomName: '101',
  transactionId: transactionId,
  guestName: 'Aline Uwase',
  checkInAt: checkIn ?? DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: checkOut ?? DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
  status: status,
);

/// A `transaction_items` row as Ditto stores it — numbers as strings, which is
/// what [transactionLineFromDitto] exists to survive.
Map<String, dynamic> _lineDoc({
  required String id,
  required String transactionId,
  String name = 'Beer',
  String qty = '2',
  String price = '1500',
}) => {
  '_id': id,
  'id': id,
  'transactionId': transactionId,
  'branchId': _branch,
  'name': name,
  'qty': qty,
  'price': price,
  'variantId': 'v1',
};

Map<String, dynamic> _folioDoc({
  String id = 't1',
  num subTotal = 0,
  String status = 'parked',
}) => {
  '_id': id,
  'id': id,
  'branchId': _branch,
  'status': status,
  'subTotal': subTotal,
};

void main() {
  late FakeDitto ditto;
  late _HotelSync sync;

  setUp(() {
    ditto = FakeDitto();
    sync = _HotelSync(ditto);
  });

  /// The half of the mixin that reaches outside Ditto: minting a folio needs
  /// the box for the branch and default payment type, and posting a charge
  /// needs the variant behind it. Both are get_it lookups, so registering
  /// fakes is all the harness this needs.
  group('folio lifecycle', () {
    late Variant roomNight;

    setUp(() async {
      await getIt.reset();
      roomNight = Variant(
        id: 'v-room',
        branchId: _branch,
        name: 'Room night',
        itemCd: 'RW1NTXU0000001',
        itemTyCd: '3',
        ttCatCd: 'TT',
        taxTyCd: 'B',
        taxPercentage: 3,
        retailPrice: 50000,
      );
      getIt.registerSingleton<LocalStorage>(_FakeBox());
      final strategy = _FakeStrategy({'v-room': roomNight});
      // ProxyService looks the strategy up by name, not by type alone.
      getIt.registerSingleton<SyncStrategy>(
        SyncStrategy(capella: strategy, cloudSync: strategy),
        instanceName: 'strategy',
      );
      ITransactionDittoAdapter.instance.overrideBranchIdProvider(() => _branch);
      ITransactionDittoAdapter.instance.overrideBusinessIdProvider(
        () => 'biz1',
      );
    });

    tearDown(() async {
      ITransactionDittoAdapter.instance.resetOverrides();
      await getIt.reset();
    });

    Future<HotelRoom> savedRoom() async {
      final r = _room();
      await sync.saveHotelRoom(r);
      return r;
    }

    test('checking a walk-in in opens exactly one folio', () async {
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 50000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(stay.status, HotelStayStatus.inHouse);
      expect(stay.hasFolio, isTrue);
      expect(ditto.store.docs('transactions'), hasLength(1));

      final folio = ditto.store.docs('transactions').single;
      expect(folio['status'], PARKED);
      expect(folio['customerName'], 'Aline Uwase');
    });

    test('a second check-in on an occupied room resumes, never duplicates',
        () async {
      final room = await savedRoom();
      final first = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 50000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );
      final second = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Someone Else',
        checkInAt: DateTime.utc(2026, 1, 10, 15),
        expectedCheckOutAt: DateTime.utc(2026, 1, 13, 11),
        nightlyRate: 90000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(second.id, first.id);
      expect(second.guestName, 'Aline Uwase');
      expect(ditto.store.docs('transactions'), hasLength(1));
    });

    test('arriving a reservation mints its folio and flips it in house',
        () async {
      final room = await savedRoom();
      final booked = await sync.reserveRoom(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 2, 1, 14),
        expectedCheckOutAt: DateTime.utc(2026, 2, 3, 11),
        nightlyRate: 60000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );
      expect(booked.hasFolio, isFalse);
      expect(ditto.store.docs('transactions'), isEmpty);

      final arrived = await sync.checkInReservation(
        stay: booked,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(arrived.status, HotelStayStatus.inHouse);
      expect(arrived.hasFolio, isTrue);
      expect(ditto.store.docs('transactions'), hasLength(1));
    });

    test('arriving an already in-house stay changes nothing', () async {
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 50000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      final again = await sync.checkInReservation(
        stay: stay,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );
      expect(again.transactionId, stay.transactionId);
      expect(ditto.store.docs('transactions'), hasLength(1));
    });

    test('posting a charge writes an RRA-complete line', () async {
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 50000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      await sync.addChargeToFolio(
        transactionId: stay.transactionId,
        branchId: _branch,
        variantId: 'v-room',
        productName: 'Room 101 · 2 nights',
        defaultPrice: 50000,
        stock: 2,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
        qty: 2,
      );

      final lines = await sync.hotelFolioLines(
        transactionId: stay.transactionId,
      );
      expect(lines, hasLength(1));
      expect(lines.single.qty, 2);
      expect(lines.single.itemCd, 'RW1NTXU0000001');
      expect(lines.single.taxPercentage, 3);

      final folio = await sync.hotelFolio(transactionId: stay.transactionId);
      expect(folio?.subTotal, 100000);
    });

    test('a charge with no registered itemCd is refused, not silently sold',
        () async {
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 50000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(
        () => sync.addChargeToFolio(
          transactionId: stay.transactionId,
          branchId: _branch,
          variantId: 'unknown-variant',
          productName: 'Mystery item',
          defaultPrice: 1000,
          stock: 5,
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('an unregistered room on an EBM branch says so', () async {
      // On a fiscalised branch a missing item is a real problem: the nights
      // cannot be invoiced, so it must be reported rather than billed blind.
      await getIt.reset();
      getIt.registerSingleton<LocalStorage>(_FakeBox());
      final onEbm = _FakeStrategy(
        {'v-room': roomNight},
        branchEbm: Ebm(
          bhfId: '00',
          tinNumber: 123456789,
          dvcSrlNo: 'dvc',
          businessId: 'biz1',
          branchId: _branch,
          mrc: 'mrc',
        ),
      );
      getIt.registerSingleton<SyncStrategy>(
        SyncStrategy(capella: onEbm, cloudSync: onEbm),
        instanceName: 'strategy',
      );

      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 11, 11),
        nightlyRate: 55000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(
        () => sync.postRoomCharge(
          stay: stay,
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            allOf(contains(room.name), contains('Rooms & floors')),
          ),
        ),
      );
    });

    test('a branch not on EBM still bills the nights, without RRA fields',
        () async {
      // A property that is not registered for EBM still runs a hotel. Refusing
      // to record the charge leaves a folio that can never total anything,
      // which is worse than one that is simply not fiscalised.
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 85000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      await sync.postRoomCharge(
        stay: stay,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      final lines = await sync.hotelFolioLines(
        transactionId: stay.transactionId,
      );
      expect(lines, hasLength(1));
      expect(lines.single.qty, 2);
      expect(lines.single.price, 85000);
      // No fabricated fiscal identity on an unregistered line.
      expect(lines.single.itemCd, isNull);

      final folio = await sync.hotelFolio(transactionId: stay.transactionId);
      expect(folio?.subTotal, 170000);
    });

    test('a registered room bills its nights against its own RRA item',
        () async {
      final room = (await savedRoom()).copyWith(variantId: 'v-room');
      await sync.saveHotelRoom(room);

      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 55000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      await sync.postRoomCharge(
        stay: stay,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      final lines = await sync.hotelFolioLines(
        transactionId: stay.transactionId,
      );
      expect(lines, hasLength(1));
      expect(lines.single.qty, 2, reason: 'two nights');
      expect(lines.single.itemCd, 'RW1NTXU0000001');

      final folio = await sync.hotelFolio(transactionId: stay.transactionId);
      expect(folio?.subTotal, 110000);
    });

    test('the branch fallback product is used even with auto-post off',
        () async {
      // autoPostRoomCharge governs whether it happens automatically; it must
      // not stop the desk posting the charge by hand.
      await sync.saveHotelBranchSettings(
        const HotelBranchSettings(
          branchId: _branch,
          enabled: true,
          autoPostRoomCharge: false,
          roomChargeVariantId: 'v-room',
        ),
      );
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 11, 11),
        nightlyRate: 55000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      await sync.postRoomCharge(
        stay: stay,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(
        await sync.hotelFolioLines(transactionId: stay.transactionId),
        hasLength(1),
      );
    });

    test('checking out settles the folio and releases the room', () async {
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 50000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );
      final folio = await sync.hotelFolio(
        transactionId: stay.transactionId,
      );

      final settled = await sync.checkOutGuest(
        stay: stay,
        transaction: folio!,
        paymentType: 'Cash',
        cashReceived: 120000,
        customerChangeDue: 20000,
      );

      expect(settled.status, COMPLETE);
      expect(settled.cashReceived, 120000);
      expect(settled.customerChangeDue, 20000);

      // The stay closes and the room goes to housekeeping, not straight back
      // to sellable.
      expect(await sync.hotelStays(branchId: _branch), isEmpty);
      final after = (await sync.hotelRooms(branchId: _branch)).single;
      expect(after.housekeeping, HotelHousekeeping.dirty);
    });

    test('open folios are listed for the dashboard, settled ones are not',
        () async {
      final room = await savedRoom();
      final stay = await sync.checkInGuest(
        branchId: _branch,
        room: room,
        guestName: 'Aline Uwase',
        checkInAt: DateTime.utc(2026, 1, 10, 14),
        expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
        nightlyRate: 50000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(await sync.hotelOpenFolios(branchId: _branch), hasLength(1));

      final folio = await sync.hotelFolio(transactionId: stay.transactionId);
      await sync.checkOutGuest(
        stay: stay,
        transaction: folio!,
        paymentType: 'Cash',
        cashReceived: 0,
        customerChangeDue: 0,
      );

      expect(await sync.hotelOpenFolios(branchId: _branch), isEmpty);
    });
  });

  group('default ditto handle', () {
    // Regression: the getter was once written as `dittoHandle => dittoHandle`,
    // which recursed until StackOverflowError on every hotel query. Nothing
    // caught it because the other tests override the getter.
    test('resolves through dittoService instead of recursing', () async {
      final real = _RealHandleHotelSync();

      expect(await real.hotelRooms(branchId: _branch), isEmpty);
      expect(await real.hotelStays(branchId: _branch), isEmpty);
      expect(await real.hotelQuotations(branchId: _branch), isEmpty);
      expect(await real.hotelBranchSettings(branchId: _branch), isNull);
      expect(await real.hotelFolioLines(transactionId: 't1'), isEmpty);
    });

    test('degrades to empty streams while Ditto is still starting', () async {
      final real = _RealHandleHotelSync();

      expect(await real.hotelRoomsStream(branchId: _branch).first, isEmpty);
      expect(await real.hotelStaysStream(branchId: _branch).first, isEmpty);
    });

    test('writes throw a clear error rather than overflowing the stack',
        () async {
      final real = _RealHandleHotelSync();
      expect(
        () => real.saveHotelRoom(_room()),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('rooms', () {
    test('saves and reads back a room', () async {
      await sync.saveHotelRoom(_room());
      final rooms = await sync.hotelRooms(branchId: _branch);

      expect(rooms, hasLength(1));
      expect(rooms.single.name, '101');
      expect(rooms.single.capacity, 2);
    });

    test('reads only the requested branch', () async {
      await sync.saveHotelRoom(_room());
      await sync.saveHotelRoom(
        HotelRoom(
          id: 'other',
          branchId: 'b2',
          floorId: 'g',
          floorName: 'G',
          name: '999',
          roomType: 'Double',
          capacity: 2,
          nightlyRate: 1,
        ),
      );

      final rooms = await sync.hotelRooms(branchId: _branch);
      expect(rooms.map((r) => r.id), ['r1']);
    });

    test('seeding is idempotent', () async {
      await sync.seedDefaultRooms(branchId: _branch);
      final first = await sync.hotelRooms(branchId: _branch);
      expect(first, isNotEmpty);

      await sync.seedDefaultRooms(branchId: _branch);
      final second = await sync.hotelRooms(branchId: _branch);
      expect(second, hasLength(first.length));
    });

    test('housekeeping updates in place without touching other fields',
        () async {
      await sync.saveHotelRoom(_room());
      await sync.setHotelRoomHousekeeping(
        roomId: 'r1',
        branchId: _branch,
        housekeeping: HotelHousekeeping.outOfOrder,
      );

      final room = (await sync.hotelRooms(branchId: _branch)).single;
      expect(room.housekeeping, HotelHousekeeping.outOfOrder);
      expect(room.name, '101');
      expect(room.nightlyRate, 50000);
    });

    test('delete is scoped to the branch', () async {
      await sync.saveHotelRoom(_room());
      await sync.deleteHotelRoom(id: 'r1', branchId: 'b2');
      expect(await sync.hotelRooms(branchId: _branch), hasLength(1));

      await sync.deleteHotelRoom(id: 'r1', branchId: _branch);
      expect(await sync.hotelRooms(branchId: _branch), isEmpty);
    });
  });

  group('branch settings', () {
    test('round-trips and stamps updatedAt', () async {
      await sync.saveHotelBranchSettings(
        const HotelBranchSettings(branchId: _branch, enabled: true),
      );

      final settings = await sync.hotelBranchSettings(branchId: _branch);
      expect(settings, isNotNull);
      expect(settings!.enabled, isTrue);
      expect(settings.updatedAt, isNotNull);
    });

    test('is null for a branch that has none', () async {
      expect(await sync.hotelBranchSettings(branchId: 'nope'), isNull);
    });
  });

  group('stays', () {
    test('only open stays are listed', () async {
      await sync.saveHotelStay(_stay(id: 'in', roomId: 'r1'));
      await sync.saveHotelStay(
        _stay(id: 'held', roomId: 'r2', status: HotelStayStatus.reserved),
      );
      await sync.saveHotelStay(
        _stay(id: 'gone', roomId: 'r3', status: HotelStayStatus.checkedOut),
      );

      final stays = await sync.hotelStays(branchId: _branch);
      expect(stays.map((s) => s.id).toSet(), {'in', 'held'});
    });

    test('finds the open stay holding a room', () async {
      await sync.saveHotelStay(_stay(id: 'in', roomId: 'r1'));
      final found = await sync.hotelStayForRoom(
        branchId: _branch,
        roomId: 'r1',
      );
      expect(found?.id, 'in');
      expect(
        await sync.hotelStayForRoom(branchId: _branch, roomId: 'r2'),
        isNull,
      );
    });

    test('range query respects half-open nights', () async {
      // Stay occupies the 10th and 11th; the 12th is free.
      await sync.saveHotelStay(_stay(id: 'in', roomId: 'r1'));

      final clashing = await sync.hotelStaysInRange(
        branchId: _branch,
        from: DateTime(2026, 1, 11),
        to: DateTime(2026, 1, 13),
      );
      expect(clashing.map((s) => s.id), ['in']);

      final backToBack = await sync.hotelStaysInRange(
        branchId: _branch,
        from: DateTime(2026, 1, 12),
        to: DateTime(2026, 1, 14),
      );
      expect(backToBack, isEmpty);
    });
  });

  group('reserveRoom', () {
    test('holds the room without opening a folio', () async {
      final stay = await sync.reserveRoom(
        branchId: _branch,
        room: _room(),
        guestName: 'Aline Uwase',
        checkInAt: DateTime(2026, 2, 1, 14),
        expectedCheckOutAt: DateTime(2026, 2, 3, 11),
        nightlyRate: 60000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(stay.status, HotelStayStatus.reserved);
      expect(stay.hasFolio, isFalse);
      // Nothing was written to transactions.
      expect(ditto.store.docs('transactions'), isEmpty);
    });

    test('refuses a room already taken for those dates', () async {
      await sync.saveHotelStay(_stay(id: 'in', roomId: 'r1'));

      expect(
        () => sync.reserveRoom(
          branchId: _branch,
          room: _room(),
          guestName: 'Second Guest',
          checkInAt: DateTime(2026, 1, 11, 14),
          expectedCheckOutAt: DateTime(2026, 1, 13, 11),
          nightlyRate: 60000,
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('allows a back-to-back booking on the departure day', () async {
      await sync.saveHotelStay(_stay(id: 'in', roomId: 'r1'));

      final stay = await sync.reserveRoom(
        branchId: _branch,
        room: _room(),
        guestName: 'Second Guest',
        checkInAt: DateTime(2026, 1, 12, 14),
        expectedCheckOutAt: DateTime(2026, 1, 14, 11),
        nightlyRate: 60000,
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );
      expect(stay.status, HotelStayStatus.reserved);
    });

    test('refuses an out-of-order room even when nothing is booked', () async {
      expect(
        () => sync.reserveRoom(
          branchId: _branch,
          room: _room(housekeeping: HotelHousekeeping.outOfOrder),
          guestName: 'Guest',
          checkInAt: DateTime(2026, 3, 1, 14),
          expectedCheckOutAt: DateTime(2026, 3, 2, 11),
          nightlyRate: 60000,
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('quotations', () {
    HotelQuotation quote({
      String id = 'q1',
      HotelQuotationStatus status = HotelQuotationStatus.sent,
      DateTime? validUntil,
    }) => HotelQuotation(
      id: id,
      branchId: _branch,
      reference: 'Q-ABC123',
      guestName: 'Aline Uwase',
      roomId: 'r1',
      roomName: '101',
      roomType: 'Double',
      checkInAt: DateTime(2026, 2, 1, 14),
      checkOutAt: DateTime(2026, 2, 3, 11),
      nightlyRate: 60000,
      status: status,
      validUntil: validUntil,
    );

    test('round-trips through the store', () async {
      await sync.saveHotelQuotation(quote());
      final quotes = await sync.hotelQuotations(branchId: _branch);
      expect(quotes.single.reference, 'Q-ABC123');
      expect(quotes.single.total, 120000);
    });

    test('converting holds the room and marks the quote booked', () async {
      await sync.saveHotelQuotation(quote());

      final stay = await sync.convertQuotationToReservation(
        quotation: quote(),
        room: _room(),
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(stay.status, HotelStayStatus.reserved);
      expect(stay.roomId, 'r1');

      final stored = (await sync.hotelQuotations(branchId: _branch)).single;
      expect(stored.status, HotelQuotationStatus.converted);
      expect(stored.convertedStayId, stay.id);
    });

    test('a quote cannot be converted twice', () async {
      final converted = quote(status: HotelQuotationStatus.converted);
      await sync.saveHotelQuotation(converted);

      expect(
        () => sync.convertQuotationToReservation(
          quotation: converted,
          room: _room(),
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('a room sold since quoting blocks conversion', () async {
      await sync.saveHotelQuotation(quote());
      // Someone else took the room for those dates in the meantime.
      await sync.saveHotelStay(
        _stay(
          id: 'walkin',
          roomId: 'r1',
          checkIn: DateTime.utc(2026, 2, 1, 14),
          checkOut: DateTime.utc(2026, 2, 4, 11),
        ),
      );

      expect(
        () => sync.convertQuotationToReservation(
          quotation: quote(),
          room: _room(),
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(isA<StateError>()),
      );

      // The quote is left open rather than marked booked.
      final stored = (await sync.hotelQuotations(branchId: _branch)).single;
      expect(stored.status, HotelQuotationStatus.sent);
    });

    test('delete is scoped to the branch', () async {
      await sync.saveHotelQuotation(quote());
      await sync.deleteHotelQuotation(id: 'q1', branchId: 'b2');
      expect(await sync.hotelQuotations(branchId: _branch), hasLength(1));

      await sync.deleteHotelQuotation(id: 'q1', branchId: _branch);
      expect(await sync.hotelQuotations(branchId: _branch), isEmpty);
    });
  });

  group('folio lines', () {
    setUp(() {
      ditto.store.seed('transactions', _folioDoc(subTotal: 3000));
      ditto.store.seed(
        'transaction_items',
        _lineDoc(id: 'l1', transactionId: 't1'),
      );
    });

    double subTotal() =>
        (ditto.store.docs('transactions').single['subTotal'] as num).toDouble();

    test('reads lines back, coercing Ditto string numbers', () async {
      final lines = await sync.hotelFolioLines(transactionId: 't1');
      expect(lines.single.qty, 2);
      expect(lines.single.price, 1500);
    });

    test('raising qty adds only the difference to the subtotal', () async {
      await sync.setFolioLineQty(
        lineId: 'l1',
        transactionId: 't1',
        qty: 3,
        stockCap: 99,
      );
      // 3000 + (3-2)*1500
      expect(subTotal(), 4500);
    });

    test('lowering qty subtracts the difference', () async {
      await sync.setFolioLineQty(
        lineId: 'l1',
        transactionId: 't1',
        qty: 1,
        stockCap: 99,
      );
      expect(subTotal(), 1500);
    });

    test('qty is clamped to the stock cap', () async {
      await sync.setFolioLineQty(
        lineId: 'l1',
        transactionId: 't1',
        qty: 50,
        stockCap: 4,
      );
      final lines = await sync.hotelFolioLines(transactionId: 't1');
      expect(lines.single.qty, 4);
      expect(subTotal(), 3000 + 2 * 1500);
    });

    test('qty zero removes the line and subtracts it exactly once', () async {
      // The bar implementation of this path subtracts twice; the guard here is
      // that deletion owns the adjustment.
      await sync.setFolioLineQty(
        lineId: 'l1',
        transactionId: 't1',
        qty: 0,
        stockCap: 99,
      );

      expect(await sync.hotelFolioLines(transactionId: 't1'), isEmpty);
      expect(subTotal(), 0); // 3000 - (2 * 1500)
    });

    test('deleting a line subtracts its value', () async {
      await sync.deleteFolioLine(lineId: 'l1', transactionId: 't1');
      expect(subTotal(), 0);
      expect(ditto.store.docs('transaction_items'), isEmpty);
    });

    test('changing price adjusts by the difference across the whole qty',
        () async {
      await sync.setFolioLinePrice(
        lineId: 'l1',
        transactionId: 't1',
        price: 2000,
      );
      // 3000 + (2000-1500)*2
      expect(subTotal(), 4000);
      final lines = await sync.hotelFolioLines(transactionId: 't1');
      expect(lines.single.price, 2000);
    });

    test('a stale stored subtotal is corrected by any line edit', () async {
      // Recomputing from lines, rather than adding a delta to what is stored,
      // means two overlapping edits cannot leave the folio inconsistent.
      ditto.store.seed('transactions', _folioDoc(subTotal: 999999));

      await sync.setFolioLineQty(
        lineId: 'l1',
        transactionId: 't1',
        qty: 2,
        stockCap: 99,
      );
      expect(subTotal(), 3000);
    });

    test('editing qty rewrites the RRA amounts derived from it', () async {
      // A folio settled with tax figures that contradict its own lines would
      // be invoiced to RRA that way.
      await sync.setFolioLineQty(
        lineId: 'l1',
        transactionId: 't1',
        qty: 4,
        stockCap: 99,
      );

      final doc = ditto.store.docs('transaction_items').single;
      expect(doc['qty'], 4);
      expect((doc['totAmt'] as num).toDouble(), closeTo(6000, 0.01));
      expect(doc['taxblAmt'], isNotNull);
      expect(doc['taxAmt'], isNotNull);
    });

    test('editing price rewrites the RRA amounts derived from it', () async {
      await sync.setFolioLinePrice(
        lineId: 'l1',
        transactionId: 't1',
        price: 2000,
      );

      final doc = ditto.store.docs('transaction_items').single;
      expect(doc['price'], 2000);
      expect(doc['prc'], 2000);
      expect((doc['totAmt'] as num).toDouble(), closeTo(4000, 0.01));
    });

    test('an unknown line changes nothing', () async {
      await sync.setFolioLineQty(
        lineId: 'nope',
        transactionId: 't1',
        qty: 9,
        stockCap: 99,
      );
      await sync.deleteFolioLine(lineId: 'nope', transactionId: 't1');
      expect(subTotal(), 3000);
      expect(await sync.hotelFolioLines(transactionId: 't1'), hasLength(1));
    });

    test('refresh recomputes the subtotal from the lines, fixing drift',
        () async {
      ditto.store.seed(
        'transaction_items',
        _lineDoc(id: 'l2', transactionId: 't1', qty: '1', price: '500'),
      );

      await sync.refreshFolioSubTotal(transactionId: 't1');
      // (2 * 1500) + (1 * 500), regardless of the stored 3000.
      expect(subTotal(), 3500);
    });

    test('lines of another folio are untouched', () async {
      ditto.store.seed(
        'transaction_items',
        _lineDoc(id: 'other', transactionId: 't2'),
      );

      final lines = await sync.hotelFolioLines(transactionId: 't1');
      expect(lines.map((l) => l.id), ['l1']);
    });

    test('adjusting a folio that does not exist is a no-op', () async {
      await sync.deleteFolioLine(lineId: 'l1', transactionId: 'ghost');
      expect(subTotal(), 3000);
    });
  });

  group('charging another outlet to a room', () {
    setUp(() {
      // A guest in house with an open folio, and a bar cart to move onto it.
      ditto.store.seed('transactions', _folioDoc(id: 'folio', subTotal: 5000));
      ditto.store.seed('transactions', _folioDoc(id: 'cart', subTotal: 3000));
      ditto.store.seed(
        'transaction_items',
        _lineDoc(id: 'room-night', transactionId: 'folio', qty: '1',
            price: '5000'),
      );
      ditto.store.seed(
        'transaction_items',
        _lineDoc(id: 'beer', transactionId: 'cart', qty: '2', price: '1500'),
      );
    });

    HotelStay inHouse({String transactionId = 'folio'}) =>
        _stay(id: 'guest', roomId: 'r1', transactionId: transactionId);

    test('only in-house stays with a folio can take a charge', () async {
      await sync.saveHotelStay(inHouse());
      await sync.saveHotelStay(
        _stay(
          id: 'booked',
          roomId: 'r2',
          transactionId: '',
          status: HotelStayStatus.reserved,
        ),
      );

      final chargeable = await sync.chargeableStays(branchId: _branch);
      expect(chargeable.map((s) => s.id), ['guest']);
    });

    test('moves the lines onto the folio and totals them together', () async {
      final moved = await sync.transferCartToFolio(
        cartTransactionId: 'cart',
        stay: inHouse(),
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(moved, 1);

      final folioLines = await sync.hotelFolioLines(transactionId: 'folio');
      expect(folioLines.map((l) => l.id).toSet(), {'room-night', 'beer'});

      // 5000 room night + 2 x 1500 beer, on one bill.
      final folio = ditto.store
          .docs('transactions')
          .firstWhere((d) => d['_id'] == 'folio');
      expect((folio['subTotal'] as num).toDouble(), 8000);
    });

    test('keeps the RRA fields the selling outlet computed', () async {
      ditto.store.seed('transaction_items', {
        ..._lineDoc(id: 'taxed', transactionId: 'cart'),
        'itemCd': 'RW2NTXU0000042',
        'taxAmt': '457.63',
        'totAmt': '3000',
        'taxTyCd': 'B',
      });

      await sync.transferCartToFolio(
        cartTransactionId: 'cart',
        stay: inHouse(),
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      final moved = (await sync.hotelFolioLines(transactionId: 'folio'))
          .firstWhere((l) => l.id == 'taxed');
      expect(moved.itemCd, 'RW2NTXU0000042');
      expect(moved.taxAmt, 457.63);
      expect(moved.taxTyCd, 'B');
    });

    test('disposes of the cart so it is not invoiced twice', () async {
      await sync.transferCartToFolio(
        cartTransactionId: 'cart',
        stay: inHouse(),
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      final ids = ditto.store.docs('transactions').map((d) => d['_id']);
      expect(ids, ['folio']);
      expect(await sync.hotelFolioLines(transactionId: 'cart'), isEmpty);
    });

    test('a reservation cannot be charged, it has no folio', () async {
      expect(
        () => sync.transferCartToFolio(
          cartTransactionId: 'cart',
          stay: _stay(
            id: 'booked',
            roomId: 'r2',
            transactionId: '',
            status: HotelStayStatus.reserved,
          ),
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('a settled sale is refused, not moved', () async {
      // Moving one would delete a revenue row that already has an RRA receipt.
      // The status string is the COMPLETE constant, not a lookalike.
      expect(COMPLETE, 'completed');
      ditto.store.seed(
        'transactions',
        _folioDoc(id: 'settled', status: 'completed'),
      );
      ditto.store.seed(
        'transaction_items',
        _lineDoc(id: 'sold', transactionId: 'settled'),
      );

      expect(
        () => sync.transferCartToFolio(
          cartTransactionId: 'settled',
          stay: inHouse(),
          clerkTenantId: 'c1',
          clerkName: 'Richie',
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('an empty cart moves nothing and leaves the folio alone', () async {
      final moved = await sync.transferCartToFolio(
        cartTransactionId: 'empty',
        stay: inHouse(),
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(moved, 0);
      final folio = ditto.store
          .docs('transactions')
          .firstWhere((d) => d['_id'] == 'folio');
      expect((folio['subTotal'] as num).toDouble(), 5000);
    });

    test('charging a folio to itself is a no-op, not a wipe', () async {
      final moved = await sync.transferCartToFolio(
        cartTransactionId: 'folio',
        stay: inHouse(),
        clerkTenantId: 'c1',
        clerkName: 'Richie',
      );

      expect(moved, 0);
      expect(
        (await sync.hotelFolioLines(transactionId: 'folio')).map((l) => l.id),
        ['room-night'],
      );
    });

    test('two outlets charging the same room both land', () async {
      ditto.store.seed('transactions', _folioDoc(id: 'cart2'));
      ditto.store.seed(
        'transaction_items',
        _lineDoc(id: 'dinner', transactionId: 'cart2', qty: '1', price: '9000'),
      );

      await sync.transferCartToFolio(
        cartTransactionId: 'cart',
        stay: inHouse(),
        clerkTenantId: 'c1',
        clerkName: 'Bar',
      );
      await sync.transferCartToFolio(
        cartTransactionId: 'cart2',
        stay: inHouse(),
        clerkTenantId: 'c2',
        clerkName: 'Restaurant',
      );

      final folio = ditto.store
          .docs('transactions')
          .firstWhere((d) => d['_id'] == 'folio');
      // 5000 + 3000 + 9000, one consolidated bill.
      expect((folio['subTotal'] as num).toDouble(), 17000);
    });
  });

  group('cancelHotelStay', () {
    test('cancels the stay, drops its empty folio and frees the room',
        () async {
      await sync.saveHotelRoom(_room(housekeeping: HotelHousekeeping.dirty));
      await sync.saveHotelStay(_stay(id: 's1', roomId: 'r1'));
      ditto.store.seed('transactions', _folioDoc(id: 't1'));

      await sync.cancelHotelStay(stay: _stay(id: 's1', roomId: 'r1'));

      expect(await sync.hotelStays(branchId: _branch), isEmpty);
      expect(ditto.store.docs('transactions'), isEmpty);

      final room = (await sync.hotelRooms(branchId: _branch)).single;
      expect(room.housekeeping, HotelHousekeeping.clean);
    });

    test('leaves a completed transaction alone', () async {
      await sync.saveHotelRoom(_room());
      ditto.store.seed('transactions', _folioDoc(id: 't1', status: 'complete'));

      await sync.cancelHotelStay(stay: _stay(id: 's1', roomId: 'r1'));

      // Only PARKED folios are dropped; a settled sale is history.
      expect(ditto.store.docs('transactions'), hasLength(1));
    });
  });

  group('observers', () {
    test('a stream emits the current rows and again after a write', () async {
      await sync.saveHotelRoom(_room());

      final seen = <int>[];
      final sub = sync
          .hotelRoomsStream(branchId: _branch)
          .listen((rooms) => seen.add(rooms.length));

      await Future<void>.delayed(Duration.zero);
      await sync.saveHotelRoom(_room(id: 'r2', name: '102'));
      await Future<void>.delayed(Duration.zero);

      expect(seen, containsAllInOrder([1, 2]));
      await sub.cancel();
    });

    test('cancelling the stream cancels the observer', () async {
      final sub = sync.hotelRoomsStream(branchId: _branch).listen((_) {});
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      await Future<void>.delayed(Duration.zero);

      // A later write must not throw into a closed controller.
      await sync.saveHotelRoom(_room());
    });
  });

  group('sync subscriptions', () {
    // The registry keyed by `collection|branchId` is a process-global set, so
    // these use a branch id no other test touches.
    test('registers replication subscriptions for the collections it reads',
        () async {
      const fresh = 'branch-sub-1';
      await sync.hotelRooms(branchId: fresh);
      await sync.hotelStays(branchId: fresh);
      await sync.hotelBranchSettings(branchId: fresh);

      final dql = ditto.sync.registered.map((r) => r.dql).join(' | ');
      expect(dql, contains('hotel_rooms'));
      expect(dql, contains('hotel_stays'));
      expect(dql, contains('hotel_branch_settings'));
    });

    test('the same branch is not subscribed twice on one instance', () async {
      const fresh = 'branch-sub-2';
      await sync.hotelRooms(branchId: fresh);
      final first = ditto.sync.registered.length;
      await sync.hotelRooms(branchId: fresh);
      expect(ditto.sync.registered, hasLength(first));
    });

    test('a rebuilt Ditto instance subscribes again', () async {
      // Subscriptions live on the instance. When DittoService rebuilds one —
      // a re-login — a process-wide registry would skip every registration as
      // already-done and replication would stop with no error anywhere.
      const fresh = 'branch-sub-3';
      await sync.hotelRooms(branchId: fresh);
      expect(ditto.sync.registered, isNotEmpty);

      final second = FakeDitto();
      final resync = _HotelSync(second);
      await resync.hotelRooms(branchId: fresh);

      expect(second.sync.registered, isNotEmpty);
    });
  });
}
