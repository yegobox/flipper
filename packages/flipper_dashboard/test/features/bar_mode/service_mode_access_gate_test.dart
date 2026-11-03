import 'dart:async';

import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_access_gate.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _Box extends Fake implements LocalStorage {
  _Box(this.userId, {this.values = const {}});

  final String? userId;
  final Map<String, String> values;

  @override
  String? getUserId() => userId;

  @override
  String? getBusinessId() => 'biz-1';

  @override
  String? readString({required String key}) => values[key];
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

    test('hotel roster: only the Hotel Mode holders and admins', () async {
      final container = ProviderContainer(
        overrides: _overrides(
          signedIn: null,
          grants: ServiceModeGrants(
            byFeature: {
              AppFeature.BarMode: {'u-w'},
              AppFeature.HotelMode: {'u-c'},
            },
          ),
        ),
      );
      addTearDown(container.dispose);
      expect(await container.read(hotelStaffProvider.future), [
        _cashier,
        _admin,
      ]);
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

  group('knownServiceModeGrants', () {
    Future<void> pumpProbe(
      WidgetTester tester,
      Future<ServiceModeGrants> grants, {
      Map<String, String> box = const {},
    }) => tester.pumpWidget(
      ProviderScope(
        overrides: [
          barServicesProvider.overrideWithValue(
            _Services(_Box('u-c', values: box)),
          ),
          serviceModeGrantsProvider.overrideWith((ref) => grants),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              final known = knownServiceModeGrants(ref);
              return Text(
                known == null
                    ? 'UNKNOWN'
                    : known.isRestricted(AppFeature.BarMode)
                    ? 'RESTRICTED'
                    : 'OPEN',
              );
            },
          ),
        ),
      ),
    );

    testWidgets('unknown while the first fetch runs with no offline copy', (
      tester,
    ) async {
      final pending = Completer<ServiceModeGrants>();
      await pumpProbe(tester, pending.future);
      expect(find.text('UNKNOWN'), findsOneWidget);

      pending.complete(_barGrantedTo('u-w'));
      await tester.pumpAndSettle();
      expect(find.text('RESTRICTED'), findsOneWidget);
    });

    testWidgets('the offline copy answers while the fetch runs', (
      tester,
    ) async {
      final pending = Completer<ServiceModeGrants>();
      await pumpProbe(
        tester,
        pending.future,
        box: {
          serviceModeGrantsCacheKey('biz-1'): encodeServiceModeGrantRows([
            {
              'user_id': 'u-w',
              'feature_name': AppFeature.BarMode,
              'status': 'active',
            },
          ]),
        },
      );
      expect(find.text('RESTRICTED'), findsOneWidget);
      pending.complete(const ServiceModeGrants());
      await tester.pumpAndSettle();
      expect(find.text('OPEN'), findsOneWidget);
    });
  });
}
