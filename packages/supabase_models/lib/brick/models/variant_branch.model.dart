import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'variants_branches'),
)
class VariantBranch extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? variantId;
  String? newVariantId;
  String? sourceBranchId;
  String? destinationBranchId;

  VariantBranch({
    String? id,
    this.variantId,
    this.newVariantId,
    this.sourceBranchId,
    this.destinationBranchId,
  }) : id = id ?? const Uuid().v4();
}
