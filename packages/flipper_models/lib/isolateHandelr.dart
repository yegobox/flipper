import 'dart:isolate';

import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/secrets.dart';

import 'package:realm/realm.dart';

import 'package:flutter/services.dart';

mixin IsolateHandler {
  static Future<void> syncUnsynced(List<dynamic> args) async {
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = Realm(config);

    await realm.subscriptions.waitForSynchronization();
  }

  static Future<void> handleEBMTrigger(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;

    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = Realm(config);

    do {
      // load all variants
      List<Variant> variants = realm.all<Variant>().toList();

      // await isar.writeTxn(() async => isar.variants.where().findAll());
      for (Variant variant in variants) {
        if (!variant.ebmSynced) {
          try {
            RWTax().saveItem(variation: variant);
            variant.ebmSynced = true;
            realm.write(() async => realm.add<Variant>(variant));
          } catch (e) {
            EBMHandler().handleNotificationMessaging(e);
            variant.ebmSynced = false;
            realm.write(() async => realm.add<Variant>(variant));
          }
        }
      }
      // load all stock
      List<Stock> stocks = realm.all<Stock>().toList();

      for (Stock stock in stocks) {
        if (!stock.ebmSynced) {
          try {
            RWTax().saveStock(stock: stock);
            stock.ebmSynced = true;
            realm.write(() async => realm.add<Stock>(stock));
          } catch (e) {
            EBMHandler().handleNotificationMessaging(e);
            stock.ebmSynced = false;
            realm.write(() async => realm.add<Stock>(stock));
          }
        }
      }
      // load all customer
      List<Customer> customers = realm.all<Customer>().toList();
      ;
      for (Customer customer in customers) {
        if (!customer.ebmSynced) {
          try {
            RWTax().saveCustomer(customer: customer);
            customer.ebmSynced = true;
            realm.write(() async => realm.add<Customer>(customer));
          } catch (e) {
            EBMHandler().handleNotificationMessaging(e);
            customer.ebmSynced = false;
            realm.write(() async => realm.add<Customer>(customer));
            ;
          }
        }
      }
    } while (true);
  }

  static Future handleCounters(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final sendPort = args[1] as SendPort;
    final branchId = args[2] as int;
    final dbPatch = args[3] as String;
    String key = args[4] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = Realm(config);
    final iCountersCollection =
        realm.query<Counter>(r'branchId == $0', [branchId]);

    await for (final changes in iCountersCollection.changes) {
      for (final result in changes.results) {
        handlecounter(result, sendPort);
      }
    }
  }

  static Future<void> handlecounter(Counter result, SendPort sendPort) async {
    // FlexibleSyncConfiguration config =
    //     realmConfig(user, encryptionKey, dbPatch);

    // final realm = Realm(config);
    // // final iCountersCollection =
    // //     realm.query<Counter>(r'branchId == $0', [branchId]);

    // result.action = AppActions.synchronized;
    // Counter? localTransaction = realm.query<Counter>(
    // r'receiptType == $0', [result.receiptType!.toUpperCase()]).firstOrNull;
    // await isar.counters
    //     .filter()
    //     .receiptTypeEqualTo(result.receiptType!.toUpperCase())
    //     .findFirst();

    // }
  }

  static FlexibleSyncConfiguration realmConfig(
    User? user,
    List<int> encryptionKey,
    String dbPatch,
  ) {
    final config = Configuration.flexibleSync(
      user!,
      realmModels,
      encryptionKey: encryptionKey,
      path: dbPatch,
    );
    return config;
  }

  /// receive data from realm, spwan new isolate
  /// https://stackoverflow.com/questions/71746186/multiple-isolates-vs-one-isolate
  /// ---->call the realm function that start everything in the isolate
  /// this is a function
  /// compute(onSave, 10000).then(() {
  ///print('isolate finished');
  ///});
  /// within also have the isar as required also initiated at the same tim
  /// in isolate
}
