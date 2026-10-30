import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/app_choice_dialog.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/hr_module_entry.dart';
import 'package:flipper_dashboard/layout.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_dashboard/widgets/app_launch_overlay.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

/// LocalStorage that records `defaultApp` writes the way the dialog expects.
class _AppChoiceBox extends MockBox {
  String? defaultApp;

  @override
  String? getUserId() => _userId;

  @override
  String? getBusinessId() => _businessId;

  @override
  String? getDefaultApp() => defaultApp;

  @override
  Future<void> writeString({required String key, required String value}) async {
    if (key == 'defaultApp') defaultApp = value;
  }
}

const _userId = 'u1';
const _businessId = 'biz1';

/// An active access row for the signed-in user in the current business.
Access _access({
  String? userType,
  String? featureName,
  String? accessLevel,
  String businessId = _businessId,
  String status = 'active',
  DateTime? expiresAt,
}) => Access(
  userId: _userId,
  businessId: businessId,
  userType: userType,
  featureName: featureName,
  accessLevel: accessLevel,
  status: status,
  expiresAt: expiresAt,
);

/// The host ships HR, and the signed-in user holds [accesses] — by default
/// they are an Admin of the current business.
List<Override> _hrOverrides({List<Access>? accesses}) => [
  hrAppBuilderProvider.overrideWithValue(
    ({required onExit, required onUpgrade}) => const SizedBox(),
  ),
  // No Supabase session: an opened HR shows its offline page, so the test
  // never reaches the network.
  hrEnsureSupabaseSessionProvider.overrideWithValue(() async => null),
  allAccessesProvider(
    _userId,
  ).overrideWith((ref) async => accesses ?? [_access(userType: 'Admin')]),
];

/// The selected tile swaps its shortcut badge for a [CircularProgressIndicator],
/// which spins forever — so settle by pumping fixed frames instead.
Future<void> _pumpSelection(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
}

void main() {
  late _AppChoiceBox box;
  late List<DialogResponse> responses;

  Future<void> pumpChooser(
    WidgetTester tester, {
    AppChoiceDialogRequest request = const AppChoiceDialogRequest(
      businessName: 'Yegobox Ltd',
      branchName: 'Kigali Heights',
    ),
    List<Override> overrides = const [],
  }) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: AppChoiceDialog(
            request: DialogRequest<AppChoiceDialogRequest>(data: request),
            completer: responses.add,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    responses = [];
    box = _AppChoiceBox();
    // The launch curtain loops an animation and arms a safety timer, so leave it
    // out of these tests; it is covered by app_launch_overlay_test.dart.
    AppLaunchOverlay.suppressForTests = true;
    if (getIt.isRegistered<LocalStorage>()) {
      getIt.unregister<LocalStorage>();
    }
    getIt.registerSingleton<LocalStorage>(box);
  });

  tearDown(() {
    AppLaunchOverlay.suppressForTests = false;
    if (getIt.isRegistered<LocalStorage>()) {
      getIt.unregister<LocalStorage>();
    }
  });

  testWidgets('offers POS, Books and Flo, with the branch and business', (
    tester,
  ) async {
    await pumpChooser(tester);

    expect(find.text('Choose your app'), findsOneWidget);
    expect(find.text('Yegobox Ltd'), findsOneWidget);
    expect(find.text('Kigali Heights'), findsOneWidget);

    expect(find.text('POS'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Flo'), findsOneWidget);
    // This app does not ship HR, so HR is not offered.
    expect(find.text('HR & Payroll'), findsNothing);
    // Everything else lives inside POS, so it is not an app of its own.
    for (final title in [
      'Inventory',
      'Reports',
      'Orders',
      'Customers',
      'Settings',
    ]) {
      expect(find.text(title), findsNothing, reason: '$title is not an app');
    }
  });

  testWidgets('marks the stored default app', (tester) async {
    box.defaultApp = 'Books';
    await pumpChooser(tester);

    expect(find.text('DEFAULT'), findsOneWidget);
    expect(find.text('Default · Books'), findsOneWidget);
  });

  testWidgets('a default from an older build reads as POS', (tester) async {
    box.defaultApp = 'Reports';
    await pumpChooser(tester);

    expect(find.text('DEFAULT'), findsOneWidget);
    expect(find.text('Default · POS'), findsOneWidget);

    // The cursor starts on that default, so Enter opens POS.
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpSelection(tester);

    expect(box.defaultApp, 'POS');
  });

  testWidgets('tapping a tile stores the choice and confirms the dialog', (
    tester,
  ) async {
    await pumpChooser(tester);

    await tester.tap(find.text('POS'));
    await _pumpSelection(tester);

    expect(box.defaultApp, 'POS');
    expect(responses, hasLength(1));
    expect(responses.single.confirmed, isTrue);
    expect(responses.single.data, {'defaultApp': 'POS'});
  });

  testWidgets('number keys launch the matching app', (tester) async {
    await pumpChooser(tester);

    // Tiles are ordered POS, Books, Flo, so "2" is Books.
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await _pumpSelection(tester);

    expect(box.defaultApp, 'Books');
    expect(responses.single.data, {'defaultApp': 'Books'});
  });

  testWidgets('number keys past the last app do nothing', (tester) async {
    await pumpChooser(tester);

    // POS, Books, Flo: there is no fourth app here.
    await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
    await _pumpSelection(tester);

    expect(box.defaultApp, isNull);
    expect(responses, isEmpty);
  });

  testWidgets('arrow keys move the cursor and Enter opens it', (tester) async {
    await pumpChooser(tester);

    // Cursor starts on POS; one step right lands on Books.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpSelection(tester);

    expect(box.defaultApp, 'Books');
  });

  testWidgets('Escape cancels without storing a default', (tester) async {
    await pumpChooser(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(box.defaultApp, isNull);
    expect(responses.single.confirmed, isFalse);
  });

  testWidgets(
    'falls back to the active branch when the caller passes no context',
    (tester) async {
      // The side-menu switcher supplies no request payload, so the branch label
      // comes from activeBranchProvider — and selecting must not read it again
      // after the pop, where `ref` is no longer usable.
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeBranchProvider.overrideWith(
              (ref) => Stream.value(
                Branch(
                  id: 'b1',
                  name: 'Nyabugogo',
                  businessId: 'biz1',
                  isDefault: true,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: AppChoiceDialog(
              request: DialogRequest<AppChoiceDialogRequest>(),
              completer: responses.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nyabugogo'), findsOneWidget);

      await tester.tap(find.text('POS'));
      await _pumpSelection(tester);

      expect(box.defaultApp, 'POS');
      expect(responses.single.confirmed, isTrue);
    },
  );

  testWidgets('choosing POS preselects its dashboard page', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    // Start elsewhere so the assertion cannot pass on the provider's default.
    container.read(selectedPageProvider.notifier).state = DashboardPage.reports;

    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: AppChoiceDialog(
            request: DialogRequest<AppChoiceDialogRequest>(
              // branchName supplied so the chooser does not fall back to
              // activeBranchProvider, which arms a retry timer.
              data: const AppChoiceDialogRequest(
                awaitsExternalNavigation: true,
                branchName: 'Kigali Heights',
              ),
            ),
            completer: responses.add,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('POS'));
    await _pumpSelection(tester);

    expect(container.read(selectedPageProvider), DashboardPage.inventory);
  });

  group('HR', () {
    // The login flow opens the chosen app itself, so selecting does not push
    // a route here.
    const loginRequest = AppChoiceDialogRequest(
      awaitsExternalNavigation: true,
      branchName: 'Kigali Heights',
    );

    testWidgets('is a third app for an admin and opens on its number', (
      tester,
    ) async {
      await pumpChooser(tester, overrides: _hrOverrides());

      expect(find.text('HR & Payroll'), findsOneWidget);
      expect(find.text('Staff, leave and payroll'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(box.defaultApp, 'HR');
      expect(responses.single.data, {'defaultApp': 'HR'});
      // Opened as its own route, like Books.
      expect(find.byType(HrModuleEntry), findsOneWidget);
    });

    testWidgets('is offered to staff with an Admin-level HR grant', (
      tester,
    ) async {
      await pumpChooser(
        tester,
        overrides: _hrOverrides(
          accesses: [_access(featureName: 'HR', accessLevel: 'Admin')],
        ),
      );

      expect(find.text('HR & Payroll'), findsOneWidget);
    });

    testWidgets('is hidden without access, and an HR default reads as POS', (
      tester,
    ) async {
      box.defaultApp = 'HR';
      await pumpChooser(tester, overrides: _hrOverrides(accesses: []));

      expect(find.text('HR & Payroll'), findsNothing);
      expect(find.text('Default · POS'), findsOneWidget);
    });

    testWidgets('is hidden in Local Mode', (tester) async {
      LocalMode.debugSet(true);
      addTearDown(() => LocalMode.debugSet(false));

      await pumpChooser(tester, overrides: _hrOverrides());

      expect(find.text('HR & Payroll'), findsNothing);
    });

    testWidgets('as the stored default, Enter opens it again', (tester) async {
      box.defaultApp = 'HR';
      await pumpChooser(
        tester,
        request: loginRequest,
        overrides: _hrOverrides(),
      );

      expect(find.text('Default · HR & Payroll'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _pumpSelection(tester);

      expect(responses.single.data, {'defaultApp': 'HR'});
    });

    testWidgets('hovering a tile moves the cursor off the default', (
      tester,
    ) async {
      box.defaultApp = 'HR';
      await pumpChooser(
        tester,
        request: loginRequest,
        overrides: _hrOverrides(),
      );

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.text('Books')));
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _pumpSelection(tester);

      expect(responses.single.data, {'defaultApp': 'Books'});
    });

    testWidgets('fits a narrow window, one card per row', (tester) async {
      // setSurfaceSize leaves the logical width alone; the view size is what
      // lays the dialog out.
      tester.view.physicalSize = const Size(480, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: _hrOverrides(),
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: AppChoiceDialog(
              request: DialogRequest<AppChoiceDialogRequest>(
                data: loginRequest,
              ),
              completer: responses.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final pos = tester.getTopLeft(find.text('POS'));
      final books = tester.getTopLeft(find.text('Books'));
      expect(books.dx, pos.dx);
      expect(books.dy, greaterThan(pos.dy));
    });

    testWidgets('the More → Apps tile follows the same rule', (tester) async {
      const tile = DashboardAllAppTile(
        page: 'HR',
        label: 'HR & Payroll',
        icon: Icons.people,
        color: Colors.blue,
        feature: 'HR',
      );
      late bool visible;
      Future<void> check(List<Override> overrides) async {
        await tester.pumpWidget(
          ProviderScope(
            key: UniqueKey(),
            overrides: overrides,
            child: Consumer(
              builder: (context, ref, _) {
                visible = dashboardAppTileVisible(ref, tile);
                return const SizedBox();
              },
            ),
          ),
        );
        // The access rows load asynchronously; let them land.
        await tester.pumpAndSettle();
      }

      await check(_hrOverrides());
      expect(visible, isTrue);
      await check(_hrOverrides(accesses: []));
      expect(visible, isFalse);
    });
  });

  group('the app opened after sign-in', () {
    late WidgetRef capturedRef;
    Future<String?> resolve(
      WidgetTester tester, {
      String? stored,
      List<Override> overrides = const [],
    }) async {
      box.defaultApp = stored;
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: overrides,
          child: Consumer(
            builder: (context, ref, _) {
              capturedRef = ref;
              return const SizedBox();
            },
          ),
        ),
      );
      return defaultAppToOpenAfterLogin(capturedRef);
    }

    testWidgets('is the stored app when it is not HR', (tester) async {
      expect(await resolve(tester, stored: 'Books'), 'Books');
      expect(await resolve(tester), isNull);
    });

    testWidgets('is HR when the user may still run it here', (tester) async {
      // Read before the access rows have loaded: it waits for them rather
      // than taking "not loaded yet" for "no".
      expect(
        await resolve(tester, stored: 'HR', overrides: _hrOverrides()),
        'HR',
      );
    });

    testWidgets('falls back to POS when HR is no longer theirs', (
      tester,
    ) async {
      expect(
        await resolve(
          tester,
          stored: 'HR',
          overrides: _hrOverrides(accesses: []),
        ),
        'POS',
      );
      // The running app does not ship HR.
      expect(await resolve(tester, stored: 'HR'), 'POS');
    });

    testWidgets('falls back to POS in Local Mode', (tester) async {
      LocalMode.debugSet(true);
      addTearDown(() => LocalMode.debugSet(false));
      expect(
        await resolve(tester, stored: 'HR', overrides: _hrOverrides()),
        'POS',
      );
    });

    testWidgets('fails closed when the access rows cannot load', (
      tester,
    ) async {
      final overrides = <Override>[
        hrAppBuilderProvider.overrideWithValue(
          ({required onExit, required onUpgrade}) => const SizedBox(),
        ),
        allAccessesProvider(
          _userId,
        ).overrideWith((ref) async => throw StateError('offline')),
      ];
      expect(await resolve(tester, stored: 'HR', overrides: overrides), 'POS');
    });
  });

  group('canRunHr matches what HR\'s RLS honours', () {
    final now = DateTime.utc(2026, 10, 30);
    bool run(List<Access> accesses, {String? businessId = _businessId}) =>
        canRunHr(accesses, businessId: businessId, now: now);

    test('an Admin of this business, or an Admin-level HR grant here', () {
      expect(run([_access(userType: 'admin')]), isTrue);
      expect(run([_access(featureName: 'hr', accessLevel: 'admin')]), isTrue);
    });

    test('a Write-level HR grant does not count', () {
      expect(run([_access(featureName: 'HR', accessLevel: 'Write')]), isFalse);
    });

    test('an admin level on another module does not count', () {
      expect(
        run([
          _access(
            userType: 'Cashier',
            featureName: 'Sales',
            accessLevel: 'Admin',
          ),
        ]),
        isFalse,
      );
    });

    test('grants from another business do not count', () {
      expect(
        run([_access(userType: 'Admin', businessId: 'other-biz')]),
        isFalse,
      );
    });

    test('inactive or expired grants do not count', () {
      expect(run([_access(userType: 'Admin', status: 'inactive')]), isFalse);
      expect(
        run([
          _access(
            featureName: 'HR',
            accessLevel: 'Admin',
            expiresAt: now.subtract(const Duration(days: 1)),
          ),
        ]),
        isFalse,
      );
      expect(
        run([
          _access(
            userType: 'Admin',
            expiresAt: now.add(const Duration(days: 1)),
          ),
        ]),
        isTrue,
      );
    });

    test('nothing counts without a current business', () {
      expect(run([_access(userType: 'Admin')], businessId: null), isFalse);
      expect(run([_access(userType: 'Admin')], businessId: ''), isFalse);
    });
  });

  group('Flo', () {
    // The login flow opens the chosen app itself, so selecting does not push
    // a route here.
    const loginRequest = AppChoiceDialogRequest(
      awaitsExternalNavigation: true,
      branchName: 'Kigali Heights',
    );

    /// Lays the chooser out at a real desktop width (setSurfaceSize leaves the
    /// logical size alone).
    Future<ProviderContainer> pumpWide(
      WidgetTester tester, {
      List<Override> overrides = const [],
    }) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(overrides: overrides);
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: AppChoiceDialog(
              request: DialogRequest<AppChoiceDialogRequest>(
                data: loginRequest,
              ),
              completer: responses.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('opens the Flo tab of the dashboard', (tester) async {
      final container = await pumpWide(tester);

      expect(find.text('Ask Flo and work together'), findsOneWidget);
      await tester.tap(find.text('Flo'));
      await _pumpSelection(tester);

      expect(box.defaultApp, 'Flo');
      expect(responses.single.data, {'defaultApp': 'Flo'});
      expect(container.read(selectedPageProvider), DashboardPage.ai);
    });

    testWidgets('is hidden in Local Mode', (tester) async {
      LocalMode.debugSet(true);
      addTearDown(() => LocalMode.debugSet(false));

      await pumpChooser(tester);

      expect(find.text('Flo'), findsNothing);
      expect(find.text('POS'), findsOneWidget);
    });

    testWidgets('as the stored default, Enter opens it again', (tester) async {
      box.defaultApp = 'Flo';
      await pumpChooser(tester, request: loginRequest);

      expect(find.text('Default · Flo'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _pumpSelection(tester);

      expect(responses.single.data, {'defaultApp': 'Flo'});
    });

    testWidgets('three apps sit in one row', (tester) async {
      await pumpWide(tester);

      final pos = tester.getTopLeft(find.text('POS'));
      expect(tester.getTopLeft(find.text('Books')).dy, pos.dy);
      expect(tester.getTopLeft(find.text('Flo')).dy, pos.dy);
    });

    testWidgets('four apps form a 2×2 grid, Flo on key 4', (tester) async {
      await pumpWide(tester, overrides: _hrOverrides());

      final pos = tester.getTopLeft(find.text('POS'));
      final books = tester.getTopLeft(find.text('Books'));
      final hr = tester.getTopLeft(find.text('HR & Payroll'));
      final flo = tester.getTopLeft(find.text('Flo'));
      expect(books.dy, pos.dy);
      expect(hr.dx, pos.dx);
      expect(hr.dy, greaterThan(pos.dy));
      expect(flo.dx, books.dx);
      expect(flo.dy, hr.dy);
      expect(tester.takeException(), isNull);

      await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
      await _pumpSelection(tester);
      expect(responses.single.data, {'defaultApp': 'Flo'});
    });
  });

  test('a stored default app opens on its dashboard tab', () {
    expect(dashboardPageForDefaultApp('Flo'), DashboardPage.ai);
    expect(dashboardPageForDefaultApp('Reports'), DashboardPage.reports);
    expect(dashboardPageForDefaultApp('Orders'), DashboardPage.orders);
    for (final app in ['POS', 'Inventory', 'Books', 'HR', 'unknown']) {
      expect(
        dashboardPageForDefaultApp(app),
        DashboardPage.inventory,
        reason: app,
      );
    }
  });
}
