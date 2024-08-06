// ignore: unused_import
import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';

import 'package:talker_flutter/talker_flutter.dart';

//
mixin Subscriptions {
  Future<void> updateSubscription({
    int? branchId,
    int? businessId,
    int? userId,
    Realm? realm,
    Realm? localRealm,
  }) async {
    final talker = TalkerFlutter.init();
    if (realm == null) return;

    // Collect current subscription names
    final existingSubscriptions = <String>{};
    for (Subscription sub in realm.subscriptions) {
      existingSubscriptions.add(sub.name!);
    }

    // Log current subscriptions
    existingSubscriptions
        .forEach((name) => talker.info("Existing Sub: ${name}"));

    if (businessId == null || branchId == null || userId == null) return;

    // Define queries with unique names
    final queries = {
      'transactionItem-$branchId':
          realm.query<TransactionItem>(r'branchId == $0', [branchId]),
      'product-$branchId': realm.query<Product>(r'branchId == $0', [branchId]),
      'variant-$branchId': realm.query<Variant>(r'branchId == $0', [branchId]),
      'unit-$branchId': realm.query<IUnit>(r'branchId == $0', [branchId]),
      'counter-$branchId': realm.query<Counter>(r'branchId == $0', [branchId]),
      'customer-$branchId':
          realm.query<Customer>(r'branchId == $0', [branchId]),
      'category-$branchId':
          realm.query<Category>(r'branchId == $0', [branchId]),
      'colors-$branchId': realm.all<PColor>(),
      'devices-$branchId': realm.query<Device>(r'branchId == $0', [branchId]),
      'transaction-$branchId':
          realm.query<ITransaction>(r'branchId == $0', [branchId]),
      'conversations-$businessId':
          realm.query<Conversation>(r'businessId == $0', [businessId]),
      'ebms-$businessId': realm.query<EBM>(r'businessId == $0', [businessId]),
      'receipts-$branchId': realm.query<Receipt>(r'branchId == $0', [branchId]),
      'units-$branchId': realm.query<IUnit>(r'branchId == $0', [branchId]),
      'permission-$userId': realm.query<LPermission>(r'userId == $0', [userId]),
      'pin-${ProxyService.box.getUserId()}': realm.query<Pin>(
          r'userId == $0', [ProxyService.box.getUserId()?.toString()]),
      'token-$businessId':
          realm.query<Token>(r'businessId == $0', [businessId]),
      'tenant-$businessId':
          realm.query<Tenant>(r'businessId == $0', [businessId]),
      'favorites-$branchId':
          realm.query<Favorite>(r'branchId == $0', [branchId]),
      'drawers-$userId': realm.query<Drawers>(r'cashierId == $0', [userId]),
      'configs-$branchId':
          realm.query<Configurations>(r'branchId == $0', [branchId]),
      'assets-$branchId': realm.query<Assets>(r'branchId == $0', [branchId]),
      'composites-$branchId':
          realm.query<Composite>(r'branchId == $0', [branchId]),
      'skus-$branchId': realm.query<SKU>(r'branchId == $0', [branchId]),
      'report-$branchId': realm.query<Report>(r'branchId == $0', [branchId]),
      'computed-$branchId':
          realm.query<Computed>(r'branchId == $0', [branchId]),
      'access-$businessId':
          realm.query<Access>(r'businessId == $0', [businessId]),
      'requests-$branchId': realm.query<StockRequest>(
          r'mainBranchId == $0 || subBranchId == $1', [branchId, branchId]),
    };

    // Update subscriptions
    realm.subscriptions.update((MutableSubscriptionSet mutableSubscriptions) {
      queries.forEach((name, query) {
        if (!existingSubscriptions.contains(name)) {
          talker.warning("Registered subscription ${name}");
          mutableSubscriptions.add(query, name: name, update: true);
        }
      });

      if (localRealm != null) {
        List<Branch> branches = localRealm
            .query<Branch>(r'businessId == $0', [businessId]).toList();
        for (Branch branch in branches) {
          final branchStock =
              realm.query<Stock>(r'branchId == $0', [branch.serverId]);
          final branchName = 'branch_${branch.serverId}_stock';
          if (!existingSubscriptions.contains(branchName)) {
            mutableSubscriptions.add(branchStock,
                name: branchName, update: true);
          }
        }
      }

      // Remove old subscriptions that are no longer needed
      // existingSubscriptions.forEach((name) {
      //   if (!queries.containsKey(name)) {
      //     mutableSubscriptions.remove(name);
      //   }
      // });
    });
  }
}
