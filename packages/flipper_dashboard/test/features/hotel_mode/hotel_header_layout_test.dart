import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_rooms_desktop.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// A non-admin clerk: the admin branch of the header reaches the router
/// locator, which is not wired up in a widget test.
final _clerk = Tenant(
  id: 'c1',
  userId: 'u1',
  name: 'Richie',
  type: 'Reception',
);

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

Widget _app({
  required Size size,
  required HotelModeState state,
  List<HotelRoom> rooms = const [],
  List<HotelStay> stays = const [],
}) {
  return ProviderScope(
    overrides: [
      hotelStaffProvider.overrideWith((ref) async => <Tenant>[]),
      hotelRoomsProvider.overrideWith((ref) => Stream.value(rooms)),
      hotelStaysProvider.overrideWith((ref) => Stream.value(stays)),
      hotelModeProvider.overrideWith(() => _FixedHotelNotifier(state)),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: size),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: const HotelRoomsDesktopScreen(),
          ),
        ),
      ),
    ),
  );
}

void main() {
  // The desk header carries brand, title, nav, three counters, the clerk chip
  // and two buttons. It overflowed by 1.1px at 1497 wide once already, so it
  // is pinned across the range of real desktop widths.
  group('room board header fits', () {
    const widths = <double>[
      1920, 1600, 1500, 1497, 1440, 1320, 1280, 1180, 1150, 1100, 1000, 950, 820,
    ];

    for (final width in widths) {
      testWidgets('at ${width.toInt()}px', (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          _app(
            size: Size(width, 900),
            state: HotelModeState(
              screen: HotelScreen.rooms,
              activeClerk: _clerk,
            ),
            rooms: [for (var i = 1; i <= 6; i++) _room(i)],
          ),
        );
        await tester.pump();

        expect(
          tester.takeException(),
          isNull,
          reason: 'header overflowed at ${width}px',
        );
      });
    }

    testWidgets('with a long staff name and role', (tester) async {
      const width = 1280.0;
      tester.view.physicalSize = const Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _app(
          size: const Size(width, 900),
          state: HotelModeState(
            screen: HotelScreen.rooms,
            activeClerk: Tenant(
              id: 'c2',
              userId: 'u2',
              name: 'Nyiraneza Mukamurenzi Josephine',
              type: 'Assistant Front Office Manager',
            ),
          ),
          rooms: [for (var i = 1; i <= 6; i++) _room(i)],
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });

  group('clerk chip', () {
    testWidgets('caps an unbounded staff name instead of widening', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: HotelClerkChip(
                name: 'Nyiraneza Mukamurenzi Josephine Uwimana',
                role: 'Assistant Front Office Manager · on duty',
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      // 38px avatar + 10px gap + the 170px text ceiling.
      expect(
        tester.getSize(find.byType(HotelClerkChip)).width,
        lessThanOrEqualTo(218),
      );
    });
  });
}
