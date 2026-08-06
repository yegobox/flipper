import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

// flutter test test/logout_session_prefs_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('logout clears the session', () {
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

    test('getUserId() is null afterwards (userIdString is cleared too)',
        () async {
      // `getUserId()` prefers userIdString over userId, so a logout that only
      // removed userId left the app looking signed in on the next launch.
      await box.writeString(key: 'userId', value: 'user-1');
      await box.writeString(key: 'userIdString', value: 'user-1');
      await box.writeString(key: 'businessId', value: 'biz-1');
      await box.writeString(key: 'branchId', value: 'branch-1');
      expect(box.getUserId(), 'user-1');

      await box.clearSessionKeys();

      expect(box.getUserId(), isNull);
      expect(box.readString(key: 'userIdString'), isNull);
      expect(box.getBusinessId(), isNull);
      expect(box.getBranchId(), isNull);
      expect(await box.authComplete(), isFalse);
    });

    test('keeps device-level preferences', () async {
      await box.writeString(key: 'userId', value: 'user-1');
      await box.writeString(key: 'encryptionKey', value: 'key-1');
      await box.writeString(key: 'thisDeviceId', value: 'device-1');
      await box.setDatabaseFilename('flipper_custom.sqlite');

      await box.clearSessionKeys();

      expect(box.encryptionKey(), 'key-1');
      expect(box.getThisDeviceId(), 'device-1');
      expect(box.getDatabaseFilename(), 'flipper_custom.sqlite');
    });
  });

  group('mergeDittoPreferences', () {
    test('a stale Ditto payload cannot resurrect a logged-out session', () {
      // Local JSON was cleared by logout; the Ditto copy never got the update
      // (app killed before the background flush).
      final legacy = <String, dynamic>{
        '_preferencesVersion': 45,
        'dbVersion': 45,
        'sessionClearedAt': 2000,
        'encryptionKey': 'key-1',
      };
      final dittoMap = <String, dynamic>{
        '_preferencesVersion': 45,
        'dbVersion': 45,
        'userId': 'user-1',
        'userIdString': 'user-1',
        'businessId': 'biz-1',
        'branchId': 'branch-1',
        'authComplete': true,
      };

      final merged = SharedPreferenceStorage.mergeDittoPreferences(
        legacy: legacy,
        dittoMap: dittoMap,
      );

      expect(merged['userId'], isNull);
      expect(merged['userIdString'], isNull);
      expect(merged['businessId'], isNull);
      expect(merged['branchId'], isNull);
      expect(merged['authComplete'], isNull);
      expect(merged['encryptionKey'], 'key-1');
    });

    test('still restores a session when no logout happened after the Ditto copy',
        () {
      final legacy = <String, dynamic>{
        '_preferencesVersion': 45,
        'dbVersion': 45,
        'sessionClearedAt': 1000,
      };
      final dittoMap = <String, dynamic>{
        '_preferencesVersion': 45,
        'dbVersion': 45,
        'sessionClearedAt': 1000,
        'userId': 'user-1',
        'userIdString': 'user-1',
        'businessId': 'biz-1',
      };

      final merged = SharedPreferenceStorage.mergeDittoPreferences(
        legacy: legacy,
        dittoMap: dittoMap,
      );

      expect(merged['userId'], 'user-1');
      expect(merged['businessId'], 'biz-1');
    });

    test('local session identity still wins over the Ditto copy', () {
      final legacy = <String, dynamic>{
        '_preferencesVersion': 45,
        'dbVersion': 45,
        'userId': 'user-current',
        'userIdString': 'user-current',
        'branchId': 'branch-current',
      };
      final dittoMap = <String, dynamic>{
        '_preferencesVersion': 45,
        'dbVersion': 45,
        'userId': 'user-previous',
        'userIdString': 'user-previous',
        'branchId': 'branch-previous',
      };

      final merged = SharedPreferenceStorage.mergeDittoPreferences(
        legacy: legacy,
        dittoMap: dittoMap,
      );

      expect(merged['userId'], 'user-current');
      expect(merged['userIdString'], 'user-current');
      expect(merged['branchId'], 'branch-current');
    });
  });
}
