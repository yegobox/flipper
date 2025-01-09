import 'package:flipper_models/CoreSync.dart';
import 'package:flipper_models/realm_model_export.dart';

import 'package:test/test.dart';

void main() {
  group('Isar Realm API!', () {
    CoreSync realm = CoreSync();

    setUpAll(() async {
      // Initialize the Realm API with an in-memory database for testing
      // await realm.configureLocal(useInMemory: true, box: ProxyService.box);
    });

    tearDownAll(() async {});
    setUp(() async {
      // realm.realm!.write(() {
      //   realm.realm!.deleteAll<Product>();
      //   realm.realm!.deleteAll<SKU>();
      //   realm.realm!.deleteAll<Variant>();
      // });
    });

    test('Add product into realm db', () async {
      Product? product = await realm.createProduct(
          bhFId: "00",
          tinNumber: 111,
          branchId: 1,
          businessId: 1,
          product: Product(
              name: "Test Product",
              color: "#ccc",
              businessId: 1,
              branchId: 1,
              isComposite: true,
              nfcEnabled: false));

      expect(product, isA<Product>());
    });

    //   test('Ensure unique SKUs for variants created with products', () async {
    //     const int numberOfProducts = 5;
    //     final skuSet = <String>{}; // Set to store unique SKUs

    //     // Add multiple products
    //     for (int i = 0; i < numberOfProducts; i++) {
    //       await realm.createProduct(
    //           bhFId: "00",
    //           tinNumber: 111,
    //           branchId: 1,
    //           businessId: 1,
    //           product: Product(
    //               name: "Product $i",
    //               color: "#ccc",
    //
    //               businessId: 1,
    //               branchId: 1,
    //               isComposite: true,
    //               nfcEnabled: false));
    //     }

    //     // Query all variants to check SKUs
    //     final variants =
    //         realm.realm!.query<Variant>(r'branchId == $0', [1]).toList();
    //     for (var variant in variants) {
    //       if (skuSet.contains(variant.sku)) {
    //         fail('Duplicate SKU found: ${variant.sku}');
    //       }
    //       skuSet.add(variant.sku!);
    //     }

    //     expect(skuSet.length, numberOfProducts * 1,
    //         reason: 'Not all SKUs are unique');
    //   });
  });
}
