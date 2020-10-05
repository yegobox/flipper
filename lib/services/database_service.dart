import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/couchbase.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
// this calss is about to replace AppDatabase class used for experimental
// query example: https://github.com/SaltechSystems/couchbase_lite/blob/master/example/lib/data/database.dart
class DatabaseService{  
  final Logger log = Logging.getLogger('Database service  Model ....');

  Future<void> openBusiness({String userId,String name,bool isSocial,String businessId})async {
     //update the document set to open a business to true
     final MutableDocument mutableDoc = MutableDocument()
            .setString('userId', userId)
            .setString('id', 'switcher_'+userId)
            .setString('name', name)
            .setString('businessId', businessId)
            .setString('tableName', 'switcher_'+userId)
            .setBoolean('isClosed', false)
            .setBoolean('isSocial', isSocial)
            // ignore: always_specify_types
            .setList('channels', [userId])
            .setString('uid', Uuid().v1())
            .setString('_id',userId);
        try {
          await AppDatabase.instance.database.saveDocument(mutableDoc);
        } on PlatformException {
          return 'Error saving document';
        }
  }
  Future<void> closeBusiness({String userId,String name,bool isSocial,String businessId})async {
     //update the document set to open a business to true
     final MutableDocument mutableDoc = MutableDocument()
            .setString('userId', userId)
            .setString('name', name)
            .setString('id', 'switcher_'+userId)
            .setString('businessId', businessId)
            .setString('tableName', 'switcher_'+userId)
            .setBoolean('isClosed', true)
            .setBoolean('isSocial', isSocial)
            // ignore: always_specify_types
            .setList('channels', [userId])
            .setString('uid', Uuid().v1())
            .setString('_id',userId);
        try {
          await AppDatabase.instance.database.saveDocument(mutableDoc);
        } catch(e) {
          log.d(e);
          return 'Error saving document';
        }
   
  }
  Future<bool> documentExist({String property,String equator})async {
    final Where query = QueryBuilder.select([SelectResult.all()])
        .from(AppDatabase.instance.dbName)
        .where(Expression.property(property)
            .equalTo(Expression.string(equator)));
      final ResultSet result = await query.execute();
      return result.allResults().isNotEmpty;
  }
}