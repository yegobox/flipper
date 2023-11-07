import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
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

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  // int categoryId;

  String? ticketName;
  @Index()
  DateTime? deletedAt;
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

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$ITransactionToJson(this);

    data['businessPhoneNumber'] = ProxyService.box.getUserPhone();
    data['businessId'] = ProxyService.box.getBusinessId();

    return data;
  }
}