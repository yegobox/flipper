import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'order.g.dart';

@Collection()
class Order extends IJsonSerializable {
  Id? id = null;
  late String reference;
  late String orderNumber;
  @Index()
  late int branchId;
  @Index(composite: [CompositeIndex('branchId')])
  late String status;
  late String orderType;
  late bool active;
  late bool draft;
  late double subTotal;
  late String paymentType;
  late double cashReceived;
  late double customerChangeDue;
  late String createdAt;
  // add receipt type offerered on this order
  /// a comma separated of the receipt type offered on this order eg. NR, NS etc...
  String? receiptType;
  String? updatedAt;
  @Index()
  late bool reported;
  int? customerId;
  String? note;
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  int? localId;

  String? action;

  String? ticketName;

  Order(
      {required this.reference,
      required this.orderNumber,
      required this.branchId,
      required this.status,
      required this.orderType,
      required this.active,
      required this.draft,
      required this.subTotal,
      required this.paymentType,
      required this.cashReceived,
      required this.customerChangeDue,
      required this.createdAt,
      this.receiptType,
      this.updatedAt,
      required this.reported,
      this.customerId,
      this.note,
      this.id,
      this.lastTouched,
      this.action,
      this.localId,
      this.remoteID,
      this.ticketName});
  factory Order.fromRecord(RecordModel record) =>
      Order.fromJson(record.toJson());
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        reference: json['reference'],
        orderNumber: json['orderNumber'],
        branchId: json['branchId'],
        status: json['status'],
        orderType: json['orderType'],
        active: json['active'],
        draft: json['draft'],
        subTotal: json['subTotal'].toDouble(),
        paymentType: json['paymentType'],
        cashReceived: json['cashReceived'].toDouble(),
        customerChangeDue: json['customerChangeDue'].toDouble(),
        createdAt: json['createdAt'],
        receiptType: json['receiptType'],
        updatedAt: json['updatedAt'],
        reported: json['reported'],
        customerId: json['customerId'],
        note: json['note'],
        lastTouched: json['lastTouched'],
        id: json['localId'],
        action: json['action'],
        remoteID: json['id'],
        ticketName: json['ticketName']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'reference': reference,
        'orderNumber': orderNumber,
        'branchId': branchId,
        'status': status,
        'orderType': orderType,
        'active': active,
        'draft': draft,
        'subTotal': subTotal,
        'paymentType': paymentType,
        'cashReceived': cashReceived,
        'customerChangeDue': customerChangeDue,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'reported': reported,
        'customerId': customerId,
        'note': note,
        'businessPhoneNumber': ProxyService.box.getUserPhone()!,
        'businessId': ProxyService.box.getBusinessId()!,
        "localId": id,
        "action": action,
        'ticketName': ticketName,
      };
}
