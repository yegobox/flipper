import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

HotelRoom _room() => const HotelRoom(
  id: 'r1',
  branchId: 'b1',
  floorId: 'ground',
  floorName: 'Ground Floor',
  name: '101',
  roomType: 'Double',
  capacity: 2,
  nightlyRate: 50000,
);

HotelStay _stay() => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '101',
  transactionId: 't1',
  guestName: 'Aline Uwase',
  checkInAt: DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
);

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  HotelModeState read() => container.read(hotelModeProvider);
  HotelModeNotifier notifier() => container.read(hotelModeProvider.notifier);

  final clerk = Tenant(id: 'c1', userId: 'u1', name: 'Richie', type: 'Agent');
  final manager = Tenant(id: 'm1', userId: 'u2', name: 'Ada', type: 'Admin');

  group('shared register', () {
    test('opens locked with nobody signed in', () {
      expect(read().screen, HotelScreen.lock);
      expect(read().activeClerk, isNull);
    });

    test('login signs the clerk on and opens the day overview', () {
      notifier().login(clerk);
      expect(read().screen, HotelScreen.dashboard);
      expect(read().activeClerk, clerk);
    });

    test('logout hands the terminal back and drops everything open', () {
      notifier().login(clerk);
      notifier().openFolio(room: _room(), stay: _stay());
      expect(read().screen, HotelScreen.folio);

      notifier().logout();

      expect(read().screen, HotelScreen.lock);
      expect(read().activeClerk, isNull);
      expect(read().activeRoom, isNull);
      expect(read().activeStay, isNull);
      expect(read().activeFolio, isNull);
      expect(read().showManagerModal, isFalse);
    });

    test('a second clerk taking over replaces the first', () {
      notifier().login(clerk);
      notifier().logout();
      notifier().login(manager);
      expect(read().activeClerk, manager);
      expect(read().screen, HotelScreen.dashboard);
    });
  });

  group('screen guards', () {
    test('cannot leave the lock without a clerk', () {
      notifier().setScreen(HotelScreen.rooms);
      expect(read().screen, HotelScreen.lock);
      notifier().setScreen(HotelScreen.folio);
      expect(read().screen, HotelScreen.lock);
    });

    test('the folio needs a bound stay, otherwise it falls back to rooms', () {
      notifier().login(clerk);
      notifier().setScreen(HotelScreen.folio);
      expect(read().screen, HotelScreen.rooms);
    });

    test('openFolio binds the room, stay and folio together', () {
      notifier().login(clerk);
      final folio = ITransaction(
        branchId: 'b1',
        status: 'parked',
        transactionType: 'sale',
        paymentType: 'Cash',
        cashReceived: 0,
        customerChangeDue: 0,
        updatedAt: DateTime.utc(2026, 1, 10),
        isIncome: true,
        isExpense: false,
        agentId: 'c1',
      );
      notifier().openFolio(room: _room(), stay: _stay(), folio: folio);

      expect(read().screen, HotelScreen.folio);
      expect(read().activeRoom?.id, 'r1');
      expect(read().activeStay?.id, 's1');
      expect(read().activeFolio, folio);
    });

    test('backToRooms clears the stay but keeps the clerk on the register', () {
      notifier().login(clerk);
      notifier().openFolio(room: _room(), stay: _stay());
      notifier().backToRooms();

      expect(read().screen, HotelScreen.rooms);
      expect(read().activeStay, isNull);
      expect(read().activeClerk, clerk);
    });
  });

  group('manager elevation', () {
    test('showManagerPin raises the keypad without changing screen', () {
      notifier().login(clerk);
      notifier().openFolio(room: _room(), stay: _stay());
      notifier().showManagerPin();

      expect(read().showManagerModal, isTrue);
      expect(read().screen, HotelScreen.folio);
    });

    test('elevateManager takes over the register and drops the keypad', () {
      notifier().login(clerk);
      notifier().openFolio(room: _room(), stay: _stay());
      notifier().showManagerPin();
      notifier().elevateManager(manager);

      expect(read().activeClerk, manager);
      expect(read().showManagerModal, isFalse);
      // Still on the folio, so the manager can settle it.
      expect(read().screen, HotelScreen.folio);
      expect(read().toastMessage, isNotNull);
    });

    test('cancelling the keypad leaves the original clerk in place', () {
      notifier().login(clerk);
      notifier().showManagerPin();
      notifier().hideManagerPin();

      expect(read().showManagerModal, isFalse);
      expect(read().activeClerk, clerk);
    });
  });

  group('after checkout', () {
    test('returns to the room board and keeps the clerk by default', () {
      notifier().login(clerk);
      notifier().openFolio(room: _room(), stay: _stay());
      notifier().afterCheckOut(message: 'Room 101 checked out');

      expect(read().screen, HotelScreen.rooms);
      expect(read().activeClerk, clerk);
      expect(read().activeStay, isNull);
      expect(read().toastMessage, 'Room 101 checked out');
    });

    test('autoLogout hands the desk back but still shows the receipt toast',
        () {
      notifier().login(clerk);
      notifier().openFolio(room: _room(), stay: _stay());
      notifier().afterCheckOut(
        message: 'Room 101 checked out',
        autoLogout: true,
      );

      expect(read().screen, HotelScreen.lock);
      expect(read().activeClerk, isNull);
      expect(read().activeStay, isNull);
      expect(read().toastMessage, 'Room 101 checked out');
    });
  });

  group('desk navigation', () {
    test('the dashboard is where a clerk lands', () {
      notifier().login(clerk);
      expect(read().screen, HotelScreen.dashboard);
      notifier().setScreen(HotelScreen.rooms);
      expect(read().screen, HotelScreen.rooms);
      notifier().setScreen(HotelScreen.dashboard);
      expect(read().screen, HotelScreen.dashboard);
    });

    test('calendar and quotes need a clerk, not a stay', () {
      notifier().setScreen(HotelScreen.calendar);
      expect(read().screen, HotelScreen.lock, reason: 'no clerk yet');

      notifier().login(clerk);
      notifier().setScreen(HotelScreen.calendar);
      expect(read().screen, HotelScreen.calendar);

      notifier().setScreen(HotelScreen.quotes);
      expect(read().screen, HotelScreen.quotes);
    });

    test('logging out from the calendar returns to the lock', () {
      notifier().login(clerk);
      notifier().setScreen(HotelScreen.calendar);
      notifier().logout();
      expect(read().screen, HotelScreen.lock);
    });
  });

  group('floor filter', () {
    test('selecting and clearing a floor', () {
      notifier().login(clerk);
      notifier().setFloorFilter('first');
      expect(read().floorFilter, 'first');
      notifier().setFloorFilter(null);
      expect(read().floorFilter, isNull);
    });
  });
}
