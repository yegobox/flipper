import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'skus'),
)
class SKU extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  int? sku;
  int? branchId;
  int? businessId;
  bool? consumed = false;
  SKU({
    String? id,
    this.sku,
    this.branchId,
    this.businessId,
    this.consumed,
  }) : id = id ?? const Uuid().v4();
}
