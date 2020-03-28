import 'package:moor/moor.dart';

class ProductImageTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get localPath => text()();

  TextColumn get productId => text().nullable()();
}
