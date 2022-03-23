import 'package:isar/isar.dart';

part 'unit.g.dart';

@Collection()
class Unit {
  late int id = Isar.autoIncrement;
  late int? fbranchId;
  late String name;
  late String value;
  String? table;
  late bool active;
  List<String>? channels;

  late List<Map<String, dynamic>>? units;
}
