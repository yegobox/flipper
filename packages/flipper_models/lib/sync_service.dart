// import 'package:pocketbase/pocketbase.dart';

import 'dart:developer';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/server_definitions.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:isar_crdt/isar_crdt.dart';
import 'package:pocketbase/pocketbase.dart';

import 'isar/clean.dart';

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
      if (json["name"] != "temp" || json["productName"] != "temp") {
        String desiredDate = removeNegativeNumber(Hlc.fromDate(
                DateTime.now(), ProxyService.box.getBranchId()!.toString())
            .toString());
        json["lastTouched"] = desiredDate;

        json["id"] = syncId();

        RecordModel result = await ProxyService.remoteApi
            .create(collection: json, collectionName: endpoint);
        log("pushedModel ${endpoint}");

        /// save lastTouched in global clock
        await ProxyService.remoteApi.create(collection: {
          "model": endpoint,
          "branchId": ProxyService.box.getBranchId()!,
          "lastTouched": desiredDate
        }, collectionName: 'clocks');
        return result;
      }
    }
    return Future.value(null);
  }

  @override
  void pull() async {
    ProxyService.remoteApi.listenToChanges();
  }
}
