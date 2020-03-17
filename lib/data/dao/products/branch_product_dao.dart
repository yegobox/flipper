import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/products/branch_product_table.dart';
import 'package:moor/moor.dart';

part 'branch_product_dao.g.dart';

@UseDao(tables: [BranchProductTable])
class BranchProductDao extends DatabaseAccessor<Database>
    with _$BranchProductDaoMixin {
  final Database db;

  BranchProductDao(this.db) : super(db);

  Future insert(Insertable<BranchProductTableData> branch) =>
      into(db.branchProductTable).insert(branch);

  Future updateBP(BranchProductTableData entry) {
    return update(db.branchProductTable).replace(entry);
  }

  Future<List<BranchProductTableData>> branchProducts() =>
      select(db.branchProductTable).get();

  Future<BranchProductTableData> getById({String id}) {
    return (select(db.branchProductTable)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  Future<BranchProductTableData> getBranchProduct({String productId}) {
    return (select(db.branchProductTable)
          ..where((t) => t.productId.equals(productId)))
        .getSingle();
  }
}
