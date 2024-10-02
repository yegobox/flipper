import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/power_sync/schema.dart';

part 'all.g.dart';

@JsonSerializable(explicitToJson: true)
class StockRequest {
  StockRequest({
    this.id,
    required this.mainBranchId,
    required this.subBranchId,
    required this.createdAt,
    required this.status,
    this.deliveryDate,
    this.deliveryNote,
    this.orderNote,
    this.customerReceivedOrder = false,
    this.driverRequestDeliveryConfirmation = false,
    this.driverId,
    required this.items,
    this.updatedAt,
  });

  factory StockRequest.fromJson(Map<String, Object?> json) =>
      _$StockRequestFromJson(json);

  final String? id;

  final int mainBranchId;
  final int subBranchId;
  @TimestampConverter()
  final DateTime createdAt;
  final String status;
  @TimestampConverter()
  final DateTime? deliveryDate;
  final String? deliveryNote;
  final String? orderNote;
  final bool customerReceivedOrder;
  final bool driverRequestDeliveryConfirmation;
  final int? driverId;
  final List<TransactionItem> items;
  @TimestampConverter()
  final DateTime? updatedAt;

  Map<String, Object?> toJson() => _$StockRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TransactionItem {
  TransactionItem({
    required this.itemId,
    required this.quantity,
    this.id,
    this.name,
    this.quantityRequested,
    this.quantityApproved,
    this.quantityShipped,
    this.transactionId,
    this.variantId,
    this.qty = 0.0,
    this.price = 0.0,
    this.discount = 0.0,
    this.type,
    this.remainingStock = 0.0,
    this.createdAt,
    this.updatedAt,
    this.isTaxExempted = false,
    this.isRefunded = false,
    this.doneWithTransaction,
    this.active,
    this.dcRt = 0.0,
    this.dcAmt = 0.0,
    this.taxblAmt = 0.0,
    this.taxAmt = 0.0,
    this.totAmt = 0.0,
    this.itemSeq,
    this.isrccCd,
    this.isrccNm = "",
    this.isrcRt = 0,
    this.isrcAmt = 0,
    this.taxTyCd,
    this.bcd,
    this.itemClsCd,
    this.itemTyCd,
    this.itemStdNm,
    this.orgnNatCd,
    this.pkg,
    this.itemCd,
    this.pkgUnitCd = "CT",
    this.qtyUnitCd = "BX",
    this.itemNm,
    this.prc = 0.0,
    this.splyAmt = 0.0,
    this.tin,
    this.bhfId,
    this.dftPrc,
    this.addInfo,
    this.isrcAplcbYn,
    this.useYn,
    this.regrId,
    this.regrNm,
    this.modrId,
    this.modrNm,
    this.lastTouched,
    this.deletedAt,
    this.action,
    this.branchId,
    this.ebmSynced = false,
    this.partOfComposite = false,
    this.compositePrice = 0,
  });

  factory TransactionItem.fromJson(Map<String, Object?> json) =>
      _$TransactionItemFromJson(json);

  int itemId;
  int quantity;

  // Common fields
  int? id;
  String? name;
  int? quantityRequested;
  int? quantityApproved;
  int? quantityShipped;
  int? transactionId;
  int? variantId;
  double qty = 0.0; // Renamed to align with common naming conventions
  double price = 0.0;
  double discount = 0.0;
  String? type;
  double remainingStock = 0.0;
  String? createdAt;
  String? updatedAt;
  bool isTaxExempted = false;
  bool isRefunded = false;

  // Transaction-related fields
  bool? doneWithTransaction;
  bool? active;

  // RRA fields
  double dcRt = 0.0;
  double dcAmt = 0.0;
  double taxblAmt = 0.0;
  double taxAmt = 0.0;
  double totAmt = 0.0;

  // Variant-related fields
  int? itemSeq;
  String? isrccCd;
  String? isrccNm = "";
  int? isrcRt = 0;
  int? isrcAmt = 0;
  String? taxTyCd;
  String? bcd;
  String? itemClsCd;
  String? itemTyCd;
  String? itemStdNm;
  String? orgnNatCd;
  String? pkg;
  String? itemCd;
  String? pkgUnitCd = "CT";
  String? qtyUnitCd = "BX";
  String? itemNm;
  double prc = 0.0; // Renamed to align with common naming conventions
  double splyAmt = 0.0;
  int? tin;
  String? bhfId;
  double? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  DateTime? lastTouched;
  DateTime? deletedAt;
  String? action;

  int? branchId;
  bool ebmSynced = false;
  bool partOfComposite = false;
  double compositePrice = 0;

  Map<String, Object?> toJson() => _$TransactionItemToJson(this);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@Collection<StockRequest>(stockRequestsTable)
final stockRequestsRef = StockRequestCollectionReference();
