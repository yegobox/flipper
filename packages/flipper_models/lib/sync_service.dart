// import 'package:pocketbase/pocketbase.dart';

import 'package:flipper_models/server_definitions.dart';

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

class SynchronizationService<M extends JsonSerializable> {
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
  void sendChanges(List<M> models) {
    for (M model in models) {
      Type modelType = model.runtimeType;
      // Use the model type to get the corresponding endpoint from the map
      String? endpoint = serverDefinitions[modelType];
      if (endpoint == null) {
        throw ArgumentError('Unsupported model type: $modelType');
      }
      // Convert the model to JSON using the `toJson()` method
      Map<String, dynamic> json = model.toJson();
    }
  }

  void receiveChanges() {
    // ProxyService.remoteApi.
  }
}
