import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_stay_picker.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

HotelStay _stay({
  required String id,
  required String roomName,
  required String guestName,
  String? guestPhone,
}) => HotelStay(
  id: id,
  branchId: 'b1',
  roomId: 'room-$id',
  roomName: roomName,
  transactionId: 'folio-$id',
  guestName: guestName,
  guestPhone: guestPhone,
  checkInAt: DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
);

Future<void> _pump(
  WidgetTester tester, {
  required List<HotelStay> stays,
  bool loading = false,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hotelChargeableStaysProvider.overrideWithValue(stays),
        hotelStaysLoadingProvider.overrideWithValue(loading),
      ],
      child: const MaterialApp(home: Scaffold(body: HotelStayPicker())),
    ),
  );
  await tester.pump();
}

void main() {
  group('charge-to-room picker', () {
    testWidgets('lists the guests a tab can be charged to', (tester) async {
      await _pump(
        tester,
        stays: [
          _stay(id: 's1', roomName: '101', guestName: 'Aline Uwase'),
          _stay(id: 's2', roomName: '204', guestName: 'Jean Bosco'),
        ],
      );

      expect(find.text('101'), findsOneWidget);
      expect(find.text('Aline Uwase'), findsOneWidget);
      expect(find.text('204'), findsOneWidget);
      expect(find.text('Jean Bosco'), findsOneWidget);
    });

    testWidgets('search narrows by room number', (tester) async {
      await _pump(
        tester,
        stays: [
          _stay(id: 's1', roomName: '101', guestName: 'Aline Uwase'),
          _stay(id: 's2', roomName: '204', guestName: 'Jean Bosco'),
        ],
      );

      await tester.enterText(find.byType(TextField), '204');
      await tester.pump();

      expect(find.text('Jean Bosco'), findsOneWidget);
      expect(find.text('Aline Uwase'), findsNothing);
    });

    testWidgets('says so when nobody is checked in', (tester) async {
      await _pump(tester, stays: const []);

      expect(find.text('Nobody is checked in'), findsOneWidget);
      // Nothing to search through, so the box would only be noise.
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('an empty list while loading is not "nobody is in"', (
      tester,
    ) async {
      await _pump(tester, stays: const [], loading: true);

      expect(find.text('Looking up guests…'), findsOneWidget);
    });
  });
}
