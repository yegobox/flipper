import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'skus'),
)
class SKU extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  int? sku;
  String? branchId;
  String? businessId;
  bool? consumed = false;
  SKU({
    String? id,
    this.sku,
    this.branchId,
    this.businessId,
    this.consumed,
  }) : id = id ?? const Uuid().v4();
  factory SKU.fromJson(Map<String, dynamic> json) {
    return SKU(
      id: json['id'] as String?,
      sku: json['sku'] as int?,
      branchId: json['branchId'] as String?,
      businessId: json['businessId'] as String?,
      consumed: json['consumed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'branchId': branchId,
      'businessId': businessId,
      'consumed': consumed,
    };
  }
}
