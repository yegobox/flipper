// What a combo costs: a sale's COGS (booked by the data-connector from each
// line's splyAmt) and a made product's supply price come from here. Combos used
// to be saved with their components' SELLING prices as cost.
//
// The real-store test skips unless LIBDITTOFFI_PATH points at a Ditto build:
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/combo_cost_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/combo_cost.dart';
import 'package:flipper_models/sync/utils/combo_stock_lines.dart';
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

Variant _v(String id, double supply, {double retail = 9999}) => Variant(
  id: id,
  name: id,
  branchId: 'b1',
  supplyPrice: supply,
  retailPrice: retail,
);

TransactionItem _line(String id, {num qty = 1, double? supply}) =>
    TransactionItem(
      id: id,
      name: id,
      qty: qty,
      price: 0,
      prc: 0,
      discount: 0,
      ttCatCd: null,
      supplyPrice: supply,
    );

void main() {
  group('comboUnitCost', () {
    test('sums component cost prices, never selling prices', () {
      final cost = comboUnitCost(
        [
          Composite(variantId: 'soda', qty: 2),
          Composite(variantId: 'bread'),
          Composite(variantId: 'gone', qty: 5),
        ],
        {'soda': _v('soda', 300), 'bread': _v('bread', 250)},
      );
      expect(cost, 2 * 300 + 250);
    });
  });

  test('comboLineCosts totals each combo line from its component lines', () {
    final costs = comboLineCosts([
      _line('tea', supply: 100),
      _line(comboComponentLineId('c1', 'soda'), qty: 4, supply: 300),
      _line(comboComponentLineId('c1', 'bread'), qty: 2, supply: 250),
      _line(comboComponentLineId('c2', 'soda'), qty: 2),
    ]);
    expect(costs, {'c1': 4 * 300 + 2 * 250, 'c2': 0.0});
  });

  group('movingAverageCost', () {
    test('weights the new batch against what is held', () {
      expect(
        movingAverageCost(
          onHandBefore: 3,
          oldCost: 500,
          qty: 10,
          unitCost: 2150,
        ),
        closeTo((3 * 500 + 10 * 2150) / 13, 1e-9),
      );
    });

    test('nothing (or less than nothing) held: the batch cost', () {
      expect(
        movingAverageCost(onHandBefore: 0, oldCost: 500, qty: 10, unitCost: 80),
        80,
      );
      expect(
        movingAverageCost(
          onHandBefore: -4,
          oldCost: 500,
          qty: 10,
          unitCost: 80,
        ),
        80,
      );
      expect(
        movingAverageCost(onHandBefore: 0, oldCost: 500, qty: 0, unitCost: 80),
        80,
      );
    });
  });

  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;

  test(
    'the cost writes touch only their own fields in a strict store',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_combo_cost');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeef0',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      final store = ditto.store;
      await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
      await store.execute(
        'INSERT INTO variants DOCUMENTS (:doc)',
        arguments: {
          'doc': {
            '_id': 'v1',
            'id': 'v1',
            'supplyPrice': 1200,
            'name': 'Combo',
          },
        },
      );
      await store.execute(
        'INSERT INTO transaction_items DOCUMENTS (:doc)',
        arguments: {
          'doc': {
            '_id': 'l1',
            'id': 'l1',
            'qty': 2,
            'splyAmt': 2400,
            'price': 1500,
          },
        },
      );

      await writeVariantSupplyPrice(ditto, variantId: 'v1', supplyPrice: 850);
      await writeLineSupplyCost(ditto, lineId: 'l1', unitCost: 850, qty: 2);

      final variant = (await store.execute(
        "SELECT * FROM variants WHERE _id = 'v1'",
      )).items.single.value;
      expect(variant['supplyPrice'], 850);
      expect(variant['name'], 'Combo');

      final line = (await store.execute(
        "SELECT * FROM transaction_items WHERE _id = 'l1'",
      )).items.single.value;
      expect(line['splyAmt'], 1700);
      expect(line['supplyPriceAtSale'], 850);
      expect(line['price'], 1500);
      ditto.close();
    },
  );
}
