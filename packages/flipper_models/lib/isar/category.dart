// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);
library flipper_models;

import 'package:isar/isar.dart';
part 'category.g.dart';

@Collection()
class Category {
  late int id = Isar.autoIncrement;
  late bool active;
  late bool focused;
  late String name;
  late int branchId;
  String? table;
}
