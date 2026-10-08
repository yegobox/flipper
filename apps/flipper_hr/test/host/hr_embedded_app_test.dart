import 'package:flipper_hr/features/billing/presentation/hr_billing_gate.dart';
import 'package:flipper_hr/features/host/hr_host.dart';
import 'package:flipper_hr/flipper_hr.dart';
import 'package:flipper_hr/router/hr_router.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/fake_hr_billing_repository.dart';

Iterable<String> _paths(List<RouteBase> routes) sync* {
  for (final route in routes) {
    if (route is GoRoute) yield route.path;
    yield* _paths(route.routes);
  }
}

Widget _app({required Widget home, List overrides = const []}) {
  return ProviderScope(
    overrides: [...overrides],
    child: MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: home,
    ),
  );
}

/// Stands in for the dashboard: pushes HR the way More → Apps does.
class _Launcher extends StatelessWidget {
  const _Launcher({required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (route) => HrEmbeddedApp(
              onExit: () => Navigator.of(route).pop(),
              onUpgrade: onUpgrade,
            ),
          ),
        ),
        child: const Text('open HR'),
      ),
    );
  }
}

void main() {
  test('the embedded router has no sign-in, picker or subscribe route', () {
    final router = buildEmbeddedHrRouter();
    addTearDown(router.dispose);

    final paths = _paths(router.configuration.routes).toList();

    expect(paths, containsAll(['/', '/overview', '/people', '/leave']));
    expect(paths, isNot(contains('/login')));
    expect(paths, isNot(contains('/signup')));
    expect(paths, isNot(contains('/business-selection')));
    expect(paths, isNot(contains('/subscribe')));
  });

  group('HrEmbeddedApp', () {
    final signedOut = authStateProvider.overrideWith(
      (ref) => Stream.value(AuthState.unauthenticated),
    );

    testWidgets('without a session it explains and offers the way back', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          home: _Launcher(onUpgrade: () {}),
          overrides: [signedOut],
        ),
      );
      await tester.tap(find.text('open HR'));
      await tester.pumpAndSettle();

      // No PIN screen: the host owns sign-in.
      expect(
        find.text('HR needs an internet connection. Connect and try again.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Back to Flipper'));
      await tester.pumpAndSettle();
      expect(find.text('open HR'), findsOneWidget);
    });

    testWidgets('system back at HR root returns to the host', (tester) async {
      await tester.pumpWidget(
        _app(
          home: _Launcher(onUpgrade: () {}),
          overrides: [signedOut],
        ),
      );
      await tester.tap(find.text('open HR'));
      await tester.pumpAndSettle();
      expect(find.text('open HR'), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('open HR'), findsOneWidget);
    });
  });

  group('HrPaywallPanel when embedded', () {
    testWidgets('control: on web the same state offers a skip', (tester) async {
      await tester.pumpWidget(
        _app(
          home: Scaffold(
            body: HrPaywallPanel(access: unpaidState(), businessId: 'biz-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('hr-skip-payment')), findsOneWidget);
    });

    testWidgets('sells the host plan and offers no skip', (tester) async {
      var upgrades = 0;
      await tester.pumpWidget(
        _app(
          overrides: [
            hrHostProvider.overrideWithValue(
              HrHost.embedded(onExit: () {}, onUpgrade: () => upgrades++),
            ),
          ],
          home: Scaffold(
            body: HrPaywallPanel(access: unpaidState(), businessId: 'biz-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('hr-paywall-subscribe')));
      await tester.pumpAndSettle();

      expect(upgrades, 1);
      expect(find.byKey(const Key('hr-skip-payment')), findsNothing);
    });
  });
}
