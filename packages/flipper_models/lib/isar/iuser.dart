import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/isar_models.dart';

part 'iuser.g.dart';

@JsonSerializable()
class IUser {
  IUser({
    required this.id,
    required this.phoneNumber,
    required this.token,
    required this.tenants,
    required this.channels,
  });

  late int id;
  String phoneNumber;
  String token;
  List<Tenant> tenants;
  List<String> channels;

  factory IUser.fromJson(Map<String, dynamic> json) => _$IUserFromJson(json);
  Map<String, dynamic> toJson() => _$IUserToJson(this);
}
