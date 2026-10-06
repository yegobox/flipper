// Runs the ticket-line flag filters against a real local Ditto store in
// DQL_STRICT_MODE, as production does. `flutter test` has no Ditto native
// library, so this skips unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/transaction_item_flag_filters_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/utils/transaction_item_flag_filters.dart';
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

void main() {
  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;

  test(
    'a ticket read returns bar/hotel lines with unset flags; others unchanged',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_item_flags');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeee01',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      final store = ditto.store;
      await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');

      const txn = 'tab-1';
      const branch = 'branch-1';
      Future<void> line(String id, Map<String, dynamic> flags) => store.execute(
        'INSERT INTO transaction_items DOCUMENTS (:doc)',
        arguments: {
          'doc': {
            '_id': id,
            'id': id,
            'transactionId': txn,
            'branchId': branch,
            'name': id,
            'qty': 1,
            'price': 100,
            ...flags,
          },
        },
      );

      // A POS line.
      await line('pos', {'active': true, 'doneWithTransaction': false});
      // A bar line as the adapter wrote it before the fix: explicit nulls.
      await line('bar', {'active': null, 'doneWithTransaction': null});
      // A line from a writer that omits both fields.
      await line('missing', {});
      // Lines a "current lines" read must still leave out.
      await line('inactive', {'active': false, 'doneWithTransaction': false});
      await line('done', {'active': true, 'doneWithTransaction': true});

      Future<Set<String>> ids({
        required bool pinned,
        bool? active,
        bool? doneWithTransaction,
      }) async {
        final flags = transactionItemFlagFilters(
          active: active,
          doneWithTransaction: doneWithTransaction,
          pinnedToTransaction: pinned,
        );
        final conditions = [
          if (pinned)
            '(transactionId = :transactionId OR transaction_id = :transactionId)',
          '(branchId = :branchId OR branch_id = :branchId)',
          ...flags.conditions,
        ];
        final result = await store.execute(
          'SELECT * FROM transaction_items WHERE ${conditions.join(' AND ')} '
          'ORDER BY createdAt DESC',
          arguments: {
            if (pinned) 'transactionId': txn,
            'branchId': branch,
            ...flags.arguments,
          },
        );
        return result.items.map((i) => i.value['id'] as String).toSet();
      }

      // Resume / Collect / receipt shape: the bar and flagless lines now show.
      expect(
        await ids(pinned: true, active: true, doneWithTransaction: false),
        {'pos', 'bar', 'missing'},
      );
      expect(await ids(pinned: true, active: true), {
        'pos',
        'bar',
        'missing',
        'done',
      });
      // Explicit non-default asks are untouched.
      expect(await ids(pinned: true, active: false), {'inactive'});
      expect(await ids(pinned: true, doneWithTransaction: true), {'done'});
      // Branch-wide reads keep strict equality, exactly as before.
      expect(
        await ids(pinned: false, active: true, doneWithTransaction: false),
        {'pos'},
      );

      // The pinned stream subscribes to the whole ticket without the flags;
      // that DQL must be accepted by the sync engine.
      final sub = prepareDqlSyncSubscription(
        'SELECT * FROM transaction_items WHERE '
        '(transactionId = :transactionId OR transaction_id = :transactionId) '
        'AND (branchId = :branchId OR branch_id = :branchId)',
        {'transactionId': txn, 'branchId': branch, 'active': true},
      );
      final subscription = ditto.sync.registerSubscription(
        sub.dql,
        arguments: sub.arguments,
      );
      subscription.cancel();

      await ditto.close();
      await dir.delete(recursive: true);
    },
  );
}
