import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';

/// Shift open/close/list operations always go through Capella (Brick + Supabase),
/// not the default CoreSync strategy.
DatabaseSyncInterface get shiftSync => ProxyService.getStrategy(Strategy.capella);
