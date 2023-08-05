library flipper_models;

import 'package:flipper_services/constants.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'branch.g.dart';

@JsonSerializable()
@Collection()
class Branch extends IJsonSerializable {
  Branch({
    required this.isDefault,
    required this.action,
    this.id,
    this.active,
    this.description,
    this.name,
    this.businessId,
    this.longitude,
    this.latitude,
    this.table,
    this.deletedAt,
  });

  Id? id = Isar.autoIncrement;
  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;
  String? table;
  late bool isDefault;

  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  String action;
  int? localId;
  @Index()
  DateTime? deletedAt;
  factory Branch.fromRecord(RecordModel record) =>
      Branch.fromJson(record.toJson());

  factory Branch.fromJson(Map<String, dynamic> json) {
    /// assign remoteID to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteID on local
    json['remoteID'] = json['id'] is int ? json['id'].toString() : json['id'];
    json.remove('id');
    // this line ony added in both business and branch as they are not part of sync schemd
    json['action'] = AppActions.create;
    return _$BranchFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$BranchToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
