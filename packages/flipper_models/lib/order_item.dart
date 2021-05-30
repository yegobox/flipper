import 'package:objectbox/objectbox.dart';

import 'order.dart';

@Entity(uid: 2)
class OrderItem {
  OrderItem({
    this.id = 0,
    required this.name,
    required this.variantId,
    required this.count,
    required this.price,
    required this.forderId,
  });
  @Id(assignable: true)
  int id;
  String name;
  int forderId;
  int variantId;
  double count;
  double price;

  final order = ToOne<OrderF>();

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: int.parse(json["id"]),
        name: json["name"],
        variantId: int.parse(json["variantId"].toString()),
        count: json["count"],
        price: json["price"].toDouble(),
        forderId: int.parse(json["orderId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "variantId": int.parse(variantId.toString()),
        "count": count,
        "price": price,
        "orderId": int.parse(forderId.toString()),
      };
}
