import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/unit_table.dart';
import 'package:moor/moor.dart';

part 'unit_dao.g.dart';

@UseDao(tables: [UnitTable])
class UnitDao extends DatabaseAccessor<Database> with _$UnitDaoMixin {
  final Database db;

  UnitDao(this.db) : super(db);

  Future updateTab(UnitTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.unitTable).replace(entry);
  }

  Future<UnitTableData> getExistingUnit(String name, int branchId) {
    return (select(db.unitTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.branchId.equals(branchId)))
        .getSingle();
  }

  Stream<List<UnitTableData>> getUnitStream(int unitId) {
    return (select(db.unitTable)..where((t) => t.id.equals(unitId))).watch();
  }

  Future insert(Insertable<UnitTableData> units) =>
      into(db.unitTable).insert(units);

  Future<List<UnitTableData>> getUnits() => select(db.unitTable).get();
}
