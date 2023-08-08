library flipper_models;

import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flipper_models/sync_service.dart';
part 'favorite.g.dart';

@JsonSerializable()
@Collection()
class Favorite extends IJsonSerializable {
  late int id;

  @Index(unique: true)
  int? favIndex;

  String? productId;
  int? branchId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;
  // only for accor when fetching from remove

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
    return _$FavoriteFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
