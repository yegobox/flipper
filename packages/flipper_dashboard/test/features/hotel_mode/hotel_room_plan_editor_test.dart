import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_room_plan_editor.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

HotelRoom _room({
  required String id,
  required String name,
  String floorId = 'ground',
  String floorName = 'Ground Floor',
  String? variantId,
}) => HotelRoom(
  id: id,
  branchId: 'b1',
  floorId: floorId,
  floorName: floorName,
  name: name,
  roomType: 'Double',
  capacity: 2,
  nightlyRate: 50000,
  variantId: variantId,
);

HotelStay _stay({required String roomId}) => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: roomId,
  roomName: roomId,
  transactionId: 't1',
  guestName: 'Aline Uwase',
  checkInAt: DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
);

Future<void> _pump(
  WidgetTester tester, {
  required List<HotelRoom> rooms,
  List<HotelStay> stays = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hotelRoomsProvider.overrideWith((ref) => Stream.value(rooms)),
        hotelStaysProvider.overrideWith((ref) => Stream.value(stays)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: HotelRoomPlanEditor()),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('room plan editor', () {
    testWidgets('offers a starter plan when the branch has no rooms', (
      tester,
    ) async {
      await _pump(tester, rooms: const []);

      expect(find.text('No rooms on this branch yet.'), findsOneWidget);
      expect(find.text('Create a starter plan'), findsOneWidget);
    });

    testWidgets('groups rooms under their floor and counts them', (
      tester,
    ) async {
      await _pump(
        tester,
        rooms: [
          _room(id: 'r1', name: '101'),
          _room(id: 'r2', name: '102'),
          _room(
            id: 'r3',
            name: '201',
            floorId: 'first',
            floorName: 'First Floor',
          ),
        ],
      );

      expect(find.text('Ground Floor'), findsOneWidget);
      expect(find.text('First Floor'), findsOneWidget);
      expect(find.text('2 rooms'), findsOneWidget);
      expect(find.text('1 room'), findsOneWidget);
      expect(find.text('101'), findsOneWidget);
      expect(find.text('201'), findsOneWidget);
    });

    testWidgets('every floor can take another room', (tester) async {
      await _pump(tester, rooms: [_room(id: 'r1', name: '101')]);
      expect(find.text('Add room'), findsOneWidget);
      expect(find.text('Add a floor or wing'), findsOneWidget);
    });

    testWidgets('flags a room RRA does not know about', (tester) async {
      // Its nights cannot be invoiced as accommodation until it is registered,
      // so the row says so rather than looking finished.
      await _pump(
        tester,
        rooms: [
          _room(id: 'r1', name: '101'),
          _room(id: 'r2', name: '102', variantId: 'v2'),
        ],
      );

      expect(find.byIcon(Icons.gpp_maybe_outlined), findsOneWidget);
      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
    });

    testWidgets('a room with a guest is locked against deletion', (
      tester,
    ) async {
      await _pump(
        tester,
        rooms: [
          _room(id: 'r1', name: '101'),
          _room(id: 'r2', name: '102'),
        ],
        stays: [_stay(roomId: 'r1')],
      );

      // The occupied room shows a padlock; the free one keeps its bin.
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));

      final locked = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.lock_outline),
          matching: find.byType(IconButton),
        ),
      );
      expect(locked.onPressed, isNull);
    });
  });
}
