import 'package:flipper_models/isar_models.dart';

part 'drawer.g.dart';

@Collection()
class Drawers {
  late int id = Isar.autoIncrement;
  late double openingBalance;
  late double closingBalance;
  String? openingDateTime;
  String? closingDateTime;

  @Index()
  late int cashierId;
  @Index(composite: [CompositeIndex('cashierId')])
  late bool open;
}
