import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/unit.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:stacked/stacked.dart';

class AddUnitViewModel extends ReactiveViewModel {
  final sharedStateService = locator<SharedStateService>();
  final DatabaseService _databaseService = ProxyService.database;

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
