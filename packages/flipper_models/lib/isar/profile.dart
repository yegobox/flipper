library flipper_models;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'profile.g.dart';

@JsonSerializable()
@Collection()
class Profile extends IJsonSerializable {
  Profile({
    this.id = 0,
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
  });

  Id id = Isar.autoIncrement;
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
  @Index()
  int businessId;
  String? nationalId;

  @Index()
  String? lastTouched;

  factory Profile.fromRecord(RecordModel record) =>
      Profile.fromJson(record.toJson());

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
