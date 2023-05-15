library flipper_models;

import 'package:isar/isar.dart';
part 'color.g.dart';

@Collection()
class PColor {
  Id id = Isar.autoIncrement;
  late String? name;
  List<String>? colors;
  late int? branchId;
  late bool active;
}
