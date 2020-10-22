import 'dart:async';

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/services/api/fake_api.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/services/database_service.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:couchbase_lite/couchbase_lite.dart' as lite;

import 'domain/redux/app_state.dart';

typedef ResultSetCallback = void Function(ResultSet results);


class AppDatabase {
  AppDatabase._internal();

  static final AppDatabase instance = AppDatabase._internal();
  final Logger log = Logging.getLogger('Old Database service ....');

  String dbName = 'main';
  // ignore: always_specify_types
  List<Future> pendingListeners = [];
  ListenerToken _replicatorListenerToken;
  lite.Database database;
  Replicator replicator;
  ListenerToken _docListenerToken;
  ListenerToken _dbListenerToken;

  @deprecated
  Future<Document> createDocumentIfNotExists(
      String id, Map<String, dynamic> map) async {
    try {
      final Document oldDoc = await database.document(id);
      if (oldDoc != null) {
        return oldDoc;
      }

      final MutableDocument newDoc =
          MutableDocument(id: id, data: map);
      if (await database.saveDocument(newDoc)) {
        return newDoc;
      } else {
        return null;
      }
    } on PlatformException {
      return null;
    }
  }

  Future<bool> login(
      {String username, String password, List<String> channels}) async {
    try {
      database = await lite.Database.initWithName(dbName);
      // Note wss://10.0.2.2:4984/main is for the android simulator on your local machine's couchbase database
      final String gatewayUrl = DotEnv().env['GATEWAY_URL'];
      final ReplicatorConfiguration config =
          ReplicatorConfiguration(database, 'ws://$gatewayUrl/main');

      config.replicatorType = ReplicatorType.pushAndPull;
      config.continuous = true;
      config.channels = channels;

      final String username = DotEnv().env['PASSWORD'];
      final String password = DotEnv().env['USERNAME'];
      log.d('username:' + username);
      log.d('password:' + password);
      // Using self signed certificate
      //config.pinnedServerCertificate = 'assets/cert-android.cer';
      // config.authenticator = BasicAuthenticator(username, password);
      replicator = Replicator(config);

      replicator.addChangeListener((ReplicatorChange event) {
        if (event.status.error != null) {
          print('Error: ' + event.status.error);
        }
        print(event.status.activity.toString());
      });

      await replicator.start();

      const String indexName = 'TypeNameIndex';
      final List<String> indices = await database.indexes;
      if (!indices.contains(indexName)) {
        final ValueIndex index = IndexBuilder.valueIndex(items: [
          ValueIndexItem.property('type'),
          ValueIndexItem.expression(Expression.property('name'))
        ]);
        await database.createIndex(index, withName: indexName);
      }

      _dbListenerToken =
          database.addChangeListener((DatabaseChange dbChange) async {
        for (String id in dbChange.documentIDs) {
         
          final Document document = await database.document(id);
          //until we save document right in all place keep this code here to keep things smooth.
          if (document != null && !document.getBoolean('touched')) {
            log.d('change in id: $id');
            //only update once to avoid infinite loop
            log.i('updated non touched document,we update the document to make the id be usable for update');
            final MutableDocument mutableDoc = document
                .toMutable()
                .setBoolean('touched', true)
                .setString(
                  'id',
                  id,
                ); //to make sure that the id that is in doc is the one we can use to make update about a single doc, this is a work around as we can not have id in a simple way
            database.saveDocument(mutableDoc);
          }
        }
      });

      return true;
    } on PlatformException {
      return false;
    }
  }

  Future<void> logout() async {
    await Future.wait(pendingListeners);

    await database.removeChangeListener(_docListenerToken);
    await database.removeChangeListener(_dbListenerToken);
    _docListenerToken = null;
    _dbListenerToken = null;

    await replicator.removeChangeListener(_replicatorListenerToken);
    _replicatorListenerToken =
        replicator.addChangeListener((ReplicatorChange event) async {
      if (event.status.activity == ReplicatorActivityLevel.stopped) {
        await database.close();
        await replicator.removeChangeListener(_replicatorListenerToken);
        await replicator.dispose();
        _replicatorListenerToken = null;
      }
    });
    await replicator.stop();
  }

  @deprecated
  Future<void> createUser(Map map) async {
    assert(map['_id'] != null);
    assert(map['name'] != null);
    assert(map['channels'] != null);
    assert(map['token'] != null);
    assert(map['id'] != null);
    assert(map['active'] != null);
    assert(map['email'] != null);
    assert(map['createdAt'] != null);
    assert(map['updatedAt'] != null);

    // ignore: always_specify_types
    final DatabaseService _databaseService = ProxyService.database;
    _databaseService.insert(id:map['id'],data:map);
  }
 
  Future<void> initialAppData() async {
    // ignore: always_specify_types
    // TODO: should add initial data only once!
    for (int i = 0; i < mockUnits.length; i++) {
     
      if (mockUnits[i]['value'] == 'kg') {
         database.saveDocument(MutableDocument(data:{'name':mockUnits[i]['name'],'focused': true}));
      } else {
        database.saveDocument(MutableDocument(data:{'name':mockUnits[i]['name'],'focused': false}));
      }
    }
  }
 
}
