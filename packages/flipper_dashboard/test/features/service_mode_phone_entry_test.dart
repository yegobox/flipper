import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_access_gate.dart';
import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _Box extends Fake implements LocalStorage {
  _Box(this.userId);

  final String? userId;

  @override
  String? getUserId() => userId;

  @override
  String? getBusinessId() => 'biz-1';

  @override
  String? readString({required String key}) => null;
}

class _Services extends BarServices {
  const _Services(this._box);

  final LocalStorage _box;

  @override
  LocalStorage get box => _box;
}

ServiceModeGrants _barGrantedTo(String userId) => ServiceModeGrants(
  byFeature: {
    AppFeature.BarMode: {userId},
  },
);

List<Override> _overrides({
  required String signedIn,
  required ServiceModeGrants grants,
  bool barOffered = true,
  bool hotelOffered = true,
  bool viewAccess = false,
}) => [
  barServicesProvider.overrideWithValue(_Services(_Box(signedIn))),
  serviceModeGrantsProvider.overrideWith((ref) async => grants),
  serviceModeOfferedProvider(ServiceMode.bar).overrideWithValue(barOffered),
  serviceModeOfferedProvider(ServiceMode.hotel).overrideWithValue(hotelOffered),
  for (final feature in serviceModeFeatures)
    featureViewAccessProvider(
      userId: signedIn,
      featureName: feature,
    ).overrideWithValue(viewAccess),
];

DashboardAllAppTile _tile(String page) => DashboardAllAppTile(
  page: page,
  label: page,
  icon: Icons.apps,
  color: Colors.black,
);

/// Whether the More sheet shows [page], per [dashboardAppTileVisible].
Future<bool> _tileVisible(
  WidgetTester tester,
  String page,
  List<Override> overrides,
) async {
  late bool visible;
  await tester.pumpWidget(
    ProviderScope(
      // A fresh scope per call: one test checks several signed-in users.
      key: UniqueKey(),
      overrides: overrides,
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) {
            visible = dashboardAppTileVisible(ref, _tile(page));
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  // Grants load asynchronously; the visibility settles once they have.
  await tester.pumpAndSettle();
  return visible;
}

/// Sizes the test view like a phone (or a desk) for [isPhoneLayout].
void _useView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Pushes [page] over a home screen, as the phone's home opens a mode host.
Future<void> _pushOver(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => page)),
            child: const Text('HOME'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('HOME'));
  await tester.pumpAndSettle();
}

void main() {
  group('serviceModeForDashboardPage', () {
    test('maps the two tile pages and nothing else', () {
      expect(
        serviceModeForDashboardPage(barModeDashboardPage),
        ServiceMode.bar,
      );
      expect(
        serviceModeForDashboardPage(hotelModeDashboardPage),
        ServiceMode.hotel,
      );
      expect(serviceModeForDashboardPage('Tickets'), isNull);
      expect(serviceModeForDashboardPage(null), isNull);
    });
  });

  group('serviceModeRevisionProvider', () {
    test('follows notifyServiceModeChanged', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(serviceModeRevisionProvider);
      notifyServiceModeChanged();
      expect(container.read(serviceModeRevisionProvider), before + 1);
    });
  });

  group('phone Bar / Hotel tiles', () {
    testWidgets('the Sell section offers both modes', (tester) async {
      late List<DashboardAllAppSection> catalog;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Builder(
            builder: (context) {
              catalog = dashboardAllAppsCatalog(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      final pages = [
        for (final section in catalog)
          for (final tile in section.apps) tile.page,
      ];
      expect(
        pages,
        containsAll([barModeDashboardPage, hotelModeDashboardPage]),
      );
    });

    testWidgets('nobody granted: shown to every staff member', (tester) async {
      final overrides = _overrides(
        signedIn: 'u-c',
        grants: const ServiceModeGrants(),
      );
      expect(await _tileVisible(tester, barModeDashboardPage, overrides), true);
      expect(
        await _tileVisible(tester, hotelModeDashboardPage, overrides),
        true,
      );
    });

    testWidgets('hidden while the branch does not run the mode', (
      tester,
    ) async {
      final overrides = _overrides(
        signedIn: 'u-c',
        grants: const ServiceModeGrants(),
        barOffered: false,
      );
      expect(
        await _tileVisible(tester, barModeDashboardPage, overrides),
        false,
      );
      expect(
        await _tileVisible(tester, hotelModeDashboardPage, overrides),
        true,
      );
    });

    testWidgets('granted to someone else: hidden', (tester) async {
      expect(
        await _tileVisible(
          tester,
          barModeDashboardPage,
          _overrides(signedIn: 'u-c', grants: _barGrantedTo('u-w')),
        ),
        false,
      );
    });

    testWidgets('the granted user, the owner and Admins see it', (
      tester,
    ) async {
      expect(
        await _tileVisible(
          tester,
          barModeDashboardPage,
          _overrides(signedIn: 'u-w', grants: _barGrantedTo('u-w')),
        ),
        true,
      );
      expect(
        await _tileVisible(
          tester,
          barModeDashboardPage,
          _overrides(
            signedIn: 'u-a',
            grants: ServiceModeGrants(
              admins: const {'u-a'},
              byFeature: {
                AppFeature.BarMode: {'u-w'},
              },
            ),
          ),
        ),
        true,
      );
      expect(
        await _tileVisible(
          tester,
          barModeDashboardPage,
          _overrides(
            signedIn: 'u-t',
            grants: _barGrantedTo('u-w'),
            viewAccess: true,
          ),
        ),
        true,
      );
    });
  });

  group('leaving a mode on a phone', () {
    testWidgets('no-access notice offers Back on a phone', (tester) async {
      _useView(tester, const Size(360, 640));
      await _pushOver(tester, const ServiceModeNoAccess(mode: ServiceMode.bar));
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('HOME'), findsOneWidget);
    });

    testWidgets('no-access notice has no Back on a desk', (tester) async {
      _useView(tester, const Size(1280, 800));
      await _pushOver(tester, const ServiceModeNoAccess(mode: ServiceMode.bar));
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('close button returns to the phone home', (tester) async {
      _useView(tester, const Size(360, 640));
      await _pushOver(
        tester,
        const Scaffold(body: Center(child: ServiceModeCloseButton())),
      );
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('HOME'), findsOneWidget);
    });

    testWidgets('close button is absent on a desk', (tester) async {
      _useView(tester, const Size(1280, 800));
      await _pushOver(
        tester,
        const Scaffold(body: Center(child: ServiceModeCloseButton())),
      );
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('close button is absent with nowhere to go back to', (
      tester,
    ) async {
      _useView(tester, const Size(360, 640));
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(body: Center(child: ServiceModeCloseButton())),
        ),
      );
      expect(find.byIcon(Icons.close), findsNothing);
    });
  });
}
