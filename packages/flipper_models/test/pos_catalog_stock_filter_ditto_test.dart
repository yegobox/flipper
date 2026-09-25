// Runs the POS stock filter's DQL against a real local Ditto store in
// DQL_STRICT_MODE, as production does. `flutter test` has no Ditto native
// library, so this skips unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/pos_catalog_stock_filter_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
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
    'stock filter DQL runs on a strict-mode store',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_stock_filter');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      final store = ditto.store;
      await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');

      const branch = 'b1';
      final now = DateTime.now();
      Future<void> variant(
        String id,
        String? stockId,
        int ageMin, {
        String taxTyCd = 'B',
        String branchId = branch,
      }) async {
        await store.execute(
          'INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
          arguments: {
            'doc': {
              '_id': id,
              'id': id,
              'branchId': branchId,
              'name': 'Item $id',
              'taxTyCd': taxTyCd,
              'imptItemSttsCd': null,
              'pchsSttsCd': null,
              if (stockId != null) 'stockId': stockId,
              'lastTouched': now
                  .subtract(Duration(minutes: ageMin))
                  .toIso8601String(),
            },
          },
        );
      }

      Future<void> stock(
        String id,
        double qty, {
        String? branchId = branch,
        bool counter = true,
      }) async {
        await store.execute(
          'INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
          arguments: {
            'doc': {
              '_id': id,
              'id': id,
              'branchId': ?branchId,
              'currentStock': qty,
            },
          },
        );
        if (counter) {
          await seedStockMilliIfAbsentOnStore(store, stockId: id, qty: qty);
        }
      }

      // Newest first: v1 .. v7
      await variant('v1', 's1', 1); // 5 in stock (counter)
      await variant('v2', 's2', 2); // 0
      await variant('v3', null, 3); // no stock id
      await variant('v4', 's4', 4); // 0.5 -> tile shows out
      await variant('v5', 's5', 5); // 3, register only (old till)
      await variant('v6', 's6', 6); // 2, stock row has no branchId (legacy)
      await variant('v7', 's7', 7, taxTyCd: 'Z'); // excluded by tax filter
      await variant('other', 's1', 0, branchId: 'b2'); // other branch
      await stock('s1', 5);
      await stock('s2', 0);
      await stock('s4', 0.5);
      await stock('s5', 3, counter: false);
      await stock('s6', 2, branchId: null);
      await stock('s7', 9);

      // A counter that moved after the register (a concurrent sale).
      await store.execute(
        stockIncrementMilliDql(),
        arguments: {'delta': -toMilli(5), 'stockId': 's1'},
      );
      await store.execute(
        stockIncrementMilliDql(),
        arguments: {'delta': toMilli(4), 'stockId': 's1'},
      );

      // Same shape the page query is built with in variants().
      const filterQuery =
          'SELECT * FROM variants WHERE branchId = :branchId'
          " AND name NOT IN ('Cash In', 'Cash Out', 'Utility', 'Custom Amount')"
          " AND (imptItemSttsCd IS NULL OR imptItemSttsCd NOT IN ('2', '4'))"
          " AND (pchsSttsCd IS NULL OR pchsSttsCd NOT IN ('01', '04'))"
          ' AND taxTyCd IN (:tax0, :tax1)';
      const orderSuffix =
          ' ORDER BY lastTouched DESC LIMIT :limit OFFSET :offset';
      final args = {'branchId': branch, 'tax0': 'A', 'tax1': 'B'};

      final catalog = await store.execute(
        stockFilterCatalogQuery(filterQuery, orderSuffix),
        arguments: args,
      );
      final rows = catalog.items
          .map((d) => Map<String, dynamic>.from(d.value))
          .toList();
      expect(rows.map((r) => r['_id']), ['v1', 'v2', 'v3', 'v4', 'v5', 'v6']);

      final branchStock = await store.execute(
        stockQtySelectDql(whereClause: 'branchId = :branchId'),
        arguments: {'branchId': branch},
      );
      final qty = stockQtyByIdKeys(
        branchStock.items.map((d) => Map<String, dynamic>.from(d.value)),
      );
      expect(qty['s1'], 4.0, reason: 'counter must win over the register');
      expect(qty['s5'], 3.0, reason: 'register-only row still counts');
      expect(qty.containsKey('s6'), isFalse);

      final missing = rows
          .map(variantRowStockId)
          .whereType<String>()
          .where((id) => !qty.containsKey(id))
          .toList();
      expect(missing, ['s6']);
      final lookup = idInLookup(missing);
      final found = await store.execute(
        stockQtySelectDql(
          whereClause:
              '_id IN (${lookup.placeholders}) OR id IN (${lookup.placeholders})',
        ),
        arguments: lookup.arguments,
      );
      qty.addAll(
        stockQtyByIdKeys(
          found.items.map((d) => Map<String, dynamic>.from(d.value)),
        ),
      );
      expect(qty['s6'], 2.0);

      final inStock = variantIdsMatchingStock(
        rows: rows,
        qtyByStockId: qty,
        inStock: true,
      );
      final outOfStock = variantIdsMatchingStock(
        rows: rows,
        qtyByStockId: qty,
        inStock: false,
      );
      expect(inStock, ['v1', 'v5', 'v6']);
      expect(outOfStock, ['v2', 'v3', 'v4']);

      final page = pageOfIds(inStock, page: 0, itemsPerPage: 2);
      final pageLookup = idInLookup(page);
      final docs = await store.execute(
        'SELECT * FROM variants WHERE _id IN (${pageLookup.placeholders})',
        arguments: pageLookup.arguments,
      );
      expect(docs.items.map((d) => d.value['_id']).toSet(), {'v1', 'v5'});

      await ditto.close();
      await dir.delete(recursive: true);
    },
  );
}
