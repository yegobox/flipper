import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:realm/realm.dart';
import 'package:test/test.dart';

void main() {
  group('Isar Realm API!', () {
    RealmAPI realm = RealmAPI();

    setUpAll(() async {
      // Initialize the Realm API with an in-memory database for testing
      await realm.configure(
          useInMemoryDb: true, encryptionKey: "", businessId: 1);
    });

    tearDownAll(() async {
      // Close Realm instances if necessary
      realm.close();

      // Clean up any temporary files or directories
      // final realmDir = Directory('mongodb-realm');
      // if (realmDir.existsSync()) {
      //   realmDir.deleteSync(recursive: true);
      // }
    });
    setUp(() async {
      realm.realm!.write(() {
        realm.realm!.deleteAll<Product>();
        realm.realm!.deleteAll<SKU>();
        realm.realm!.deleteAll<Variant>();
      });
    });

    test('Add product into realm db', () async {
      Product? product = await realm.createProduct(
          bhFId: "00",
          tinNumber: 111,
          branchId: 1,
          businessId: 1,
          product: Product(ObjectId(),
              name: "Test Product",
              color: "#ccc",
              id: randomNumber(),
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
    //           product: Product(ObjectId(),
    //               name: "Product $i",
    //               color: "#ccc",
    //               id: randomNumber(),
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
