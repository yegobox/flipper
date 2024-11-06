import 'package:flipper_models/BricksSync.dart';
import 'package:flipper_models/FirestoreSync.dart';
import 'package:flipper_models/FlipperInterfaceCapella.dart';
import 'package:flipper_services/Capella.dart';

enum Strategy { capella, cloudSync, bricks }

class SyncStrategy {
  final Capella capella;
  final FirestoreSync cloudSync;
  final BricksSync bricksSync;
  Strategy _currentStrategy = Strategy.capella;

  SyncStrategy({
    required this.capella,
    required this.cloudSync,
    required this.bricksSync,
  });

  FlipperInterfaceCapella get current =>
      _currentStrategy == Strategy.capella ? capella : bricksSync;

  void setStrategy(Strategy strategy) {
    _currentStrategy = strategy;
  }
}
