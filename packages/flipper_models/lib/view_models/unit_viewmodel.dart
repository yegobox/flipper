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
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

import 'Queries.dart';

class UnitViewModel extends ReactiveViewModel {
  final DatabaseService _databaseService = ProxyService.database;

  final RxValue<List<Unit>> _units = RxValue<List<Unit>>(initial: null);
  List<Unit> get units => _units.value;

  final sharedStateService = locator<SharedStateService>();
  final Logger log = Logging.getLogger('units:)');

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void loadUnits() {
    final q = Query(_databaseService.db, Queries.Q_10);

    q.parameters = {'T': AppTables.unit};

    q.addChangeListener((results) {
      //on change do
      final List<Unit> t = [];
      for (Map map in results.allResults) {
        t.add(Unit.fromMap(map));
      }
      //override the _unit
      _units.value = t;
      sharedStateService.setUnits(units: _units.value);
      notifyListeners();
    });
  }

  void updateProductWithCurrentUnit({Unit unit}) async {
    final Document productDoc =
        _databaseService.getById(id: sharedStateService.product.id);
    productDoc.properties['unit'] = unit.name;
    _databaseService.update(document: productDoc);
  }

  void saveFocusedUnit({Unit unit}) async {
    // reset other focused if any!
    for (Unit unit in sharedStateService.units) {
      final Document unitDoc = _databaseService.getById(id: unit.id);
      if (unit.focused) {
        unitDoc.properties['focused'] = false;
        _databaseService.update(document: unitDoc);
      }
    }

    final Document unitDoc = _databaseService.getById(id: unit.id);

    unitDoc.properties['focused'] = true;
    _databaseService.update(document: unitDoc);
    updateProductWithCurrentUnit(unit: unit);
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [sharedStateService];
}
