// Runs the pending-cart cleanup / resumed-ticket DQL against a real local
// Ditto store in DQL_STRICT_MODE, as production does. `flutter test` has no
// Ditto native library, so this skips unless LIBDITTOFFI_PATH points at one:
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/pending_sale_cart_cleanup_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/helpers/pending_sale_cart_cleanup.dart';
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
  const skip = 'set LIBDITTOFFI_PATH to run against a real Ditto store';

  late Ditto ditto;
  late Store store;
  const branch = 'b1';
  const agent = 'u1';
  const thisTill = 'dev-u1';
  const otherTill = 'dev-u2';

  Future<void> txn(
    String id, {
    String status = 'pending',
    String device = thisTill,
    String agentId = agent,
    double subTotal = 0,
    String? ticketName,
    bool idInUnderscoreOnly = false,
  }) async {
    await store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {
        'doc': {
          '_id': id,
          if (!idInUnderscoreOnly) 'id': id,
          'branchId': branch,
          'status': status,
          'agentId': agentId,
          'deviceId': device,
          'isExpense': false,
          'isOriginalTransaction': true,
          'transactionType': 'Sale',
          'subTotal': subTotal,
          'ticketName': ticketName,
        },
      },
    );
  }

  Future<void> line(String transactionId) async {
    await store.execute(
      'INSERT INTO transaction_items DOCUMENTS (:doc)',
      arguments: {
        'doc': {
          '_id': 'line-$transactionId',
          'transactionId': transactionId,
          'branchId': branch,
          'qty': 1,
        },
      },
    );
  }

  Future<Set<String>> ids(String dql, Map<String, dynamic> args) async {
    final result = await store.execute(dql, arguments: args);
    return {
      for (final item in result.items)
        (item.value['_id'] ?? item.value['transactionId']) as String,
    };
  }

  setUpAll(() async {
    if (!hasDitto) return;
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('ditto_cart_cleanup');
    PathProviderPlatform.instance = _FakePaths(dir.path);
    await Ditto.init();
    ditto = await Ditto.open(
      DittoConfig(
        databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeee1',
        connect: const DittoConfigConnectSmallPeersOnly(),
        persistenceDirectory: dir.path,
      ),
    );
    store = ditto.store;
    await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');

    await txn('live');
    await txn('empty');
    await txn('resumed', subTotal: 900, ticketName: 'Table 4');
    await line('resumed');
    await txn('cart', subTotal: 300);
    await line('cart');
    await txn('other-till', device: otherTill, subTotal: 500);
    await txn('parked', status: 'parked', subTotal: 400, ticketName: 'T9');
  });

  test(
    'siblings are scoped to this device and exclude the live cart',
    skip: hasDitto ? false : skip,
    () async {
      expect(
        await ids(pendingSaleCartSiblingsDql, {
          'branchId': branch,
          'status': 'pending',
          'agentId': agent,
          'deviceId': thisTill,
          'isExpense': false,
          'isOriginal': true,
          'excludeId': 'live',
        }),
        {'empty', 'resumed', 'cart'},
      );
    },
  );

  test(
    'line lookup binds the array as IN :ids',
    skip: hasDitto ? false : skip,
    () async {
      final args = {
        'ids': ['empty', 'resumed', 'cart'],
      };
      expect(await ids(cartIdsWithLinesDql, args), {'resumed', 'cart'});
      // The old parenthesised form matched nothing, so cleanup never ran.
      expect(
        await ids(
          'SELECT transactionId FROM transaction_items '
          'WHERE transactionId IN (:ids)',
          args,
        ),
        isEmpty,
      );
    },
  );

  test(
    'resumed-ticket sweep finds this device\'s valued pending rows only',
    skip: hasDitto ? false : skip,
    () async {
      expect(
        await ids(resumedTicketSweepDql, {
          'branchId': branch,
          'status': 'pending',
          'deviceId': thisTill,
          'isExpense': false,
          'isOriginal': true,
        }),
        {'resumed', 'cart'},
      );
    },
  );

  test(
    'tickets list status clause includes resumed (pending) rows',
    skip: hasDitto ? false : skip,
    () async {
      // Mirrors openPosTicketsTransactionsStream(includeResumed: true).
      final found = await ids(
        'SELECT * FROM transactions WHERE (status = :parked OR status = :pending) '
        'AND subTotal > 0 AND isOriginalTransaction = :isOriginal '
        'AND branchId = :branchId',
        {
          'parked': 'parked',
          'pending': 'pending',
          'isOriginal': true,
          'branchId': branch,
        },
      );
      expect(found, containsAll(<String>{'parked', 'resumed', 'other-till'}));
      // Dart then keeps only rows that are resumed tickets.
      final result = await store.execute(
        'SELECT * FROM transactions WHERE status = :pending AND subTotal > 0',
        arguments: {'pending': 'pending'},
      );
      final listed = [
        for (final item in result.items)
          if (isResumedPendingTicketRow(Map<String, dynamic>.from(item.value)))
            item.value['_id'],
      ];
      expect(listed, ['resumed']);
    },
  );

  test(
    'deletes match rows that carry their id only in _id',
    skip: hasDitto ? false : skip,
    () async {
      await txn('ghost', idInUnderscoreOnly: true);
      await line('ghost');
      final args = {
        'ids': ['ghost'],
      };
      await store.execute(deleteCartLinesDql, arguments: args);
      await store.execute(deleteCartsDql, arguments: args);
      expect(await ids(cartIdsWithLinesDql, args), isEmpty);
      expect(
        await ids('SELECT * FROM transactions WHERE _id = :id', {
          'id': 'ghost',
        }),
        isEmpty,
      );
    },
  );

  tearDownAll(() async {
    if (hasDitto) await ditto.close();
  });
}
