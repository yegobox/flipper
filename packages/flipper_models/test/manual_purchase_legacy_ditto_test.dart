// Runs the legacy manual purchase line DQL against a real local Ditto store in
// DQL_STRICT_MODE, as production does. `flutter test` has no Ditto native
// library, so this skips unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/manual_purchase_legacy_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
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
    'legacy line DQL finds only approved manual lines and retires them',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_legacy_lines');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-ffffffffffff',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      final store = ditto.store;
      await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');

      Future<void> purchase(
        String id,
        String regTyCd, {
        String branch = 'b1',
      }) => store.execute(
        'INSERT INTO purchases DOCUMENTS (:doc)',
        arguments: {
          'doc': {'_id': id, 'branchId': branch, 'regTyCd': regTyCd},
        },
      );
      Future<void> line(String id, String purchaseId, String? status) =>
          store.execute(
            'INSERT INTO variants DOCUMENTS (:doc)',
            arguments: {
              'doc': {
                '_id': id,
                'id': id,
                'branchId': 'b1',
                'name': 'Line $id',
                'color': '#ff0000',
                'purchaseId': purchaseId,
                'pchsSttsCd': status,
              },
            },
          );

      // An old-build stock: register only, no counter yet.
      Future<void> stock(String id, double qty) => store.execute(
        'INSERT INTO stocks DOCUMENTS (:doc)',
        arguments: {
          'doc': {'_id': id, 'id': id, 'branchId': 'b1', 'currentStock': qty},
        },
      );

      await purchase('pm', 'M');
      await purchase('pa', 'A'); // RRA purchase: its '02' lines are not ours
      await purchase('pm-other', 'M', branch: 'b2');
      await line('legacy', 'pm', '02');
      await line('waiting', 'pm', '01');
      await line('stocked', 'pm', '03');
      await line('rra', 'pa', '02');
      await line('other-branch', 'pm-other', '02');
      await stock('s-legacy', 5);
      await stock('s-product', 12);

      Future<Map<String, bool>> found() async => {
        for (final l in await ManualPurchaseDitto.legacyLinesOnStore(
          store,
          'b1',
        ))
          l.line.id: l.repaired,
      };
      Future<double?> onHand(String id) =>
          ManualPurchaseDitto.stockOnHandOnStore(store, id);

      // Only this branch's manual '02' line; no line carries the flag yet.
      expect(await found(), {'legacy': false});

      Future<void> move(double qty) =>
          ManualPurchaseDitto.moveLegacyLineStockOnStore(
            store,
            lineId: 'legacy',
            lineStockId: 's-legacy',
            targetVariantId: 'product-1',
            targetStockId: 's-product',
            qty: qty,
          );

      await move(5);
      expect(await onHand('s-legacy'), 0);
      expect(await onHand('s-product'), 17);
      // Repaired lines keep coming back so later runs can re-check them.
      expect(await found(), {'legacy': true});
      final doc = (await store.execute(
        "SELECT * FROM variants WHERE _id = 'legacy'",
      )).items.single.value;
      expect(doc['pchsSttsCd'], '03');
      expect(doc[ManualPurchaseDitto.targetVariantIdField], 'product-1');
      // A field-level update: nothing the line already had is lost.
      expect(doc['color'], '#ff0000');
      expect(doc['name'], 'Line legacy');
      // Older builds read the register: it follows the counter.
      final reg = (await store.execute(
        "SELECT * FROM stocks WHERE _id = 's-product'",
      )).items.single.value;
      expect(reg['currentStock'], 17);

      // A second device's move of the same 5 merges in additively...
      await move(5);
      expect(await onHand('s-legacy'), -5);
      expect(await onHand('s-product'), 22);
      // ...and moving the line's negative balance back settles both.
      await move(-5);
      expect(await onHand('s-legacy'), 0);
      expect(await onHand('s-product'), 17);

      // Both replicas correcting the same -5 overshoot the other way, and the
      // next run moves that back: every correction conserves line + product.
      await move(5);
      await move(-5);
      await move(-5);
      expect(await onHand('s-legacy'), 5);
      expect(await onHand('s-product'), 12);
      await move(5);
      expect(await onHand('s-legacy'), 0);
      expect(await onHand('s-product'), 17);
      final lineReg = (await store.execute(
        "SELECT * FROM stocks WHERE _id = 's-legacy'",
      )).items.single.value;
      expect(lineReg['currentStock'], 0);

      await ManualPurchaseDitto.retireLegacyLineOnStore(store, 'waiting');
      expect((await found()).keys, containsAll(['legacy', 'waiting']));

      await ditto.close();
    },
  );
}
