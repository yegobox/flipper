import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'units'),
)
class IUnit extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  final int id;

  int? branchId;
  String? name;
  String? value;
  @Sqlite(defaultValue: "false")
  @Supabase(defaultValue: "false")
  bool? active;

  DateTime? lastTouched;

  String? createdAt;
  IUnit({
    required this.id,
    this.branchId,
    this.name,
    this.value,
    this.active,
    this.lastTouched,
    this.createdAt,
  });
}
