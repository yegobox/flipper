// Saving a product's "Low stock / reorder at" level on an existing stock row
// must land without moving quantity. Runs against a real local Ditto store in
// DQL_STRICT_MODE; skips unless LIBDITTOFFI_PATH points at the native library:
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/stock_threshold_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flipper_models/sync/utils/stock_threshold.dart';
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
    'threshold update keeps qty registers and counter',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp(
        'ditto_stock_threshold',
      );
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeef',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      final store = ditto.store;
      await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');

      await store.execute(
        'INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {
          'doc': {
            '_id': 's1',
            'id': 's1',
            'branchId': 'b1',
            'currentStock': 10.0,
            'rsdQty': 10.0,
            'lowStock': 0.0,
            'showLowStockAlert': true,
          },
        },
      );
      await seedStockMilliIfAbsentOnStore(store, stockId: 's1', qty: 10);
      // A sale the register has not caught up with yet.
      await store.execute(
        stockIncrementMilliDql(),
        arguments: {'delta': -toMilli(3), 'stockId': 's1'},
      );

      Future<Map<String, dynamic>> read() async {
        final r = await store.execute(
          stockSelectWithMilliDql(whereClause: '_id = :id'),
          arguments: {'id': 's1'},
        );
        return Map<String, dynamic>.from(r.items.single.value);
      }

      await updateStockThresholdOnStore(store, stockId: 's1', lowStock: 8);
      var doc = await read();
      expect(doc['lowStock'], 8);
      expect(doc['showLowStockAlert'], true);
      expect(doc['currentStock'], 10);
      expect(doc['rsdQty'], 10);
      expect(parseStockMilli(doc[stockCurrentStockMilliField]), toMilli(7));

      await updateStockThresholdOnStore(
        store,
        stockId: 's1',
        lowStock: 5,
        showLowStockAlert: false,
      );
      doc = await read();
      expect(doc['lowStock'], 5);
      expect(doc['showLowStockAlert'], false);
      expect(parseStockMilli(doc[stockCurrentStockMilliField]), toMilli(7));

      // Nothing to write: the document is left alone.
      final before = doc['lastTouched'];
      await updateStockThresholdOnStore(store, stockId: 's1');
      expect((await read())['lastTouched'], before);

      await ditto.close();
      await dir.delete(recursive: true);
    },
  );
}
