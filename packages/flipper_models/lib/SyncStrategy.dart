import 'package:flipper_models/CoreSync.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_services/Capella.dart';

enum Strategy { capella, cloudSync, bricks }

class SyncStrategy {
  final Capella capella;
  final CoreSync cloudSync;
  Strategy _currentStrategy = Strategy.cloudSync;

  SyncStrategy({
    required this.capella,
    required this.cloudSync,
  });

  DatabaseSyncInterface get current => _currentStrategy == Strategy.capella
      ? capella as DatabaseSyncInterface
      : cloudSync;

  void setStrategy(Strategy strategy) {
    _currentStrategy = strategy;
  }
}
