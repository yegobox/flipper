import 'dart:core';
import 'dart:developer';
import 'package:flipper_models/server_definitions.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';
import 'isar_models.dart';

abstract class IJsonSerializable {
  Map<String, dynamic> toJson();
  DateTime? lastTouched = DateTime.now();
  DateTime? deletedAt;
  String action = AppActions.create;
}

class SynchronizationService<M extends IJsonSerializable>
    implements SyncApiInterface<M> {
  @override
  Future<void> push() async {
    try {
      await localChanges();
    } catch (e) {}
  }

  Future<Map<String, dynamic>?> _push(M model) async {
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
        String namesString =
            itemOnTransaction.map((item) => item.name).join(',');
        json["itemName"] = namesString;
        if (itemOnTransaction.isEmpty)
          return null; // do not proceed if name is empty
      }

      if (endpoint == "stocks" && json["retailPrice"] == null) {
        throw Exception("stocks has null retail price");
      }

      if (endpoint == "variants" && json["retailPrice"] == null) {
        throw Exception("variant has null retail price");
      }

      /// remove trailing dashes to sent lastTouched
      final lastTouched = DateTime.now().toIso8601String();
      json["lastTouched"] = lastTouched;

      RecordModel? result = null;

      if (json['action'] == AppActions.update) {
        result = await ProxyService.remote
            .update(data: json, collectionName: endpoint, recordId: json['id']);
      } else if (json['action'] == AppActions.deleted) {
        result = await ProxyService.remote
            .update(data: json, collectionName: endpoint, recordId: json['id']);
      } else if (json['action'] == AppActions.create) {
        //change action when sending to remote to avoid pulling it next time with create
        // this means we won't perform unnecessary action on item that is neither updated,deleted or created.
        json['action'] = AppActions.nA;
        result = await ProxyService.remote
            .create(collection: json, collectionName: endpoint);
      }
      if (result != null) {
        Map<String, dynamic> updatedJson = Map.from(result.toJson());
        updatedJson['action'] = AppActions.updated;
        updatedJson['lastTouched'] = lastTouched;
        return updatedJson;
      }
    }
    return null;
  }

  @override
  void pull() async {
    ProxyService.remote.listenToChanges();
  }

  // The extracted function for updating and reporting transactions
  Future<void> _pushTransactions(ITransaction transaction) async {
    /// fix@issue where the createdAt synced on server is older compared to when a transaction was completed.
    transaction.updatedAt = DateTime.now().toIso8601String();
    transaction.createdAt = DateTime.now().toIso8601String();
    if (transaction.action != AppActions.remote) {
      Map<String, dynamic>? variantRecord = await _push(transaction as M);
      if (variantRecord != null && variantRecord.isNotEmpty) {
        ITransaction trans = ITransaction.fromJson(variantRecord);

        /// keep the local ID unchanged to avoid complication
        trans.id = transaction.id;
        trans.action = AppActions.remote;

        await ProxyService.isar.update(data: trans);
      }
    }
  }

  @override
  Future<void> localChanges() async {
    log('pushing local changes to server', name: 'sync');
    final data = await ProxyService.isar.getUnSyncedData();
    for (Product product in data.products) {
      if (product.action != AppActions.remote && product.name != TEMP_PRODUCT) {
        Map<String, dynamic>? record = await _push(product as M);

        if (record != null && record.isNotEmpty) {
          Product product = Product.fromJson(record);

          product.action = AppActions.remote;
          await ProxyService.isar.update(data: product);
        }

        /// now sync other to avoid lace condition when synching
        List<Variant> variants = await ProxyService.isar.variants(
            branchId: ProxyService.box.getBranchId()!, productId: product.id);
        for (Variant variant in variants) {
          if (variant.action != AppActions.remote) {
            Map<String, dynamic>? variantRecord = await _push(variant as M);
            if (variantRecord != null && variantRecord.isNotEmpty) {
              Variant va = Variant.fromJson(variantRecord);

              va.action = AppActions.remote;
              await ProxyService.isar.update(data: va);
            }

            /// push related stock
            Stock stock =
                await ProxyService.isar.stockByVariantId(variantId: variant.id);
            Map<String, dynamic>? stockRecord = await _push(stock as M);
            if (stockRecord != null && stockRecord.isNotEmpty) {
              Stock s = Stock.fromJson(stockRecord);

              s.action = AppActions.remote;

              await ProxyService.isar.update(data: s);
            }

            /// end of pushing related stock to this variant
          }
        }

        /// done syncing related to product data
      }
    }

    for (ITransaction transaction in data.transactions) {
      await _pushTransactions(transaction);
    }
    for (TransactionItem item in data.transactionItems) {
      if (item.action != AppActions.remote) {
        Map<String, dynamic>? stockRecord = await _push(item as M);
        if (stockRecord != null && stockRecord.isNotEmpty) {
          TransactionItem iItem = TransactionItem.fromJson(stockRecord);

          iItem.action = AppActions.remote;

          await ProxyService.isar.update(data: iItem);
        }
      }
    }

    for (Favorite favorite in data.favorites) {
      if (favorite.action != AppActions.remote) {
        Map<String, dynamic>? record = await _push(favorite as M);

        if (record != null && record.isNotEmpty) {
          Favorite fav = Favorite.fromJson(record);

          fav.action = AppActions.remote;
          await ProxyService.isar.update(data: fav);
        }
      }
    }

    /// pushing devices
    for (Device device in data.devices) {
      if (device.action != AppActions.remote) {
        Map<String, dynamic>? record = await _push(device as M);

        if (record != null && record.isNotEmpty) {
          Device dev = Device.fromJson(record);

          dev.action = AppActions.remote;
          await ProxyService.isar.update(data: dev);
        }
      }
    }
  }
}
