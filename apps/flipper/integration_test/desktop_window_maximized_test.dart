import 'dart:io';

import 'package:flipper_rw/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:window_manager/window_manager.dart';

// flutter test -d macos integration_test/desktop_window_maximized_test.dart
// flutter test -d windows integration_test/desktop_window_maximized_test.dart
//
// Checks the real OS window: after the same call main() makes, the window is
// maximized, and stays maximized once the first frame has been shown. (On
// Windows the runner's first-frame ShowWindow(SW_SHOWNORMAL) used to restore
// the window right after it was maximized, so a check that stopped at the first
// "maximized" passed while users got a small window with a black border.)
// Deliberately does not boot the full app (no secrets, Ditto or DB).
bool get isDesktop =>
    Platform.isWindows || Platform.isMacOS || Platform.isLinux;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'the desktop window opens maximized',
    (tester) async {
      await maximizeOnLaunch();
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Maximize is asynchronous on macOS (animated zoom), so poll briefly.
      var maximized = false;
      for (var i = 0; i < 20 && !maximized; i++) {
        await tester.pump(const Duration(milliseconds: 250));
        maximized = await windowManager.isMaximized();
      }

      expect(maximized, isTrue);

      // The runner shows the window from its native first-frame callback, so
      // completed pumps prove nothing: wait for the first frame to be
      // rasterized, then until the window is actually visible (Show() done),
      // and only then check nothing restored it.
      await tester.binding.waitUntilFirstFrameRasterized;
      var visible = false;
      for (var i = 0; i < 50 && !visible; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        visible = await windowManager.isVisible();
      }
      expect(visible, isTrue, reason: 'the runner never showed the window');
      expect(
        await windowManager.isMaximized(),
        isTrue,
        reason: 'the window was restored after the first frame',
      );
    },
    skip: !isDesktop,
  );
}
