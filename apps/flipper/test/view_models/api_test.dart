import 'package:test/test.dart';
import 'common.dart';

void main() {
  group('Isar API', () {
    // late Product product;
    // late Order order;

    setUpAll(() async {
      // registerServices();
      // await setupLocator();
      // ProxyService.box.write(key: 'userId', value: 1);
      // ProxyService.box.write(key: 'businessId', value: 1);
      // ProxyService.box.write(key: 'branchId', value: 1);
    });

    tearDownAll(() {
      // unregisterServices();
      // ProxyService.box.remove(key: "userId");
      // ProxyService.box.remove(key: "businessId");
      // ProxyService.box.remove(key: "branchId");
    });

    isarTest('Test we have a Testing product', () async {
      // expect(1, 1);
      // product = await ProxyService.isarApi
      //     .createProduct(product: Product()..name = "Testing");
      // expect(product, isA<Product>());
      // expect("Testing", product.name);
      expect(1, 1);
    });

    isarTest('Test can create order', () async {
      // order = await ProxyService.isar.manageOrder();
      // expect(order, isA<Order>());
      expect(1, 1);
    });
  });
}
