import 'package:flipper_models/sync_service.dart';

abstract class Sync<M extends IJsonSerializable> {
  Future<void> pull();
  Future<void> push();
  Future<void> localChanges();
  factory Sync.create() => SynchronizationService<M>();

  Future<void> onSave<M extends IJsonSerializable>({required M item});
}
