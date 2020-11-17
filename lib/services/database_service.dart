import 'dart:async';
import 'dart:io';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper/services/api/fake_api.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final Logger log = Logging.getLogger('Database:');

  // ignore: always_specify_types
  List<Future> pendingListeners = [];

  // ignore: prefer_typing_uninitialized_variables
  var db;

  Future login({List<String> channels}) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    // ignore: prefer_single_quotes
    db = Database("main", directory: appDocPath);


    final String gatewayUrl = DotEnv().env['GATEWAY_URL'];
    final String username = DotEnv().env['USERNAME'];
    final String password = DotEnv().env['PASSWORD'];

    // final replicator = Replicator(
    //   db,
    //   endpointUrl: 'ws://$gatewayUrl/main/',
    //   username: username,
    //   password: password, // or
    //   // 'sessionId': 'dfhfsdyf8dfenfajfoadnf83c4dfhdfad3228yrsefd',
    // );

    // // Set up a status listener
    // replicator.addChangeListener((status) {
    //   print('Replicator status: ' + status.activityLevel.toString());
    // });
    // if(channels!=null){
    //   replicator.channels = channels;
    // }
    // // Start the replicator
    // replicator.start();
  }

  Document getById({@required String id}) {
    return db.getMutableDocument(id);
  }

  Future<bool> update({@required Document document}) async {
    return await db.saveDocument(document);
  }

  Document insert({String id, Map data}) {
    final _id = id ?? Uuid().v1();
    final doc = Document(_id, data: data);
    return db.saveDocument(doc);
  }

  // initializers
  Future<void> initialAppData() async {
    // ignore: always_specify_types
    final bool isAppConstantsInitialized =
        await ProxyService.sharedPref.isAppConstantsInitialized();
    if (!isAppConstantsInitialized) {
      for (int i = 0; i < mockUnits.length; i++) {
        if (mockUnits[i]['value'] == 'kg') {
          insert(data: {'name': mockUnits[i]['name'], 'focused': true});
        } else {
          insert(data: {'name': mockUnits[i]['name'], 'focused': false});
        }
      }
    }
  }
}
