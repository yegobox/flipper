import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_access_gate.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
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

final _waiter = Tenant(id: 't-w', name: 'Waiter', userId: 'u-w');
final _cashier = Tenant(id: 't-c', name: 'Cashier', userId: 'u-c');
final _admin = Tenant(id: 't-a', name: 'Boss', userId: 'u-a', type: 'Admin');

ServiceModeGrants _barGrantedTo(String userId) => ServiceModeGrants(
  byFeature: {
    AppFeature.BarMode: {userId},
  },
);

List<Override> _overrides({
  required String? signedIn,
  required ServiceModeGrants grants,
}) => [
  barServicesProvider.overrideWithValue(_Services(_Box(signedIn))),
  serviceModeGrantsProvider.overrideWith((ref) async => grants),
  barStaffProvider.overrideWith((ref) async => [_waiter, _cashier, _admin]),
  if (signedIn != null)
    for (final feature in serviceModeFeatures)
      featureViewAccessProvider(
        userId: signedIn,
        featureName: feature,
      ).overrideWithValue(false),
];

Future<void> _pumpGate(
  WidgetTester tester, {
  required String? signedIn,
  required ServiceModeGrants grants,
  ServiceMode mode = ServiceMode.bar,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(signedIn: signedIn, grants: grants),
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: ServiceModeAccessGate(mode: mode, child: const Text('HOST')),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('barSignInStaffProvider', () {
    Future<List<Tenant>> signIn(ServiceModeGrants grants) {
      final container = ProviderContainer(
        overrides: _overrides(signedIn: null, grants: grants),
      );
      addTearDown(container.dispose);
      return container.read(barSignInStaffProvider.future);
    }

    test('nobody granted Bar Mode: every staff member can sign in', () async {
      expect(await signIn(const ServiceModeGrants()), [
        _waiter,
        _cashier,
        _admin,
      ]);
    });

    test('Bar Mode granted: only the granted staff and admins', () async {
      expect(await signIn(_barGrantedTo('u-w')), [_waiter, _admin]);
    });

    test('a Hotel Mode grant leaves the bar roster open', () async {
      final grants = ServiceModeGrants(
        byFeature: {
          AppFeature.HotelMode: {'u-c'},
        },
      );
      expect(await signIn(grants), [_waiter, _cashier, _admin]);
    });
  });

  group('ServiceModeAccessGate', () {
    testWidgets('grandfathered: shows the host to anyone', (tester) async {
      await _pumpGate(
        tester,
        signedIn: 'u-c',
        grants: const ServiceModeGrants(),
      );
      expect(find.text('HOST'), findsOneWidget);
    });

    testWidgets('granted user gets the host', (tester) async {
      await _pumpGate(tester, signedIn: 'u-w', grants: _barGrantedTo('u-w'));
      expect(find.text('HOST'), findsOneWidget);
    });

    testWidgets('user without the grant gets the notice', (tester) async {
      await _pumpGate(tester, signedIn: 'u-c', grants: _barGrantedTo('u-w'));
      expect(find.text('HOST'), findsNothing);
      expect(find.byType(ServiceModeNoAccess), findsOneWidget);
    });

    testWidgets('owner and Admin-type users always get the host', (
      tester,
    ) async {
      await _pumpGate(
        tester,
        signedIn: 'u-a',
        grants: ServiceModeGrants(
          admins: const {'u-a'},
          byFeature: {
            AppFeature.BarMode: {'u-w'},
          },
        ),
      );
      expect(find.text('HOST'), findsOneWidget);
    });

    testWidgets('a Bar grant does not open Hotel', (tester) async {
      await _pumpGate(
        tester,
        signedIn: 'u-w',
        mode: ServiceMode.hotel,
        grants: ServiceModeGrants(
          byFeature: {
            AppFeature.BarMode: {'u-w'},
            AppFeature.HotelMode: {'u-c'},
          },
        ),
      );
      expect(find.byType(ServiceModeNoAccess), findsOneWidget);
    });
  });
}
