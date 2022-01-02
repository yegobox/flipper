// import 'dart:io';

// import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
// import 'package:flipper_models/category.dart';
// import 'package:flipper_models/color.dart';
// import 'package:flipper_models/order.dart';
// import 'package:flipper_models/product.dart';
// import 'package:flipper_models/unit.dart';
// import 'package:flipper_models/unit_mock.dart';
// import 'package:flipper_models/variant_stock.dart';
// import 'package:flipper_models/variants.dart';
// import 'package:flipper_models/variation_mock.dart';
// import 'package:flipper_services/LiteApi.dart';
// import 'package:flipper_services/constants.dart';
import 'package:test/test.dart';
// import 'package:flipper_models/b.dart';
// import '../helpers/test_helpers.dart';
// import 'package:uuid/uuid.dart';

// const TESTDIR = '_tmp';
void main() {
  test('default', () {
    expect(1, 1);
  });
}
// void main() {
//   initializeCblC();
//   setUpAll(() {
//     registerServices();
//     if (Directory(TESTDIR).existsSync()) {
//       Directory(TESTDIR).delete(recursive: true);
//     }
//   });

//   tearDownAll(() {
//     unregisterServices();
//   });
//   test('test create order', () async {
//     if (!Directory(TESTDIR).existsSync()) {
//       Directory(TESTDIR).createSync();
//     }

//     var db = Database('document1', directory: TESTDIR);
//     LiteApi api = new LiteApi(database: db);

//     OrderF order = await api.createOrder(
//         variation: variationMock, customAmount: 30, price: 300);

//     expect(order, isA<OrderF>());
//     expect(order.cashReceived, isA<double>());

//     expect(order.subTotal, isA<double>());
//     expect(order.channels, isA<List<String>>());

//     expect(await api.pendingOrderExist(), isA<OrderF>());
//     expect(await api.orders(), isA<List<OrderF>>());
//   });
//   test('Test we can insert object in the list', () async {
//     var db = Database('document1', directory: TESTDIR);
//     LiteApi api = new LiteApi(database: db);
//     B b = await api.insertB();
//     expect(b, isA<B>());
//     expect(b.asi.length, 2);
//   });
//   test('can delete object given id', () async {
//     var db = Database('document1', directory: TESTDIR);
//     LiteApi api = new LiteApi(database: db);
//     OrderF order = await api.createOrder(
//         variation: variationMock, customAmount: 30, price: 300);
//     expect(await api.delete(id: order.id, endPoint: 'order'), true);
//   });
//   test('When called should create a product and Query stock', () async {
//     //create a product,variation and stock and query and see if we get VariantStock
//     var db = Database('document1', directory: TESTDIR);
//     LiteApi api = new LiteApi(database: db);
//     Product product = await api.createProduct(
//       product: customProductMock,
//     );
//     expect(product, isA<Product>());

//     List<Variant> variations =
//         await api.variants(branchId: 11, productId: product.id);

//     expect(variations, isA<List<Variant>>());

//     expect(variations[0].id, isA<String>());

//     List<VariantStock> variantsStocks =
//         await api.variantStock(branchId: 11, variantId: variations[0].id);

//     expect(variantsStocks, isA<List<VariantStock>>());
//   });
//   test('Test can create Colors and  Query them', () async {
//     //
//     var db = Database('document1', directory: TESTDIR);
//     LiteApi api = new LiteApi(database: db);
//     final List<String> colors = [
//       '#d63031',
//       '#0984e3',
//       '#e84393',
//       '#2d3436',
//       '#6c5ce7',
//       '#74b9ff',
//       '#ff7675',
//       '#a29bfe'
//     ];

//     final PColor color = new PColor(
//       id: DateTime.now().millisecondsSinceEpoch,
//       colors: colors,
//       table: AppTables.color,
//       channels: ['300'],
//       active: false,
//       fbranchId: 11,
//       name: 'sample',
//     );
//     api.create<PColor>(data: color.toJson(), endPoint: 'color');

//     //now Querying should return list of colors
//     List<PColor> _colors = await api.colors(branchId: 11);
//     expect(_colors, isA<List<PColor>>());
//     expect(_colors.length, 8);
//   });
//   test('can create units and Query them', () async {
//     //
//     var db = Database('document1', directory: TESTDIR);
//     LiteApi api = new LiteApi(database: db);
//     final unitId = DateTime.now().millisecondsSinceEpoch;

//     final units = new Unit(
//       name: 'sample',
//       active: false,
//       id: unitId,
//       table: AppTables.unit,
//       units: mockUnits,
//       fbranchId: 11, //stands where there was BID as branchId
//       channels: ['300'],
//     );
//     api.addUnits(data: units.toJson());
//     List<Unit> _units = await api.units(branchId: 11);
//     expect(_units, isA<List<Unit>>());
//   });
//   test('can create category and Query them', () async {
//     //
//     var db = Database('document1', directory: TESTDIR);
//     final categoryId = DateTime.now().millisecondsSinceEpoch;
//     LiteApi api = new LiteApi(database: db);
//     final Category category = new Category(
//       id: categoryId,
//       active: true,
//       table: AppTables.category,
//       focused: true,
//       name: 'NONE',
//       channels: ['300'],
//       fbranchId: 11,
//     );
//     api.create<Category>(data: category.toJson(), endPoint: 'category');
//     List<Category> categories = await api.categories(branchId: 11);
//     expect(categories, isA<List<Category>>());
//   });
//   test('Can delete a product and related variant(s) and Query should return []',
//       () async {
//     //
//     expect(1, 1);
//   });
// }
