import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:realm/realm.dart';
import 'package:test/test.dart';

void main() {
  group('Isar Realm API!', () {
    RealmAPI realm = RealmAPI();
    setUpAll(() async {
      await realm.configure(
        useInMemoryDb: true,
      );
    });

    tearDownAll(() {});

    test('Add product into realm db', () async {
      Product? product = await realm.createProduct(
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
  });
}
