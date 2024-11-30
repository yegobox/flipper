import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'variant.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stocks'),
)
class Stock extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  int? tin;
  String? bhfId;
  int? branchId;
  int? variantId;
  double currentStock = 0.0;
  double lowStock = 0;
  bool? canTrackingStock = true;
  bool? showLowStockAlert = true;
  int? productId;
  bool? active;
  double value = 0.0;
  double rsdQty = 0.0;
  DateTime? lastTouched;
  DateTime? deletedAt;
  bool ebmSynced = false;
  final Variant? variant;
  double? initialStock;

  Stock({
    required this.id,
    this.tin,
    this.bhfId,
    this.branchId,
    this.variantId,
    this.currentStock = 0.0,
    this.lowStock = 0,
    this.canTrackingStock = true,
    this.showLowStockAlert = true,
    this.productId,
    this.active,
    this.value = 0.0,
    this.rsdQty = 0.0,
    this.lastTouched,
    this.deletedAt,
    this.ebmSynced = false,
    this.variant,
    this.initialStock,
  });
}
