import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'category.g.dart';

@JsonSerializable()
@Collection()
class Category extends IJsonSerializable {
  Id? id;
  late bool active;
  late bool focused;
  late String name;
  @Index()
  late int branchId;
  @override
  DateTime? deletedAt;

  @override
  String? lastTouched;
  Category({
    this.id,
    required this.active,
    required this.focused,
    required this.name,
    required this.branchId,
  });

  factory Category.fromRecord(RecordModel record) =>
      Category.fromJson(record.toJson());
  factory Category.fromJson(Map<String, dynamic> json) {
    json.remove('id');
    return _$CategoryFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$CategoryToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
