import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

// flutter test test/account_mode_prefs_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('personal mode keys', () {
    late SharedPreferenceStorage box;

    setUp(() async {
      box = SharedPreferenceStorage();
      await box.initializePreferences();
      await box.clear();
    });

    tearDown(() async {
      await box.clear();
      box.dispose();
    });

    // Without these the personal signup would be forgotten before the server
    // hears of it, and a cold start would open the business app first.
    for (final (key, value) in [
      ('accountModes', '{"biz-1":"personal"}'),
      ('pendingAccountMode', 'personal'),
    ]) {
      test('$key is writable', () async {
        await box.writeString(key: key, value: value);
        expect(
          box.readString(key: key),
          value,
          reason: '$key is missing from the LocalStorage allowlist',
        );
        box.remove(key: key);
        expect(box.readString(key: key), isNull);
      });
    }
  });
}
