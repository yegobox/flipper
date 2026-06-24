import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

/// Android launcher pinned shortcuts via [MethodChannel].
///
/// Channel implementation: [apps/flipper/android/.../MainActivity.kt].
class AppShortcutsPlatform {
  AppShortcutsPlatform._();

  static const MethodChannel _channel =
      MethodChannel('rw.flipper/app_shortcuts');

  /// Whether the current launcher supports pinning shortcuts (Android O+).
  static Future<bool> isPinShortcutSupported() async {
    if (!UniversalPlatform.isAndroid) return false;
    try {
      final ok = await _channel.invokeMethod<bool>('isPinShortcutSupported');
      return ok ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Requests a pinned shortcut. Returns whether the OS accepted the request.
  /// The user still confirms in a system dialog when supported.
  static Future<PinShortcutResult> requestPinShortcut({
    required String id,
    required String label,
    required String page,
  }) async {
    if (!UniversalPlatform.isAndroid) {
      return PinShortcutResult(ok: false, reason: 'not_android');
    }
    try {
      final raw = await _channel.invokeMethod<dynamic>(
        'requestPinShortcut',
        <String, dynamic>{
          'id': id,
          'label': label,
          'page': page,
        },
      );
      if (raw is Map) {
        final ok = raw['ok'] == true;
        final reason = raw['reason']?.toString();
        return PinShortcutResult(ok: ok, reason: reason);
      }
      return PinShortcutResult(ok: false, reason: 'bad_response');
    } on PlatformException catch (e) {
      return PinShortcutResult(ok: false, reason: e.code);
    }
  }

  /// Pending shortcut page from the cold-start Activity intent (consumed once).
  static Future<String?> consumePendingShortcutPage() async {
    if (!UniversalPlatform.isAndroid) return null;
    try {
      return await _channel.invokeMethod<String>('consumePendingShortcutPage');
    } on PlatformException {
      return null;
    }
  }

  /// Listen for shortcuts opened while the Activity is already running (warm start).
  static void setShortcutLaunchListener(void Function(String page)? listener) {
    if (!UniversalPlatform.isAndroid) {
      _channel.setMethodCallHandler(null);
      return;
    }
    if (listener == null) {
      _channel.setMethodCallHandler(null);
      return;
    }
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onShortcutLaunched') {
        final args = call.arguments;
        String? page;
        if (args is Map) {
          page = args['page'] as String?;
        }
        if (page != null && page.isNotEmpty) {
          listener(page);
        }
      }
    });
  }
}

class PinShortcutResult {
  PinShortcutResult({required this.ok, this.reason});

  final bool ok;
  final String? reason;
}
