import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all.g.dart';

@firestoreSerializable
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

  factory StockRequest.fromJson(Map<String, Object?> json) => _$StockRequestFromJson(json);

  @Id()
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

@firestoreSerializable
class TransactionItem {
  TransactionItem({
    required this.itemId,
    required this.quantity,
  });

  factory TransactionItem.fromJson(Map<String, Object?> json) => _$TransactionItemFromJson(json);

  final String itemId;
  final int quantity;

  Map<String, Object?> toJson() => _$TransactionItemToJson(this);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@Collection<StockRequest>('stockRequests')
final stockRequestsRef = StockRequestCollectionReference();