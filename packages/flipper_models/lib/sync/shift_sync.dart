import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';

/// Shift open/close/list operations go through Capella's [ShiftApi], which
/// reads/writes the Ditto `shifts` collection directly (not Brick/SQLite).
DatabaseSyncInterface get shiftSync => ProxyService.getStrategy(Strategy.capella);
