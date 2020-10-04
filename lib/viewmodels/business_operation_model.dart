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
  Future<Switcher> futureToRun() async {
    log.i('query if user drawer is open with ID'+id);
    // ignore: always_specify_types
    final lite.Where query = lite.QueryBuilder.select([lite.SelectResult.all()])
        .from(dbName)
        .where(lite.Expression.property('tableName')
            .equalTo(lite.Expression.string('business_operations'))
            .and(lite.Expression.property('userId'))
            .equalTo(lite.Expression.string(id)));
    try {
      final lite.ResultSet result = await query.execute();
      if (!result.allResults().isNotEmpty) {
        final List<Map<String, dynamic>> activeDrawer =
            result.map((lite.Result result) {
          return result.toMap();
        }).toList();
        final Switcher response =
            Switcher.fromData(activeDrawer[0]);
        log.i('data found with Id:'+id);
        return response;
      } else {
        log.i('no data found with Id:'+id);
        return Switcher();
      }
      // ignore: empty_catches
    } catch (e) {}
    return Switcher();
  }
}
