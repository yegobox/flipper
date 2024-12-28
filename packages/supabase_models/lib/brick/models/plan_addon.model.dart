import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'addons'),
  sqliteConfig: SqliteSerializable(),
)
class PlanAddon extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  final String id;

  @Supabase(name: "plan_id")
  final int? planId;

  @Supabase(name: "addon_name")
  final String? addonName;

  @Supabase(name: "created_at")
  final DateTime? createdAt;

  PlanAddon({
    String? id,
    this.planId,
    this.addonName,
    this.createdAt,
  }) : id = id ?? const Uuid().v4();
}
