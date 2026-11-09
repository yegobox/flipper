// Books' ledger sync and change feed against a real local Ditto store in
// DQL_STRICT_MODE, as production runs. `flutter test` has no Ditto native
// library, so the store tests skip unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/core/accounting_ledger_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/utils/local_store_indexes.dart';
import 'package:flipper_web/core/ditto/accounting_cloud_sync.dart';
import 'package:flipper_web/services/ditto_mixins/accounting_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/ditto_core_mixin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  _FakePaths(this.dir);
  final String dir;
  @override
  Future<String?> getApplicationDocumentsPath() async => dir;
  @override
  Future<String?> getApplicationSupportPath() async => dir;
  @override
  Future<String?> getTemporaryPath() async => dir;
}

/// The accounting store alone, without DittoService's sync setup.
class _AccountingStore extends DittoCore with AccountingMixin {}

const _biz = '89ed8709-172d-4524-bab8-5f9d31f98657';
const _other = '0b9c6c8e-1111-4222-8333-944455556666';

void main() {
  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;
  final skip = hasDitto
      ? false
      : 'set LIBDITTOFFI_PATH to run against a real Ditto store';

  group('accounting cloud subscriptions', () {
    test('journal lines sync only for this business', () {
      final specs = accountingCloudSubscriptionSpecs(
        businessId: _biz,
        branchId: 'br-1',
      );
      final journal = [
        for (final s in specs)
          if (s.sql.contains('FROM journal_')) s,
      ];
      expect(journal.map((s) => s.key), [
        'journal_entries|$_biz',
        'journal_lines|$_biz',
      ]);
      for (final s in journal) {
        expect(s.sql, contains('WHERE businessId = :businessId'));
        expect(s.args, {'businessId': _biz});
      }
    });

    test('no accounting subscription reads a whole collection', () {
      for (final s in accountingCloudSubscriptionSpecs(
        businessId: _biz,
        branchId: 'br-1',
      )) {
        expect(s.sql, contains(' WHERE '), reason: s.key);
      }
    });

    test('branch collections are added only with a branch', () {
      final keys = accountingCloudSubscriptionSpecs(
        businessId: _biz,
      ).map((s) => s.key);
      expect(keys.where((k) => k.startsWith('transactions|')), isEmpty);
    });
  });

  group('on a strict-mode store', () {
    late Directory dir;
    late Ditto ditto;

    Future<void> insert(String collection, Map<String, dynamic> doc) =>
        ditto.store.execute(
          'INSERT INTO $collection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
          arguments: {'doc': doc},
        );

    Future<List<String>> lineIds() async {
      final r = await ditto.store.execute(
        'SELECT _id FROM journal_lines ORDER BY _id',
      );
      return [for (final i in r.items) i.value['_id'] as String];
    }

    setUp(() async {
      if (!hasDitto) return;
      TestWidgetsFlutterBinding.ensureInitialized();
      dir = await Directory.systemTemp.createTemp('ditto_ledger');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeee7',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      await ditto.store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
    });

    tearDown(() async {
      if (!hasDitto) return;
      await ditto.close();
      await dir.delete(recursive: true);
    });

    test('eviction drops only lines known to be another business\'s', () async {
      await insert('journal_lines', {'_id': 'mine', 'businessId': _biz});
      await insert('journal_lines', {'_id': 'mine_snake', 'business_id': _biz});
      await insert('journal_lines', {
        '_id': 'mine_mixed',
        'businessId': 'legacy',
        'business_id': _biz,
      });
      await insert('journal_lines', {'_id': 'theirs', 'businessId': _other});
      await insert('journal_lines', {
        '_id': 'theirs_both',
        'businessId': _other,
        'business_id': _other,
      });
      await insert('journal_lines', {'_id': 'unknown', 'journalEntryId': 'x'});
      await insert('journal_lines', {
        '_id': 'unknown_null',
        'businessId': null,
      });
      await insert('journal_lines', {'_id': 'unknown_empty', 'businessId': ''});

      await evictOtherBusinessesJournalLines(ditto: ditto, businessId: _biz);

      expect(await lineIds(), [
        'mine',
        'mine_mixed',
        'mine_snake',
        'unknown',
        'unknown_empty',
        'unknown_null',
      ]);

      // Once per business per process.
      await insert('journal_lines', {
        '_id': 'theirs_late',
        'businessId': _other,
      });
      await evictOtherBusinessesJournalLines(ditto: ditto, businessId: _biz);
      expect(await lineIds(), contains('theirs_late'));
    }, skip: skip);

    test('the journal indexes are created', () async {
      for (final statement in localStoreIndexStatements()) {
        await ditto.store.execute(statement);
      }
      final r = await ditto.store.execute('SELECT * FROM system:indexes');
      final names = r.items.map((i) => i.value.toString()).join(' ');
      for (final name in [
        'idx_journal_entries_businessId',
        'idx_journal_entries_business_id',
        'idx_journal_lines_businessId',
        'idx_journal_lines_business_id',
        'idx_journal_lines_journalEntryId',
      ]) {
        expect(names, contains(name));
      }
    }, skip: skip);

    test('watchChanges fires on change and stops when cancelled', () async {
      final store = _AccountingStore()..setDitto(ditto);
      const query =
          'SELECT * FROM journal_entries '
          'WHERE businessId = :businessId OR business_id = :businessId';
      var fired = 0;
      final sub = store
          .watchChanges('journal_entries', query, {'businessId': _biz})
          .listen((_) => fired++);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final initial = fired;

      await insert('journal_entries', {'_id': 'e1', 'businessId': _biz});
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(fired, greaterThan(initial));

      await sub.cancel();
      final afterCancel = fired;
      await insert('journal_entries', {'_id': 'e2', 'businessId': _biz});
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(fired, afterCancel);
    }, skip: skip);
  });

  test('watchChanges is empty before Ditto is open', () async {
    final store = _AccountingStore();
    expect(
      await store
          .watchChanges('journal_entries', 'SELECT * FROM journal_entries', {})
          .isEmpty,
      isTrue,
    );
  });
}
