import 'package:moor/moor.dart';

class ColorTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(Constant(false))();
}
