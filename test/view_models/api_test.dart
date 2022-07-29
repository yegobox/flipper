import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:test/test.dart';
import 'package:flipper_services/locator.dart';
import '../helpers/test_helpers.dart';
import 'common.dart';

void main() {
  group('Isar API', () {
    late Isar isar;
    late Product product;

    late Order order;

    setUp(() async {
      isar = await openTempIsar([
        OrderSchema,
        BusinessSchema,
        BranchSchema,
        OrderItemSchema,
        ProductSchema,
        VariantSchema,
        ProfileSchema,
        SubscriptionSchema,
        IPointSchema,
        StockSchema,
        FeatureSchema,
        VoucherSchema,
        PColorSchema,
        CategorySchema,
        IUnitSchema,
        SettingSchema,
        DiscountSchema,
        CustomerSchema,
        PinSchema,
        ReceiptSchema,
      ]);
      IsarAPI().getInstance(iisar: isar);
      await setupLocator();
      registerServices();
    });

    tearDown(() async {
      unregisterServices();
      // await isar.close();
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
    });

    // isarTest('Can update order add NS on it as receipt type', () async {
    //   order.receiptType = "NS";
    //   await ProxyService.isarApi.update(data: order);
    //   // Order? updated = await ProxyService.isarApi.getOrderById(id: order.id);
    //   expect(order.receiptType, isA<void>());
    // });
  });
}
