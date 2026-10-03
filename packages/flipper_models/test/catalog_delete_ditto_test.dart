// Runs the catalog delete DQL against a real local Ditto store in
// DQL_STRICT_MODE, as production does. `flutter test` has no Ditto native
// library, so the store tests skip unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/catalog_delete_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/utils/catalog_delete.dart';
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
  final skip = hasDitto
      ? false
      : 'set LIBDITTOFFI_PATH to run against a real Ditto store';

  test('DeletedCatalogIds remembers ids and ignores null/empty', () {
    final ids = DeletedCatalogIds()..addAll(['v1', null, '', 's1']);
    expect(ids.contains('v1'), isTrue);
    expect(ids.contains('s1'), isTrue);
    expect(ids.contains('v2'), isFalse);
    expect(ids.contains(null), isFalse);
    expect(ids.contains(''), isFalse);
  });

  group('catalog delete on a strict-mode store', () {
    late Directory dir;
    late Ditto ditto;
    late dynamic store;

    setUp(() async {
      if (!hasDitto) return;
      TestWidgetsFlutterBinding.ensureInitialized();
      dir = await Directory.systemTemp.createTemp('ditto_catalog_delete');
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

      Future<void> insert(String collection, Map<String, dynamic> doc) =>
          store.execute(
            'INSERT INTO $collection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
            arguments: {'doc': doc},
          );

      // A product with two variants, plus a duplicate product document with
      // a random _id left behind by the pre-reconcile Product.toJson.
      await insert('products', {'_id': 'p1', 'id': 'p1', 'name': 'Soap'});
      await insert('products', {'_id': 'dup-random', 'id': 'p1'});
      for (final v in ['v1', 'v2']) {
        await insert('stocks', {
          '_id': 's-$v',
          'id': 's-$v',
          'currentStock': 3,
        });
        await insert('variants', {
          '_id': v,
          'id': v,
          'productId': 'p1',
          'stockId': 's-$v',
        });
      }
      // Another product that must be left alone.
      await insert('products', {'_id': 'p2', 'id': 'p2'});
      await insert('stocks', {'_id': 's-v3', 'id': 's-v3'});
      await insert('variants', {
        '_id': 'v3',
        'id': 'v3',
        'productId': 'p2',
        'stockId': 's-v3',
      });
    });

    tearDown(() async {
      if (!hasDitto) return;
      await ditto.close();
      await dir.delete(recursive: true);
    });

    Future<Set<String>> ids(String collection) async => (await store.execute(
      'SELECT _id FROM $collection',
    )).items.map<String>((d) => d.value['_id'] as String).toSet();

    test('deleting a variant removes it and its stock only', () async {
      final removed = await deleteVariantDocs(store, variantId: 'v1');

      expect(removed.stockId, 's-v1');
      expect(removed.productId, 'p1');
      expect(await ids('variants'), {'v2', 'v3'});
      expect(await ids('stocks'), {'s-v2', 's-v3'});
      expect(await ids('products'), {'p1', 'dup-random', 'p2'});
      expect(await productHasVariants(store, 'p1'), isTrue);
    }, skip: skip);

    test('a product emptied of variants can be detected', () async {
      await deleteVariantDocs(store, variantId: 'v1');
      await deleteVariantDocs(store, variantId: 'v2');

      expect(await productHasVariants(store, 'p1'), isFalse);
      expect(await productHasVariants(store, 'p2'), isTrue);
    }, skip: skip);

    test('deleting a product removes every copy, variant and stock', () async {
      final removed = await deleteProductDocs(store, productId: 'p1');

      expect(removed.map((d) => d.variantId).toSet(), {'v1', 'v2'});
      expect(removed.map((d) => d.stockId).toSet(), {'s-v1', 's-v2'});
      expect(await ids('products'), {'p2'});
      expect(await ids('variants'), {'v3'});
      expect(await ids('stocks'), {'s-v3'});
    }, skip: skip);

    test('deleting a missing variant is a no-op, not an error', () async {
      final removed = await deleteVariantDocs(store, variantId: 'nope');

      expect(removed.stockId, isNull);
      expect(removed.productId, isNull);
      expect(await ids('variants'), {'v1', 'v2', 'v3'});
    }, skip: skip);
  });
}
