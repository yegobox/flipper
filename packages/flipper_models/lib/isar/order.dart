import 'package:flipper_models/isar_models.dart';

part 'order.g.dart';

@Collection()
class Order {
  Id id = Isar.autoIncrement;
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
  bool? reported;
  int? customerId;
  String? note;
  final orderItems = IsarLinks<OrderItem>();
  final discounts = IsarLinks<Discount>();
  // toJson helper
  Map<String, dynamic> toJson() => {
        'id': id,
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
        'note': note
      };
}
