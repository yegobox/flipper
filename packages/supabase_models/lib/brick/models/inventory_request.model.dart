import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/models/financing.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:uuid/uuid.dart';

class InventoryRequest {
  final String id;
  String? mainBranchId;
  String? subBranchId;

  DateTime? createdAt;
  // e.g., "pending", "approved", "partiallyApproved", "rejected", "fulfilled"
  String? status;
  DateTime? deliveryDate;
  String? deliveryNote;
  String? orderNote;
  bool? customerReceivedOrder = false;
  bool? driverRequestDeliveryConfirmation = false;
  int? driverId;

  DateTime? updatedAt;
  num? itemCounts;

  String? bhfId;
  String? tinNumber;

  // audit fields
  String? approvedBy;
  DateTime? approvedAt;

  // stock financing
  Financing? financing;
  String? financingId;

  List<TransactionItem>? transactionItems;

  Branch? branch;
  // the requester same as subBranchId but this will use uuid representation of the subBranchId
  String? branchId;
  InventoryRequest({
    String? id,
    this.mainBranchId,
    this.bhfId,
    this.tinNumber,
    this.itemCounts,
    this.subBranchId,
    this.createdAt,
    this.status,
    required this.branchId,
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
    this.approvedBy,
    this.approvedAt,
  }) : id = id ?? const Uuid().v4();

  Future<InventoryRequest> copyWith(
      {Branch? branch,
      Financing? financing,
      List<TransactionItem>? transactionItems}) async {
    return InventoryRequest(
      id: id,
      mainBranchId: mainBranchId,
      subBranchId: subBranchId,
      branchId: branchId,
      createdAt: createdAt,
      status: status,
      deliveryDate: deliveryDate,
      deliveryNote: deliveryNote,
      financingId: financingId,
      orderNote: orderNote,
      customerReceivedOrder: customerReceivedOrder,
      driverRequestDeliveryConfirmation: driverRequestDeliveryConfirmation,
      driverId: driverId,
      transactionItems: transactionItems ?? this.transactionItems,
      updatedAt: updatedAt,
      itemCounts: itemCounts,
      bhfId: bhfId,
      tinNumber: tinNumber,
      financing: financing ?? this.financing,
      branch: branch ?? this.branch,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
    );
  }
}
