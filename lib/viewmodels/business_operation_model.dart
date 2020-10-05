import 'package:flipper/model/converters/switcher.dart';
import 'package:flipper/util/logger.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:couchbase_lite/couchbase_lite.dart' as lite;

// ignore: always_specify_types
class BusinessOperation extends FutureViewModel {
  BusinessOperation({this.id});

  final Logger log = Logging.getLogger('Business Operation  Model ....');
  // lite.Database _database;
  final String id;
  String dbName = 'main';

  @override
  // ignore: always_specify_types
  Future futureToRun() async {
    
    // ignore: always_specify_types
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('tableName')
            .equalTo(lite.Expression.string('switcher_'+id)));
    try {
      final lite.ResultSet result = await query.execute();
      
      if (result.allResults().isNotEmpty) {
         final List<Switcher> model = result.map((lite.Result result) {
            log.d(result.toMap());
            return Switcher.fromMap(result.toMap());
        }).toList();
        final Switcher switchi = model[0];
        log.d(switchi);
        return switchi; //intrested in first result. FIXME(richard):should be one result.
      } else {
        log.i('no data found with Id:'+id);
        return null;
      }
    } catch (e) {
      log.d(e);
      return null;
    }
  }
}
