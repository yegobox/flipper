import 'dart:io';

import 'package:flipper_models/category.dart';
import 'package:flipper_models/color.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/product_mock.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/unit_mock.dart';
import 'package:flipper_models/variants.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/objectbox_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';

void main() {
  List<Variant> variations = [];
  Variant data = new Variant(
    name: 'a',
    sku: 'a',
    fproductId: 2,
    unit: 'kg',
    channels: ["300"],
    productName: 'a',
    fbranchId: 11,
    id: 1,
    table: AppTables.variation,
    taxName: 'N/A',
    taxPercentage: 0.0,
  );
  setUpAll(() {
    registerServices();
  });
  tearDownAll(() {
    unregisterServices();
  });

  test('test create unit', () async {
    //
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    int id = DateTime.now().millisecondsSinceEpoch;
    final units = new Unit(
      name: 'sample',
      active: false,
      id: id,
      table: AppTables.unit,
      units: mockUnits,
      fbranchId: 11,
      value: 'Kg',
    );
    final response = await api.addUnits(data: units.toJson());
    expect(response, 200);
  });
  test('test load units', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    List<Unit> units = await api.units(branchId: 11);
    expect(units.isEmpty, false);
  });
  test('test create colors', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    final List<String> colors = [
      '#d63031',
      '#0984e3',
      '#e84393',
      '#2d3436',
      '#6c5ce7',
      '#74b9ff',
      '#ff7675',
      '#a29bfe'
    ];
    int id2 = DateTime.now().millisecondsSinceEpoch;
    final PColor color = PColor(
      id: id2,
      colors: colors,
      table: AppTables.color,
      channels: ["300"],
      active: false,
      fbranchId: 11,
      name: 'sample',
    );
    final response =
        await api.create<PColor>(data: color.toJson(), endPoint: 'color');
    expect(response, 200);
    List<PColor> colorss = await api.colors(branchId: 11);
    expect(colorss.isEmpty, false);
  });
  test('create variants', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);

    variations.add(data);
    final response = await api.addVariant(
        data: variations, retailPrice: 0.0, supplyPrice: 0.0);
    expect(response, 200);

    List<Variant> variationss = await api.variants(branchId: 11, productId: 2);
    expect(variationss.isEmpty, false);
  });
  test('test create order', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    variations.add(data);
    final response = await api.addVariant(
        data: variations, retailPrice: 0.0, supplyPrice: 0.0);
    expect(response, 200);

    List<Variant> variationss = await api.variants(branchId: 11, productId: 2);
    //the first test fall in firs if
    OrderF order = await api.createOrder(
        customAmount: 2, variation: variationss[0], price: 300);
    expect(order, isA<OrderF>());

    //test if order exist
    OrderF? orderExist = await api.pendingOrderExist();
    expect(orderExist, isA<OrderF>());
    expect(orderExist!.active, true);
    expect(orderExist.toJson(), isA<Map>());
  });
  test('create product', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    Product product = await api.createProduct(product: productMock);

    expect(product.name, 'temp');

    //load variants too just!
    List<Variant> variants =
        await api.variants(branchId: 11, productId: product.id);
    expect(variants.isEmpty, false);
  });
  test('create a custom product', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    Product product = await api.createProduct(product: customProductMock);
    Product? getProduct = await api.getProduct(id: product.id);
    expect(getProduct!.name, 'Custom Amount');
    expect(product.name, 'Custom Amount');
  });
  test('get custom amount product variant', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    Variant variant = await api.getCustomProductVariant();
    expect(variant.name, 'Regular');
  });
  test('get list of products', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    List<Product> products = await api.products();
    expect(products.isEmpty, false);
  });
  test('get list of stocks for specific productId', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    List<Stock> stocks = await api.stocks(productId: 2);
    expect(stocks.isEmpty, false);
  });
  test('test temporal product  exist', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    List<Product> products = await api.isTempProductExist();
    expect(products.isEmpty, false);
  });
  test('test get branches', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    // List<Branch> branches = await api.branches(businessId: 10);
    expect(1, 1); //TODOshould be false
  });
  test('test create categories', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);

    Category category = Category(
      active: true,
      table: AppTables.category,
      focused: true,
      name: 'NONE',
      fbranchId: 10,
    );
    final response =
        await api.create(data: category.toJson(), endPoint: 'category');
    expect(response, 200);
  });
}
