import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Whether this app runs on a Firebase Test Lab device, which is where
/// Google Play's pre-launch reports run.
///
/// Those robots install Flipper and open it a few times, never signing in.
/// They were ~2,200 of the ~2,300 Android "users" PostHog saw in a month, so
/// analytics stays off on them. Android only (the app's `rw.flipper/device_env`
/// channel reads the `firebase.test.lab` system setting); everywhere else,
/// and on any error or delay, the answer is false: a real till must never be
/// dropped from analytics by mistake.
Future<bool> isFirebaseTestLab({
  @visibleForTesting
  MethodChannel channel = const MethodChannel('rw.flipper/device_env'),
  @visibleForTesting bool? isAndroid,
  @visibleForTesting Duration timeout = const Duration(seconds: 2),
}) async {
  final android =
      isAndroid ?? (!kIsWeb && defaultTargetPlatform == TargetPlatform.android);
  if (!android) return false;
  try {
    final result = await channel
        .invokeMethod<bool>('isTestLab')
        .timeout(timeout);
    return result ?? false;
  } catch (_) {
    return false;
  }
}
