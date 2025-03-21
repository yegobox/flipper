library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile extends IJsonSerializable {
  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.state,
    required this.country,
    this.pincode,
    this.profilePic,
    this.coverPic,
    this.about,
    required this.vaccinationCode,
    required this.livingAt,
    required this.cell,
    required this.district,
    required this.businessId,
    required this.nationalId,
    this.deletedAt,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? state;
  String country;
  String? pincode;
  String? profilePic;
  String? coverPic;
  String? about;
  String vaccinationCode;
  String livingAt;
  String cell;
  String district;

  int businessId;
  String? nationalId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  DateTime? deletedAt;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
