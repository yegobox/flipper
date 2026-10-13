import 'package:flipper_web/features/apps/apps_screen.dart';
import 'package:flipper_web/features/apps/atlas_downloads.dart';
import 'package:flipper_web/features/home/home_screen.dart';
import 'package:flipper_web/features/home/sections/books_home_sections.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  late List<Uri> opened;

  setUp(() => opened = []);

  /// `/apps` (and `/`, `/login`) behind a real router, with motion off.
  Future<void> pumpApps(
    WidgetTester tester, {
    TargetPlatform platform = TargetPlatform.windows,
    Size size = const Size(1440, 2400),
    String at = '/apps',
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    Widget still(BuildContext context, Widget child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: child,
    );
    final router = GoRouter(
      initialLocation: at,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => still(context, const HomeScreen()),
        ),
        GoRoute(
          path: '/apps',
          builder: (context, _) => still(
            context,
            Theme(
              data: BooksHomeTheme.of(Brightness.light),
              child: AppsPage(onOpen: opened.add, platform: platform),
            ),
          ),
        ),
        GoRoute(path: '/login', builder: (_, _) => const Text('login')),
        GoRoute(path: '/signup', builder: (_, _) => const Text('signup')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pump();
  }

  Finder header(String label) => find.descendant(
    of: find.byType(BooksHomeHeader),
    matching: find.text(label),
  );

  Future<void> tapVisible(WidgetTester tester, Finder target) async {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    // Clear the pinned header.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  testWidgets('lays out the lineup, the download and where it runs', (
    tester,
  ) async {
    await pumpApps(tester);
    expect(tester.takeException(), isNull);

    expect(find.textContaining('One OS.'), findsOneWidget);
    expect(find.text('Download Atlas for Windows'), findsOneWidget);
    for (final app in [
      'Point of sale',
      'Accounting',
      'Flow AI',
      'Hotel',
      'Bar',
      'Kitchen display',
      'HR & payroll',
    ]) {
      expect(find.text(app), findsOneWidget, reason: app);
    }
    expect(find.text('INCLUDED IN FLIPPER OS'), findsOneWidget);
  });

  testWidgets('fits a phone without overflowing', (tester) async {
    await pumpApps(
      tester,
      platform: TargetPlatform.android,
      size: const Size(390, 6000),
    );
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
  });

  group('offers the installer for the computer it is open on', () {
    for (final (platform, label, url) in [
      (TargetPlatform.windows, 'Windows', AtlasDownloads.windows),
      (TargetPlatform.macOS, 'macOS', AtlasDownloads.macOS),
      (TargetPlatform.linux, 'Linux', AtlasDownloads.linuxAppImage),
    ]) {
      testWidgets(label, (tester) async {
        await pumpApps(tester, platform: platform);
        await tester.tap(find.text('Download Atlas for $label').first);
        await tester.pumpAndSettle();
        expect(opened, [Uri.parse(url)]);
      });
    }

    testWidgets('and the store on a phone', (tester) async {
      await pumpApps(tester, platform: TargetPlatform.android);
      expect(find.textContaining('Download Atlas for'), findsNothing);
      expect(find.text('On a phone? Get Flipper from the store.'), findsOne);

      await tester.tap(find.text('Get it on Google Play').first);
      await tester.pumpAndSettle();
      expect(opened, [Uri.parse(booksHomePlayStoreUrl)]);
    });
  });

  testWidgets('lists the other installers and every release', (tester) async {
    await pumpApps(tester, platform: TargetPlatform.windows);
    // Windows is the main button, so the row offers the rest.
    expect(find.widgetWithText(BooksHomeTextLink, 'WINDOWS'), findsNothing);
    await tester.tap(find.text('MACOS'));
    await tester.tap(find.text('LINUX .DEB'));
    await tester.tap(find.text('ALL RELEASES ON GITHUB'));
    await tester.pumpAndSettle();
    expect(opened, [
      Uri.parse(AtlasDownloads.macOS),
      Uri.parse(AtlasDownloads.linuxDeb),
      Uri.parse(AtlasDownloads.releases),
    ]);
  });

  testWidgets('where it runs: launcher, stores and the browser', (
    tester,
  ) async {
    await pumpApps(tester, platform: TargetPlatform.macOS);

    await tapVisible(tester, find.text('With the Atlas launcher'));
    await tapVisible(tester, find.text('Get it from Microsoft'));
    expect(opened, [
      Uri.parse(AtlasDownloads.macOS),
      Uri.parse(booksHomeMicrosoftStoreUrl),
    ]);

    await tapVisible(tester, find.text('Open in browser'));
    expect(find.text('login'), findsOneWidget);
  });

  testWidgets('the lineup ends with Atlas, which installs them all', (
    tester,
  ) async {
    await pumpApps(tester, platform: TargetPlatform.linux);
    // Main button + the lineup's last cell.
    expect(find.text('DOWNLOAD ATLAS FOR LINUX'), findsOneWidget);
    await tapVisible(tester, find.text('DOWNLOAD ATLAS FOR LINUX'));
    expect(opened, [Uri.parse(AtlasDownloads.linuxAppImage)]);
  });

  group('nav', () {
    Color? navColor(WidgetTester tester, String label) =>
        tester.widget<Text>(header(label)).style?.color;

    testWidgets('marks Apps and leads back home', (tester) async {
      await pumpApps(tester);
      expect(navColor(tester, 'APPS'), AppGrad.onPanel);

      await tester.tap(header('PRICING'));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('home leads to Apps', (tester) async {
      await pumpApps(tester, at: '/');
      await tester.tap(header('APPS'));
      await tester.pumpAndSettle();
      expect(find.byType(AppsPage), findsOneWidget);
    });

    testWidgets('the footer Download link leads to Apps', (tester) async {
      await pumpApps(tester, at: '/');
      await tapVisible(tester, find.text('Download'));
      expect(find.byType(AppsPage), findsOneWidget);
    });

    testWidgets('the native section points computers to Atlas', (tester) async {
      await pumpApps(tester, at: '/');
      await tapVisible(tester, find.text('ON A COMPUTER? DOWNLOAD ATLAS'));
      expect(find.byType(AppsPage), findsOneWidget);
    });
  });
}
