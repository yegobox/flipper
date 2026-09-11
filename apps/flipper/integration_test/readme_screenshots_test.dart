// Captures the screenshots that feed the README hero image.
//
// Runs the real desktop app, signs in to the demo business, walks the main
// screens and writes one PNG per screen. Plain `integration_test` only — no
// Patrol, no driver — so it runs with the same command CI already uses for
// the Windows smoke test:
//
//   cd apps/flipper
//   flutter test -d windows integration_test/readme_screenshots_test.dart \
//       --dart-define=FLUTTER_TEST_ENV=false \
//       --dart-define=FLIPPER_DEVICE_PREVIEW=false \
//       --dart-define=SCREENSHOT_DIR=/abs/path/to/out \
//       --dart-define=DEMO_PIN=157307 \
//       --dart-define=DEMO_OTP=725155
//
// (`-d macos` works the same way for a local run.)
//
// Why not `binding.takeScreenshot`? The integration_test plugin only
// implements `captureScreenshot` for Android, iOS and web; on desktop it
// throws MissingPluginException. Rasterising the root RenderView's layer is
// the path `matchesGoldenFile` already relies on and works everywhere the app
// renders, so that is what `_shoot` does.
//
// Compose the PNGs into the hero with scripts/screenshots/compose_readme_hero.py.

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flipper_login/login_semantics.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_rw/main.dart' as app_main;
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stacked/stacked.dart' show PageRouteInfo;
import 'package:stacked_services/stacked_services.dart';

const _outDir = String.fromEnvironment(
  'SCREENSHOT_DIR',
  defaultValue: 'readme_screenshots',
);
const _demoPin = String.fromEnvironment('DEMO_PIN', defaultValue: '157307');
const _demoOtp = String.fromEnvironment('DEMO_OTP', defaultValue: '725155');

/// Screens shot after sign-in, in README order. Navigation goes through the
/// same [RouterService] the dashboard's app grid uses
/// (see dashboard_quick_apps_navigation.dart), which is far more stable than
/// tapping tiles whose layout changes with every redesign.
final _screens = <String, PageRouteInfo?>{
  '02_dashboard': null, // wherever sign-in lands
  '03_pos': CheckOutRoute(isBigScreen: true),
  '04_transactions': TransactionsRoute(),
  '05_cashbook': CashbookRoute(isBigScreen: true),
  '06_customers': CustomersRoute(),
};

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture README screenshots', (tester) async {
    final out = Directory(_outDir)..createSync(recursive: true);
    debugPrint('[readme-screenshots] writing to ${out.absolute.path}');

    await app_main.main();
    // Not pumpAndSettle: the sign-in screen animates continuously, so it
    // would never settle and would burn its 10-minute default timeout.
    await tester.pump(const Duration(seconds: 5));

    // ── Sign in ─────────────────────────────────────────────────────────
    // Three possible first screens, all leading to the PIN screen:
    //  * desktop-width window → QR login (DesktopLoginView) with a
    //    "Switch to PIN login" button;
    //  * compact window, fresh install → landing page with "Sign in";
    //  * compact window, seen a login before → PIN screen directly.
    final pinScreen = find.byKey(const Key(LoginMaestroIds.pinScreen));
    final desktopPinSwitch = find.byKey(const Key('pinLogin_desktop'));
    final landingSignIn = find.byKey(const Key(LoginMaestroIds.landingSignIn));
    await _waitForAny(tester, [pinScreen, desktopPinSwitch, landingSignIn]);
    if (pinScreen.evaluate().isEmpty) {
      await _tap(
        tester,
        desktopPinSwitch.evaluate().isNotEmpty ? desktopPinSwitch : landingSignIn,
      );
      await _waitFor(tester, pinScreen);
    }
    await _settle(tester);
    await _shoot(tester, out, '01_sign_in');

    // Six digits auto-submit the PIN (see _onPinTextChanged in pin_login.dart)
    // and reveal the OTP step, which defaults to Authenticator.
    await tester.enterText(
      find.byKey(const Key(LoginMaestroIds.pinField)),
      _demoPin,
    );
    await _waitFor(
      tester,
      find.byKey(const Key(LoginMaestroIds.otpField)),
      timeout: const Duration(seconds: 60),
    );

    // The demo account is verified with a fixed SMS code, so switch to SMS —
    // this also triggers the OTP request — then submit the code.
    await _tap(tester, find.byKey(const Key(LoginMaestroIds.authSms)));
    await tester.pump(const Duration(seconds: 2));
    await tester.enterText(
      find.byKey(const Key(LoginMaestroIds.otpField)),
      _demoOtp,
    );
    await _tap(tester, find.byKey(const Key(LoginMaestroIds.pinSubmit)));

    // ── Business / branch choice, if the demo account has more than one ──
    final mainApp = find.byKey(const Key('mainApp'));
    await _waitForAny(
      tester,
      [mainApp, find.text('Choose a business'), find.text('Choose a branch')],
      timeout: const Duration(seconds: 90),
    );
    if (find.text('Choose a business').evaluate().isNotEmpty) {
      await _tap(tester, _byTypeName('_BusinessChoiceTile').first);
      await _waitForAny(
        tester,
        [mainApp, find.text('Choose a branch')],
        timeout: const Duration(seconds: 60),
      );
    }
    if (find.text('Choose a branch').evaluate().isNotEmpty) {
      // First branch is preselected; the gradient button continues.
      await _tap(tester, _byTypeName('FlipperGradientButton').first);
    }
    await _waitFor(tester, mainApp, timeout: const Duration(seconds: 90));

    // ── Screens ─────────────────────────────────────────────────────────
    final router = locator<RouterService>();
    for (final entry in _screens.entries) {
      if (entry.value != null) {
        unawaited(router.navigateTo(entry.value!));
      }
      // Give Ditto observers a moment to fill lists before the shot.
      await tester.pump(const Duration(seconds: 3));
      await _settle(tester);
      await _shoot(tester, out, entry.key);
    }
  }, timeout: const Timeout(Duration(minutes: 15)));
}

/// Rasterises the whole window at physical resolution and writes a PNG.
Future<void> _shoot(WidgetTester tester, Directory out, String name) async {
  final view = tester.binding.renderViews.first;
  // debugLayer is populated in debug builds, which is what `flutter test -d`
  // produces.
  final layer = view.debugLayer! as OffsetLayer;
  // The RenderView's TransformLayer bakes the device pixel ratio into the
  // scene, so ask for bounds in physical pixels at ratio 1 to get an exact
  // full-window image on both 100% and HiDPI displays.
  final dpr = view.flutterView.devicePixelRatio;
  final bounds = Offset.zero & (view.size * dpr);
  final image = await layer.toImage(bounds);
  final size = '${image.width}x${image.height}';
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  final file = File('${out.path}${Platform.pathSeparator}$name.png');
  file.writeAsBytesSync(bytes!.buffer.asUint8List());
  debugPrint('[readme-screenshots] ${file.path} ($size)');
}

/// Scrolls the target into view, then taps it — and fails loudly if the tap
/// would not land (off-screen, obscured). On the runner's small display the
/// sign-in form's submit button sits below the fold once the OTP field opens,
/// and a silently missed tap costs a full timeout to diagnose.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 300));
  final center = tester.getCenter(finder);
  final hit = tester.hitTestOnBinding(center);
  final target = tester.renderObject(finder);
  final landed = hit.path.any((e) => e.target == target ||
      (e.target is RenderObject &&
          _isDescendant(e.target as RenderObject, target)));
  if (!landed) {
    throw TestFailure(
      'Tap on ${finder.describeMatch(Plurality.one)} at $center would not '
      'reach the widget (window ${tester.binding.renderViews.first.size}).',
    );
  }
  await tester.tap(finder);
}

bool _isDescendant(RenderObject node, RenderObject ancestor) {
  RenderObject? cur = node;
  while (cur != null) {
    if (identical(cur, ancestor)) return true;
    cur = cur.parent;
  }
  return false;
}

/// pumpAndSettle that gives up quietly — live streams (Ditto observers,
/// spinners) can keep the tree "unsettled" forever.
Future<void> _settle(WidgetTester tester) async {
  try {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 5),
    );
  } on FlutterError {
    // still animating — fine for a screenshot
  }
}

Future<void> _waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) =>
    _waitForAny(tester, [finder], timeout: timeout);

Future<void> _waitForAny(
  WidgetTester tester,
  List<Finder> finders, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finders.any((f) => f.evaluate().isNotEmpty)) return;
  }
  throw TestFailure(
    'Timed out after $timeout waiting for any of: '
    '${finders.map((f) => f.describeMatch(Plurality.one)).join(', ')}',
  );
}

/// Finds widgets by runtime type name — lets the test reach private
/// widgets (`_BusinessChoiceTile`) without exporting them.
Finder _byTypeName(String name) =>
    find.byWidgetPredicate((w) => w.runtimeType.toString() == name);
