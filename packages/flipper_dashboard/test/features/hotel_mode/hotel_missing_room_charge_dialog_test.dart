import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

HotelStay _stay() => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '101',
  transactionId: 't1',
  guestName: 'Aline Uwase',
  checkInAt: DateTime(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime(2026, 1, 12, 11),
  nightlyRate: 50000,
);

/// Opens the dialog from a button and records what it returned.
Future<List<HotelMissingRoomChargeChoice?>> _open(WidgetTester tester) async {
  final results = <HotelMissingRoomChargeChoice?>[];
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async => results.add(
              await HotelMissingRoomChargeDialog.show(context, stay: _stay()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return results;
}

void main() {
  group('missing room charge at checkout', () {
    testWidgets('states the nights and the amount that would be posted', (
      tester,
    ) async {
      await _open(tester);
      expect(find.text('No room charge on this folio'), findsOneWidget);
      expect(find.textContaining('2 nights'), findsOneWidget);
      expect(find.textContaining('RWF 100,000'), findsOneWidget);
    });

    testWidgets('post, skip and cancel each return their own answer', (
      tester,
    ) async {
      final results = await _open(tester);
      await tester.tap(
        find.byKey(const ValueKey('hotel-missing-room-charge-post')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('hotel-missing-room-charge-skip')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(results, [
        HotelMissingRoomChargeChoice.post,
        HotelMissingRoomChargeChoice.skip,
        null,
      ]);
    });
  });
}
