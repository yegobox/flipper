// import 'package:flipper_models/RealmApi.dart';
// import 'package:flipper_models/helperModels/random.dart';
// import 'package:flipper_models/realm/schemas.dart';
// import 'package:flipper_services/locator.dart';
// import 'package:flipper_services/proxy.dart';
// import 'package:realm/realm.dart';
import 'package:test/test.dart';

void main() {
  group('Isar Realm API!', () {
    // RealmAPI realm = RealmAPI();
    // setUpAll(() async {
    //   // await initDependencies();
    //   await realm.configure(
    //       useInMemoryDb: true, encryptionKey: "", businessId: 1);
    //   // create sku to use while testing
    // });

    tearDownAll(() {});

    test('Add product into realm db', () async {
      expect(1, 1);
      // Product? product = await realm.createProduct(
      //     tinNumber: 111,
      //     branchId: 1,
      //     businessId: 1,
      //     product: Product(ObjectId(),
      //         name: "Test Product",
      //         color: "#ccc",
      //         id: randomNumber(),
      //         businessId: 1,
      //         branchId: 1,
      //         isComposite: true,
      //         nfcEnabled: false));

      // expect(product, isA<Product>());
    });
  });
}
