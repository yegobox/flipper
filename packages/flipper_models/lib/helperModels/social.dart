import 'package:flipper_models/sync_service.dart';

import 'package:flipper_services/constants.dart';
import 'package:json_annotation/json_annotation.dart';
part 'social.g.dart';

@JsonSerializable()
class Social extends IJsonSerializable {
  int? id;

  bool isAccountSet;

  String socialType;

  String socialUrl;

  int branchId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String? message;

  DateTime? deletedAt;
  Social({
    required this.id,
    required this.isAccountSet,
    required this.socialType,
    required this.branchId,
    required this.message,
    required this.socialUrl,
    required this.lastTouched,
    this.deletedAt,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    // this line ony added in both business and branch as they are not part of sync schemd
    json['action'] = AppActions.created;
    return _$SocialFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}
