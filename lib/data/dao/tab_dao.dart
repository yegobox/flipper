import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/tabs.dart';
import 'package:moor/moor.dart';

part 'tab_dao.g.dart';

@UseDao(tables: [TabsTable])
class TabsDao extends DatabaseAccessor<Database> with _$TabsDaoMixin {
  final Database db;

  TabsDao(this.db) : super(db);

  Future insert(Insertable<TabsTableData> tab) =>
      into(db.tabsTable).insert(tab);

  Future updateTab(TabsTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.tabsTable).replace(entry);
  }

  Future<TabsTableData> getTab() {
    return (select(db.tabsTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.id.equals(1))
          ..limit(1))
        .getSingle();
  }
}
