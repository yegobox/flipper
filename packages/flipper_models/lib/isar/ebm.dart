import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'ebm.g.dart';

@JsonSerializable()
@Collection()
class EBM extends IJsonSerializable {
  EBM({
    required this.action,
    required this.bhfId,
    required this.tinNumber,
    required this.dvcSrlNo,
    required this.userId,
    required this.businessId,
    required this.branchId,
    this.taxServerUrl,
  });
  late String id;
  String bhfId;
  int tinNumber;
  String dvcSrlNo;
  int userId;
  String? taxServerUrl;
  int businessId;
  int branchId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  @Index()
  DateTime? deletedAt;
  factory EBM.fromRecord(RecordModel record) => EBM.fromJson(record.toJson());

  factory EBM.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$EBMFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$EBMToJson(this);
  }
}
