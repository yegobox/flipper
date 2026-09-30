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
// maximized. Deliberately does not boot the full app (no secrets, Ditto or DB).
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
    },
    skip: !isDesktop,
  );
}
