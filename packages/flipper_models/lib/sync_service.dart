// import 'package:pocketbase/pocketbase.dart';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/server_definitions.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class JsonSerializable {
  Map<String, dynamic> toJson({required String remoteId});
}

class SynchronizationService<M extends JsonSerializable>
    implements SyncApiInterface<M> {
  @override
  Future<RecordModel?> push(M model) async {
    Type modelType = model.runtimeType;
    // Use the model type to get the corresponding endpoint from the map
    String? endpoint = serverDefinitions[modelType];
    if (endpoint != null) {
      // Convert the model to JSON using the `toJson()` method
      Map<String, dynamic> json = model.toJson(remoteId: syncId());
      if (json["name"] != "temp") {
        return await ProxyService.remoteApi
            .create(collection: json, collectionName: endpoint);
      }
    }
    return Future.value(null);
  }

  @override
  void pull() async {
    ProxyService.remoteApi.listenToChanges();
  }
}
