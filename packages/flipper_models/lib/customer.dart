import 'dart:convert';

import 'package:objectbox/objectbox.dart';

Customer sCustomerJson(String str) => Customer.fromJson(json.decode(str));

@Entity()
class Customer {
  @Id(assignable: true)
  int id;
  String name;
  String email;
  String phone;
  String address;

  int orderId;

  String? updatedAt;
  Customer(
      {this.id = 0,
      required this.orderId,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      this.updatedAt});
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      id: json["id"],
      name: json["name"],
      orderId: json["orderId"],
      address: json["address"],
      phone: json["phone"],
      email: json["email"],
      updatedAt: json["updatedAt"]);
  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "email": email,
        "orderId": orderId,
        "phone": phone,
        "address": address,
        "updatedAt": updatedAt
      };
}
