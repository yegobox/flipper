import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'order.g.dart';

@JsonSerializable()
@Collection()
class Order extends IJsonSerializable {
  // @JsonKey(name: 'localId')
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
  String? action;
  int? localId;
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
      this.remoteID,
      this.ticketName});
  factory Order.fromRecord(RecordModel record) =>
      Order.fromJson(record.toJson());

  factory Order.fromJson(Map<String, dynamic> json) {
    json.remove('id');
    return _$OrderFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$OrderToJson(this);
    if (id != null) {
      data['localId'] = id;
      data['businessPhoneNumber'] = ProxyService.box.getUserPhone();
      data['businessId'] = ProxyService.box.getBusinessId();
    }
    return data;
  }
}
