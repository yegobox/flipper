import 'package:isar/isar.dart';

part 'unit.g.dart';

@Collection()
class IUnit {
  Id id = Isar.autoIncrement;
  @Index()
  late int branchId;
  late String name;
  late String value;
  late bool active;
  @Ignore()
  late List<Map<String, dynamic>>? units;
}
