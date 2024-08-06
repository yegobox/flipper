// ignore: unused_import
import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';

import 'package:talker_flutter/talker_flutter.dart';

mixin Subscriptions {
  
  Future<void> updateSubscription(
      {int? branchId,
      int? businessId,
      int? userId,
      Realm? realm,
      Realm? localRealm}) async {
    final talker = TalkerFlutter.init();
    for (Subscription sub in realm!.subscriptions) {
      talker.warning(sub.name);
    }

    if (businessId == null || branchId == null || userId == null) return;
    //https://www.mongodb.com/docs/realm/sdk/flutter/sync/manage-sync-subscriptions/
    final transactionItem =
        realm.query<TransactionItem>(r'branchId == $0', [branchId]);
    final product = realm.query<Product>(r'branchId == $0', [branchId]);
    final variant = realm.query<Variant>(r'branchId == $0', [branchId]);

    final unit = realm.query<IUnit>(r'branchId == $0', [branchId]);
    final counter = realm.query<Counter>(r'branchId == $0', [branchId]);

    final customer = realm.query<Customer>(r'branchId == $0', [branchId]);
    final category = realm.query<Category>(r'branchId == $0', [branchId]);
    final colors = realm.all<PColor>();
    final devices = realm.query<Device>(r'branchId == $0', [branchId]);

    final transaction =
        realm.query<ITransaction>(r'branchId == $0', [branchId]);

    final conversations =
        realm.query<Conversation>(r'businessId == $0', [businessId]);

    final ebms = realm.query<EBM>(r'businessId == $0', [businessId]);

    final receipts = realm.query<Receipt>(r'branchId == $0', [branchId]);
    final units = realm.query<IUnit>(r'branchId == $0', [branchId]);
    final permission = realm.query<LPermission>(r'userId == $0', [userId]);

    final pin = realm.query<Pin>(
        r'userId == $0', [ProxyService.box.getUserId()?.toString()]);

    // fake subscription as I normally do not these model synced across devices but I don't know how I can pause one model
    final token = realm.query<Token>(r'businessId == $0', [businessId]);
    final tenant = realm.query<Tenant>(r'businessId == $0', [businessId]);
    final favorites = realm.query<Favorite>(r'branchId == $0', [branchId]);
    final drawers = realm.query<Drawers>(r'cashierId == $0', [userId]);
    final configs = realm.query<Configurations>(r'branchId == $0', [branchId]);
    final assets = realm.query<Assets>(r'branchId == $0', [branchId]);
    final composites = realm.query<Composite>(r'branchId == $0', [branchId]);
    final skus = realm.query<SKU>(r'branchId == $0', [branchId]);
    final report = realm.query<Report>(r'branchId == $0', [branchId]);
    final computed = realm.query<Computed>(r'branchId == $0', [branchId]);
    final access = realm.query<Access>(r'businessId == $0', [businessId]);
    final requests = realm.query<StockRequest>(
        r'mainBranchId == $0 || subBranchId == $1', [branchId, branchId]);

    /// because we receive stock request from sub branches and
    /// in the process of giving stock to a sub branches we assign new stock object
    /// to a sub branch if the sub branch does not have stock with same variantId
    /// and we don't want to create new object everytime a sub branch request new stock
    /// we want to maintain the stock object with same variant then we need to update the existing stock object
    /// hence because at main branch we might now have stocks of sub branches it is the reason why we need to subscribe
    /// to all sub branches and main branch stock
    if (localRealm != null) {
      List<Branch> branches =
          localRealm.query<Branch>(r'businessId == $0 ', [businessId]).toList();
      for (Branch branch in branches) {
        final branchStock =
            realm.query<Stock>(r'branchId == $0', [branch.serverId]);
        realm.subscriptions.update((mutableSubscriptions) {
          mutableSubscriptions.add(branchStock,
              name: 'branch_${branch.serverId}_stock', update: true);
        });
      }
    }

    requests.unsubscribe();

    /// https://www.mongodb.com/docs/atlas/device-sdks/sdk/flutter/sync/manage-sync-subscriptions/
    /// First unsubscribe
    // drawers.unsubscribe();
    // token.unsubscribe();
    // tenant.unsubscribe();
    // permission.unsubscribe();
    // pin.unsubscribe();
    // units.unsubscribe();
    // receipts.unsubscribe();
    // favorites.unsubscribe();
    // ebms.unsubscribe();
    // devices.unsubscribe();
    // conversations.unsubscribe();
    // colors.unsubscribe();
    // category.unsubscribe();
    // customer.unsubscribe();
    // receipts.unsubscribe();
    // receipts.unsubscribe();
    // devices.unsubscribe();
    // transaction.unsubscribe();
    // End of unsubscribing

    realm.subscriptions.update((MutableSubscriptionSet mutableSubscriptions) {
      mutableSubscriptions.add(access, name: "access", update: true);
      mutableSubscriptions.add(composites, name: "composites", update: true);
      mutableSubscriptions.add(computed, name: "computed", update: true);
      mutableSubscriptions.add(drawers, name: "drawers", update: true);
      mutableSubscriptions.add(token, name: "token", update: true);
      mutableSubscriptions.add(assets, name: "assets", update: true);
      mutableSubscriptions.add(skus, name: "skus", update: true);
      mutableSubscriptions.add(report, name: "report", update: true);
      mutableSubscriptions.add(requests, name: "requests", update: true);
      mutableSubscriptions.add(permission, name: "permission", update: true);

      mutableSubscriptions.add(tenant,
          name: "tenant-${businessId}", update: true);
      // mutableSubscriptions.add(permission,
      //     name: "permission-${userId}", update: true);
      mutableSubscriptions.add(pin, name: "pin-${businessId}", update: true);
      mutableSubscriptions.add(units,
          name: "units-${businessId}", update: true);
      mutableSubscriptions.add(receipts,
          name: "receipts-${businessId}", update: true);
      mutableSubscriptions.add(favorites,
          name: "favorites-${branchId}", update: true);
      mutableSubscriptions.add(ebms, name: "ebms-${businessId}", update: true);
      mutableSubscriptions.add(devices,
          name: "devices-${businessId}", update: true);
      mutableSubscriptions.add(conversations,
          name: "conversations-${businessId}", update: true);
      mutableSubscriptions.add(colors,
          name: "colors-${businessId}", update: true);
      mutableSubscriptions.add(category,
          name: "category-${businessId}", update: true);
      mutableSubscriptions.add(customer,
          name: "iCustomer-${branchId}", update: true);
      mutableSubscriptions.add(product,
          name: "iProduct-${branchId}", update: true);
      mutableSubscriptions.add(counter,
          name: "iCounter-${branchId}", update: true);
      mutableSubscriptions.add(variant,
          name: "iVariant-${branchId}", update: true);

      mutableSubscriptions.add(unit, name: "iUnit-${branchId}", update: true);
      mutableSubscriptions.add(transaction,
          name: "transaction-${branchId}", update: true);
      mutableSubscriptions.add(transactionItem,
          name: "transactionItem-${branchId}", update: true);

      mutableSubscriptions.add(configs, name: "configs", update: true);
    });
  }
}
