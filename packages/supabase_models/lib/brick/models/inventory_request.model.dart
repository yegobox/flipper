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

  String? bhfId;
  String? tinNumber;

  // stock financing
  Financing? financing;
  InventoryRequest({
    String? id,
    this.mainBranchId,
    this.bhfId,
    this.tinNumber,
    this.itemCounts,
    this.subBranchId,
    this.createdAt,
    this.status,
    this.branch,
    this.deliveryDate,
    this.deliveryNote,
    this.orderNote,
    this.customerReceivedOrder,
    this.driverRequestDeliveryConfirmation,
    this.driverId,
    this.transactionItems,
    this.updatedAt,
    this.financing,
  }) : id = id ?? const Uuid().v4();

  Future<InventoryRequest> copyWith(
      {Branch? branch, Financing? financing}) async {
    return InventoryRequest(
      id: id,
      mainBranchId: mainBranchId,
      subBranchId: subBranchId,
      createdAt: createdAt,
      status: status,
      deliveryDate: deliveryDate,
      deliveryNote: deliveryNote,
      orderNote: orderNote,
      customerReceivedOrder: customerReceivedOrder,
      driverRequestDeliveryConfirmation: driverRequestDeliveryConfirmation,
      driverId: driverId,
      transactionItems: transactionItems,
      updatedAt: updatedAt,
      itemCounts: itemCounts,
      bhfId: bhfId,
      tinNumber: tinNumber,
      financing: financing,
      branch: branch,
    );
  }
}
