library flipper_models;

import 'package:objectbox/objectbox.dart';

@Entity()
class Menu {
  Menu({this.id = 1, required this.name, required this.branchId});
  @Id(assignable: true)
  int id;
  String name;
  int branchId;
}
