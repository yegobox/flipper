import 'package:flipper_models/sync_service.dart';

abstract class SyncApiInterface<M extends IJsonSerializable> {
  void pull();
  Future<void> push();
  Future<void> localChanges();
  factory SyncApiInterface.create() => SynchronizationService<M>();
}
