import 'package:shared_preferences/shared_preferences.dart';

/// One-time consent before business data is sent to Anthropic through the
/// user's own Claude account. Stored per device.
class ClaudeConsent {
  ClaudeConsent._();

  static const _key = 'flo_claude_cli_consent_v1';

  static Future<bool> isGranted() async =>
      (await SharedPreferences.getInstance()).getBool(_key) ?? false;

  static Future<void> grant() async =>
      (await SharedPreferences.getInstance()).setBool(_key, true);
}
