import 'dart:async';

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flipper/services/api/fake_api.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:couchbase_lite/couchbase_lite.dart' as lite;

typedef ResultSetCallback = void Function(ResultSet results);
//oct 22  443372
class CoreDB {
  CoreDB._internal();

  static final CoreDB instance = CoreDB._internal();
  final Logger log = Logging.getLogger('Core Data ....');

  String dbName = 'main';
  // ignore: always_specify_types
  List<Future> pendingListeners = [];
  ListenerToken _replicatorListenerToken;
  lite.Database database;
  Replicator replicator;
  ListenerToken _docListenerToken;
  ListenerToken _dbListenerToken;

  Future<bool> login(
      {String username, String password, List<String> channels}) async {
    try {
      database = await lite.Database.initWithName(dbName);
      // Note wss://10.0.2.2:4984/main || ws://10.0.2.2:4984/main is for the android simulator on your local machine's couchbase database
      final String gatewayUrl = DotEnv().env['GATEWAY_URL'];
      final ReplicatorConfiguration config =
          ReplicatorConfiguration(database, 'ws://$gatewayUrl/main');

      config.replicatorType = ReplicatorType.pushAndPull;
      config.continuous = true;
      config.channels = channels;

      final String username = DotEnv().env['PASSWORD'];
      final String password = DotEnv().env['USERNAME'];

      // Using self signed certificate
      //config.pinnedServerCertificate = 'assets/cert-android.cer';
      config.authenticator = BasicAuthenticator(username, password);
      replicator = Replicator(config);

      replicator.addChangeListener((ReplicatorChange event) {
        if (event.status.error != null) {
          log.d('Error: ' + event.status.error);
        }
        log.i(event.status.activity.toString());
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
            final table = document.getString('table');
            log.i('update::table::$table');
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

  Future<void> initialAppData() async {
    // ignore: always_specify_types
    final bool isAppConstantsInitialized =
        await ProxyService.sharedPref.isAppConstantsInitialized();
    if (!isAppConstantsInitialized) {
      for (int i = 0; i < mockUnits.length; i++) {
        if (mockUnits[i]['value'] == 'kg') {
          database.saveDocument(MutableDocument(
              data: {'name': mockUnits[i]['name'], 'focused': true}));
        } else {
          database.saveDocument(MutableDocument(
              data: {'name': mockUnits[i]['name'], 'focused': false}));
        }
      }
    }
  }
}
