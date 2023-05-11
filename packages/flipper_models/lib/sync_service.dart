import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/utils.dart';
import 'package:flipper_models/server_definitions.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/hlc.dart';
import 'package:pocketbase/pocketbase.dart';

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

      if (endpoint == "orders") {
        String namesString = (await ProxyService.isarApi.orderItems(
          orderId: json["localId"],
        ))
            .map((item) => item.name)
            .join(',');
        json["itemName"] = namesString;
      }
      if (endpoint == "stocks" && json["retailPrice"] == null) {
        throw Exception("stocks has null retail price");
      }

      if (endpoint == "variants" && json["retailPrice"] == null) {
        throw Exception("variant has null retail price");
      }
      if (json["name"] != "temp" || json["productName"] != "temp") {
        /// remove trailing dashes to sent lastTouched
        json["lastTouched"] = removeTrailingDash(Hlc.fromDate(
                DateTime.now(), ProxyService.box.getBranchId()!.toString())
            .toString());
        json["id"] = syncId();

        RecordModel? result;
        if (json['action'] == 'create') {
          result = await ProxyService.remoteApi
              .create(collection: json, collectionName: endpoint);
        } else if (json['action'] == 'update' && json["remoteID"] != null) {
          json["id"] = json["remoteID"];
          result = await ProxyService.remoteApi.update(
              data: json, collectionName: endpoint, recordId: json["remoteID"]);
          print(endpoint);
        }
        return result;
      }
    }
    return null;
  }

  @override
  void pull() async {
    ProxyService.remoteApi.listenToChanges();
  }
}
