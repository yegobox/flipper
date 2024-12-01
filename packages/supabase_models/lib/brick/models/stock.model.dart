import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stocks'),
)
class Stock extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true)
  final int id;

  int? tin;
  String? bhfId;
  int? branchId;
  int? variantId;
  @Supabase(defaultValue: "0")
  int? currentStock;
  @Supabase(defaultValue: "0")
  int? lowStock;
  @Supabase(defaultValue: "true")
  bool? canTrackingStock;
  @Supabase(defaultValue: "true")
  bool? showLowStockAlert;
  int? productId;
  bool? active;
  int? value;
  int? rsdQty;
  DateTime? lastTouched;
  DateTime? deletedAt;
  @Supabase(defaultValue: "false")
  bool? ebmSynced;
  @Supabase(defaultValue: "1")
  int? initialStock;

  @Supabase(name: 'variant')
  final Variant variant;

  Stock({
    required this.id,
    this.tin,
    this.bhfId,
    required this.variant,
    this.branchId,
    this.variantId,
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
