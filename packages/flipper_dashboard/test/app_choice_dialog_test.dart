import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/app_choice_dialog.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/hr_module_entry.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_dashboard/widgets/app_launch_overlay.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_services/locator.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
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
  String? getDefaultApp() => defaultApp;

  @override
  Future<void> writeString({required String key, required String value}) async {
    if (key == 'defaultApp') defaultApp = value;
  }
}

const _userId = 'u1';

/// The host ships HR, and the signed-in user is an admin unless [admin] says
/// otherwise; [hrGrant] is the staff 'HR' grant.
List<Override> _hrOverrides({bool admin = true, bool hrGrant = false}) => [
  hrAppBuilderProvider.overrideWithValue(
    ({required onExit, required onUpgrade}) => const SizedBox(),
  ),
  // No Supabase session: an opened HR shows its offline page, so the test
  // never reaches the network.
  hrEnsureSupabaseSessionProvider.overrideWithValue(() async => null),
  featureAccessLevelProvider(
    userId: _userId,
    accessLevel: AccessLevel.ADMIN,
  ).overrideWithValue(admin),
  featureAccessProvider(
    userId: _userId,
    featureName: 'HR',
  ).overrideWithValue(hrGrant),
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

  testWidgets('offers only POS and Books, with the branch and business', (
    tester,
  ) async {
    await pumpChooser(tester);

    expect(find.text('Choose your app'), findsOneWidget);
    expect(find.text('Yegobox Ltd'), findsOneWidget);
    expect(find.text('Kigali Heights'), findsOneWidget);

    expect(find.text('POS'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
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

    // Tiles are ordered POS, Books, so "2" is Books.
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await _pumpSelection(tester);

    expect(box.defaultApp, 'Books');
    expect(responses.single.data, {'defaultApp': 'Books'});
  });

  testWidgets('number keys past the last app do nothing', (tester) async {
    await pumpChooser(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
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

    testWidgets('is offered to staff with the HR grant', (tester) async {
      await pumpChooser(
        tester,
        overrides: _hrOverrides(admin: false, hrGrant: true),
      );

      expect(find.text('HR & Payroll'), findsOneWidget);
    });

    testWidgets('is hidden without access, and an HR default reads as POS', (
      tester,
    ) async {
      box.defaultApp = 'HR';
      await pumpChooser(tester, overrides: _hrOverrides(admin: false));

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
      }

      await check(_hrOverrides());
      expect(visible, isTrue);
      await check(_hrOverrides(admin: false));
      expect(visible, isFalse);
    });
  });
}
