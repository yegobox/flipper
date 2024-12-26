import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'codes'),
)
class ItemCode extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  @Sqlite(index: true)
  @Supabase(name: 'item_code')
  final String itemCode;
  @Supabase(name: 'created_at')
  final DateTime createdAt;

  ItemCode({
    required this.id,
    required this.itemCode,
    required this.createdAt,
  });
}
