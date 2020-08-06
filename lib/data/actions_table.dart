import 'package:moor/moor.dart';

class ActionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isLocked => boolean().withDefault(Constant(false))();
  TextColumn get name => text()();
}
