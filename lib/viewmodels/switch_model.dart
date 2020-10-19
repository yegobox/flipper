import 'package:flipper/model/converters/switcher.dart';
import 'package:flipper/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:couchbase_lite/couchbase_lite.dart' as lite;

// ignore: always_specify_types
class SwitchModel extends FutureViewModel {
  SwitchModel({this.id});

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
         final List<Map<String, dynamic>> model = result.map((lite.Result result) {
            return result.toMap();
        }).toList();
        
        final Switcher  switchi = Switcher.fromMap(model[0][dbName]); //intrested in first result. FIXME(richard):should be one result.
        
        return switchi; 
      } else {
       
        return null;
      }
    } catch (e) {
      log.d(e);
      return null;
    }
  }
}
