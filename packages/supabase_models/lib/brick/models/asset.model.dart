import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'assets'),
)
class Assets extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  int? branchId;
  int? businessId;
  String? assetName;
  String? productId;
  Assets({
    String? id,
    this.branchId,
    this.businessId,
    this.assetName,
    this.productId,
  }) : id = id ?? const Uuid().v4();
}
