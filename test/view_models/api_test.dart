import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:test/test.dart';
import 'common.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  group('Isar API', () {
    late Product product;
    late Order order;

    setUpAll(() async {
      await GetStorage.init();
      await setupLocator();
      ProxyService.box.write(key: 'userId', value: "1");
      ProxyService.box.write(key: 'businessId', value: 1);
      ProxyService.box.write(key: 'branchId', value: 1);
    });

    tearDownAll(() {
      ProxyService.box.remove(key: "userId");
      ProxyService.box.remove(key: "businessId");
      ProxyService.box.remove(key: "branchId");
    });

    isarTest('Test we have a Testing product', () async {
      product = await ProxyService.isarApi
          .createProduct(product: Product()..name = "Testing");
      expect(product, isA<Product>());
      expect("Testing", product.name);
    });

    isarTest('Test can create order', () async {
      order = await ProxyService.isarApi.manageOrder();
      expect(order, isA<Order>());
      expect(1, 1);
    });
  });
}
