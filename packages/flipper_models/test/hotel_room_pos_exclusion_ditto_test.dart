// Runs the DQL that keeps hotel rooms off the POS catalog against a real
// local Ditto store in DQL_STRICT_MODE, as production does. `flutter test`
// has no Ditto native library, so this skips unless LIBDITTOFFI_PATH points
// at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/hotel_room_pos_exclusion_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
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
    'room exclusion and placeholder purge DQL run on a strict-mode store',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_room_filter');
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

      Future<void> variant(String id, String name, String productId) =>
          store.execute(
            'INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
            arguments: {
              'doc': {
                '_id': id,
                'id': id,
                'branchId': 'b1',
                'name': name,
                'productId': productId,
              },
            },
          );

      await variant('room-item', '101', 'room-product');
      await variant('stray', '101', 'gone-product');
      await variant('skol', 'Skol', 'skol-product');
      await store.execute(
        'INSERT INTO products DOCUMENTS (:doc)',
        arguments: {
          'doc': {'_id': 'room-product', 'name': '101'},
        },
      );

      Future<Set<String>> ids(String sql, Map<String, dynamic> args) async =>
          (await store.execute(
            sql,
            arguments: args,
          )).items.map((d) => d.value['_id'] as String).toSet();

      // The catalog exclusion, as variants() appends it.
      expect(
        await ids(
          'SELECT _id FROM variants WHERE branchId = :branchId '
          'AND NOT (_id IN :excludeVariantIds)',
          {
            'branchId': 'b1',
            'excludeVariantIds': ['room-item'],
          },
        ),
        {'stray', 'skol'},
      );

      // The purge's candidate query, matching on room names.
      expect(
        await ids(
          'SELECT * FROM variants WHERE branchId = :branchId AND name IN :names',
          {
            'branchId': 'b1',
            'names': ['101'],
          },
        ),
        {'room-item', 'stray'},
      );

      // Which candidate products still exist.
      expect(
        await ids('SELECT _id FROM products WHERE _id IN :ids', {
          'ids': ['room-product', 'gone-product'],
        }),
        {'room-product'},
      );

      final roomProducts = await store.execute(
        'SELECT productId FROM variants WHERE _id IN :ids',
        arguments: {
          'ids': ['room-item'],
        },
      );
      expect(roomProducts.items.single.value['productId'], 'room-product');

      await ditto.close();
      await dir.delete(recursive: true);
    },
  );
}
