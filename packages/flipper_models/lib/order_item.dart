import 'package:objectbox/objectbox.dart';

import 'order.dart';

@Entity()
class OrderItem {
  OrderItem(
      {this.id = 0,
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
      this.type = 'item'});
  @Id(assignable: true)
  int id;
  String name;
  int forderId;
  int fvariantId;
  double count;
  double price;
  double? discount;

  /// the type is used to distinguish between different types of items
  /// (e.g. 'item', 'subscription', 'shipping', 'tax', 'discount')
  /// @return the type of the item
  String? type;
  bool reported;

  int remainingStock;
  String createdAt;
  String updatedAt;

  final order = ToOne<OrderF>();

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
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
        price: json["price"].toDouble(),
        forderId: int.parse(json["forderId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "type": type == null ? 'item' : type,
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
