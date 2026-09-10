import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_calendar_screen.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

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

class _FixedHotelNotifier extends HotelModeNotifier {
  _FixedHotelNotifier(this.initial);
  final HotelModeState initial;

  @override
  HotelModeState build() => initial;
}

/// One "n free" label is rendered per day column in the header, so counting
/// them counts the days on screen.
int _visibleDays(WidgetTester tester) =>
    tester.widgetList(find.textContaining(' free')).length;

Future<void> _pump(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hotelStaffProvider.overrideWith((ref) async => <Tenant>[]),
        hotelRoomsProvider.overrideWith(
          (ref) => Stream.value([for (var i = 1; i <= 5; i++) _room(i)]),
        ),
        hotelStaysProvider.overrideWith(
          (ref) => Stream.value(const <HotelStay>[]),
        ),
        hotelModeProvider.overrideWith(
          () => _FixedHotelNotifier(
            HotelModeState(
              screen: HotelScreen.calendar,
              activeClerk: Tenant(id: 'c1', userId: 'u1', name: 'Richie'),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(size: Size(width, 900)),
            child: SizedBox(
              width: width,
              height: 900,
              child: const HotelCalendarScreen(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('availability calendar fills the window', () {
    // The grid used to be a fixed 14 days at 74px, so it stopped at ~1186px
    // and left the rest of a wide desk blank whatever the window size.
    testWidgets('a wide desk shows well past the old fixed 14 days', (
      tester,
    ) async {
      await _pump(tester, 1900);
      expect(_visibleDays(tester), greaterThan(14));
    });

    testWidgets('a narrow desk shows fewer days rather than squashing them', (
      tester,
    ) async {
      await _pump(tester, 1000);
      final days = _visibleDays(tester);
      expect(days, greaterThan(0));
      expect(days, lessThan(20));
    });

    testWidgets('the grid spans the viewport at 1900px', (tester) async {
      await _pump(tester, 1900);

      // 150px room column + one cell per day must reach the right edge.
      final grid = tester.getSize(
        find
            .descendant(
              of: find.byType(SingleChildScrollView),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(grid.width, closeTo(1900, 1.0));
    });

    for (final width in <double>[1920, 1900, 1600, 1440, 1280, 1024, 1000, 900]) {
      testWidgets('lays out without overflow at ${width.toInt()}px', (
        tester,
      ) async {
        await _pump(tester, width);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
