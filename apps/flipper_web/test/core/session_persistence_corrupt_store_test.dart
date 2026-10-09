import 'package:flipper_web/core/business_selection_persistence.dart';
import 'package:flipper_web/core/session_persistence.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

/// Mirrors shared_preferences_windows reading a NUL-filled prefs file.
class _CorruptStore extends SharedPreferencesStorePlatform {
  Never _fail() => throw const FormatException(
    'Unexpected character (at character 1)',
    '\u0000\u0000\u0000',
    0,
  );

  @override
  Future<Map<String, Object>> getAll() async => _fail();

  @override
  Future<bool> clear() async => _fail();

  @override
  Future<bool> remove(String key) async => _fail();

  @override
  Future<bool> setValue(String valueType, String key, Object value) async =>
      _fail();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.resetStatic();
    SharedPreferencesStorePlatform.instance = _CorruptStore();
  });

  tearDown(() {
    SharedPreferences.resetStatic();
    SharedPreferences.setMockInitialValues({});
  });

  test(
    'a store that fails to decode reads as empty instead of throwing',
    () async {
      expect(await SessionPersistence.readApiUserId(), isNull);
      expect(await SessionPersistence.readLoginKey(), isNull);
      expect(
        await BusinessSelectionPersistence.readForUserIds(['u1', 'u2']),
        isNull,
      );
    },
  );

  test('saves and clears are no-ops on a store that fails to decode', () async {
    await SessionPersistence.save(apiUserId: 'u1', loginKey: 'k');
    await SessionPersistence.clear();
    await BusinessSelectionPersistence.save(
      userId: 'u1',
      businessId: 'b1',
      branchId: 'br1',
    );
    await BusinessSelectionPersistence.clear();
  });

  test('a healthy store still round-trips the selection', () async {
    SharedPreferences.setMockInitialValues({});
    await BusinessSelectionPersistence.save(
      userId: 'u1',
      businessId: 'b1',
      branchId: 'br1',
    );
    final result = await BusinessSelectionPersistence.readForUserIds(['u1']);
    expect(result?.businessId, 'b1');
    expect(result?.branchId, 'br1');
  });
}
