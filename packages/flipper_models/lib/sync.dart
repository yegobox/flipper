import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class SyncApiInterface<M extends JsonSerializable> {
  Future<RecordModel?> pull();
  Future<RecordModel?> push(M model);
  factory SyncApiInterface.create() => SynchronizationService<M>();
}
