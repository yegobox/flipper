import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'categories'),
)
class Category extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  bool? active;
  bool focused = false;
  String? name;

  int? branchId;
  DateTime? deletedAt;
  DateTime? lastTouched;
  Category({
    required this.id,
    this.active,
    this.focused = false,
    this.name,
    this.branchId,
    this.deletedAt,
    this.lastTouched,
  });
}
