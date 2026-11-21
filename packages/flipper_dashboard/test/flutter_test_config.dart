import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs before every test file in this package.
///
/// Since Flutter 3.50, a `fontsChange` system message makes every attached
/// paragraph schedule a relayout frame callback. A font that finishes loading
/// in real time after a test's last pump (google_fonts, for one) leaves that
/// callback pending, and the test fails with "An animation is still running
/// even after the widget tree was disposed". These tests render with the test
/// font, so a late font change has nothing to relayout: drop it here and pass
/// every other system message to the binding as before.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  SystemChannels.system.setMessageHandler((Object? message) async {
    if (message is Map && message['type'] == 'fontsChange') return null;
    // ignore: invalid_use_of_protected_member
    await binding.handleSystemMessage(message!);
    return null;
  });
  await testMain();
}
