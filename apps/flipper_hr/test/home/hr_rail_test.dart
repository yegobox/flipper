// The desktop HR menu is the POS rail: the same widgets, at the same width,
// so the two apps cannot drift apart. This pins that HR mounts them, what each
// entry does, and that the old collapsible sidebar is gone.

import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/widgets/pos_side_rail.dart';
import 'package:flipper_hr/features/billing/application/hr_billing_providers.dart';
import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/features/host/hr_host.dart';
import 'package:flipper_hr/features/session/data/hr_account_repository.dart';
import 'package:flipper_hr/features/session/data/hr_identity_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fake_hr_account_repository.dart';
import '../helpers/fake_hr_billing_repository.dart';
import '../helpers/fake_hr_session_repository.dart';

/// Implements rather than extends: the real constructor reaches for
/// `Supabase.instance`, which tests never initialise.
class _FakeAuthService implements AuthService {
  int signOuts = 0;

  @override
  Future<void> signOut() async => signOuts++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<GoRouter> _pumpShell(
  WidgetTester tester, {
  required HrSession session,
  HrHost host = const HrHost.web(),
  Size size = const Size(1400, 900),
  AuthService? auth,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  Widget page(String path) => Center(child: Text('page $path'));
  final router = GoRouter(
    initialLocation: '/people',
    routes: [
      ShellRoute(
        builder: (context, state, child) => HrHomeShell(child: child),
        routes: [
          for (final path in const [
            '/overview',
            '/people',
            '/pay',
            '/attendance',
            '/approvals',
            '/my-time',
            '/leave',
            '/my-pay',
          ])
            GoRoute(path: path, builder: (_, _) => page(path)),
        ],
      ),
      GoRoute(
        path: '/business-selection',
        builder: (_, _) => page('/business-selection'),
      ),
      GoRoute(path: '/login', builder: (_, _) => page('/login')),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hrHostProvider.overrideWithValue(host),
        if (auth != null) authServiceProvider.overrideWithValue(auth),
        hrSessionRepositoryProvider.overrideWithValue(
          FakeHrSessionRepository(session: session),
        ),
        currentUserProfileProvider.overrideWith((ref) async => null),
        hrAccountRepositoryProvider.overrideWithValue(
          FakeHrAccountRepository(row: const HrAccountRow(name: 'Aline Uwase')),
        ),
        hrBillingRepositoryProvider.overrideWithValue(
          FakeHrBillingRepository(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

String _tooltipOf(WidgetTester tester, Finder item) =>
    tester.widget<PosRailItem>(item).tooltip;

void main() {
  testWidgets('desktop draws the POS rail at the POS width', (tester) async {
    await _pumpShell(tester, session: managerSession());

    final frame = find.byType(PosRailFrame);
    expect(frame, findsOneWidget);
    expect(tester.getSize(frame).width, PosLayoutBreakpoints.sideMenuWidth);
    // The rail replaces the labelled sidebar and its collapse toggle.
    expect(find.byKey(const Key('hr-sidebar-toggle')), findsNothing);
    expect(find.text('Flipper HR'), findsNothing);
  });

  testWidgets('the account avatar sits at the top bar\'s right edge', (
    tester,
  ) async {
    await _pumpShell(tester, session: managerSession());

    final avatar = find.byKey(const Key('hr-account-avatar'));
    // 16px of bar padding + the avatar's own 6px.
    expect(tester.getTopRight(avatar).dx, 1400 - 16 - 6);
  });

  testWidgets('one rail entry per destination, named by its tooltip', (
    tester,
  ) async {
    final session = managerSession();
    await _pumpShell(tester, session: session);

    final destinations = hrDestinationsFor(session);
    for (final d in destinations) {
      final item = find.byKey(Key('hr-sidebar-${d.path.replaceAll('/', '')}'));
      expect(item, findsOneWidget, reason: d.path);
      expect(_tooltipOf(tester, item), d.label);
    }
    // Manage and You are split by the rail's hairline, plus the one above
    // the pinned exit entry.
    expect(find.byType(PosRailDivider), findsNWidgets(2));
  });

  testWidgets('the current route is the selected entry; tapping navigates', (
    tester,
  ) async {
    final router = await _pumpShell(tester, session: managerSession());

    bool selected(String key) =>
        tester.widget<PosRailItem>(find.byKey(Key(key))).isSelected;

    expect(selected('hr-sidebar-people'), isTrue);
    expect(selected('hr-sidebar-leave'), isFalse);

    await tester.tap(find.byKey(const Key('hr-sidebar-leave')));
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.path, '/leave');
    expect(find.text('page /leave'), findsOneWidget);
    expect(selected('hr-sidebar-leave'), isTrue);
    expect(selected('hr-sidebar-people'), isFalse);
  });

  testWidgets('a session with one group gets no group hairline', (
    tester,
  ) async {
    await _pumpShell(tester, session: ownerSession());

    // Only the hairline above the exit entry.
    expect(find.byType(PosRailDivider), findsOneWidget);
  });

  testWidgets('on the web the exit entry signs out', (tester) async {
    final auth = _FakeAuthService();
    final router = await _pumpShell(
      tester,
      session: ownerSession(),
      auth: auth,
    );

    final exit = find.byKey(const Key('hr-rail-exit'));
    expect(tester.widget<PosRailItem>(exit).isLogout, isTrue);
    expect(_tooltipOf(tester, exit), 'Sign Out');

    await tester.tap(exit);
    await tester.pumpAndSettle();

    expect(auth.signOuts, 1);
    expect(router.routerDelegate.currentConfiguration.uri.path, '/login');
    expect(find.text('page /login'), findsOneWidget);
  });

  testWidgets('embedded, the exit entry goes back to Flipper', (tester) async {
    var exits = 0;
    await _pumpShell(
      tester,
      session: ownerSession(),
      host: HrHost.embedded(onExit: () => exits++, onUpgrade: () {}),
    );

    final exit = find.byKey(const Key('hr-rail-exit'));
    expect(_tooltipOf(tester, exit), 'Back to Flipper');

    await tester.tap(exit);
    await tester.pumpAndSettle();
    expect(exits, 1);
  });

  testWidgets('the branch avatar opens business selection on the web', (
    tester,
  ) async {
    final router = await _pumpShell(tester, session: ownerSession());

    await tester.tap(find.byKey(const Key('hr-rail-branch')));
    await tester.pumpAndSettle();

    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      '/business-selection',
    );
  });

  testWidgets('embedded, the branch avatar is only a label', (tester) async {
    final router = await _pumpShell(
      tester,
      session: ownerSession(),
      host: HrHost.embedded(onExit: () {}, onUpgrade: () {}),
    );

    await tester.tap(find.byKey(const Key('hr-rail-branch')));
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.path, '/people');
  });

  testWidgets('a phone keeps the bottom nav and labelled drawer', (
    tester,
  ) async {
    await _pumpShell(
      tester,
      session: managerSession(),
      size: const Size(400, 800),
    );

    expect(find.byType(PosRailFrame), findsNothing);
    expect(find.byKey(const Key('hr-module-nav')), findsOneWidget);

    // Eight destinations overflow the bar; "More" opens the drawer.
    await tester.tap(find.byKey(const Key('hr-nav-more')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('hr-drawer-my-pay')), findsOneWidget);
    expect(find.byKey(const Key('hr-account-name')), findsOneWidget);

    await tester.tap(find.byKey(const Key('hr-drawer-my-pay')));
    await tester.pumpAndSettle();
    expect(find.text('page /my-pay'), findsOneWidget);
  });
}
