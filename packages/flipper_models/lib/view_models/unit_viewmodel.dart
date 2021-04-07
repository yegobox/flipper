import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

import 'Queries.dart';

class UnitViewModel extends ReactiveViewModel {
  final DatabaseService _db = ProxyService.database;

  Unit _focusedUnit;

  Unit get focusedCategory => _focusedUnit;

  List<Unit> units = [];

  final sharedStateService = locator<SharedStateService>();
  final Logger log = Logging.getLogger('units:)');

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void loadUnits() {
    final q = Query(_db.db, Queries.Q_10);

    q.parameters = {'T': AppTables.unit};
    units.clear();
    final results = q.execute();
    for (Map map in results.allResults) {
      units.add(Unit.fromMap(map));
      sharedStateService.setUnits(units: units);
    }
    notifyListeners();
  }

  void updateProductWithCurrentUnit({Unit unit}) async {
    final Document productDoc = _db.getById(id: sharedStateService.product.id);
    productDoc.properties['unit'] = unit.name;
    _db.update(document: productDoc);
  }

  void saveFocusedUnit({Unit newUnit}) async {
    // reset other focused if any!
    for (Unit unit in units) {
      final Document unitDoc = _db.getById(id: unit.id);
      if (unit.focused) {
        unitDoc.properties['focused'] = false;
        _db.update(document: unitDoc);
      }
    }

    final Document unitDoc = _db.getById(id: newUnit.id);

    unitDoc.properties['focused'] = newUnit.focused == true ? false : true;
    final Document doc = _db.update(document: unitDoc);
    _focusedUnit = Unit.fromMap(doc.map);

    updateProductWithCurrentUnit(unit: newUnit);

    loadUnits();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [sharedStateService];
}
