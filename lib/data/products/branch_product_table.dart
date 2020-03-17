import 'package:moor/moor.dart';

class BranchProductTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get productId => text()();

//  TextColumn get channel => text().nullable()();

  TextColumn get branchId => text()();
}
