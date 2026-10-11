import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/module_launcher/all_apps_catalog.dart';
import 'package:flipper_web/features/module_launcher/all_apps_sheet.dart';
import 'package:flipper_web/features/module_launcher/app_launcher_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget _launcherButton() => Builder(
  builder: (context) => TextButton(
    onPressed: () => AllAppsSheet.open(context),
    child: const Text('open launcher'),
  ),
);

Future<void> _pumpRouter(WidgetTester tester) async {
  final router = GoRouter(
    initialLocation: '/accounting',
    routes: [
      GoRoute(
        path: '/accounting',
        builder: (_, _) => Scaffold(body: _launcherButton()),
      ),
      GoRoute(
        path: '/pos',
        builder: (_, _) => const Scaffold(body: Text('POS page')),
      ),
    ],
  );
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('launcher tiles that exist on the web map to their routes', () {
    expect(webAppRouteFor('Accounting'), '/accounting');
    expect(webAppRouteFor('POS'), '/pos');
    expect(webAppRouteFor('Inventory'), isNull);
  });

  testWidgets('the POS tile opens /pos', (tester) async {
    await _pumpRouter(tester);

    await tester.tap(find.text('open launcher'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quick Sell'));
    await tester.pumpAndSettle();

    expect(find.text('POS page'), findsOneWidget);
  });

  testWidgets('apps not on the web yet still say coming soon', (tester) async {
    await _pumpRouter(tester);

    await tester.tap(find.text('open launcher'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inventory'));
    await tester.pump();

    expect(find.text('POS page'), findsNothing);
    expect(find.textContaining('coming soon'), findsOneWidget);
  });

  testWidgets('inside the native app the host launcher opens instead', (
    tester,
  ) async {
    var hostOpened = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: AppLauncherHost(
          onOpenLauncher: () => hostOpened++,
          child: Scaffold(body: _launcherButton()),
        ),
      ),
    );

    await tester.tap(find.text('open launcher'));
    await tester.pumpAndSettle();

    expect(hostOpened, 1);
    expect(find.text('Quick Sell'), findsNothing);
  });
}
