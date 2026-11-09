import 'dart:async';

import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_desktop.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart'
    show StaffRoster;
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show connectivityStreamProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

final _aline = Tenant(id: 't1', name: 'Aline', userId: 'u1', pin: 111111);
final _bosco = Tenant(id: 't2', name: 'Bosco', userId: 'u2', pin: 222222);

/// Restored from the offline copy: same people, no PIN.
final _alineCached = Tenant(id: 't1', name: 'Aline', userId: 'u1');

StaffRoster _fresh(List<Tenant> t) => (tenants: t, fresh: true);
StaffRoster _cached(List<Tenant> t) => (tenants: t, fresh: false);
const StaffRoster _none = (tenants: <Tenant>[], fresh: false);

/// Answers each read with the next queued roster (the last one repeats), or
/// throws when that entry is an [Exception].
class _Loader {
  _Loader(this._answers);

  final List<Object> _answers;
  final List<String?> calls = [];

  Future<StaffRoster> call(String? businessId) async {
    calls.add(businessId);
    final answer = _answers.length > 1 ? _answers.removeAt(0) : _answers.first;
    if (answer is Exception) throw answer;
    return answer as StaffRoster;
  }
}

/// A container with [loader] and a controllable connectivity stream.
({ProviderContainer container, StreamController<bool> online, List<int> builds})
_harness(_Loader loader, {Stream<Branch>? branch}) {
  final online = StreamController<bool>();
  final container = ProviderContainer(
    overrides: [
      staffRosterLoaderProvider.overrideWithValue(loader.call),
      connectivityStreamProvider.overrideWith((ref) => online.stream),
      activeBranchProvider.overrideWith(
        (ref) => branch ?? const Stream<Branch>.empty(),
      ),
    ],
  );
  final builds = <int>[];
  // A rebuild shows as a loading state; count them.
  container.listen(barStaffProvider, (previous, next) {
    if (next.isLoading) builds.add(1);
  }, fireImmediately: true);
  return (container: container, online: online, builds: builds);
}

Future<List<Tenant>> _settle(WidgetTester tester, ProviderContainer c) async {
  await tester.pump();
  await tester.pump();
  return c.read(barStaffProvider.future);
}

void main() {
  group('barStaffProvider', () {
    testWidgets('an empty roster reads again until staff appear', (
      tester,
    ) async {
      final loader = _Loader([
        _none,
        _none,
        _fresh([_aline]),
      ]);
      final h = _harness(loader);
      addTearDown(h.container.dispose);

      expect(await _settle(tester, h.container), isEmpty);
      expect(loader.calls, hasLength(1));

      // Still empty: read again, but the screen is not rebuilt for nothing.
      await tester.pump(staffRosterEmptyRetryDelay);
      await tester.pump();
      expect(loader.calls, hasLength(2));
      expect(h.builds, hasLength(1));

      await tester.pump(staffRosterEmptyRetryDelay);
      expect(await _settle(tester, h.container), [_aline]);
      // The rebuild takes the background read; it does not read again.
      expect(loader.calls, hasLength(3));
      expect(h.builds, hasLength(2));

      // A live roster schedules nothing further.
      await tester.pump(staffRosterCachedRefreshDelay * 3);
      expect(loader.calls, hasLength(3));
    });

    testWidgets('a failed background read tries again later', (tester) async {
      final loader = _Loader([
        _none,
        Exception('offline'),
        _fresh([_aline]),
      ]);
      final h = _harness(loader);
      addTearDown(h.container.dispose);

      expect(await _settle(tester, h.container), isEmpty);
      await tester.pump(staffRosterEmptyRetryDelay);
      await tester.pump();
      expect(loader.calls, hasLength(2));
      expect(h.container.read(barStaffProvider).value, isEmpty);

      await tester.pump(staffRosterEmptyRetryDelay);
      expect(await _settle(tester, h.container), [_aline]);
    });

    testWidgets('coming back online reads again at once', (tester) async {
      final loader = _Loader([
        _none,
        _fresh([_aline]),
      ]);
      final h = _harness(loader);
      addTearDown(h.container.dispose);

      expect(await _settle(tester, h.container), isEmpty);
      h.online.add(false);
      await tester.pump();
      expect(loader.calls, hasLength(1));

      h.online.add(true);
      expect(await _settle(tester, h.container), [_aline]);
      expect(loader.calls, hasLength(2));
      // A live roster schedules nothing further.
      await tester.pump(staffRosterEmptyRetryDelay);
      expect(loader.calls, hasLength(2));
    });

    testWidgets('the offline copy is kept when the live read has the same '
        'people', (tester) async {
      final loader = _Loader([
        _cached([_alineCached]),
        _fresh([_aline]),
      ]);
      final h = _harness(loader);
      addTearDown(h.container.dispose);

      final first = await _settle(tester, h.container);
      expect(first.single.pin, isNull);

      await tester.pump(staffRosterCachedRefreshDelay);
      await tester.pump();
      expect(loader.calls, hasLength(2));
      // No rebuild: a PIN being typed on the lock screen is not dropped.
      expect(h.builds, hasLength(1));
      expect(identical(h.container.read(barStaffProvider).value, first), true);

      // The live read settled it: nothing more is scheduled.
      await tester.pump(staffRosterCachedRefreshDelay * 3);
      expect(loader.calls, hasLength(2));
    });

    testWidgets('the offline copy is replaced when the people changed', (
      tester,
    ) async {
      final loader = _Loader([
        _cached([_alineCached]),
        _cached([_alineCached]),
        _fresh([_aline, _bosco]),
      ]);
      final h = _harness(loader);
      addTearDown(h.container.dispose);

      expect(await _settle(tester, h.container), [_alineCached]);

      // Still offline, same copy: read again later.
      await tester.pump(staffRosterCachedRefreshDelay);
      await tester.pump();
      expect(loader.calls, hasLength(2));
      expect(h.builds, hasLength(1));

      await tester.pump(staffRosterCachedRefreshDelay);
      expect(await _settle(tester, h.container), [_aline, _bosco]);
      expect(loader.calls, hasLength(3));
    });

    testWidgets('a business switch reads the new business, once', (
      tester,
    ) async {
      final branches = StreamController<Branch>();
      final loader = _Loader([
        _none,
        _fresh([_aline]),
        _fresh([_bosco]),
      ]);
      final h = _harness(loader, branch: branches.stream);
      addTearDown(h.container.dispose);
      addTearDown(branches.close);

      expect(await _settle(tester, h.container), isEmpty);
      // Switch business just before the background read is due: the new
      // business is read, and the old one's timer is gone.
      await tester.pump(
        staffRosterEmptyRetryDelay - const Duration(seconds: 1),
      );
      branches.add(Branch(id: 'b2', name: 'Other', businessId: 'biz-2'));
      await tester.pump();
      final roster = await _settle(tester, h.container);
      expect(loader.calls.last, 'biz-2');
      expect(roster, [_aline]);
      await tester.pump(staffRosterEmptyRetryDelay);
      expect(loader.calls, hasLength(2));
    });

    testWidgets('disposing stops the background reads', (tester) async {
      final loader = _Loader([_none]);
      final h = _harness(loader);

      expect(await _settle(tester, h.container), isEmpty);
      h.container.dispose();
      await tester.pump(staffRosterEmptyRetryDelay * 2);
      expect(loader.calls, hasLength(1));
    });
  });

  group('BarLockDesktopScreen with no staff', () {
    testWidgets('says why and offers Retry, which reads again', (tester) async {
      tester.view.physicalSize = const Size(1440, 912);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final loader = _Loader([
        _none,
        _fresh([_aline]),
      ]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            staffRosterLoaderProvider.overrideWithValue(loader.call),
            connectivityStreamProvider.overrideWith(
              (ref) => const Stream<bool>.empty(),
            ),
            activeBranchProvider.overrideWith(
              (ref) => const Stream<Branch>.empty(),
            ),
            serviceModeGrantsProvider.overrideWith(
              (ref) async => const ServiceModeGrants(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: const Scaffold(body: BarLockDesktopScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final l10n = lookupFlipperAppLocalizations(const Locale('en'));
      expect(find.text(l10n.barNoStaffYet), findsOneWidget);
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();

      expect(loader.calls, hasLength(2));
      expect(find.text(l10n.barNoStaffYet), findsNothing);
      expect(find.text('Aline'), findsOneWidget);
    });
  });
}
