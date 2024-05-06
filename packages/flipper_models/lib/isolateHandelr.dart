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
}
