import 'package:flipper_models/helper_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'iuser.g.dart';

@JsonSerializable()
class IUser {
  IUser(
      {required this.id,
      required this.phoneNumber,
      required this.token,
      required this.uid,
      required this.tenants,
      this.pin});

  int? id;
  String phoneNumber;
  String? token;

  /// enable user to be create from server and for this case uid will not exist.
  String? uid;
  List<ITenant> tenants;
  int? pin;

  factory IUser.fromJson(Map<String, dynamic> json) => _$IUserFromJson(json);
  Map<String, dynamic> toJson() => _$IUserToJson(this);
}
