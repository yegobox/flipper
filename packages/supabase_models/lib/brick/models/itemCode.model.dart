import 'package:brick_core/query.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';

part 'itemCode.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'codes'),
)
@DittoAdapter('codes', syncDirection: SyncDirection.sendOnly)
class ItemCode extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  @Sqlite(index: true)
  final String code;

  final DateTime createdAt;
  final String branchId;

  ItemCode({
    String? id,
    required this.branchId,
    required this.code,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();
}
