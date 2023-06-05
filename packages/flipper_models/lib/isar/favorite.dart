library flipper_models;

import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flipper_models/sync_service.dart';
part 'favorite.g.dart';

@JsonSerializable()
@Collection()
class Favorite extends IJsonSerializable {
  @JsonKey(includeToJson: false, includeFromJson: false)
  Id? id = null;

  @Index(unique: true)
  int? favIndex;

  int? productId;
  int? branchId;

  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  int? localId;
  String? action;

  Favorite(this.favIndex, this.productId, this.branchId);

  factory Favorite.fromRecord(RecordModel record) =>
      Favorite.fromJson(record.toJson());

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
