import 'package:flipper_dashboard/widgets/app_launch_overlay.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<void> pumpHost(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        home: const Scaffold(body: Text('behind the curtain')),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> showCurtain(WidgetTester tester) async {
    final shown = AppLaunchOverlay.show(
      navigator: navigatorKey.currentState!,
      appLabel: 'Reports',
      accent: const Color(0xFF534AB7),
      iconSvg: DashboardQuickAccessSvgs.appSwitcherReportsIcon(),
      contextLabel: 'Kigali Heights',
    );
    // Drain the fade-in without settling: the sweep bar loops forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await shown;
  }

  testWidgets('curtain names the app being opened and its branch', (
    tester,
  ) async {
    await pumpHost(tester);
    await showCurtain(tester);

    expect(AppLaunchOverlay.isVisible, isTrue);
    expect(find.text('Opening Reports'), findsOneWidget);
    expect(find.text('Kigali Heights'), findsOneWidget);

    // It covers the route below rather than replacing it, so the destination can
    // build behind it.
    expect(find.text('behind the curtain'), findsOneWidget);

    final dismissed = AppLaunchOverlay.dismiss();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
    await dismissed;

    expect(AppLaunchOverlay.isVisible, isFalse);
    expect(find.text('Opening Reports'), findsNothing);
  });

  testWidgets('dismissWhenSettled holds through the page transition', (
    tester,
  ) async {
    await pumpHost(tester);
    await showCurtain(tester);

    // Stand in for the login flow's authentication work, so the minimum-hold
    // floor is already satisfied and only the settle window is under test.
    await tester.pump(const Duration(seconds: 2));

    AppLaunchOverlay.dismissWhenSettled();

    // The destination route animates for 300ms with the page we came from still
    // painted underneath, so the curtain must survive that window — dropping it
    // on the next frame is what flashed the previous screen.
    await tester.pump();
    expect(AppLaunchOverlay.isVisible, isTrue);
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      AppLaunchOverlay.isVisible,
      isTrue,
      reason: 'lifted during the destination route transition',
    );

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 400));
    expect(AppLaunchOverlay.isVisible, isFalse);
  });

  testWidgets('survives a slow login hand-off without self-dismissing', (
    tester,
  ) async {
    await pumpHost(tester);
    await showCurtain(tester);

    // The login flow can spend ~20s before it navigates — completeDitto­After‑
    // LoginChoices is bounded at 15s on its own. A backstop that fires in that
    // window drops the curtain back onto the branch screen, and the app then
    // appears seconds later.
    await tester.pump(const Duration(seconds: 12));
    expect(
      AppLaunchOverlay.isVisible,
      isTrue,
      reason: 'self-dismissed while the hand-off was still in flight',
    );
    expect(find.textContaining('Syncing your business'), findsOneWidget);

    await tester.pump(const Duration(seconds: 10));
    expect(AppLaunchOverlay.isVisible, isTrue);

    final dismissed = AppLaunchOverlay.dismiss();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 400));
    await dismissed;
    expect(AppLaunchOverlay.isVisible, isFalse);
  });

  testWidgets('dismiss is a no-op when nothing is showing', (tester) async {
    await pumpHost(tester);

    expect(AppLaunchOverlay.isVisible, isFalse);
    await AppLaunchOverlay.dismiss();
    expect(AppLaunchOverlay.isVisible, isFalse);
  });

  testWidgets('suppressForTests keeps the curtain out of the tree', (
    tester,
  ) async {
    AppLaunchOverlay.suppressForTests = true;
    addTearDown(() => AppLaunchOverlay.suppressForTests = false);

    await pumpHost(tester);
    await AppLaunchOverlay.show(
      navigator: navigatorKey.currentState!,
      appLabel: 'POS',
      accent: const Color(0xFF185FA5),
      iconSvg: DashboardQuickAccessSvgs.appSwitcherPosIcon(),
    );
    await tester.pump();

    expect(AppLaunchOverlay.isVisible, isFalse);
    expect(find.text('Opening POS'), findsNothing);
  });
}
