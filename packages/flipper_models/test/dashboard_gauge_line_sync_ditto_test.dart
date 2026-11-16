// Proves the dashboard gauge's line-item sync subscription DQL against a real
// Ditto store in DQL_STRICT_MODE. Skips unless LIBDITTOFFI_PATH points at a
// Ditto native library (see pos_catalog_stock_filter_ditto_test.dart).
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_item_mixin.dart'
    show reportScopeItemsByBranchIdDql, reportScopeItemsByBranchSnakeDql;
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
    'gauge line sync DQL matches the branch from the window start on',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_gauge_sync');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeee2',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      final store = ditto.store;
      await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
      Future<void> line(
        String id,
        String branch,
        String createdAt, {
        bool snake = false,
      }) => store.execute(
        'INSERT INTO transaction_items DOCUMENTS (:d)',
        arguments: {
          'd': {
            '_id': id,
            if (snake) 'branch_id': branch else 'branchId': branch,
            'createdAt': createdAt,
          },
        },
      );
      await line('in', 'b1', '2026-11-10T09:00:00.000');
      await line('snake', 'b1', '2026-11-12T09:00:00.000', snake: true);
      await line('before', 'b1', '2026-11-01T09:00:00.000');
      await line('other', 'b2', '2026-11-12T09:00:00.000');

      final args = {
        'branchId': 'b1',
        'historyWindowStart': DateTime(2026, 11, 9).toIso8601String(),
      };
      final rows = await store.execute(
        dashboardGaugeLineSyncDql,
        arguments: args,
      );
      expect(rows.items.map((i) => i.value['_id']).toSet(), {'in', 'snake'});
      // Report scope, first tier: the camelCase and snake_case queries with
      // the same window together find every in-window line once.
      final window = {
        'branchId': 'b1',
        'startDate': DateTime(2026, 11, 9).toIso8601String(),
        'endDate': DateTime(2026, 11, 12, 23, 59, 59, 999).toIso8601String(),
      };
      final camel = await store.execute(
        reportScopeItemsByBranchIdDql,
        arguments: window,
      );
      final snake = await store.execute(
        reportScopeItemsByBranchSnakeDql,
        arguments: window,
      );
      expect(camel.items.map((i) => i.value['_id']).toSet(), {'in'});
      expect(snake.items.map((i) => i.value['_id']).toSet(), {'snake'});

      // The same DQL registers as a sync subscription without complaint.
      final sub = ditto.sync.registerSubscription(
        dashboardGaugeLineSyncDql,
        arguments: args,
      );
      sub.cancel();
    },
  );
}
