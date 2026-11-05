import 'dart:async';

import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/books_module_entry.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_access_gate.dart';
import 'package:flipper_dashboard/features/service_mode_hotkey.dart';
import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_dashboard/features/tenant/mixins/tenant_permissions_mixin.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';

const _me = 'u-1';

class _Box extends Fake implements LocalStorage {
  @override
  String? getUserId() => _me;

  @override
  String? getBusinessId() => 'biz-1';

  @override
  String? readString({required String key}) => null;

  @override
  bool? readBool({required String key}) => null;
}

class _Services extends BarServices {
  const _Services();

  @override
  LocalStorage get box => getIt<LocalStorage>();
}

/// [feature] granted to someone else, so it is no longer open to all.
ServiceModeGrants _restricted(List<String> features, {String to = 'u-2'}) =>
    ServiceModeGrants(
      byFeature: {
        for (final f in features) f: {to},
      },
    );

List<Override> _overrides({
  required ServiceModeGrants grants,
  bool pos = true,
}) => [
  barServicesProvider.overrideWithValue(const _Services()),
  serviceModeGrantsProvider.overrideWith((ref) async => grants),
  serviceModeOfferedProvider(ServiceMode.bar).overrideWithValue(true),
  serviceModeOfferedProvider(ServiceMode.hotel).overrideWithValue(true),
  for (final feature in posViewFeatures)
    featureViewAccessProvider(
      userId: _me,
      featureName: feature,
    ).overrideWithValue(pos),
];

void _useDesktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1600, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Opens Books (just its hotkey desk) over a home screen, as the dashboard
/// pushes it.
Future<void> _openBooks(WidgetTester tester, List<Override> overrides) async {
  _useDesktop(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        navigatorKey: StackedService.navigatorKey,
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  settings: const RouteSettings(
                    name: BooksModuleEntry.routeName,
                  ),
                  builder: (_) =>
                      const Scaffold(body: BooksModeDesk(child: Text('BOOKS'))),
                ),
              ),
              child: const Text('HOME'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('HOME'));
  await tester.pumpAndSettle();
}

Future<void> _pressHotkey(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await tester.pumpAndSettle();
}

DashboardAllAppTile _tile(String page) => DashboardAllAppTile(
  page: page,
  label: page,
  icon: Icons.apps,
  color: Colors.black,
  feature: page == 'POS' ? AppFeature.Sales : null,
);

void main() {
  late List<String> did;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<LocalStorage>(_Box());
    did = [];
    serviceModeHotkeyApply = (mode) async {
      did.add('apply ${mode.name}');
      return true;
    };
    serviceModeHotkeyOpen = (mode) => did.add('open ${mode.name}');
  });

  tearDown(() async {
    serviceModeHotkeyApply = applyServiceMode;
    serviceModeHotkeyOpen = openServiceModeShell;
    await getIt.reset();
  });

  group('the mode hotkey in Books', () {
    testWidgets('skips a mode the user is not granted and leaves Books', (
      tester,
    ) async {
      await _openBooks(
        tester,
        _overrides(grants: _restricted([AppFeature.BarMode])),
      );
      expect(find.text('BOOKS'), findsOneWidget);

      await _pressHotkey(tester);
      // POS → Bar is skipped (granted to someone else) → Hotel.
      expect(did, ['apply hotel', 'open hotel']);
      expect(find.text('BOOKS'), findsNothing);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('only POS allowed: back to POS, nothing to switch', (
      tester,
    ) async {
      await _openBooks(
        tester,
        _overrides(
          grants: _restricted([AppFeature.BarMode, AppFeature.HotelMode]),
        ),
      );
      await _pressHotkey(tester);
      expect(did, ['open pos']);
      expect(find.text('BOOKS'), findsNothing);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });

    testWidgets('no mode allowed: stays in Books and says so', (tester) async {
      await _openBooks(
        tester,
        _overrides(
          grants: _restricted([AppFeature.BarMode, AppFeature.HotelMode]),
          pos: false,
        ),
      );
      await _pressHotkey(tester);
      expect(did, isEmpty);
      expect(find.text('BOOKS'), findsOneWidget);
      expect(
        find.textContaining("You don't have access to POS, Bar or Hotel."),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });
  });

  group('Books and Flo grants', () {
    Future<Map<String, bool>> visible(
      WidgetTester tester,
      ServiceModeGrants grants,
    ) async {
      final result = <String, bool>{};
      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: _overrides(grants: grants),
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                for (final page in ['Accounting', 'Chat', 'POS']) {
                  result[page] = dashboardAppTileVisible(ref, _tile(page));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('open to all until someone is granted them', (tester) async {
      expect(await visible(tester, const ServiceModeGrants()), {
        'Accounting': true,
        'Chat': true,
        'POS': true,
      });
      expect(
        await visible(tester, _restricted([AppFeature.Books, AppFeature.Flo])),
        {'Accounting': false, 'Chat': false, 'POS': true},
      );
      expect(
        await visible(
          tester,
          _restricted([AppFeature.Books, AppFeature.Flo], to: _me),
        ),
        {'Accounting': true, 'Chat': true, 'POS': true},
      );
    });

    testWidgets('admins keep them once restricted', (tester) async {
      final grants = ServiceModeGrants(
        admins: {_me},
        byFeature: {
          AppFeature.Books: {'u-2'},
        },
      );
      expect((await visible(tester, grants))['Accounting'], isTrue);
    });

    Future<void> pumpGate(WidgetTester tester, ServiceModeGrants grants) async {
      _useDesktop(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(grants: grants),
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ModuleAccessGate(
                      feature: AppFeature.Books,
                      label: (_) => 'Books',
                      child: const Text('BOOKS'),
                    ),
                  ),
                ),
                child: const Text('HOME'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();
    }

    testWidgets('Flo turns away staff not granted it', (tester) async {
      _useDesktop(tester);
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(grants: _restricted([AppFeature.Flo])),
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: const Ai(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining("You don't have access to Flo"),
        findsOneWidget,
      );
    });

    testWidgets('a Bar host turns away staff not granted Bar Mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(grants: _restricted([AppFeature.BarMode])),
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: const ServiceModeAccessGate(
              mode: ServiceMode.bar,
              child: Text('BAR'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('BAR'), findsNothing);
      expect(find.textContaining("You don't have access to"), findsOneWidget);
    });

    testWidgets('the module gate waits while nothing is known yet', (
      tester,
    ) async {
      final never = Completer<ServiceModeGrants>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            barServicesProvider.overrideWithValue(const _Services()),
            serviceModeGrantsProvider.overrideWith((ref) => never.future),
          ],
          child: MaterialApp(
            home: ModuleAccessGate(
              feature: AppFeature.Books,
              label: (_) => 'Books',
              child: const Text('BOOKS'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('BOOKS'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('the module gate lets the granted in', (tester) async {
      await pumpGate(tester, const ServiceModeGrants());
      expect(find.text('BOOKS'), findsOneWidget);
    });

    testWidgets('the module gate turns others back, on a desk too', (
      tester,
    ) async {
      await pumpGate(tester, _restricted([AppFeature.Books]));
      expect(find.text('BOOKS'), findsNothing);
      expect(
        find.textContaining("You don't have access to Books"),
        findsOneWidget,
      );
      // Books was opened over something, so Back works on a desk too.
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('HOME'), findsOneWidget);
    });
  });

  group('the User Management matrix', () {
    test('lists Books, Flo and HR', () {
      expect(features, containsAll([AppFeature.Books, AppFeature.Flo]));
      expect(features, contains(AppFeature.HR));
    });

    test('HR offers only No Access and Admin', () {
      expect(TenantPermissionsMixin.accessLevelsFor(AppFeature.HR), [
        'No Access',
        'admin',
      ]);
      expect(
        TenantPermissionsMixin.accessLevelsFor(AppFeature.Books),
        accessLevels,
      );
    });

    test('switching HR on grants Admin; anything else Write', () {
      final levels = <String, String>{};
      final active = <String, bool>{};
      TenantPermissionsMixin.applyActiveToggle(
        AppFeature.HR,
        true,
        levels,
        active,
      );
      TenantPermissionsMixin.applyActiveToggle(
        AppFeature.Flo,
        true,
        levels,
        active,
      );
      expect(levels, {AppFeature.HR: 'admin', AppFeature.Flo: 'write'});
    });

    testWidgets('the HR row offers Admin, and shows Write as No Access', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) =>
                  TenantPermissionsMixin.buildPermissionRowStatic(
                    context,
                    0,
                    AppFeature.HR,
                    {AppFeature.HR: 'write'},
                    {AppFeature.HR: true},
                    setState,
                  ),
            ),
          ),
        ),
      );
      final dropdown = tester.widget<DropdownButton<String>>(
        find.byType(DropdownButton<String>),
      );
      expect(dropdown.items!.map((i) => i.value), ['No Access', 'admin']);
      expect(dropdown.value, 'No Access');
    });

    test('labels the new rows', () {
      final l10n = lookupFlipperAppLocalizations(const Locale('en'));
      String label(String f) => TenantPermissionsMixin.featureLabel(l10n, f);
      expect(label(AppFeature.Books), 'Books');
      expect(label(AppFeature.Flo), 'Flo');
      expect(label(AppFeature.HR), l10n.hrAndPayroll);
    });
  });

  group('serviceModeGrantsFromRows', () {
    test('counts Books and Flo grants', () {
      final grants = serviceModeGrantsFromRows([
        {'user_id': 'u-2', 'feature_name': AppFeature.Books},
        {'user_id': 'u-3', 'feature_name': AppFeature.Flo},
        {'user_id': 'u-4', 'feature_name': AppFeature.Sales},
      ], now: DateTime(2026, 11, 5));
      expect(grants.byFeature, {
        AppFeature.Books: {'u-2'},
        AppFeature.Flo: {'u-3'},
      });
    });
  });
}
