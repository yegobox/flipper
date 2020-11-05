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

  @override
  // ignore: always_specify_types
  Future futureToRun() async {
    final List<Map<String, dynamic>> switcher = await _databaseService.filter(
      equator: AppTables.switchi,
      property: 'table',
    );

    if (switcher.isNotEmpty) {
      final Switcher switchi = Switcher.fromMap(switcher[0][
          'main']); //intrested in first result. FIXME(richard):should be one result.
      log.i(switchi);
      return switchi;
    }
    return null;
  }
}
