import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/couchbase.dart';
import 'package:flipper/home/open_close_drawerview.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

// this calss is about to replace AppDatabase class used for experimental
// query example: https://github.com/SaltechSystems/couchbase_lite/blob/master/example/lib/data/database.dart
class DatabaseService {
  final Logger log = Logging.getLogger('Database service  Model ....');

  Future<void> saveDrawerHistory({
    double float,
    String note,
    String businessId,
    String userId,
    BusinessState businessState,
  }) async {
    // ignore: always_specify_types
    final Map<String,dynamic> businessMap ={
      'float': float,
      'businessState': businessState== BusinessState.OPEN?'Open':'Close',
      'note': note,
      'businessId': businessId,
      'userId': userId,
      // ignore: always_specify_types
      'channels': [userId],
      'uid': Uuid().v1()
    };
    try {
       final MutableDocument newDoc =
        MutableDocument(id: businessId, data: businessMap);
        await AppDatabase.instance.database.saveDocument(newDoc);
    } on PlatformException {
      return 'Error saving document';
    }
  }

  Future<void> openCloseBusiness(
      {String userId,
      String name,
      bool isSocial = false,
      String businessId,
      bool isClosed = true,
      }) async {
    
    final Document document =
        await AppDatabase.instance.database.document(userId);

    final Map<String,dynamic> buildMap = {
      'tableName': 'switcher_'+userId,
      'name': name,
      'isClosed': isClosed,
      'isSocial': isSocial,
      'businessId': businessId,
      // ignore: always_specify_types
      'channels': [userId]
    };
    if (document == null) {
      try {
         final MutableDocument newDoc =
        MutableDocument(id: userId, data: buildMap);
        await AppDatabase.instance.database.saveDocument(newDoc);
      // ignore: empty_catches
      } on PlatformException {
      }
    } else {
      final MutableDocument mutableDoc =
          document.toMutable().setBoolean('isClosed', isClosed);
      AppDatabase.instance.database.saveDocument(mutableDoc);
    }
  }

  Future<bool> documentExist({String property, String equator}) async {
    final Where query = QueryBuilder.select([SelectResult.all()])
        .from(AppDatabase.instance.dbName)
        .where(
            Expression.property(property).equalTo(Expression.string(equator)));
    final ResultSet result = await query.execute();
    return result.allResults().isNotEmpty;
  }

  // products functions
  // TODO(richard): save custom product function
  // TODO(richard): getItemBy name Function
}
