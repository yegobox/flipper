import 'dart:isolate';

import 'package:flipper_models/mixins/EBMHandler.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/secrets.dart';

import 'package:realm/realm.dart';

import 'package:flutter/services.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
    int tinNumber = args[5] as int;
    String bhfId = args[6] as String;
    List<int> encryptionKey = key.toIntList();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final app = App.getById(AppSecrets.appId);
    final user = app?.currentUser!;
    FlexibleSyncConfiguration config =
        realmConfig(user, encryptionKey, dbPatch);

    final realm = Realm(config);

    await syncUnsynced(args);

    // load all variants
    List<Variant> variants = realm.all<Variant>().toList();
    final talker = TalkerFlutter.init();
    await realm.writeAsync(() async {
      for (Variant variant in variants) {
        if (!variant.ebmSynced) {
          try {
            variant.tin = tinNumber;
            variant.bhfId = bhfId;
            talker.info("saving Variant on EBM server ${variant.tin}");
            await RWTax().saveItem(variation: variant);
            variant.ebmSynced = true;
            realm.add<Variant>(variant, update: true);
          } catch (e, s) {
            talker.info("failed to save Variant on EBM server");
            talker.error(s);
            EBMHandler().handleNotificationMessaging(e);
            variant.ebmSynced = false;

            realm.add<Variant>(variant, update: true);
          }
        }
      }
    });
    // load all stock
    List<Stock> stocks = realm.all<Stock>().toList();
    realm.writeAsync(() async {
      for (Stock stock in stocks) {
        if (!stock.ebmSynced) {
          try {
            Variant variant = realm.query<Variant>(
              r'id == $0 AND deletedAt == nil',
              [stock.variantId],
            ).first;
            stock.tin = tinNumber;
            stock.bhfId = bhfId;
            await RWTax().saveStock(stock: stock, variant: variant);
            stock.ebmSynced = true;
            realm.add<Stock>(stock, update: true);
          } catch (e, s) {
            talker.error(s);
            EBMHandler().handleNotificationMessaging(e);
            stock.ebmSynced = false;
            realm.add<Stock>(stock, update: true);
          }
        }
      }
    });
    // load all customer
    List<Customer> customers = realm.all<Customer>().toList();
    realm.writeAsync(() async {
      for (Customer customer in customers) {
        if (!customer.ebmSynced) {
          try {
            customer.tin = tinNumber;
            customer.bhfId = bhfId;
            await RWTax().saveCustomer(customer: customer);
            customer.ebmSynced = true;
            realm.add<Customer>(customer, update: true);
          } catch (e) {
            EBMHandler().handleNotificationMessaging(e);
            customer.ebmSynced = false;
            realm.add<Customer>(customer, update: true);
          }
        }
      }
    });
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
