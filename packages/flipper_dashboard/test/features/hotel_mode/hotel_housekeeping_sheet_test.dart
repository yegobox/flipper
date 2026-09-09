import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_housekeeping_sheet.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

HotelRoom _room({
  HotelHousekeeping housekeeping = HotelHousekeeping.clean,
}) => HotelRoom(
  id: 'r1',
  branchId: 'b1',
  floorId: 'ground',
  floorName: 'Ground Floor',
  name: '101',
  roomType: 'Double',
  capacity: 2,
  nightlyRate: 50000,
  housekeeping: housekeeping,
);

HotelStay _stay({HotelStayStatus status = HotelStayStatus.inHouse}) => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '101',
  transactionId: 't1',
  guestName: 'Aline Uwase',
  checkInAt: DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
  status: status,
);

Future<void> _pump(
  WidgetTester tester, {
  required HotelRoom room,
  HotelStay? stay,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: HotelHousekeepingSheet(room: room, stay: stay),
      ),
    ),
  );
}

/// Finds the tappable surface for an option by its label.
InkWell _rowFor(WidgetTester tester, String label) {
  return tester.widget<InkWell>(
    find.ancestor(of: find.text(label), matching: find.byType(InkWell)).first,
  );
}

void main() {
  group('housekeeping sheet', () {
    testWidgets('offers every state with what it means for the desk',
        (tester) async {
      await _pump(tester, room: _room());

      expect(find.text('Clean'), findsOneWidget);
      expect(find.text('Needs cleaning'), findsOneWidget);
      expect(find.text('Inspected'), findsOneWidget);
      expect(find.text('Out of order'), findsOneWidget);
      expect(
        find.text('Ready to sell — the desk can check a guest in.'),
        findsOneWidget,
      );
    });

    testWidgets('names the room it is acting on', (tester) async {
      await _pump(tester, room: _room());
      expect(find.text('Housekeeping · Room 101'), findsOneWidget);
      expect(find.text('Double · sleeps 2'), findsOneWidget);
    });

    testWidgets('marks the current state', (tester) async {
      await _pump(tester, room: _room(housekeeping: HotelHousekeeping.dirty));
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('picking a state returns it to the caller', (tester) async {
      HotelHousekeeping? picked;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  picked = await HotelHousekeepingSheet.show(
                    context,
                    room: _room(),
                    mobile: false,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Needs cleaning'));
      await tester.pumpAndSettle();

      expect(picked, HotelHousekeeping.dirty);
    });

    group('occupied room', () {
      testWidgets('cannot be blocked for maintenance', (tester) async {
        await _pump(tester, room: _room(), stay: _stay());

        // The guest outranks housekeeping: blocking the room would leave the
        // board claiming it is both occupied and unsellable.
        expect(_rowFor(tester, 'Out of order').onTap, isNull);
        expect(_rowFor(tester, 'Needs cleaning').onTap, isNotNull);
      });

      testWidgets('says who is in the room and what to do', (tester) async {
        await _pump(tester, room: _room(), stay: _stay());
        expect(
          find.textContaining('Aline Uwase is in this room'),
          findsOneWidget,
        );
        expect(
          find.text('Unavailable while the room is occupied.'),
          findsOneWidget,
        );
      });

      testWidgets('a checked-out stay no longer blocks anything',
          (tester) async {
        await _pump(
          tester,
          room: _room(),
          stay: _stay(status: HotelStayStatus.checkedOut),
        );
        expect(_rowFor(tester, 'Out of order').onTap, isNotNull);
        expect(find.textContaining('is in this room'), findsNothing);
      });
    });
  });
}
