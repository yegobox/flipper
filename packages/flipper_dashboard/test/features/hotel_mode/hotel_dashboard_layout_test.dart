import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_dashboard_screen.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

HotelRoom _room(int i) => HotelRoom(
  id: 'r$i',
  branchId: 'b1',
  floorId: 'ground',
  floorName: 'Ground Floor',
  name: '10$i',
  roomType: 'Double',
  capacity: 2,
  nightlyRate: 50000,
);

HotelStay _stay({
  required String id,
  required String roomId,
  HotelStayStatus status = HotelStayStatus.inHouse,
  DateTime? checkIn,
  DateTime? checkOut,
}) => HotelStay(
  id: id,
  branchId: 'b1',
  roomId: roomId,
  roomName: roomId,
  transactionId: 't_$id',
  guestName: 'Aline Uwase',
  checkInAt: checkIn ?? DateTime.now().subtract(const Duration(days: 1)),
  expectedCheckOutAt: checkOut ?? DateTime.now().add(const Duration(days: 2)),
  nightlyRate: 50000,
  status: status,
);

class _FixedHotelNotifier extends HotelModeNotifier {
  _FixedHotelNotifier(this.initial);
  final HotelModeState initial;

  @override
  HotelModeState build() => initial;
}

Future<void> _pump(
  WidgetTester tester,
  double width, {
  List<HotelRoom> rooms = const [],
  List<HotelStay> stays = const [],
  List<ITransaction> folios = const [],
}) async {
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hotelStaffProvider.overrideWith((ref) async => <Tenant>[]),
        hotelRoomsProvider.overrideWith((ref) => Stream.value(rooms)),
        hotelStaysProvider.overrideWith((ref) => Stream.value(stays)),
        hotelOpenFoliosProvider.overrideWith((ref) => Stream.value(folios)),
        hotelQuotationsProvider.overrideWith(
          (ref) => Stream.value(const <HotelQuotation>[]),
        ),
        hotelModeProvider.overrideWith(
          () => _FixedHotelNotifier(
            HotelModeState(
              screen: HotelScreen.dashboard,
              activeClerk: Tenant(id: 'c1', userId: 'u1', name: 'Richie'),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(size: Size(width, 1000)),
            child: SizedBox(
              width: width,
              height: 1000,
              child: const HotelDashboardScreen(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('manager dashboard', () {
    testWidgets('greets the clerk and headlines occupancy', (tester) async {
      await _pump(
        tester,
        1440,
        rooms: [for (var i = 1; i <= 4; i++) _room(i)],
        stays: [_stay(id: 's1', roomId: 'r1')],
      );

      expect(find.text('Good day, Richie'), findsOneWidget);
      // 1 of 4 sellable rooms.
      expect(find.text('25%'), findsOneWidget);
      expect(find.textContaining('1 of 4 sellable rooms'), findsOneWidget);
    });

    testWidgets('shows the six headline figures', (tester) async {
      await _pump(
        tester,
        1440,
        rooms: [for (var i = 1; i <= 4; i++) _room(i)],
        stays: [_stay(id: 's1', roomId: 'r1')],
      );

      for (final label in [
        'Arrivals today',
        'Departures today',
        'Available rooms',
        'Pending payments',
        'Room revenue tonight',
        'Open quotations',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
    });

    testWidgets('an empty property renders zeroes, not a crash', (
      tester,
    ) async {
      await _pump(tester, 1440);
      expect(tester.takeException(), isNull);
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('lists arrivals and departures for today', (tester) async {
      final now = DateTime.now();
      await _pump(
        tester,
        1440,
        rooms: [_room(1), _room(2)],
        stays: [
          _stay(
            id: 'arriving',
            roomId: 'r1',
            status: HotelStayStatus.reserved,
            checkIn: DateTime(now.year, now.month, now.day, 15),
            checkOut: DateTime(now.year, now.month, now.day + 2, 11),
          ),
          _stay(
            id: 'leaving',
            roomId: 'r2',
            checkIn: DateTime(now.year, now.month, now.day - 2, 14),
            checkOut: DateTime(now.year, now.month, now.day, 11),
          ),
        ],
      );

      expect(find.text('Arriving today'), findsOneWidget);
      expect(find.text('Departing today'), findsOneWidget);
      expect(find.text('No arrivals booked for today.'), findsNothing);
      expect(find.text('Nobody is due to leave today.'), findsNothing);
    });

    testWidgets('warns about overstays', (tester) async {
      final now = DateTime.now();
      await _pump(
        tester,
        1440,
        rooms: [_room(1)],
        stays: [
          _stay(
            id: 'over',
            roomId: 'r1',
            checkIn: now.subtract(const Duration(days: 3)),
            checkOut: now.subtract(const Duration(days: 1)),
          ),
        ],
      );

      expect(find.textContaining('past departure'), findsOneWidget);
      expect(find.text('Open board'), findsOneWidget);
    });

    for (final width in <double>[1920, 1600, 1440, 1280, 1100, 900]) {
      testWidgets('lays out without overflow at ${width.toInt()}px', (
        tester,
      ) async {
        await _pump(
          tester,
          width,
          rooms: [for (var i = 1; i <= 6; i++) _room(i)],
          stays: [_stay(id: 's1', roomId: 'r1')],
        );
        expect(tester.takeException(), isNull);
      });
    }
  });
}
