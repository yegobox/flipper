import 'dart:async';

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/core_db.dart';
import 'package:flipper/data/observable_response.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

// this class is about to replace AppDatabase class used for experimental
// query example: https://github.com/SaltechSystems/couchbase_lite/blob/master/example/lib/data/database.dart
class DatabaseService {
  final Logger log = Logging.getLogger('Database service  Model ....');
 
  // ignore: always_specify_types
  List<Future> pendingListeners = [];
  
  Future<bool> documentExist({String property, String equator}) async {
    final Where query = QueryBuilder.select([SelectResult.all()])
        .from(CoreDB.instance.dbName)
        .where(
            Expression.property(property).equalTo(Expression.string(equator)));
    final ResultSet result = await query.execute();
    return result.allResults().isNotEmpty;
  }
  // products functions
 
  Future<Document> getById({String id}) async {
    return await CoreDB.instance.database.document(id);
  }

  // A filter query to look for a document muck like select * from where name =sth and email =sth
  Future<List<Map<String, dynamic>>> filter(
      {String property,
      String equator,
      String andProperty,
      String andEquator,
      bool and = false}) async {
    // ignore: always_specify_types
    Where query;
    if (!and) {
      query = QueryBuilder.select([SelectResult.all()])
          .from(CoreDB.instance.dbName)
          .where(
            Expression.property(property).equalTo(
              Expression.string(equator),
            ),
          );
    } else {
      query = QueryBuilder.select(
        [
          SelectResult.all()
        ])
          .from(CoreDB.instance.dbName)
          .where(Expression.property(property)
                .equalTo(
                  Expression.value(equator),
                )
                // This was not working so a workaround is to map where the second Equator is
                .add(
                  Expression.property(andProperty).equalTo(
                    Expression.value(andEquator),
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
    return await CoreDB.instance.database.saveDocument(document);
  }

  Future<Document> insert({String id, Map data}) async {
    final String _id = id ?? Uuid().v1();
    final MutableDocument newDoc =
        MutableDocument(id: _id, data: data);
    await CoreDB.instance.database.saveDocument(newDoc);
    final Document document = await getById(id: _id);
    assert(document !=null);
    return document;
  }

  ObservableResponse<ResultSet> observer({
    String property,
    String equator,
    String andProperty,
    String andEquator,
    bool and = false,
  }) {
    final BehaviorSubject<ResultSet> stream = BehaviorSubject<ResultSet>();
    // Execute a query and then post results and all changes to the stream
    Where query;
    if (!and) {
      query = QueryBuilder.select([SelectResult.all()])
          .from(CoreDB.instance.dbName)
          .where(
            Expression.property(property).equalTo(
              Expression.string(equator),
            ),
          );
    } else {
      query = QueryBuilder.select([SelectResult.all()])
          .from(CoreDB.instance.dbName)
          .where(
            Expression.property(property)
                .equalTo(
                  Expression.string(equator),
                )
                .and(
                  Expression.property(andProperty).equalTo(
                    Expression.string(andEquator),
                  ),
                ),
          );
    }
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
