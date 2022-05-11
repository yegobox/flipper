import 'package:isar/isar.dart';

part 'unit.g.dart';

@Collection()
class Unit {
  late int id = Isar.autoIncrement;
  @Index()
  late int branchId;
  late String name;
  late String value;
  late bool active;

  late List<Map<String, dynamic>>? units;
}
