import 'dart:convert';

import 'package:isar/isar.dart';

part 'customer.g.dart';

CustomerSync customerJson(String str) =>
    CustomerSync.fromJson(json.decode(str));

@Collection()
class CustomerSync {
  late int id = Isar.autoIncrement;
  late String name;
  late String email;
  late String phone;
  late String address;

  late int orderId;

  late int branchId;

  late String? updatedAt;
  CustomerSync(
      {this.id = 0,
      required this.orderId,
      required this.branchId,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      this.updatedAt});
  factory CustomerSync.fromJson(Map<String, dynamic> json) => CustomerSync(
      id: json["id"],
      branchId: json["branchId"],
      name: json["name"],
      orderId: json["orderId"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      updatedAt: json["updatedAt"]);
  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "branchId": branchId,
        "email": email,
        "orderId": orderId,
        "phone": phone,
        "address": address,
        "updatedAt": updatedAt
      };
}
