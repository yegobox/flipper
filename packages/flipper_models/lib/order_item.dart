import 'package:objectbox/objectbox.dart';

import 'order.dart';

@Entity()
class OrderItem {
  OrderItem({
    this.id = 0,
    required this.name,
    required this.fvariantId,
    required this.count,
    required this.price,
    required this.forderId,
  });
  @Id(assignable: true)
  int id;
  String name;
  int forderId;
  int fvariantId;
  double count;
  double price;

  final order = ToOne<OrderF>();

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: int.parse(json["id"]),
        name: json["name"],
        fvariantId: int.parse(json["variantId"].toString()),
        count: json["count"],
        price: json["price"].toDouble(),
        forderId: int.parse(json["orderId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "variantId": int.parse(fvariantId.toString()),
        "count": count,
        "price": price,
        "orderId": int.parse(forderId.toString()),
      };
}
