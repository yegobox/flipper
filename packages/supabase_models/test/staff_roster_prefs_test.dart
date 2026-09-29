import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

// flutter test test/staff_roster_prefs_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('offline staff roster keys', () {
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

    // The roster is keyed per business, so it cannot sit in the fixed
    // allowlist; without the prefix rule every write silently no-ops and an
    // offline start shows "No staff yet".
    test('staff_roster_<businessId> is writable', () async {
      const key = 'staff_roster_42';
      const value = '{"v":2,"tenants":[]}';
      expect(box.readString(key: key), isNull, reason: 'cleared box');
      await box.writeString(key: key, value: value);
      expect(
        box.readString(key: key),
        value,
        reason:
            'staff_roster_ prefix is missing from the LocalStorage allowlist',
      );
    });

    test('an unrelated unlisted key is still rejected', () async {
      await box.writeString(key: 'not_an_allowed_key', value: 'x');
      expect(box.readString(key: 'not_an_allowed_key'), isNull);
    });
  });
}
