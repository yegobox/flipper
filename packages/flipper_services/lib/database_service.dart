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
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/shared_state_service.dart';

class DatabaseService {
  final Logger log = Logging.getLogger('Database:');
  final _state = locator<SharedStateService>();
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
    if (!db.isOpen) {
      db.open();
    }
    final FlipperConfig flipperConfig =
        await ProxyService.firestore.getConfigs();
    if (flipperConfig == null) {
      return null;
    }
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

  // purgeDocument
  bool delete({String id}) {
    return db.purgeDocument(id);
    // ProxyService.pusher.syncToClients();
  }

  Document insert({String id, Map data}) {
    final _id = id ?? Uuid().v1();
    final doc = Document(_id, data: data);
    final datas = db.saveDocument(doc);
    ProxyService.pusher.syncToClients();
    return datas;
  }

  void createCustomItem(
      {@required String branchId, @required String userId, String businessId}) {
    final id1 = Uuid().v1();
    final Document productDoc = insert(id: id1, data: {
      'name': 'Custom Amount',
      'categoryId': '',
      'color': '#955be9',
      'id': id1,
      'active': true,
      'hasPicture': false,
      'channels': [userId],
      'table': AppTables.product,
      'isCurrentUpdate': false,
      'isDraft': true,
      'taxId': '',
      'businessId': businessId,
      'branchId': branchId,
      'description': 'Custom Amount',
      'createdAt': DateTime.now().toIso8601String(),
    });
    // create it's regular
    final variantId = Uuid().v1();
    insert(id: variantId, data: {
      'isActive': false,
      'name': 'Regular',
      'unit': 'kg',
      'channels': [userId],
      'table': AppTables.variation,
      'productId': productDoc.ID,
      'sku': Uuid().v1().substring(0, 4),
      'id': variantId,
      'userId': userId,
      'productName': 'Custom Amount',
      'createdAt': DateTime.now().toIso8601String(),
    });
    // create it's stock
    final id3 = Uuid().v1();

    insert(id: id3, data: {
      'variantId': variantId,
      'supplyPrice': 0.0,
      'value': 0.0,
      'canTrackingStock': false,
      'showLowStockAlert': false,
      'retailPrice': 0.0,
      'channels': [userId],
      'isActive': true,
      'table': AppTables.stock,
      'lowStock': 0.0,
      'currentStock': 0.0,
      'id': id3,
      'productId': productDoc.ID,
      'branchId': branchId,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // initializer
  Future<void> initialAppData(
      {@required String branchId,
      @required String userId,
      String businessId}) async {
    // ignore: always_specify_types
    final bool isAppConstantsInitialized =
        await ProxyService.sharedPref.isAppConstantsInitialized();
    if (!isAppConstantsInitialized) {
      // create a custom item
      createCustomItem(
          branchId: branchId, userId: userId, businessId: businessId);
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

  /// logout and close a database
  /// this need to be fine tuned as sometime it cause the app
  /// to crash so it need to be restarted again.
  void logout({dynamic context}) {
    if (db.isOpen) {
      replicator.stop();
      db.close();
      _state.setDidLogout(logout: true);
    }
  }

  /// given a variantId return a stock related to it
  /// if no stock which nealy impossible then return null
  String getStockIdGivenVariantId({String variantId}) {
    final q = Query(db, 'SELECT  id WHERE table=\$T AND variantId=\$variantId');
    q.parameters = {'T': AppTables.stock, 'variantId': variantId};
    final results = q.execute();
    if (results.isEmpty) return null;
    return results[0]['id'];
  }

  /// given that we only have one Custom Amount product in system
  /// we query the product where name=Custom Amount and use the id to get its variant
  Document getCustomProductVariant() {
    final q =
        Query(db, 'SELECT  id,name WHERE table=\$T AND name=\$NAME LIMIT 1');
    q.parameters = {'T': AppTables.product, 'NAME': 'Custom Amount'};

    // get this product then use it's id to get related variant
    final results = q.execute();
    if (results.isEmpty) return null;

    final qq = Query(db, 'SELECT  id WHERE table=\$T AND productId=\$P');
    qq.parameters = {'T': AppTables.variation, 'P': results[0]['id']};
    final result = qq.execute();
    return getById(id: result[0]['id']);
  }
}
