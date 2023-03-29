import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
part 'social.g.dart';

@JsonSerializable()
@Collection()
class Social extends IJsonSerializable {
  Id? id = null;

  bool isAccountSet;

  String socialType;

  String socialUrl;

  Social(
      {this.id,
      required this.isAccountSet,
      required this.socialType,
      required this.socialUrl});

  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}
