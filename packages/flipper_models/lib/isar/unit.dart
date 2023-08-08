import 'package:isar/isar.dart';

part 'unit.g.dart';

@Collection()
class IUnit {
  late String id;
  @Index()
  late int branchId;
  late String name;
  late String value;
  late bool active;
}
