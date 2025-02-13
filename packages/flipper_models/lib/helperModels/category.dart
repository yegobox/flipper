import 'package:flipper_models/sync_service.dart';

import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable()
class Category extends IJsonSerializable {
  int? id;
  late bool active;
  late bool focused;
  late String name;

  // late String type; == expense, income, etc...

  late int branchId;
  @override
  DateTime? deletedAt;

  @override
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  Category({
    required this.id,
    required this.active,
    required this.focused,
    required this.name,
    required this.branchId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return _$CategoryFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
