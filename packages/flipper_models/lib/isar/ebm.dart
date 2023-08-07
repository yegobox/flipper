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
  Id? id = Isar.autoIncrement;
  String bhfId;
  int tinNumber;
  String dvcSrlNo;
  String userId;
  String? taxServerUrl;
  int businessId;
  int branchId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  @Index()
  String? remoteId;
  String action;
  int? localId;
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
    json['remoteId'] ??= json['id'].toString();
    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();
    json['id'] = json['localId'];
    return _$EBMFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$EBMToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
