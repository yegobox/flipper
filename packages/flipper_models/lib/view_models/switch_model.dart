import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flipper_models/business_history.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class SwitchModel extends ReactiveViewModel {
  final Logger log = Logging.getLogger('BusinessHistory....');

  final DatabaseService _databaseService = ProxyService.database;
  bool _isOPEN;
  bool get isOPEN => _isOPEN;

  BusinessHistory _businessHistory;
  BusinessHistory get businessHistory {
    return _businessHistory;
  }

  void getDrawerState() async {
    final q = Query(_databaseService.db,
        'SELECT  id,cashierName,openingHour,isSocial,table,openingFloat,closingFloat,displayText,businessId,userId,createdAt WHERE table=\$T AND openingHour=\$OPEN');

    q.parameters = {
      'T': AppTables.drawerHistories,
      'OPEN': true
    }; //if we business is not OPEN do not ask to put opening float again.

    final histories = q.execute();
    for (Map map in histories.allResults) {
      print(BusinessHistory.fromMap(map));
      _businessHistory = BusinessHistory.fromMap(map);
      ProxyService.sharedState.setBusinessHistory(history: _businessHistory);
    }
    // notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [ProxyService.sharedState];
}
