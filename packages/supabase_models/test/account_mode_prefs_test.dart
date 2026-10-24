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

  group('personal mode keys stay with the local file', () {
    Map<String, dynamic> prefs(Map<String, dynamic> extra) => {
          '_preferencesVersion': 1,
          'dbVersion': 1,
          ...extra,
        };

    // The Ditto prefs copy is flushed in the background. One written before
    // a switch to personal still says business; when it won the merge, the
    // app went back to the business shell "after a while".
    test('an older Ditto copy never reverts the mode', () {
      const personal =
          '{"biz":{"mode":"personal","changedAt":"2026-10-23T09:00:00Z"}}';
      const business =
          '{"biz":{"mode":"business","changedAt":"2026-10-22T09:00:00Z"}}';
      for (final dittoVersion in [1, 999]) {
        final merged = SharedPreferenceStorage.mergeDittoPreferences(
          legacy: prefs({'accountModes': personal}),
          dittoMap: {
            ...prefs({'accountModes': business}),
            '_preferencesVersion': dittoVersion,
          },
        );
        expect(merged['accountModes'], personal, reason: 'v$dittoVersion');
      }
    });

    test('a pending personal signup is neither lost nor resurrected', () {
      expect(
        SharedPreferenceStorage.mergeDittoPreferences(
          legacy: prefs({'pendingAccountMode': 'personal'}),
          dittoMap: prefs({}),
        )['pendingAccountMode'],
        'personal',
      );
      expect(
        SharedPreferenceStorage.mergeDittoPreferences(
          legacy: prefs({}),
          dittoMap: prefs({'pendingAccountMode': 'personal'}),
        ).containsKey('pendingAccountMode'),
        isFalse,
      );
    });
  });
}
