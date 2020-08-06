import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/reason_table.dart';
import 'package:moor/moor.dart';

part 'reason_dao.g.dart';

@UseDao(tables: [ReasonTable])
class ReasonDao extends DatabaseAccessor<Database> with _$ReasonDaoMixin {
  final Database db;

  ReasonDao(this.db) : super(db);

  Future insert(Insertable<ReasonTableData> reason) =>
      into(db.reasonTable).insert(reason);

  Future updateHistory(ReasonTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.reasonTable).replace(entry);
  }

  Future<List<ReasonTableData>> getReasons() => select(db.reasonTable).get();
}
