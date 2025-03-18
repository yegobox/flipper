import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/sync/interfaces/storage_interface.dart';
import 'package:flipper_models/sync/interfaces/database_sync_interface.dart';
import 'package:flipper_services/ai_strategy_impl.dart';
import 'package:supabase_models/brick/repository.dart';

abstract class CoreSyncBase extends AiStrategyImpl
    implements AuthInterface, TenantInterface, StorageInterface, DatabaseSyncInterface {
  final Repository repository = Repository();
  bool offlineLogin = false;
  final String apihub;

  CoreSyncBase(this.apihub);

  // Common functionality that will be shared across all implementations
  Future<void> initialize() async {
    // Add initialization logic here
  }

  Future<void> dispose() async {
    // Add cleanup logic here
  }
}
