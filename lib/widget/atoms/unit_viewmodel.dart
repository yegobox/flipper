import 'package:flipper/model/unit_response.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/proxy.dart';
import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/services/database_service.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:flipper/utils/logger.dart';

import 'package:logger/logger.dart';

class UnitViewModel extends ReactiveViewModel {
  final DatabaseService _databaseService = ProxyService.database;
  final List<Unit> _units = <Unit>[];
  final sharedStateService = locator<SharedStateService>();
  final Logger log = Logging.getLogger('units:)');

  List<Unit> get units => _units;
  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void loadUnits() {
    final q = Query(_databaseService.db,
        'SELECT id, name,table,branchId,focused,channels WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.unit};

    q.addChangeListener((List results) {
      for (Map map in results) {
        if (!_units.contains(Unit.fromMap(map))) {
          log.d(map);
          _units.add(Unit.fromMap(map));
        }
        notifyListeners();
      }
    });
  }

  void saveFocusedUnit({Unit unit}) async {
    // reset other focused if any!
    // for (Unit unit in units) {
    //   final Document unitDoc = _databaseService.getById(id: unit.id);
    //   if (unit.focused) {
    //     unitDoc.properties['focused'] = false;
    //     _databaseService.update(document: unitDoc);
    //   }
    // }

    // final Document unitDoc = _databaseService.getById(id: unit.id);

    // unitDoc.properties['focused'] = false;
    // _databaseService.update(document: unitDoc);
    // notifyListeners();
  }

  void updateProductWithCurrentUnit({Unit unit}) async {
    //NOTE: we update product variation not actual product as the unit is associated with variation.

    final q = Query(_databaseService.db,
        'SELECT * WHERE table=\$VALUE AND productId=\$productId');

    q.parameters = {
      'VALUE': AppTables.variation,
      'productId': sharedStateService.product.id
    };

    final variants = q.execute();

    if (variants.isNotEmpty) {
      for (Map map in variants) {
        map.forEach((key, value) {
          //  sharedStateService.setProduct(product: Product.fromMap(value));
        });
        notifyListeners();
      }
    }
    // FIXME(richard): finish the logic this logic seems to be invalid or too complicated for nothing
    // for (var i = 0; i < variants.length; i++) {
    //   final Variation variation = Variation.fromMap(variants[i]);
    //   final Document variationDocument =
    //       _databaseService.getById(id: variation.id);

    //   variationDocument.properties['unit']    =unit.name;

    //   _databaseService.update(document: variationDocument);
    // }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [sharedStateService];
}
