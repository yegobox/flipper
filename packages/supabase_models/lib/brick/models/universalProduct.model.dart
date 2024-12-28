import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'uni_products'),
)
class UnversalProduct extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final String id;

  String? itemClsCd;
  String? itemClsNm;
  int? itemClsLvl;
  String? taxTyCd;
  String? mjrTgYn;
  String? useYn;

  int? businessId;
  int? branchId;
  UnversalProduct({
    String? id,
    this.itemClsCd,
    this.itemClsNm,
    this.itemClsLvl,
    this.taxTyCd,
    this.mjrTgYn,
    this.useYn,
    this.businessId,
    this.branchId,
  }) : id = id ?? const Uuid().v4();
  // fromMap method
  factory UnversalProduct.fromMap(Map<String, dynamic> map) {
    return UnversalProduct(
      id: map['id'] as String,
      itemClsCd: map['item_cls_cd'] as String?,
      itemClsNm: map['item_cls_nm'] as String?,
      itemClsLvl: map['item_cls_lvl'] as int?,
      taxTyCd: map['tax_ty_cd'] as String?,
      mjrTgYn: map['mjr_tg_yn'] as String?,
      useYn: map['use_yn'] as String?,
      businessId: map['business_id'] as int?,
      branchId: map['branch_id'] as int?,
    );
  }
}
