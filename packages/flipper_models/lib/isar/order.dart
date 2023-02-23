import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';

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
  @Index()
  bool? reported;
  int? customerId;
  String? note;
  final orderItems = IsarLinks<OrderItem>();
  final discounts = IsarLinks<Discount>();
  // toJson helper
  Map<String, dynamic> toJson(
          {required String itemName, bool convertIdToString = false}) =>
      {
        /// remove id in sent object as it is hard to guarantee the lenght to always be 15. keep the logic
        /// here as it will be useful when adopt full sync
        // 'id': convertIdToString
        //     ? "${id}_${DateTime.now().millisecondsSinceEpoch.toString().substring(0, min(15 - id.toString().length, DateTime.now().millisecondsSinceEpoch.toString().length))}"
        //     : id,
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
        'itemName': itemName
      };
}
