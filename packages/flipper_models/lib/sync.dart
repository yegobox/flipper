import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class SyncApiInterface<M extends JsonSerializable> {
  Future<RecordModel?> pull();
  Future<List<RecordModel?>> push(List<M> models);
  factory SyncApiInterface.create() => SynchronizationService<M>();
}
