import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'uni_products'),
)
class UnversalProduct extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  String? itemClsCd;
  String? itemClsNm;
  int? itemClsLvl;
  String? taxTyCd;
  String? mjrTgYn;
  String? useYn;

  int? businessId;
  int? branchId;
  UnversalProduct({
    required this.id,
    this.itemClsCd,
    this.itemClsNm,
    this.itemClsLvl,
    this.taxTyCd,
    this.mjrTgYn,
    this.useYn,
    this.businessId,
    this.branchId,
  });
}
