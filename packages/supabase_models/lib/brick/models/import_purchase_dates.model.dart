import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flutter/foundation.dart' hide Category;

part 'import_purchase_dates.model.ditto_sync_adapter.g.dart';
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'import_purchase_dates'),
)
@DittoAdapter(
  'import_purchase_dates',
  syncDirection: SyncDirection.sendOnly,
)
class ImportPurchaseDates extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final String? lastRequestDate;
  final String? branchId;
  final String? requestType;

  ImportPurchaseDates(
      {String? id,
      required this.lastRequestDate,
      required this.branchId,
      required this.requestType})
      : id = id ?? const Uuid().v4();
}
