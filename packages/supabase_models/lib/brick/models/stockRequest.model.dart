import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stock_requests'),
  sqliteConfig: SqliteSerializable(),
)
class StockRequest extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  int? mainBranchId;
  int? subBranchId;
  DateTime? createdAt;
  // e.g., "pending", "approved", "partiallyApproved", "rejected", "fulfilled"
  String? status;
  DateTime? deliveryDate;
  String? deliveryNote;
  String? orderNote;
  bool? customerReceivedOrder = false;
  bool? driverRequestDeliveryConfirmation = false;
  int? driverId;
  final List<TransactionItem> items;
  DateTime? updatedAt; // Optional field for tracking last update
  StockRequest({
    String? id,
    this.mainBranchId,
    this.subBranchId,
    this.createdAt,
    this.status,
    this.deliveryDate,
    this.deliveryNote,
    this.orderNote,
    this.customerReceivedOrder,
    this.driverRequestDeliveryConfirmation,
    this.driverId,
    required this.items,
    this.updatedAt,
  }) : id = id ?? const Uuid().v4();
}
