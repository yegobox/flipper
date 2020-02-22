import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/tax_table.dart';
import 'package:moor/moor.dart';

part 'tax_dao.g.dart';

@UseDao(tables: [TaxTable])
class TaxDao extends DatabaseAccessor<Database> with _$TaxDaoMixin {
  final Database db;

  TaxDao(this.db) : super(db);

  Future insert(Insertable<TaxTableData> tax) => into(db.taxTable).insert(tax);

  Future updateTax(TabsTableData entry) {
    return update(db.tabsTable).replace(entry);
  }

  Future<TaxTableData> getTaxByName(String name, int branchId) {
    return (select(db.taxTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((tbl) => tbl.name.equals(name))
          ..where((tbl) => tbl.branchId.equals(branchId)))
        .getSingle();
  }

  Future<List<TabsTableData>> getTaxes() {
    return (select(db.tabsTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .get();
  }
}
