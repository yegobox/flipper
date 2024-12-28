import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stocks'),
)
class Stock extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? variantId;

  int? tin;
  String? bhfId;
  String? branchId;
  @Supabase(defaultValue: "0.0")
  double? currentStock;
  @Supabase(defaultValue: "0.0")
  double? lowStock;
  @Supabase(defaultValue: "true")
  bool? canTrackingStock;
  @Supabase(defaultValue: "true")
  bool? showLowStockAlert;
  String? productId;
  bool? active;
  double? value;
  double? rsdQty;
  DateTime? lastTouched;
  DateTime? deletedAt;
  @Supabase(defaultValue: "false")
  bool? ebmSynced;
  @Supabase(defaultValue: "0.0")
  double? initialStock;

  Stock({
    String? id,
    this.tin,
    this.bhfId,
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
  }) : id = id ?? const Uuid().v4();
}
