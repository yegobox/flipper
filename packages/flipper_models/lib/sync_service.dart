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
  /// read the entire isar models
  /// see changes in them
  /// if there is change send them to appropriate endpoint on
  /// our sync server
  // ignore: todo
  /// TODO: how will I know the model type if I make it generic like bellow?
  /// this method is
  /// how do we know changes to send?
  /// We can have strategy 1:
  /// fetch data from remote first
  /// if there conflict on local replace data and move on
  @override
  Future<List<RecordModel?>> push(List models) async {
    List<RecordModel> results = [];
    for (M model in models) {
      Type modelType = model.runtimeType;
      // Use the model type to get the corresponding endpoint from the map
      String? endpoint = serverDefinitions[modelType];
      if (endpoint != null) {
        // Convert the model to JSON using the `toJson()` method
        /// when we push the model to the server we also updat the model remoteID
        /// once we receive confirmation that the item is created on server we update the
        /// local copy with remoteID of the remote.
        Map<String, dynamic> json = model.toJson(remoteId: syncId());
        if (json["name"] != "temp") {
          final result = await ProxyService.remoteApi
              .create(collection: json, collectionName: endpoint);
          results.add(result);
        }
      }
    }
    return results;
  }

  @override
  Future<RecordModel> pull() {
    // TODO: implement pull
    throw UnimplementedError();
  }
}
