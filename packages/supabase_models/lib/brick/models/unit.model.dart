import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'units'),
)
class IUnit extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? branchId;
  String? name;
  String? value;
  bool active = false;

  DateTime? lastTouched;

  String? createdAt;
  DateTime? deletedAt;
  IUnit({
    required this.id,
    this.branchId,
    this.name,
    this.value,
    this.active = false,
    this.lastTouched,
    this.createdAt,
    this.deletedAt,
  });
}
