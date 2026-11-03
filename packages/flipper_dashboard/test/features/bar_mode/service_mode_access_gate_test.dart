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

/// Stands in for the Bar / Hotel notifier's signed-in clerk.
class _Clerk extends Notifier<Tenant?> {
  @override
  Tenant? build() => null;

  void set(Tenant? tenant) => state = tenant;
}

final _clerkProvider = NotifierProvider<_Clerk, Tenant?>(_Clerk.new);

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

    // The host opens on its own lock / starting screen, which waits for the
    // grants itself; the gate only closes once they are known.
    testWidgets('first fetch pending, no offline copy: host, then the grants', (
      tester,
    ) async {
      final pending = Completer<ServiceModeGrants>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            barServicesProvider.overrideWithValue(_Services(_Box('u-c'))),
            serviceModeGrantsProvider.overrideWith((ref) => pending.future),
          ],
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: const ServiceModeAccessGate(
              mode: ServiceMode.bar,
              child: Text('HOST'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('HOST'), findsOneWidget);

      pending.complete(_barGrantedTo('u-w'));
      await tester.pumpAndSettle();
      expect(find.text('HOST'), findsNothing);
      expect(find.byType(ServiceModeNoAccess), findsOneWidget);
    });
  });

  group('signOutIneligibleClerk', () {
    late ServiceModeGrants grants;
    late List<Tenant> roster;

    Future<ProviderContainer> pumpDesk(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            barServicesProvider.overrideWithValue(_Services(_Box(null))),
            serviceModeGrantsProvider.overrideWith((ref) async => grants),
            barStaffProvider.overrideWith((ref) async => roster),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                signOutIneligibleClerk(
                  ref,
                  ServiceMode.bar,
                  clerk: _clerkProvider,
                  signOut: () => ref.read(_clerkProvider.notifier).set(null),
                );
                return Text(ref.watch(_clerkProvider)?.name ?? 'LOCK');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return ProviderScope.containerOf(tester.element(find.byType(Consumer)));
    }

    Future<void> signIn(WidgetTester tester, ProviderContainer c, Tenant t) {
      c.read(_clerkProvider.notifier).set(t);
      return tester.pumpAndSettle();
    }

    setUp(() {
      grants = _barGrantedTo('u-w');
      roster = [_waiter, _cashier, _admin];
    });

    testWidgets('a pick made before the grant went never opens the floor', (
      tester,
    ) async {
      final c = await pumpDesk(tester);
      await signIn(tester, c, _cashier);
      expect(find.text('LOCK'), findsOneWidget);

      await signIn(tester, c, _waiter);
      expect(find.text('Waiter'), findsOneWidget);
    });

    testWidgets('a grant revoked at the desk signs the clerk out', (
      tester,
    ) async {
      final c = await pumpDesk(tester);
      await signIn(tester, c, _waiter);
      expect(find.text('Waiter'), findsOneWidget);

      grants = _barGrantedTo('u-c');
      c.invalidate(serviceModeGrantsProvider);
      await tester.pumpAndSettle();
      expect(find.text('LOCK'), findsOneWidget);
    });

    testWidgets('an Admin demoted at the desk loses the bypass', (
      tester,
    ) async {
      final c = await pumpDesk(tester);
      await signIn(tester, c, _admin);
      expect(find.text('Boss'), findsOneWidget);

      // The kept tenant still says Admin; the refreshed roster does not.
      roster = [
        _waiter,
        Tenant(id: 't-a', name: 'Boss', userId: 'u-a', type: 'Agent'),
      ];
      c.invalidate(barStaffProvider);
      await tester.pumpAndSettle();
      expect(find.text('LOCK'), findsOneWidget);
    });

    testWidgets('an unreadable roster keeps the signed-in Admin', (
      tester,
    ) async {
      roster = const [];
      final c = await pumpDesk(tester);
      await signIn(tester, c, _admin);
      expect(find.text('Boss'), findsOneWidget);
    });

    /// [sinceLoaded] changes the server's answer after the container loaded
    /// the grants and roster, i.e. what a fresh read would see.
    Future<ProviderContainer> mountWithClerk(
      WidgetTester tester,
      Tenant clerk, {
      void Function()? sinceLoaded,
    }) async {
      final container = ProviderContainer(
        overrides: [
          barServicesProvider.overrideWithValue(_Services(_Box(null))),
          serviceModeGrantsProvider.overrideWith((ref) async => grants),
          barStaffProvider.overrideWith((ref) async => roster),
        ],
      );
      addTearDown(container.dispose);
      // Bound and settled before the desk exists, as after Bar → Hotel → Bar.
      container.read(_clerkProvider.notifier).set(clerk);
      await container.read(serviceModeGrantsProvider.future);
      await container.read(barStaffProvider.future);
      sinceLoaded?.call();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                signOutIneligibleClerk(
                  ref,
                  ServiceMode.bar,
                  clerk: _clerkProvider,
                  signOut: () => ref.read(_clerkProvider.notifier).set(null),
                );
                return const Text('DESK');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('a clerk bound before the desk opened, without access', (
      tester,
    ) async {
      final container = await mountWithClerk(tester, _cashier);
      expect(container.read(_clerkProvider), isNull);
    });

    testWidgets('a clerk bound before the desk opened, with access', (
      tester,
    ) async {
      final container = await mountWithClerk(tester, _waiter);
      expect(container.read(_clerkProvider), _waiter);
    });

    testWidgets('bound before the desk opened: a loaded demotion is re-read', (
      tester,
    ) async {
      // Loaded while demoted; promoted back to Admin since.
      roster = [
        _waiter,
        Tenant(id: 't-a', name: 'Boss', userId: 'u-a', type: 'Agent'),
      ];
      final container = await mountWithClerk(
        tester,
        _admin,
        sinceLoaded: () => roster = [_waiter, _admin],
      );
      expect(container.read(_clerkProvider), _admin);
    });

    testWidgets('bound before the desk opened: a loaded revoke is re-read', (
      tester,
    ) async {
      // Loaded without the cashier's grant; granted since.
      final container = await mountWithClerk(
        tester,
        _cashier,
        sinceLoaded: () => grants = ServiceModeGrants(
          byFeature: {
            AppFeature.BarMode: {'u-w', 'u-c'},
          },
        ),
      );
      expect(container.read(_clerkProvider), _cashier);
    });

    testWidgets('grandfathered: anyone stays', (tester) async {
      grants = const ServiceModeGrants();
      final c = await pumpDesk(tester);
      await signIn(tester, c, _cashier);
      expect(find.text('Cashier'), findsOneWidget);
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
