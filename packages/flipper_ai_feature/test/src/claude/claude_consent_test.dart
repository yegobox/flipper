import 'package:flipper_ai_feature/src/claude/claude_consent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('consent starts ungranted and persists once granted', () async {
    expect(await ClaudeConsent.isGranted(), isFalse);

    await ClaudeConsent.grant();

    expect(await ClaudeConsent.isGranted(), isTrue);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('flo_claude_cli_consent_v1'), isTrue);
  });

  test('an earlier grant on this device is honoured', () async {
    SharedPreferences.setMockInitialValues({'flo_claude_cli_consent_v1': true});
    expect(await ClaudeConsent.isGranted(), isTrue);
  });
}
