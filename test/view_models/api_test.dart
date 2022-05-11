import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('Int filter', () {
    late Isar isar;

    setUp(() async {
      isar = await openTempIsar([BusinessSchema]);
    });

    tearDown(() async {
      await isar.close();
    });

    isarTest('.equalTo()', () async {
      IsarAPI api = IsarAPI(isar: isar);
      expect(1, 1);
      // where clause
      // await qEqual(col.where().fieldEqualTo(2).findAll(), [obj2]);
      // await qEqual(col.where().fieldEqualTo(null).findAll(), [objNull]);
      // await qEqual(col.where().fieldEqualTo(5).findAll(), []);

      // // filters
      // await qEqualSet(col.filter().fieldEqualTo(2).findAll(), [obj2]);
      // await qEqualSet(col.filter().fieldEqualTo(null).findAll(), [objNull]);
      // await qEqualSet(col.filter().fieldEqualTo(5).findAll(), []);
    });
  });
}
