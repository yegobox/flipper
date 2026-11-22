import 'dart:convert';
import 'dart:io';

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

  // A cursor that never reached disk would hand the same SKU numbers out
  // again after a restart, so the allocator must hear about a failed write.
  group('a failed file write', () {
    late SharedPreferenceStorage box;
    late Directory dir;

    setUp(() async {
      box = SharedPreferenceStorage();
      await box.initializePreferences();
      dir = Directory.systemTemp.createTempSync('sku_prefs_');
      // Both the temp file and the direct-write fallback hit a directory.
      final blocked = '${dir.path}/prefs.json';
      Directory(blocked).createSync();
      Directory('$blocked.tmp').createSync();
      box.debugFilePath = blocked;
    });

    tearDown(() {
      box.dispose();
      dir.deleteSync(recursive: true);
    });

    test('throws for skuBlocks', () async {
      await expectLater(
        box.writeString(key: 'skuBlocks', value: '{"biz":{"next":5}}'),
        throwsA(isA<FileSystemException>()),
      );
    });

    test('is only logged for other keys', () async {
      await box.writeString(key: 'branchId', value: 'branch-1');
      expect(box.readString(key: 'branchId'), 'branch-1');
    });
  });

  // Overlapping saves share the `.tmp` file; an older save must never land
  // after a newer SKU cursor.
  group('overlapping saves', () {
    late SharedPreferenceStorage box;
    late Directory dir;
    late String path;

    setUp(() async {
      box = SharedPreferenceStorage();
      await box.initializePreferences();
      dir = Directory.systemTemp.createTempSync('sku_prefs_queue_');
      path = '${dir.path}/prefs.json';
      box.debugFilePath = path;
    });

    tearDown(() {
      box.dispose();
      dir.deleteSync(recursive: true);
    });

    test('the file ends with the latest cursor', () async {
      await Future.wait([
        box.writeString(key: 'branchId', value: 'branch-1'),
        box.writeString(key: 'skuBlocks', value: '{"biz":{"next":5}}'),
        box.writeString(key: 'branchId', value: 'branch-2'),
        box.writeString(key: 'skuBlocks', value: '{"biz":{"next":9}}'),
      ]);
      final saved = jsonDecode(File(path).readAsStringSync()) as Map;
      expect(saved['skuBlocks'], '{"biz":{"next":9}}');
      expect(saved['branchId'], 'branch-2');
    });

    test('a failed save does not block the ones after it', () async {
      final blocked = '${dir.path}/blocked.json';
      Directory(blocked).createSync();
      Directory('$blocked.tmp').createSync();
      box.debugFilePath = blocked;
      await expectLater(
        box.writeString(key: 'skuBlocks', value: '{"biz":{"next":5}}'),
        throwsA(isA<FileSystemException>()),
      );

      box.debugFilePath = path;
      await box.writeString(key: 'skuBlocks', value: '{"biz":{"next":6}}');
      final saved = jsonDecode(File(path).readAsStringSync()) as Map;
      expect(saved['skuBlocks'], '{"biz":{"next":6}}');
    });
  });

  test('the Ditto copy is built before Ditto is open', () async {
    // No Ditto store in tests: the attach still builds the mirror payload
    // (skuBlocks left out) and keeps the local value.
    final box = SharedPreferenceStorage();
    await box.initializePreferences();
    await box.writeString(key: 'skuBlocks', value: '{"biz":{"next":7}}');
    await box.attachDittoPersistence(readDitto: () async => null);
    expect(box.readString(key: 'skuBlocks'), '{"biz":{"next":7}}');
    await box.clear();
    box.dispose();
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
