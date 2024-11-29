import 'package:flipper_models/CoreSync.dart';
import 'package:flipper_models/CoreDataInterface.dart';
import 'package:flipper_services/Capella.dart';

enum Strategy { capella, cloudSync, bricks }

class SyncStrategy {
  final Capella capella;
  final CoreSync cloudSync;
  Strategy _currentStrategy = Strategy.capella;

  SyncStrategy({
    required this.capella,
    required this.cloudSync,
  });

  CoreDataInterface get current =>
      _currentStrategy == Strategy.capella ? capella : cloudSync;

  void setStrategy(Strategy strategy) {
    _currentStrategy = strategy;
  }
}
