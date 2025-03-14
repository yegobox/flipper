library flipper_models;

import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
part 'favorite.g.dart';

@JsonSerializable()
class Favorite extends IJsonSerializable {
  int? id;

  int? favIndex;

  int? productId;
  int? branchId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;
  // only for accor when fetching from remove

  DateTime? deletedAt;
  Favorite({
    this.favIndex,
    this.productId,
    this.branchId,
    required this.action,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return _$FavoriteFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
