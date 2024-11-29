import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'skus'),
)
class SKU extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? sku = 1000;
  int? branchId;
  int? businessId;
  bool? consumed = false;
  SKU({
    required this.id,
    this.sku,
    this.branchId,
    this.businessId,
    this.consumed,
  });
}
