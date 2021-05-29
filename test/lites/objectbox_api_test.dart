import 'dart:io';

import 'package:flipper_models/unit.dart';
import 'package:flipper_models/unit_mock.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/objectbox_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/test.dart';

void main() {
  test('test create unit', () async {
    //
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    final units = new Unit(
      name: 'sample',
      active: false,
      id: 'XX',
      table: AppTables.unit,
      units: mockUnits,
      branchId: 'XX',
      channels: ["300"],
    );
    final response = await api.addUnits(data: units.toJson());
    expect(response, 200);
  });
  test('test create colors', () async {
    Directory dir = await getApplicationDocumentsDirectory();
    ObjectBoxApi api = new ObjectBoxApi(dir: dir);
    final PColor color = new PColor(
      id: colorId,
      colors: colors,
      table: AppTables.color,
      channels: [userId],
      active: false,
      branchId: branches[0].id,
      name: 'sample',
    );
    final response =
        await api.create<PColor>(data: color.toJson(), endPoint: 'color');
  });
}
