library flipper_models;

import 'package:flipper_models/isar/random.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flipper_models/sync_service.dart';
part 'favorite.g.dart';

@JsonSerializable()
@Collection()
class Favorite extends IJsonSerializable {
  Id? id = syncIdInt();

  @Index(unique: true)
  int? favIndex;

  int? productId;
  int? branchId;

  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  String action;
  // only for accor when fetching from remove
  int? localId;
  @Index()
  DateTime? deletedAt;
  Favorite({
    this.favIndex,
    this.productId,
    this.branchId,
    required this.action,
  });

  factory Favorite.fromRecord(RecordModel record) =>
      Favorite.fromJson(record.toJson());

  factory Favorite.fromJson(Map<String, dynamic> json) {
    json.remove('id');
    return _$FavoriteFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$FavoriteToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
