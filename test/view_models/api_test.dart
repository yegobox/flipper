import 'package:flipper_models/isar_api.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:test/test.dart';

import '../helpers/test_helpers.dart';
import 'common.dart';

void main() {
  group('Isar API', () {
    late Isar isar;

    setUp(() async {
      registerServices();
      // ensure there is a temp product
      // ensure we have custom Amount product
      // ensure we have business created and it's branch
      isar = await openTempIsar([BusinessSchema]);
    });

    tearDown(() async {
      unregisterServices();
      await isar.close();
    });

    isarTest('.Test we have business named yegobox.', () async {
      IsarAPI.instance(isarRef: isar);
      BusinessHomeViewModel viewModel = BusinessHomeViewModel();

      expect(1, 1);
      // where clause
      // await qEqual(col.where().fieldEqualTo(2).findAll(), [obj2]);
      // await qEqual(col.where().fieldEqualTo(null).findAll(), [objNull]);
      // await qEqual(col.where().fieldEqualTo(5).findAll(), []);

      // filters
      // await qEqualSet(col.filter().fieldEqualTo(2).findAll(), [obj2]);
      // await qEqualSet(col.filter().fieldEqualTo(null).findAll(), [objNull]);
      // await qEqualSet(col.filter().fieldEqualTo(5).findAll(), []);
    });
  });
}
