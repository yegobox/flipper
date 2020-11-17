import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/utils/constant.dart';
import 'package:flipper/model/converters/switcher.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class SwitchModel extends FutureViewModel {
  final Logger log = Logging.getLogger('Switcher....');

  final DatabaseService _databaseService = ProxyService.database;

  Switcher _switchi;
  Switcher get switchi {
    return _switchi;
  }

  @override
  // ignore: always_specify_types
  Future futureToRun() async {
   
    final q = Query(_databaseService.db, 'SELECT * WHERE table=\$VALUE');

    q.parameters = {'VALUE': AppTables.switchi};

    final switchers = q.execute();

    if (switchers.isNotEmpty) {
   
      for (Map map in switchers) {
        map.forEach((key,value){
           _switchi = Switcher.fromMap(value);
        });
        notifyListeners();
      }
      return switchi;
    }
    return null;
  }
}
