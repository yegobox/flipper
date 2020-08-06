import 'package:flipper/data/color_table.dart';

import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'color_dao.g.dart';

@UseDao(tables: [ColorTable])
class ColorDao extends DatabaseAccessor<Database> with _$ColorDaoMixin {
  final Database db;

  ColorDao(this.db) : super(db);

  Future insert(Insertable<ColorTableData> color) =>
      into(db.colorTable).insert(color);

  Future updateColor(ColorTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.colorTable).replace(entry);
  }

  Stream<List<ColorTableData>> getColors() => select(db.colorTable).watch();

  Future<ColorTableData> colorExists(String name) {
    return (select(db.colorTable)..where((t) => t.name.equals(name)))
        .getSingle();
  }
}
