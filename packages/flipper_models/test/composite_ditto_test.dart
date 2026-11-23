// Combo (composite) components are written to Ditto only, but the till read
// them from SQLite/Supabase, so a combo made since #587 sold as nothing.
//
// The real-store test skips unless LIBDITTOFFI_PATH points at a Ditto build:
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/composite_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/utils/composite_ditto.dart';
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

/// A `composites` document exactly as `CapellaSync.saveComposite` writes it.
Map<String, dynamic> _doc(String id, String variantId, num qty) => {
  '_id': id,
  'id': id,
  'productId': 'combo',
  'variantId': variantId,
  'qty': qty,
  'branchId': 'b1',
  'businessId': 'biz1',
  'actualPrice': 1500,
};

void main() {
  group('compositeFromDittoDoc', () {
    test('reads what saveComposite writes, int numbers included', () {
      final c = compositeFromDittoDoc(_doc('c1', 'soda', 2));
      expect(c.id, 'c1');
      expect(c.productId, 'combo');
      expect(c.variantId, 'soda');
      expect(c.qty, 2.0);
      expect(c.actualPrice, 1500.0);
      expect(c.branchId, 'b1');
      expect(c.businessId, 'biz1');
    });

    test('falls back to _id and tolerates missing fields', () {
      final c = compositeFromDittoDoc({'_id': 'c2', 'qty': 'lots'});
      expect(c.id, 'c2');
      expect(c.qty, isNull);
      expect(c.variantId, isNull);
    });
  });

  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;

  test(
    'readCompositesFromDitto finds a combo\'s components in a strict store',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_composites');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeef',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      await ditto.store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
      for (final doc in [
        _doc('c1', 'soda', 2),
        _doc('c2', 'bread', 1),
        {..._doc('c3', 'soda', 1), 'productId': 'other-combo'},
      ]) {
        await ditto.store.execute(
          'INSERT INTO composites DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
          arguments: {'doc': doc},
        );
      }

      final byProduct = await readCompositesFromDitto(
        ditto,
        productId: 'combo',
      );
      expect(byProduct.map((c) => c.variantId).toSet(), {'soda', 'bread'});
      expect(byProduct.firstWhere((c) => c.variantId == 'soda').qty, 2.0);

      final byBoth = await readCompositesFromDitto(
        ditto,
        productId: 'combo',
        variantId: 'soda',
      );
      expect(byBoth.single.id, 'c1');

      expect(await readCompositesFromDitto(ditto), isEmpty);
      ditto.close();
    },
  );
}
