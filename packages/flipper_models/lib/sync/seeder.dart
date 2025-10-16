import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';

/// Utility class to seed/hydrate Ditto with existing SQLite data
class DittoSeeder {
  static final DittoSyncCoordinator _coordinator =
      DittoSyncCoordinator.instance;

  /// Hydrate Stock data from SQLite to Ditto
  static Future<void> hydrateStocks() async {
    await _coordinator.hydrate<Stock>();
  }

  /// Hydrate all registered models from SQLite to Ditto
  static Future<Map<Type, int>> hydrateAll() async {
    return await _coordinator.pullBackupForAll();
  }

  /// Hydrate specific model type
  // static Future<int> hydrate<T>() async {
  //   return await _coordinator.pullBackupFor<T>();
  // }
}
