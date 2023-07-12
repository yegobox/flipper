import 'dart:developer';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/server_definitions.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';

import 'isar_models.dart';

abstract class IJsonSerializable {
  Map<String, dynamic> toJson();
}

class SynchronizationService<M extends IJsonSerializable>
    implements SyncApiInterface<M> {
  @override
  Future<RecordModel?> push(M model) async {
    Type modelType = model.runtimeType;
    // Use the model type to get the corresponding endpoint from the map
    String? endpoint = serverDefinitions[modelType];

    if (endpoint != null) {
      // Convert the model to JSON using the `toJson()` method
      Map<String, dynamic> json = model.toJson();

      if (endpoint == "transactions") {
        List<TransactionItem> itemOnTransaction = await ProxyService.isar
            .transactionItems(transactionId: json["id"], doneWithTransaction: true);
        log(itemOnTransaction.length.toString(), name: "ItemOnTransaction");
        String namesString = itemOnTransaction.map((item) => item.name).join(',');
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
}
