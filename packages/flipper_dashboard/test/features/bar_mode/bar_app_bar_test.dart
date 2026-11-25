// flutter test test/features/bar_mode/bar_app_bar_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// Every Bar screen with a way back uses the app's CustomAppBar, and its back
// button lands where the hand-built headers used to: Settle → the tab,
// the tab on a phone → the floor, Credit → the floor.

import 'dart:io';
import 'dart:typed_data';

import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_credit_screen.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_pos_mobile.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_settle_desktop.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_settle_mobile.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_design_system/flipper_design_system.dart'
    show CustomAppBar;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FontLoader;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

const _desk = Size(1440, 912);
const _phone = Size(390, 844);

final _table = BarTable(
  id: 'tb4',
  branchId: 'b1',
  zoneId: 'z1',
  zoneName: 'Main Bar',
  name: 'B4',
  seats: 4,
);

ITransaction _tab() => ITransaction(
  id: 'tab-1',
  branchId: 'b1',
  status: 'parked',
  transactionType: 'Sale',
  paymentType: 'CASH',
  subTotal: 7000,
  cashReceived: 0,
  customerChangeDue: 0,
  isIncome: true,
  isExpense: false,
  agentId: 't1',
  updatedAt: DateTime.now().toUtc(),
);

ITransaction _loan(String id, String customer) => ITransaction(
  id: id,
  branchId: 'b1',
  status: 'parked',
  transactionType: 'Sale',
  paymentType: 'CREDIT',
  subTotal: 3000,
  cashReceived: 0,
  customerChangeDue: 0,
  isIncome: true,
  isExpense: false,
  agentId: 't1',
  isLoan: true,
  customerName: customer,
  remainingBalance: 3000,
  updatedAt: DateTime.now().toUtc(),
);

/// A signed-in Bar on [screen] that records where back sends it.
class _RecordingBar extends BarModeNotifier {
  _RecordingBar(this._initial);

  final BarModeState _initial;
  final screens = <BarScreen>[];

  @override
  BarModeState build() => _initial;

  @override
  void setScreen(BarScreen screen) {
    screens.add(screen);
    state = state.copyWith(screen: screen);
  }
}

/// The default test font draws every glyph as a full square, which makes
/// text several times wider than it is, so the desk's payment panel would
/// overflow. Load the fonts the screens really use (Outfit and JetBrains
/// Mono through google_fonts, Roboto for Material defaults); widths then
/// mean something, and any overflow, the new header's included, fails.
Future<void> _loadRealFonts() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  final root =
      Platform.environment['FLUTTER_ROOT'] ??
      File(
        Platform.resolvedExecutable,
      ).parent.parent.parent.parent.parent.parent.path;
  Future<void> load(String family, Iterable<String> paths) async {
    final loader = FontLoader(family);
    for (final path in paths) {
      final bytes = File(path).readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  final material = '$root/bin/cache/artifacts/material_fonts';
  await load('Roboto', [
    for (final w in ['Regular', 'Medium', 'Bold']) '$material/Roboto-$w.ttf',
  ]);
  await load('MaterialIcons', ['$material/MaterialIcons-Regular.otf']);

  // google_fonts asks for one family per weight ("Outfit_700"); the bundled
  // files are the app's own (apps/flipper/google_fonts).
  const bundled = '../../apps/flipper/google_fonts';
  const weights = [
    (FontWeight.w100, 'Thin'),
    (FontWeight.w200, 'ExtraLight'),
    (FontWeight.w300, 'Light'),
    (FontWeight.w400, 'Regular'),
    (FontWeight.w500, 'Medium'),
    (FontWeight.w600, 'SemiBold'),
    (FontWeight.w700, 'Bold'),
    (FontWeight.w800, 'ExtraBold'),
  ];
  for (final (weight, name) in weights) {
    await load(GoogleFonts.outfit(fontWeight: weight).fontFamily!, [
      '$bundled/Outfit-$name.ttf',
    ]);
    await load(GoogleFonts.jetBrainsMono(fontWeight: weight).fontFamily!, [
      '$bundled/JetBrainsMono-$name.ttf',
    ]);
  }
}

void _useView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<_RecordingBar> _pump(
  WidgetTester tester,
  Widget screen, {
  required Size size,
  required BarScreen on,
  String? cashierName = 'Richard Mugisha',
  List<ITransaction> loans = const [],
}) async {
  _useView(tester, size);
  final bar = _RecordingBar(
    BarModeState(
      screen: on,
      activeCashier: Tenant(id: 't1', name: cashierName),
      activeTable: _table,
      activeTab: _tab(),
    ),
  );
  final lines = [
    TransactionItem(
      name: 'FP0076',
      qty: 2,
      price: 3500,
      discount: 0,
      prc: 3500,
      ttCatCd: 'B',
      loggedByTenantId: 't1',
    ),
  ];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        barModeProvider.overrideWith(() => bar),
        barTabLinesProvider('tab-1').overrideWith((ref) => Stream.value(lines)),
        barStaffProvider.overrideWith(
          (ref) async => [Tenant(id: 't1', name: cashierName)],
        ),
        barCreditTabsProvider.overrideWith((ref) => Stream.value(loans)),
        hotelRoomChargeAvailableProvider.overrideWithValue(false),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Roboto'),
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
  return bar;
}

Future<void> _tapBack(WidgetTester tester, String barKey) async {
  await tester.tap(
    find.descendant(
      of: find.byKey(ValueKey(barKey)),
      matching: find.byIcon(Icons.arrow_back),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() async {
    registerFallbackValue(Strategy.capella);
    await _loadRealFonts();
  });

  setUp(() async {
    await getIt.reset();
    final box = MockBox();
    when(() => box.getBranchId()).thenReturn('b1');
    when(() => box.getBusinessId()).thenReturn('biz1');
    when(() => box.getUserId()).thenReturn('u1');
    when(() => box.currentSaleCustomerPhoneNumber()).thenReturn('783054874');
    when(() => box.readString(key: any(named: 'key'))).thenReturn(null);
    when(() => box.readBool(key: any(named: 'key'))).thenReturn(false);
    getIt.registerSingleton<LocalStorage>(box);
    final strategy = MockSyncStrategy();
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
  });

  tearDown(() async => getIt.reset());

  group('Settle bill', () {
    for (final (name, chip) in [
      ('Richard Mugisha', 'Richard M.'),
      ('Richie', 'Richie'),
    ]) {
      testWidgets('desk: CustomAppBar names zone and table ($name)', (
        tester,
      ) async {
        final bar = await _pump(
          tester,
          const BarSettleDesktopScreen(),
          size: _desk,
          on: BarScreen.settle,
          cashierName: name,
        );

        final appBar = find.byKey(const ValueKey('bar-settle-app-bar'));
        expect(appBar, findsOneWidget);
        expect(tester.widget(appBar), isA<CustomAppBar>());
        expect(
          find.descendant(of: appBar, matching: find.text('B4')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: appBar, matching: find.text(chip)),
          findsOneWidget,
        );

        await _tapBack(tester, 'bar-settle-app-bar');
        expect(bar.screens, [BarScreen.pos]);
      });
    }

    testWidgets('desk: a cashier with no name shows the staff fallback', (
      tester,
    ) async {
      await _pump(
        tester,
        const BarSettleDesktopScreen(),
        size: _desk,
        on: BarScreen.settle,
        cashierName: null,
      );
      final l10n = FlipperAppLocalizations.of(
        tester.element(find.byType(BarSettleDesktopScreen)),
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('bar-settle-app-bar')),
          matching: find.text(l10n.barStaffFallback),
        ),
        findsOneWidget,
      );
    });

    testWidgets('phone: CustomAppBar goes back to the tab', (tester) async {
      final bar = await _pump(
        tester,
        const BarSettleMobileScreen(),
        size: _phone,
        on: BarScreen.settle,
      );

      expect(
        tester.widget(find.byKey(const ValueKey('bar-settle-app-bar'))),
        isA<CustomAppBar>(),
      );
      await _tapBack(tester, 'bar-settle-app-bar');
      expect(bar.screens, [BarScreen.pos]);
    });
  });

  testWidgets('tab on a phone: CustomAppBar goes back to the floor', (
    tester,
  ) async {
    final bar = await _pump(
      tester,
      const BarPosMobileScreen(),
      size: _phone,
      on: BarScreen.pos,
    );

    final appBar = find.byKey(const ValueKey('bar-pos-mobile-app-bar'));
    expect(tester.widget(appBar), isA<CustomAppBar>());
    expect(
      find.descendant(of: appBar, matching: find.text('B4')),
      findsOneWidget,
    );
    await _tapBack(tester, 'bar-pos-mobile-app-bar');
    expect(bar.screens, [BarScreen.tables]);
  });

  group('Credit', () {
    final loans = [_loan('l1', 'Alice'), _loan('l2', 'Bob')];

    testWidgets('desk: search sits in the bar and filters; back to floor', (
      tester,
    ) async {
      final bar = await _pump(
        tester,
        const BarCreditScreen(),
        size: _desk,
        on: BarScreen.credit,
        loans: loans,
      );

      final appBar = find.byKey(const ValueKey('bar-credit-app-bar'));
      expect(tester.widget(appBar), isA<CustomAppBar>());
      final search = find.descendant(
        of: appBar,
        matching: find.byType(TextField),
      );
      expect(search, findsOneWidget);

      await tester.enterText(search, 'ali');
      await tester.pump();
      expect(find.text('Alice'), findsWidgets);
      expect(find.text('Bob'), findsNothing);

      await _tapBack(tester, 'bar-credit-app-bar');
      expect(bar.screens, [BarScreen.tables]);
    });

    testWidgets('phone: search sits under the bar; back to floor', (
      tester,
    ) async {
      final bar = await _pump(
        tester,
        const BarCreditScreen(),
        size: _phone,
        on: BarScreen.credit,
        loans: loans,
      );

      final appBar = find.byKey(const ValueKey('bar-credit-app-bar'));
      expect(tester.widget(appBar), isA<CustomAppBar>());
      expect(
        find.descendant(of: appBar, matching: find.byType(TextField)),
        findsNothing,
      );
      expect(find.byType(TextField), findsOneWidget);

      await _tapBack(tester, 'bar-credit-app-bar');
      expect(bar.screens, [BarScreen.tables]);
    });
  });
}
