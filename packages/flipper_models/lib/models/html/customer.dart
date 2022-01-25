import 'dart:convert';

CustomerSync CustomerJson(String str) =>
    CustomerSync.fromJson(json.decode(str));

class CustomerSync {
  int id;
  String name;
  String email;
  String phone;
  String address;

  int orderId;

  int branchId;

  String? updatedAt;
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
