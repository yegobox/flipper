import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/helper_models.dart';

part 'iuser.g.dart';

@JsonSerializable()
class IUser {
  IUser(
      {required this.id,
      required this.phoneNumber,
      required this.token,
      required this.uid,
      required this.tenants,
      required this.channels,
      this.pin});

  int? id;
  String phoneNumber;
  String token;
  String uid;
  List<ITenant> tenants;
  List<String> channels;
  int? pin;

  factory IUser.fromJson(Map<String, dynamic> json) => _$IUserFromJson(json);
  Map<String, dynamic> toJson() => _$IUserToJson(this);
}
