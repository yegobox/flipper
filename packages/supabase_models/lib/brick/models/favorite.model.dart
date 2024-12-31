import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'favorites'),
)
class Favorite extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  String? favIndex;

  // @Sqlite(unique: true)
  String? productId;
  int? branchId;

  DateTime? lastTouched;

  DateTime? deletedAt;
  Favorite({
    String? id,
    this.favIndex,
    this.productId,
    this.branchId,
    this.lastTouched,
    this.deletedAt,
  }) : id = id ?? const Uuid().v4();
}
