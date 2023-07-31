import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'ebm.g.dart';

@JsonSerializable()
@Collection()
class EBM extends IJsonSerializable {
  EBM({
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

  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  String? action;
  int? localId;
  @Index()
  DateTime? deletedAt;
  factory EBM.fromRecord(RecordModel record) => EBM.fromJson(record.toJson());

  factory EBM.fromJson(Map<String, dynamic> json) {
    /// assign remoteID to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteID on local
    if (json['id'] is int) {
      json['remoteID'] = json['id'].toString();
    } else {
      json['remoteID'] = json['id'];
    }
    json.remove('id');
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
