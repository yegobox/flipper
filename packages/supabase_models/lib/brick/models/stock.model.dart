import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stocks'),
)
class Stock extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true, index: true)
  @Supabase(unique: true)
  final int id;

  @Supabase(foreignKey: 'variant_id')
  Variant? variant;

  // If the association will be created by the app, specify
  // a field that maps directly to the foreign key column
  // so that Brick can notify Supabase of the association.
  // @Sqlite(ignore: true)
  final int variantId;

  int? tin;
  String? bhfId;
  int? branchId;
  // int? variantId;
  @Supabase(defaultValue: "0.0")
  double? currentStock;
  @Supabase(defaultValue: "0.0")
  double? lowStock;
  @Supabase(defaultValue: "true")
  bool? canTrackingStock;
  @Supabase(defaultValue: "true")
  bool? showLowStockAlert;
  int? productId;
  bool? active;
  double? value;
  double? rsdQty;
  DateTime? lastTouched;
  DateTime? deletedAt;
  @Supabase(defaultValue: "false")
  bool? ebmSynced;
  @Supabase(defaultValue: "1")
  int? initialStock;

  Stock({
    required this.id,
    this.tin,
    required this.variantId,
    this.bhfId,
    required this.variant,
    this.branchId,
    // this.variantId,
    this.currentStock,
    this.lowStock,
    this.canTrackingStock,
    this.showLowStockAlert,
    this.productId,
    this.active,
    this.value,
    this.rsdQty,
    this.lastTouched,
    this.deletedAt,
    this.ebmSynced,
    this.initialStock,
  });
}
