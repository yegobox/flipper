import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/unit_table.dart';
import 'package:moor/moor.dart';

part 'unit_dao.g.dart';

@UseDao(tables: [UnitTable])
class UnitDao extends DatabaseAccessor<Database> with _$UnitDaoMixin {
  final Database db;

  UnitDao(this.db) : super(db);

  Future updateUnit(UnitTableData entry) {
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

  Stream<List<UnitTableData>> getUnitsStream() => select(db.unitTable).watch();
}
