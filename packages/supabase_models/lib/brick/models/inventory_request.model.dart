import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/financing.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stock_requests'),
)
class InventoryRequest extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  int? mainBranchId;
  int? subBranchId;

  Branch? branch;
  // the requester same as subBranchId but this will use uuid representation of the subBranchId
  String? branchId;

  DateTime? createdAt;
  // e.g., "pending", "approved", "partiallyApproved", "rejected", "fulfilled"
  String? status;
  DateTime? deliveryDate;
  String? deliveryNote;
  String? orderNote;
  bool? customerReceivedOrder = false;
  bool? driverRequestDeliveryConfirmation = false;
  int? driverId;
  @Supabase(ignore: true)
  List<TransactionItem>? transactionItems;
  DateTime? updatedAt;
  num? itemCounts;

  // stock financing
  final Financing? financing;
  String? financingId;
  InventoryRequest({
    String? id,
    this.mainBranchId,
    this.itemCounts,
    this.subBranchId,
    this.createdAt,
    this.status,
    this.branchId,
    this.branch,
    this.deliveryDate,
    this.deliveryNote,
    this.financingId,
    this.orderNote,
    this.customerReceivedOrder,
    this.driverRequestDeliveryConfirmation,
    this.driverId,
    this.transactionItems,
    this.updatedAt,
    this.financing,
  }) : id = id ?? const Uuid().v4();
}
