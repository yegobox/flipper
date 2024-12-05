import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'assets'),
)
class Assets extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? branchId;
  int? businessId;
  String? assetName;
  int? productId;
  Assets({
    required this.id,
    this.branchId,
    this.businessId,
    this.assetName,
    this.productId,
  });
}
