import 'package:flipper_models/isar_models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'itransaction.g.dart';

@JsonSerializable()
@Collection()
class ITransaction extends IJsonSerializable {
  late String id;
  late String reference;
  String? categoryId;
  late String transactionNumber;
  @Index()
  late int branchId;
  late String status;
  late String transactionType;
  late double subTotal;
  late String paymentType;
  late double cashReceived;
  late double customerChangeDue;
  late String createdAt;
  // add receipt type offerered on this transaction
  /// a comma separated of the receipt type offered on this transaction eg. NR, NS etc...
  String? receiptType;
  String? updatedAt;

  String? customerId;
  String? note;

  @JsonKey(
      includeIfNull: true, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? lastTouched;

  String action;

  // int categoryId;

  String? ticketName;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? deletedAt;

  // fields when a transaction is created for ordering system
  int? supplierId;

  static DateTime? _dateTimeFromJson(String? json) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.fromJson(json);
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.toJson(dateTime);
  }

  ITransaction({
    required this.reference,
    this.categoryId,
    required this.transactionNumber,
    required this.branchId,
    required this.status,
    required this.transactionType,
    required this.subTotal,
    required this.paymentType,
    required this.cashReceived,
    required this.customerChangeDue,
    required this.createdAt,
    this.supplierId,
    this.receiptType,
    this.updatedAt,
    this.customerId,
    this.note,
    required this.id,
    required this.lastTouched,
    required this.action,
    this.ticketName,
    this.deletedAt,
  });

  factory ITransaction.fromRecord(RecordModel record) =>
      ITransaction.fromJson(record.toJson());

  factory ITransaction.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$ITransactionFromJson(json);
  }

  // Add methods to check type
  bool isIncome() {
    return this.transactionType == "cashIn" ||
        this == "sale" ||
        this == "onlineSale";
  }

  bool isExpense() {
    return this.transactionType == "cashOut";
  }

  @override
  Map<String, dynamic> toJson() => _$ITransactionToJson(this);

  ITransaction copyWith({
  String? reference,
  String? categoryId,
  String? transactionNumber,
  int? branchId,
  String? status,
  String? transactionType,
  double? subTotal,
  String? paymentType,
  double? cashReceived,
  double? customerChangeDue,
  String? createdAt,
  int? supplierId,
  String? receiptType,
  String? updatedAt,
  String? customerId,
  String? note,
  String? id,
  DateTime? lastTouched,
  String? action,
  String? ticketName,
  DateTime? deletedAt,
}) {
  return ITransaction(
    reference: reference ?? this.reference,
    categoryId: categoryId ?? this.categoryId,
    transactionNumber: transactionNumber ?? this.transactionNumber,
    branchId: branchId ?? this.branchId,
    status: status ?? this.status,
    transactionType: transactionType ?? this.transactionType,
    subTotal: subTotal ?? this.subTotal,
    paymentType: paymentType ?? this.paymentType,
    cashReceived: cashReceived ?? this.cashReceived,
    customerChangeDue: customerChangeDue ?? this.customerChangeDue,
    createdAt: createdAt ?? this.createdAt,
    supplierId: supplierId ?? this.supplierId,
    receiptType: receiptType ?? this.receiptType,
    updatedAt: updatedAt ?? this.updatedAt,
    customerId: customerId ?? this.customerId,
    note: note ?? this.note,
    id: id ?? this.id,
    lastTouched: lastTouched ?? this.lastTouched,
    action: action ?? this.action,
    ticketName: ticketName ?? this.ticketName,
    deletedAt: deletedAt ?? this.deletedAt,
  );
}

}
