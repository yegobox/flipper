import 'dart:developer';
import 'dart:core';
import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/server_definitions.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';

import 'isar_models.dart';

abstract class IJsonSerializable {
  Map<String, dynamic> toJson();
  String? lastTouched;
  DateTime? deletedAt;
  String? remoteID;
  String? action;
  int? localId;
}

class SynchronizationService<M extends IJsonSerializable>
    implements SyncApiInterface<M> {
  @override
  Future<void> push() async {
    await dirtyData();
  }

  Future<RecordModel?> _push(M model) async {
    Type modelType = model.runtimeType;
    // Use the model type to get the corresponding endpoint from the map
    String? endpoint = serverDefinitions[modelType];

    if (endpoint != null) {
      // Convert the model to JSON using the `toJson()` method
      Map<String, dynamic> json = model.toJson();

      if (endpoint == "transactions") {
        List<TransactionItem> itemOnTransaction = await ProxyService.isar
            .transactionItems(
                transactionId: json["id"], doneWithTransaction: true);
        log(itemOnTransaction.length.toString(), name: "ItemOnTransaction");
        String namesString =
            itemOnTransaction.map((item) => item.name).join(',');
        json["itemName"] = namesString;
      }

      if (endpoint == "stocks" && json["retailPrice"] == null) {
        log(json.toString(), name: "stocks");
        throw Exception("stocks has null retail price");
      }

      if (endpoint == "variants" && json["retailPrice"] == null) {
        log(json.toString(), name: "variants");
        throw Exception("variant has null retail price");
      }

      /// remove trailing dashes to sent lastTouched
      json["lastTouched"] = DateTime.now().toIso8601String();
      json["id"] = syncId();

      RecordModel? result;
      // log(json.toString());
      // Assume that `json` is a variable holding a JSON object
      //because there is a case where I might update yet there is no equivalent
      //object remote, in this case we will fallback in create
      if (json['action'] == 'update') {
        var remoteID = json["remoteID"];
        if (remoteID != null) {
          json["id"] = remoteID;
          result = await ProxyService.remote
              .update(data: json, collectionName: endpoint, recordId: remoteID);
        }
        // ignore: unnecessary_null_comparison
      } else if (json['action'] == 'create' || result == null) {
        result = await ProxyService.remote
            .create(collection: json, collectionName: endpoint);
      }

      return result;
    }
    return null;
  }

  @override
  void pull() async {
    ProxyService.remote.listenToChanges();
  }

  // The extracted function for updating and reporting transactions
  Future<void> _pushTransactions(Transaction transaction) async {
    /// fix@issue where the createdAt synced on server is older compared to when a transaction was completed.
    transaction.updatedAt = DateTime.now().toIso8601String();
    transaction.createdAt = DateTime.now().toIso8601String();

    RecordModel? variantRecord = await _push(transaction as M);
    if (variantRecord != null) {
      Transaction o = Transaction.fromRecord(variantRecord);
      o.remoteID = variantRecord.id;

      // /// keep the local ID unchanged to avoid complication
      o.id = transaction.id;

      await ProxyService.isar.update(data: o);
    }
  }

  @override
  Future<void> dirtyData() async {
    final data = await ProxyService.isar.getUnSyncedData();

    for (Transaction transaction in data.transactions) {
      await _pushTransactions(transaction);
    }
    for (Stock stock in data.stocks) {
      int stockId = stock.id!;

      RecordModel? stockRecord = await _push(stock as M);
      if (stockRecord != null) {
        Stock s = Stock.fromRecord(stockRecord);
        s.remoteID = stockRecord.id;

        /// keep the local ID unchanged to avoid complication
        s.id = stockId;
        s.action = AppActions.updated;

        await ProxyService.isar.update(data: s);
      }
    }
    for (Variant variant in data.variants) {
      int variantId = variant.id!;

      RecordModel? variantRecord = await _push(variant as M);
      if (variantRecord != null) {
        Variant va = Variant.fromRecord(variantRecord);
        va.remoteID = variantRecord.id;

        // /// keep the local ID unchanged to avoid complication
        va.id = variantId;
        va.action = AppActions.updated;
        await ProxyService.isar.update(data: va);
      }
    }

    for (Product product in data.products) {
      RecordModel? record = await _push(product as M);
      int oldId = product.id!;
      if (record != null) {
        Product product = Product.fromRecord(record);
        product.remoteID = record.id;

        /// keep the local ID unchanged to avoid complication
        product.id = oldId;
        product.action = AppActions.updated;
        await ProxyService.isar.update(data: product);
      }
    }

    for (Favorite favorite in data.favorites) {
      RecordModel? record = await _push(favorite as M);
      int oldId = favorite.id!;
      if (record != null) {
        Favorite fav = Favorite.fromRecord(record);
        fav.remoteID = record.id;

        /// keep the local ID unchanged to avoid complication
        fav.id = oldId;
        fav.action = AppActions.updated;
        await ProxyService.isar.update(data: fav);
      }
    }

    /// pushing devices
    for (Device device in data.devices) {
      RecordModel? record = await _push(device as M);
      int oldId = device.id!;
      if (record != null) {
        Device dev = Device.fromRecord(record);
        dev.remoteID = record.id;

        /// keep the local ID unchanged to avoid complication
        dev.id = oldId;
        dev.action = AppActions.updated;
        await ProxyService.isar.update(data: dev);
      }
    }
  }
}
