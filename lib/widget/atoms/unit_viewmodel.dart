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

  void navigateTo({String path}) {
    ProxyService.nav.navigateTo(Routing.addCategoryScreen);
  }

  void loadUnits() {
    final q = Query(_databaseService.db,
        'SELECT id, name,table,branchId,focused,channels WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.unit};

    q.addChangeListener((List results) {
      _units.clear(); //clear the list to avoid dups
      for (Map map in results) {
        _units.add(Unit.fromMap(map));
      }
      sharedStateService.setUnits(units: _units);
      notifyListeners();
    });
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [sharedStateService];
}
