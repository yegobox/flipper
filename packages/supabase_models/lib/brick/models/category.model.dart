import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'categories'),
)
class Category extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  bool? active;
  bool focused = false;
  String? name;

  int? branchId;
  DateTime? deletedAt;
  DateTime? lastTouched;
  Category({
    String? id,
    this.active,
    this.focused = false,
    this.name,
    this.branchId,
    this.deletedAt,
    this.lastTouched,
  }) : id = id ?? const Uuid().v4();
}
