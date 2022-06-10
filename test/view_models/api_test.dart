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
    setupLocator();

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
        PointsSchema,
        StockSchema,
        FeatureSchema,
        VoucherSchema,
        PColorSchema,
        CategorySchema,
        UnitSchema,
        SettingSchema,
        DiscountSchema,
        CustomerSchema,
        PinSchema,
        ReceiptSchema,
      ]);
      IsarAPI.instance(isarRef: isar);
      registerServices();
    });

    tearDown(() async {
      unregisterServices();
      await isar.close();
    });

    isarTest('Test we have a Testing product', () async {
      BusinessHomeViewModel viewModel = BusinessHomeViewModel();
      product = await ProxyService.isarApi
          .createProduct(product: Product()..name = "Testing");
      expect(product, isA<Product>());
      expect("Testing", product.name);
    });

    // isarTest('Test can create order', () async {
    //   Order order = await ProxyService.isarApi.manageOrder();
    //   expect(order, isA<Order>());
    // });
  });
}
