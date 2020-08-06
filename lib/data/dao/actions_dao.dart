import 'package:flipper/data/actions_table.dart';
import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'actions_dao.g.dart';

@UseDao(tables: [ActionsTable])
class ActionsDao extends DatabaseAccessor<Database> with _$ActionsDaoMixin {
  final Database db;

  ActionsDao(this.db) : super(db);

  Future insert(Insertable<ActionsTableData> branch) =>
      into(db.actionsTable).insert(branch);

  Stream<List<ActionsTableData>> getActionByStream(String name) {
    return (select(db.actionsTable)..where((t) => t.name.equals(name))).watch();
  }

  Future<ActionsTableData> getActionBy(String name) {
    return (select(db.actionsTable)..where((t) => t.name.equals(name)))
        .getSingle();
  }

  Future updateAction(ActionsTableData entry) {
    return update(db.actionsTable).replace(entry);
  }
}
