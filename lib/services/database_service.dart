import 'dart:async';

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/couchbase.dart';
import 'package:flipper/data/observable_response.dart';
import 'package:flipper/home/open_close_drawerview.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

// this calss is about to replace AppDatabase class used for experimental
// query example: https://github.com/SaltechSystems/couchbase_lite/blob/master/example/lib/data/database.dart
class DatabaseService {
  final Logger log = Logging.getLogger('Database service  Model ....');
  final Database dbInstance = AppDatabase.instance.database;
  // ignore: always_specify_types
  List<Future> pendingListeners = [];
  @deprecated //use insert and update function no need to define every action functons here
  Future<void> saveDrawerHistory({
    double float,
    String note,
    String businessId,
    String userId,
    BusinessState businessState,
  }) async {
    // ignore: always_specify_types
    final Map<String, dynamic> businessMap = {
      'float': float,
      'businessState': businessState == BusinessState.OPEN ? 'Open' : 'Close',
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
  @deprecated
  Future<void> openCloseBusiness({
    String userId,
    String name,
    bool isSocial = false,
    String businessId,
    bool isClosed = true,
  }) async {
    final Document document =
        await AppDatabase.instance.database.document(userId);

    final Map<String, dynamic> buildMap = {
      'tableName': 'switcher_' + userId,
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
      } on PlatformException {}
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
  Future<dynamic> getById({String id}) async {
    return await dbInstance.document(id);
  }

  // A filter query to look for a document muck like select * from where name =sth and email =sth
  Future<List<Map<String, dynamic>>> filter(
      {String property,
      String equator,
      String andProperty,
      String andEquator,
      bool and=false}) async {
    // ignore: always_specify_types
    Where query;
    if (!and) {
      query = QueryBuilder.select([SelectResult.all()])
          .from(AppDatabase.instance.dbName)
          .where(
            Expression.property(property).equalTo(
              Expression.string(equator),
            ),
          );
    } else {
      query = QueryBuilder.select([SelectResult.all()])
          .from(AppDatabase.instance.dbName)
          .where(
            Expression.property(property)
                .equalTo(
                  Expression.string(equator),
                )
                .add(
                  Expression.property(andProperty).equalTo(
                    Expression.string(andEquator),
                  ),
                ),
          );
    }
    final ResultSet result = await query.execute();
    final List<Map<String, dynamic>> model = result.map((Result result) {
      return result.toMap();
    }).toList();
    
    return model; 
  }

  Future<bool> update({Document document}) async {
    return await AppDatabase.instance.database.saveDocument(document);
  }

  Future<Document> insert({String id, Map  data}) async {
    log.d(data);
    final MutableDocument newDoc =
        MutableDocument(id: id??Uuid().v1(), data: data);
    await AppDatabase.instance.database.saveDocument(newDoc);
    return newDoc;
  }

  ObservableResponse<ResultSet> observer({String property, String equator}) {
    final BehaviorSubject<ResultSet> stream = BehaviorSubject<ResultSet>();
    // Execute a query and then post results and all changes to the stream

    final Where query = QueryBuilder.select([SelectResult.all()])
        .from(AppDatabase.instance.dbName)
        .where(
            Expression.property(property).equalTo(Expression.string(equator)));

    final Null Function(ResultSet results) processResults =
        (ResultSet results) {
      if (!stream.isClosed) {
        stream.add(results);
      }
    };
    
    return _buildObservableQueryResponse(stream, query, processResults);
  }

  ObservableResponse<T> _buildObservableQueryResponse<T>(
      BehaviorSubject<T> subject,
      Query query,
      ResultSetCallback resultsCallback) {
    final Future<ListenerToken> futureToken =
        query.addChangeListener((QueryChange change) {
      if (change.results != null) {
        resultsCallback(change.results);
      }
    });

    final Null Function() removeListener = () {
      // ignore: always_specify_types
      final newFuture = futureToken.then((ListenerToken token) async {
        if (token != null) {
          await query.removeChangeListener(token);
        }
      });

      pendingListeners.add(newFuture);
      newFuture.whenComplete(() {
        pendingListeners.remove(newFuture);
      });
    };

    try {
      query.execute().then(resultsCallback);
    } on PlatformException {
      removeListener();
      rethrow;
    }

    return ObservableResponse<T>(subject, () {
      removeListener();
      subject.close();
    });
  }
}
