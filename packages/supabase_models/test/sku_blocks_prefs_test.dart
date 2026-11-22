import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

// flutter test test/sku_blocks_prefs_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('skuBlocks', () {
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

    // Without it the reserved SKU numbers are never kept, and every save
    // offline would come out as SKU pending.
    test('is writable', () async {
      const value = '{"biz-1":{"next":64,"end":113}}';
      await box.writeString(key: 'skuBlocks', value: value);
      expect(
        box.readString(key: 'skuBlocks'),
        value,
        reason: 'skuBlocks is missing from the LocalStorage allowlist',
      );
    });
  });

  group('skuBlocks stays on this device', () {
    Map<String, dynamic> prefs(Map<String, dynamic> extra) => {
          '_preferencesVersion': 1,
          'dbVersion': 1,
          ...extra,
        };

    // The numbers were reserved for this device. Taking another device's
    // copy from Ditto would hand the same numbers out twice.
    test('the local file wins over the Ditto copy', () {
      const mine = '{"biz":{"next":10,"end":59}}';
      const theirs = '{"biz":{"next":200,"end":249}}';
      for (final dittoVersion in [1, 999]) {
        final merged = SharedPreferenceStorage.mergeDittoPreferences(
          legacy: prefs({'skuBlocks': mine}),
          dittoMap: {
            ...prefs({'skuBlocks': theirs}),
            '_preferencesVersion': dittoVersion,
          },
        );
        expect(merged['skuBlocks'], mine, reason: 'v$dittoVersion');
      }
    });

    test('is never copied to Ditto', () {
      final payload = SharedPreferenceStorage.dittoMirrorPayload({
        'skuBlocks': '{"biz":{"next":1,"end":50}}',
        'staff_roster_biz': 'hashed',
        'branchId': 'branch-1',
      });
      expect(payload, {'branchId': 'branch-1'});
    });

    test('a Ditto copy is never adopted when this device has none', () {
      final merged = SharedPreferenceStorage.mergeDittoPreferences(
        legacy: prefs({}),
        dittoMap: prefs({'skuBlocks': '{"biz":{"next":1,"end":50}}'}),
      );
      expect(merged.containsKey('skuBlocks'), isFalse);
    });
  });
}
