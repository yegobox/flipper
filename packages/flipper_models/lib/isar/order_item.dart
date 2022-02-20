import 'package:isar/isar.dart';

part 'order_item.g.dart';

@Collection()
class OrderItemSync {
  OrderItemSync({
    this.id = 0,
    required this.name,
    required this.fvariantId,
    required this.count,
    required this.price,
    required this.forderId,
    this.discount,
    required this.createdAt,
    required this.updatedAt,
    this.reported = false,
    this.remainingStock = 0,
    this.type = 'item',
  });
  late int id = Isar.autoIncrement;
  late String name;
  late int forderId;
  late int fvariantId;
  late double count;
  late double price;
  late double? discount;

  late String? type;
  late bool reported;

  late int remainingStock;
  late String createdAt;
  late String updatedAt;
  // final orderItems = IsarLink<OrderItemSync>();
  List<OrderItemSync>? orderItems;

  factory OrderItemSync.fromJson(Map<String, dynamic> json) => OrderItemSync(
        id: int.parse(json["id"]),
        type: json["type"],
        reported: json["reported"],
        remainingStock: json["remainingStock"],
        name: json["name"],
        discount: json["discount"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        fvariantId: int.parse(json["fvariantId"].toString()),
        count: json["count"],
        price: json["price"] != null ? json["price"].toDouble() : 0.0,
        forderId: int.parse(json["forderId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "type": type ?? 'item',
        "reported": reported,
        "remainingStock": remainingStock,
        "discount": discount,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "fvariantId": int.parse(fvariantId.toString()),
        "count": count,
        "price": price,
        "forderId": int.parse(forderId.toString()),
      };
}
