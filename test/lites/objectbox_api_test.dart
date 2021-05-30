import 'dart:io';

import 'package:flipper_models/color.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/unit_mock.dart';
import 'package:flipper_models/variation.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/objectbox_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart';

void main() {
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
      branchId: 11,
      channels: ["300"],
    );
    final response = await api.addUnits(data: units.toJson());
    expect(response, 200);
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
      branchId: 11,
      name: 'sample',
    );
    final response =
        await api.create<PColor>(data: color.toJson(), endPoint: 'color');
    expect(response, 200);
    List<PColor> colorss = await api.colors(branchId: 11);
    expect(colorss, isA<List<PColor>>());
  });
  test('create variants', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    List<Variation> variations = [];
    Variation data = new Variation(
      name: 'a',
      sku: 'a',
      productId: 2,
      unit: 'kg',
      channels: ["300"],
      productName: 'a',
      branchId: 11,
      id: 1,
      table: AppTables.variation,
      taxName: 'N/A',
      taxPercentage: 0.0,
    );
    variations.add(data);
    final response = await api.addVariant(
        data: variations, retailPrice: 0.0, supplyPrice: 0.0);
    expect(response, 200);

    List<Variation> variationss =
        await api.variants(branchId: 11, productId: 2);
    expect(variationss, isA<List<Variation>>());
  });
  test('test create order', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);

    // api.createOrder(customAmount: 2, variation: variation, price: 300);
  });
}
