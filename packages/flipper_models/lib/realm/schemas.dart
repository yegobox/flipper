import 'package:realm/realm.dart';
part 'schemas.realm.dart';

@RealmModel()
class _RealmBranch {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;

  late bool isDefault;

  DateTime? lastTouched;

  late String action;

  DateTime? deletedAt;
}
