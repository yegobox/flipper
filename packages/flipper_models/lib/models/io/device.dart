// To parse this JSON data, do
//
//     final Device = DeviceFromMap(jsonString);
import 'package:objectbox/objectbox.dart';
import 'dart:convert';

Device deviceFromMap(String str) => Device.fromMap(json.decode(str));

String deviceToMap(Device data) => json.encode(data.toMap());

@Entity()
@Sync()
class Device {
  Device({
    this.id = 0,
    required this.userId,
    required this.name,
    required this.branchId,
    required this.businessId,
  });

  int id;
  String userId;
  String name;
  int branchId;
  int businessId;

  factory Device.fromMap(Map<String, dynamic> json) => Device(
        userId: json["userId"],
        name: json["phoneNumber"],
        branchId: json["branchId"],
        businessId: json["businessId"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "name": name,
        "branchId": branchId,
        "businessId": businessId,
      };
}
