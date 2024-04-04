import 'package:realm/realm.dart';
part 'realmIUnit.realm.dart';

@RealmModel()
class _RealmIUnit {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  late String id;
  late int branchId;
  late String name;
  late String value;
  late bool active;

  /// this model that not sync properties as it not meant
  /// to be edited

  void updateProperties(RealmIUnit other) {
    // Assuming that  has properties similar to IUnit
    id = other.id;
    branchId = other.branchId;
    name = other.name;
    value = other.value;
    active = other.active;
  }
}
