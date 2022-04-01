import 'package:isar/isar.dart';

part 'order_item.g.dart';

@Collection()
class OrderItem {
  late int id = Isar.autoIncrement;
  late String name;
  late int orderId;
  late int variantId;
  late double count;
  late double price;
  late double? discount;

  String? type;
  late bool reported;

  late double remainingStock;
  late String createdAt;
  late String updatedAt;
}
