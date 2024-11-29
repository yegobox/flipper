import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'favorites'),
)
class Favorite extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? favIndex;

  int? productId;
  int? branchId;

  DateTime? lastTouched;

  DateTime? deletedAt;
  Favorite({
    required this.id,
    this.favIndex,
    this.productId,
    this.branchId,
    this.lastTouched,
    this.deletedAt,
  });
}
