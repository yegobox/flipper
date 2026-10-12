import 'package:flipper_web/features/home/home_screen.dart';
import 'package:flipper_web/features/home/sections/books_home_sections.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flipper_web/features/home/widgets/books_theme_toggle.dart';
import 'package:flipper_web/features/login/theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The landing page's motion and pointer paths: hover inversion, the running
/// marquee, reveal-on-scroll, and the taps that route away from the page.
/// The section tests pump with reduced motion, which skips all of these.
void main() {
  setUp(() {
    // Fire visibility callbacks in the frame rather than on a timer.
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    BooksHomeTheme.of(Brightness.light);
  });

  Widget app(Widget child, {bool still = false}) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        size: const Size(1200, 900),
        disableAnimations: still,
      ),
      child: Scaffold(body: child),
    ),
  );

  Future<TestGesture> mouse(WidgetTester tester) async {
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    return gesture;
  }

  Color? colorOf(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style?.color;

  group('hover', () {
    testWidgets('an index cell inverts under the pointer and back', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          const Center(
            child: SizedBox(
              width: 360,
              child: IndexCell(number: '01', title: 'Ledger', body: 'Body'),
            ),
          ),
        ),
      );
      expect(colorOf(tester, 'Ledger'), AppColors.ink);

      final pointer = await mouse(tester);
      await pointer.moveTo(tester.getCenter(find.text('Ledger')));
      await tester.pumpAndSettle();
      expect(colorOf(tester, 'Ledger'), AppColors.invertFg);

      await pointer.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(colorOf(tester, 'Ledger'), AppColors.ink);
    });

    testWidgets('a line button fills on hover, on the page and on a panel', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LineButton(label: 'Page', onTap: () {}),
              LineButton(label: 'Panel', onTap: () {}, onInverse: true),
              InkButton(label: 'White', onTap: () {}, onInverse: true),
              InkButton(label: 'Off', onTap: null),
            ],
          ),
        ),
      );
      Color? fill(String label) =>
          (tester
                      .widget<AnimatedContainer>(
                        find
                            .ancestor(
                              of: find.text(label),
                              matching: find.byType(AnimatedContainer),
                            )
                            .first,
                      )
                      .decoration
                  as BoxDecoration?)
              ?.color;

      expect(colorOf(tester, 'Page'), AppColors.ink);
      expect(colorOf(tester, 'Panel'), AppGrad.onPanel);
      expect(colorOf(tester, 'White'), AppColors.accentInk);
      expect(colorOf(tester, 'Off'), AppColors.faint);
      expect(fill('Page')!.a, 0);

      final pointer = await mouse(tester);
      await pointer.moveTo(tester.getCenter(find.text('Page')));
      await tester.pumpAndSettle();
      expect(fill('Page'), AppColors.bgRaised);

      await pointer.moveTo(tester.getCenter(find.text('Panel')));
      await tester.pumpAndSettle();
      expect(fill('Page')!.a, 0);
      expect(fill('Panel')!.a, greaterThan(0));
    });

    testWidgets('a nav link brightens on hover', (tester) async {
      await tester.pumpWidget(
        app(
          Center(
            child: NavTextLink(label: 'Pricing', onTap: () {}),
          ),
        ),
      );
      expect(colorOf(tester, 'PRICING'), AppColors.muted);

      final pointer = await mouse(tester);
      await pointer.moveTo(tester.getCenter(find.text('PRICING')));
      await tester.pumpAndSettle();
      expect(colorOf(tester, 'PRICING'), AppColors.ink);
    });
  });

  testWidgets('a press dragged off the button does not fire it', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      app(
        Center(
          child: InkButton(label: 'Go', onTap: () => taps++),
        ),
      ),
    );

    final press = await tester.startGesture(tester.getCenter(find.text('Go')));
    await tester.pump();
    await press.moveBy(const Offset(0, 300));
    await press.up();
    await tester.pumpAndSettle();
    expect(taps, 0);

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  group('wordmark', () {
    FlipperMark mark(WidgetTester tester) => tester.widget<FlipperMark>(
      find.descendant(
        of: find.byType(UnfoldingWordmark),
        matching: find.byType(FlipperMark),
      ),
    );
    double markLeft(WidgetTester tester) =>
        tester.getTopLeft(find.byType(FlipperMark)).dx;

    testWidgets('draws the ring, then unfolds the word out of it', (
      tester,
    ) async {
      await tester.pumpWidget(app(const UnfoldingWordmark()));
      expect(mark(tester).progress, 0);
      final centred = markLeft(tester);

      // Mid-draw, still centred: the word has not started.
      await tester.pump(const Duration(milliseconds: 200));
      expect(mark(tester).progress, inInclusiveRange(0.2, 0.9));
      expect(markLeft(tester), centred);

      await tester.pumpAndSettle();
      expect(mark(tester).progress, 1);
      expect(markLeft(tester), lessThan(centred));
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('starts formed under reduced motion', (tester) async {
      await tester.pumpWidget(app(const UnfoldingWordmark(), still: true));
      expect(mark(tester).progress, 1);
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('the loader keeps drawing the mark', (tester) async {
      await tester.pumpWidget(app(const Center(child: FlipperMarkLoader())));
      await tester.pump(const Duration(milliseconds: 400));
      final early = tester.widget<FlipperMark>(find.byType(FlipperMark));
      expect(early.progress, inExclusiveRange(0, 1));
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('rotating headline', () {
    const lines = [('One', 'first.'), ('Two', 'second.'), ('Three', 'third.')];
    Finder showing(int i) => find.byKey(ValueKey(i));

    testWidgets('flips through every line and back', (tester) async {
      await tester.pumpWidget(
        app(const RotatingHeadline(lines: lines, size: 40)),
      );
      expect(showing(0), findsOneWidget);

      // Each flip: the hold elapses, then the switch animates to rest
      // (well inside the next hold, so settling stops there).
      Future<void> nextLine() async {
        await tester.pump(const Duration(milliseconds: 2600));
        await tester.pumpAndSettle();
      }

      await nextLine();
      expect(showing(1), findsOneWidget);
      expect(showing(0), findsNothing);

      await nextLine();
      await nextLine();
      expect(showing(0), findsOneWidget);

      // Disposing stops the clock (no pending timer).
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('holds the first line under reduced motion', (tester) async {
      await tester.pumpWidget(
        app(const RotatingHeadline(lines: lines, size: 40), still: true),
      );
      await tester.pump(const Duration(seconds: 10));
      expect(showing(0), findsOneWidget);
      expect(showing(1), findsNothing);
    });

    testWidgets('keeps the height of the tallest line', (tester) async {
      await tester.pumpWidget(
        app(
          const Center(
            child: SizedBox(
              width: 300,
              child: RotatingHeadline(
                lines: [
                  ('Short', 'one.'),
                  ('A much longer line that', 'has to wrap onto more lines.'),
                ],
                size: 30,
              ),
            ),
          ),
        ),
      );
      final first = tester.getSize(find.byType(RotatingHeadline));
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(RotatingHeadline)), first);
      await tester.pumpWidget(const SizedBox());
    });
  });

  group('marquee', () {
    Widget ticker({required bool still, List<String> items = const ['A']}) =>
        app(MarqueeTicker(items: items), still: still);

    testWidgets('scrolls on screen and stops for reduced motion', (
      tester,
    ) async {
      await tester.pumpWidget(ticker(still: false));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.hasRunningAnimations, isTrue);

      // A rebuild with new items swaps the delegate; still running.
      await tester.pumpWidget(ticker(still: false, items: const ['A', 'B']));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpWidget(ticker(still: true, items: const ['A', 'B']));
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('pauses once scrolled out of view', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        app(
          ListView(
            controller: controller,
            children: const [
              MarqueeTicker(items: ['A']),
              SizedBox(height: 3000),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.hasRunningAnimations, isTrue);

      controller.jumpTo(2000);
      await tester.pump();
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });
  });

  group('reveal', () {
    double opacityOf(WidgetTester tester, String text) => tester
        .widget<AnimatedOpacity>(
          find.ancestor(
            of: find.text(text),
            matching: find.byType(AnimatedOpacity),
          ),
        )
        .opacity;

    testWidgets('fades in what is on screen at first paint', (tester) async {
      await tester.pumpWidget(
        app(
          const Reveal(delay: Duration(milliseconds: 50), child: Text('Shown')),
        ),
      );
      expect(opacityOf(tester, 'Shown'), 0);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();
      expect(opacityOf(tester, 'Shown'), 1);
    });

    testWidgets('fades in what is scrolled to later', (tester) async {
      await tester.pumpWidget(
        app(
          // Not a ListView: it would not build the off-screen child at all.
          const SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 2000),
                Reveal(child: Text('Later')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(opacityOf(tester, 'Later'), 0);

      // Fully on screen: a sliver at the edge is under the 12% threshold.
      await tester.ensureVisible(find.text('Later'));
      // Lay out at the new offset, then do what BooksHomePage's scroll
      // listener does: a scroll alone does not re-run the detector.
      await tester.pump();
      VisibilityDetectorController.instance.notifyNow();
      await tester.pumpAndSettle();
      expect(opacityOf(tester, 'Later'), 1);
    });
  });

  testWidgets('scanlines repaint only when the palette changes', (
    tester,
  ) async {
    Widget scan(Brightness b) {
      BooksHomeTheme.of(b);
      // A fresh (non-const) widget per pump, as the hero builds it.
      return app(ScanlineBackground(child: SizedBox.expand(key: ValueKey(b))));
    }

    final painter = find.descendant(
      of: find.byType(ScanlineBackground),
      matching: find.byType(CustomPaint),
    );
    await tester.pumpWidget(scan(Brightness.light));
    final light = tester.widget<CustomPaint>(painter).painter!;
    await tester.pumpWidget(scan(Brightness.light));
    final again = tester.widget<CustomPaint>(painter).painter!;
    expect(again.shouldRepaint(light), isFalse);

    await tester.pumpWidget(scan(Brightness.dark));
    final dark = tester.widget<CustomPaint>(painter).painter!;
    expect(dark.shouldRepaint(light), isTrue);
    expect(AppColors.palette.isDark, isTrue);
    expect(AppColors.inkStrong, BooksPalette.dark.inkStrong);
  });

  testWidgets('the native section opens each store', (tester) async {
    tester.view.physicalSize = const Size(1200, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final opened = <Uri>[];
    await tester.pumpWidget(
      app(
        SingleChildScrollView(
          child: BooksHomeNativeSection(onOpenStore: opened.add),
        ),
        still: true,
      ),
    );

    await tester.tap(find.text('Get it on Google Play'));
    await tester.tap(find.text('Get it from Microsoft'));
    await tester.pumpAndSettle();
    expect(opened, [
      Uri.parse(booksHomePlayStoreUrl),
      Uri.parse(booksHomeMicrosoftStoreUrl),
    ]);
  });

  testWidgets('the theme toggle flips the app theme', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: app(const Center(child: BooksThemeToggle())),
      ),
    );
    expect(container.read(themeProvider), ThemeMode.light);

    await tester.tap(find.byType(BooksThemeToggle));
    await tester.pump();
    expect(container.read(themeProvider), ThemeMode.dark);
  });

  testWidgets('the compact menu routes its links and buttons', (tester) async {
    tester.view.physicalSize = const Size(700, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final navTaps = <String>[];
    var signIns = 0;
    var starts = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: BooksHomeHeader(
              onStartFree: () => starts++,
              onSignIn: () => signIns++,
              onNavTap: navTaps.add,
            ),
          ),
        ),
      ),
    );

    Future<void> openMenuAndTap(String label) async {
      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    await openMenuAndTap('PRICING');
    expect(navTaps, ['Pricing']);
    await openMenuAndTap('Log in');
    expect(signIns, 1);
    await openMenuAndTap('Start free');
    expect(starts, 1);
  });

  group('page', () {
    Future<void> pumpPage(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: const HomeScreen(),
            ),
          ),
          GoRoute(path: '/signup', builder: (_, _) => const Text('signup')),
          GoRoute(path: '/login', builder: (_, _) => const Text('login')),
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

    testWidgets('header nav scrolls to its section', (tester) async {
      await pumpPage(tester);
      final pricing = find.widgetWithText(SectionIndex, 'PRICING');
      final before = tester.getTopLeft(pricing).dy;

      await tester.tap(header('PRICING'));
      await tester.pumpAndSettle();
      final after = tester.getTopLeft(pricing).dy;
      expect(after, lessThan(before));
      expect(after, lessThan(1200));

      for (final link in ['PLATFORM', 'FLOW AI', 'FEATURES']) {
        await tester.tap(header(link));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('the nav marks the section in view', (tester) async {
      await pumpPage(tester);
      Color? navColor(String label) =>
          tester.widget<Text>(header(label)).style?.color;
      expect(navColor('BOOKS'), AppColors.invertFg);
      expect(navColor('PRICING'), isNot(AppColors.invertFg));

      await tester.tap(header('PRICING'));
      await tester.pumpAndSettle();
      expect(navColor('PRICING'), AppColors.invertFg);
      expect(navColor('BOOKS'), isNot(AppColors.invertFg));

      await tester.tap(find.byType(FlipperMark).first);
      await tester.pumpAndSettle();
      expect(navColor('BOOKS'), AppColors.invertFg);
    });

    testWidgets('start free goes to sign-up', (tester) async {
      await pumpPage(tester);
      await tester.tap(header('Start free'));
      await tester.pumpAndSettle();
      expect(find.text('signup'), findsOneWidget);
    });

    testWidgets('log in goes to sign-in', (tester) async {
      await pumpPage(tester);
      await tester.tap(header('Log in'));
      await tester.pumpAndSettle();
      expect(find.text('login'), findsOneWidget);
    });

    Future<void> tapInBody(WidgetTester tester, String label) async {
      final target = find.text(label).last;
      // Centre it so the pinned header does not take the tap.
      await tester.ensureVisible(target);
      await tester.pump();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    testWidgets('explore flow stays on the page', (tester) async {
      await pumpPage(tester);
      await tapInBody(tester, 'Explore Flow AI');
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('the closing call to action routes', (tester) async {
      await pumpPage(tester);
      await tapInBody(tester, 'Talk to sales');
      expect(find.text('login'), findsOneWidget);
    });

    testWidgets('the hero buttons route and scroll', (tester) async {
      await pumpPage(tester);
      final hero = find.byType(BooksHomeHero);
      await tester.tap(
        find.descendant(of: hero, matching: find.text('See how it works')),
      );
      await tester.pumpAndSettle();
      expect(
        tester.getTopLeft(find.widgetWithText(SectionIndex, 'ONE PLATFORM')).dy,
        lessThan(400),
      );

      await tester.drag(find.byType(CustomScrollView), const Offset(0, 3000));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(of: hero, matching: find.text('Start free')),
      );
      await tester.pumpAndSettle();
      expect(find.text('signup'), findsOneWidget);
    });
  });
}
