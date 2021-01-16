library flipper_services;

import 'dart:async';
import 'dart:io';

import 'package:couchbase_lite_dart/couchbase_lite_dart.dart';
import 'package:flipper_services/api/fake_api.dart';
import 'package:flipper_services/constant.dart';
import 'package:flipper_services/flipper_config.dart';
import 'package:flipper_services/logger.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final Logger log = Logging.getLogger('Database:');

  // ignore: always_specify_types
  List<Future> pendingListeners = [];

  // ignore: prefer_typing_uninitialized_variables
  Database db;
  Replicator replicator;

  Future login({List<String> channels}) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    // ignore: prefer_single_quotes
    db = Database("main", directory: appDocPath);

    final FlipperConfig flipperConfig =
        await ProxyService.firestore.getConfigs();

    final String gatewayUrl = flipperConfig.gateway;
    final String username = flipperConfig.username;
    final String password = flipperConfig.password;
    assert(gatewayUrl != null);
    assert(username != null);
    assert(password != null);
    if (channels != null) {
      replicator = Replicator(
        db,
        endpointUrl: 'ws://$gatewayUrl/main/',
        username: username,
        password: password,
        channels: channels,
      );

      // Set up a status listener
      replicator.addChangeListener((status) {
        print('Replicator status: ' + status.activityLevel.toString());
      });
      replicator.continuous = true;
      replicator.replicatorType = ReplicatorType.pushAndPull;

      // Start the replicator
      replicator.start();
    }
  }

  Document getById({@required String id}) {
    return db.getMutableDocument(id);
  }

  Document update({@required Document document}) {
    final data = db.saveDocument(document);
    ProxyService.pusher.syncToClients();
    return data;
  }

  Document insert({String id, Map data}) {
    final _id = id ?? Uuid().v1();
    final doc = Document(_id, data: data);
    final datas = db.saveDocument(doc);
    ProxyService.pusher.syncToClients();
    return datas;
  }

  // initializer
  Future<void> initialAppData(
      {@required String branchId, @required String userId}) async {
    // ignore: always_specify_types
    final bool isAppConstantsInitialized =
        await ProxyService.sharedPref.isAppConstantsInitialized();
    if (!isAppConstantsInitialized) {
      for (int i = 0; i < mockUnits.length; i++) {
        final String id = Uuid().v1();
        if (mockUnits[i]['value'] == 'kg') {
          insert(id: id, data: {
            'id': id,
            'name': mockUnits[i]['name'],
            'branchId': branchId,
            'table': AppTables.unit,
            'channels': [userId],
            'focused': true
          });
        } else {
          insert(id: id, data: {
            'id': id,
            'name': mockUnits[i]['name'],
            'branchId': branchId,
            'table': AppTables.unit,
            'channels': [userId],
            'focused': false
          });
        }
      }
    }
  }

  void logout({dynamic context}) {
    if (db.isOpen) {
      replicator.stop();
      db.close();
      // StoreProvider.of<AppState>(context).dispatch(
      //   VerifyAuthenticationState(),
      // );
    }
  }
}
