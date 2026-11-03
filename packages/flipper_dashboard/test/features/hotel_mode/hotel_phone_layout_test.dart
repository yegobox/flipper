import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_folio_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_rooms_mobile.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_check_in_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// Check-in reads the branch's check-out hour; nothing else touches the box.
class _Box extends Fake implements LocalStorage {
  @override
  int? readInt({required String key}) => null;
}

const _phone = Size(360, 640);

/// Starts the desk on [initial] instead of the starting screen.
class _Desk extends HotelModeNotifier {
  _Desk(this.initial);

  final HotelModeState initial;

  @override
  HotelModeState build() => initial;
}

void _usePhone(WidgetTester tester) {
  tester.view.physicalSize = _phone;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Opens [open] from a button on a bare phone screen.
Future<void> _openFrom(
  WidgetTester tester,
  Future<void> Function(BuildContext context) open, {
  Locale? locale,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => open(context),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

const _room = HotelRoom(
  id: 'r1',
  branchId: 'b1',
  floorId: 'f1',
  floorName: 'Ground',
  name: '101',
  roomType: 'Deluxe',
  capacity: 2,
  nightlyRate: 50000,
);

TransactionItem _line(String name) => TransactionItem(
  name: name,
  qty: 2,
  price: 50000,
  discount: 0,
  prc: 50000,
  ttCatCd: 'B',
  loggedByName: 'Reception',
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('check-out on a phone', () {
    testWidgets('opens as a bottom sheet with every tender legible', (
      tester,
    ) async {
      _usePhone(tester);
      await _openFrom(
        tester,
        (context) => HotelCheckOutDialog.show(context, total: 120000),
      );
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
      expect(find.text('Mobile money'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a long tender label wraps at full size instead of shrinking', (
      tester,
    ) async {
      _usePhone(tester);
      await _openFrom(
        tester,
        (context) => HotelCheckOutDialog.show(context, total: 120000),
        locale: const Locale('rw'),
      );
      expect(tester.takeException(), isNull);
      final label = find.text('Amafaranga kuri telefoni');
      expect(label, findsOneWidget);
      // Painted width over layout width: below 1 means it was scaled down.
      expect(
        tester.getRect(label).width / tester.getSize(label).width,
        closeTo(1, 0.001),
      );
      // Every rail grows to the tallest label.
      final cash = find.ancestor(
        of: find.text('Amafaranga'),
        matching: find.byType(Container),
      );
      final momo = find.ancestor(of: label, matching: find.byType(Container));
      expect(
        tester.getSize(cash.first).height,
        tester.getSize(momo.first).height,
      );
    });

    testWidgets('keeps Settle clear of the system navigation bar', (
      tester,
    ) async {
      _usePhone(tester);
      tester.view.padding = const FakeViewPadding(bottom: 48);
      addTearDown(tester.view.resetPadding);
      await _openFrom(
        tester,
        (context) => HotelCheckOutDialog.show(context, total: 120000),
      );
      expect(tester.takeException(), isNull);
      final settle = find.text('Settle & release room');
      expect(tester.getRect(settle).bottom, lessThanOrEqualTo(640 - 48));
    });

    testWidgets('fits above the keyboard', (tester) async {
      _usePhone(tester);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      await _openFrom(
        tester,
        (context) => HotelCheckOutDialog.show(context, total: 120000),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('stays a dialog on the desk', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _openFrom(
        tester,
        (context) => HotelCheckOutDialog.show(context, total: 120000),
      );
      expect(find.byType(Dialog), findsOneWidget);
    });
  });

  group('room board on a phone', () {
    testWidgets('a long occupancy count leaves the header buttons on screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            hotelRoomsProvider.overrideWith((ref) => Stream.value([])),
            hotelStaysProvider.overrideWith((ref) => Stream.value([])),
            hotelOccupancyProvider.overrideWithValue((
              total: 120,
              occupied: 118,
              vacant: 2,
              reserved: 0,
              dirty: 0,
              blocked: 0,
            )),
          ],
          child: MaterialApp(
            locale: const Locale('rw'),
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: const Scaffold(body: HotelRoomsMobileScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.getRect(find.byIcon(Icons.logout)).right, lessThan(320));
    });
  });

  group('check-in on a phone', () {
    setUp(() async {
      await getIt.reset();
      getIt.registerSingleton<LocalStorage>(_Box());
    });

    testWidgets('scrolls instead of overflowing above the keyboard', (
      tester,
    ) async {
      _usePhone(tester);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      await _openFrom(
        tester,
        (context) => HotelCheckInSheet.show(context, room: _room, mobile: true),
      );
      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(HotelCheckInSheet),
          matching: find.byType(SingleChildScrollView),
        ),
        findsOneWidget,
      );
    });
  });

  group('folio line on a phone', () {
    Future<void> pumpLine(WidgetTester tester, {required bool mobile}) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: HotelLayoutScope(
              mobile: mobile,
              child: Padding(
                padding: const EdgeInsets.all(18),
                // In a list, as on the folio screen: unbounded height.
                child: ListView(
                  children: [
                    HotelFolioLineTile(
                      line: _line('Room 101 · Deluxe king with lake view'),
                      onIncrement: () {},
                      onDecrement: () {},
                      onDelete: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('moves the controls to a second row', (tester) async {
      _usePhone(tester);
      await pumpLine(tester, mobile: true);
      expect(tester.takeException(), isNull);

      final name = tester.getRect(find.textContaining('Deluxe king'));
      final plus = tester.getRect(find.byIcon(Icons.add));
      expect(plus.top, greaterThan(name.bottom));
      // A thumb-sized target around the icon.
      final button = find.ancestor(
        of: find.byIcon(Icons.add),
        matching: find.byType(SizedBox),
      );
      expect(tester.getSize(button.first), const Size(40, 40));
    });

    testWidgets('keeps the single dense row on the desk', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpLine(tester, mobile: false);

      final name = tester.getRect(find.textContaining('Deluxe king'));
      final plus = tester.getRect(find.byIcon(Icons.add));
      expect(plus.center.dy, closeTo(name.center.dy, 12));
    });

    testWidgets('a read-only line shows its quantity', (tester) async {
      _usePhone(tester);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: HotelLayoutScope(
              mobile: true,
              child: HotelFolioLineTile(
                line: _line('Minibar'),
                readOnly: true,
                onIncrement: () {},
                onDecrement: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('× 2'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });

  group('desk nav', () {
    Future<void> pumpNav(
      WidgetTester tester, {
      required bool mobile,
      bool compact = false,
    }) => tester.pumpWidget(
      ProviderScope(
        overrides: [
          hotelModeProvider.overrideWith(
            () => _Desk(const HotelModeState(screen: HotelScreen.rooms)),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: HotelLayoutScope(
              mobile: mobile,
              child: HotelDeskNav(compact: compact),
            ),
          ),
        ),
      ),
    );

    testWidgets('a phone names every segment and drops Today', (tester) async {
      _usePhone(tester);
      await pumpNav(tester, mobile: true, compact: true);
      expect(find.text('Rooms'), findsOneWidget);
      expect(find.text('Calendar'), findsOneWidget);
      expect(find.text('Today'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the desk keeps its icon-only compact nav', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpNav(tester, mobile: false, compact: true);
      expect(find.text('Rooms'), findsNothing);
      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    });
  });

  group('folio on a phone', () {
    final stay = HotelStay(
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

    Future<void> pumpFolio(WidgetTester tester, {required bool mobile}) =>
        tester.pumpWidget(
          ProviderScope(
            overrides: [
              hotelModeProvider.overrideWith(
                () => _Desk(
                  HotelModeState(
                    screen: HotelScreen.folio,
                    activeRoom: _room,
                    activeStay: stay,
                  ),
                ),
              ),
              hotelFolioLinesProvider.overrideWith(
                (ref, id) => Stream.value([
                  for (var i = 0; i < 6; i++) _line('Charge $i'),
                ]),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: FlipperLocalizationDelegates.delegates,
              supportedLocales: FlipperLocalizationDelegates.supportedLocales,
              home: const Scaffold(body: HotelFolioScreen()),
            ),
          ),
        );

    testWidgets('pins Check out below the charges', (tester) async {
      _usePhone(tester);
      await pumpFolio(tester, mobile: true);
      await tester.pumpAndSettle();
      final checkOut = find.textContaining('Check out');
      expect(checkOut, findsOneWidget);
      // Outside the list, so it never scrolls below the fold.
      expect(
        find.ancestor(of: checkOut, matching: find.byType(Scrollable)),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('the desk keeps Check out at the end of the list', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pumpFolio(tester, mobile: false);
      await tester.pumpAndSettle();
      expect(
        find.ancestor(
          of: find.textContaining('Check out'),
          matching: find.byType(Scrollable),
        ),
        findsWidgets,
      );
    });
  });
}
