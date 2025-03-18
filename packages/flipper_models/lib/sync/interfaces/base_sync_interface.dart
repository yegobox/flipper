import 'package:flipper_services/ai_strategy.dart';
import 'package:flipper_services/abstractions/storage.dart';

abstract class BaseSyncInterface extends AiStrategy {
  Future<void> startReplicator();
  
  Future<BaseSyncInterface> configureLocal({
    required bool useInMemory,
    required LocalStorage box,
  });

  Future<BaseSyncInterface> configureCapella({
    required bool useInMemory,
    required LocalStorage box,
  });

  Future<void> initCollections();
}
