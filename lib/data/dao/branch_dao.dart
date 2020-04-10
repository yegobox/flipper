import 'package:flipper/data/branch.dart';
import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'branch_dao.g.dart';

@UseDao(tables: [BranchTable])
class BranchDao extends DatabaseAccessor<Database> with _$BranchDaoMixin {
  final Database db;

  BranchDao(this.db) : super(db);

  Future updateBranch(BranchTableData entry) {
    return update(db.branchTable).replace(entry);
  }

  Future insert(Insertable<BranchTableData> branch) =>
      into(db.branchTable).insert(branch);
  Future<List<BranchTableData>> getBranches() => select(db.branchTable).get();

  Future<BranchTableData> getBranchById({String branchId}) {
    return (select(db.branchTable)..where((t) => t.id.equals(branchId)))
        .getSingle();
  }
}
