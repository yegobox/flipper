import 'package:flipper/helper/constant.dart';
import 'package:flipper/model/converters/switcher.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

// ignore: always_specify_types
class SwitchModel extends FutureViewModel {
  SwitchModel({this.id});

  final Logger log = Logging.getLogger('Switcher....');
  
  final String id;
  final DatabaseService _databaseService = ProxyService.database;

  @override
  // ignore: always_specify_types
  Future futureToRun() async {
      
      final List<Map<String, dynamic>> switcher = await _databaseService.filter(
        equator: AppTables.switchi + id,
        property: 'tableName',
      );

      final Switcher  switchi = Switcher.fromMap(switcher[0]['main']); //intrested in first result. FIXME(richard):should be one result.
      log.i(switchi);
      return switchi;
  }
}
