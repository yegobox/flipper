import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:flipper_models/DatabaseSyncInterface.dart';

enum Strategy { capella, cloudSync, bricks }

class SyncStrategy {
  final DatabaseSyncInterface capella;
  final DatabaseSyncInterface cloudSync;
  late Strategy _currentStrategy;

  SyncStrategy({
    required this.capella,
    required this.cloudSync,
  }) {
    // Enforce Capella on Web, otherwise default to CoreSync
    _currentStrategy = kIsWeb ? Strategy.capella : Strategy.cloudSync;
  }

  DatabaseSyncInterface get current {
    return kIsWeb
        ? capella // Always use Capella on Web
        : (_currentStrategy == Strategy.capella ? capella : cloudSync);
  }

  void setStrategy(Strategy strategy) {
    if (kIsWeb && strategy != Strategy.capella) {
      throw UnsupportedError("Only Capella is supported on the web.");
    }
    _currentStrategy = strategy;
  }
}
