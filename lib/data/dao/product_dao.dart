import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/product_table.dart';
import 'package:flipper/data/variation_table.dart';
import 'package:moor/moor.dart';

part 'product_dao.g.dart';

@UseDao(tables: [ProductTable, VariationTable])
class ProductDao extends DatabaseAccessor<Database> with _$ProductDaoMixin {
  final Database db;

  ProductDao(this.db) : super(db);

  Future insert(Insertable<ProductTableData> item) =>
      into(db.productTable).insert(item);

  Future deleteItem(Insertable<ProductTableData> product) =>
      delete(db.productTable).delete(product);

  //only updated deletedAt column
  Future softDelete(ProductTableData entry) {
    return update(db.productTable)
        .replace(entry.copyWith(deletedAt: DateTime.now().toIso8601String()));
  }

  Future updateProduct(ProductTableData entry) {
    return update(db.productTable).replace(entry);
  }

  Future<ProductTableData> getItemByBranch({String name, String branchId}) {
    return (select(db.productTable)..where((t) => t.name.equals(name)))
        .getSingle();
  }

  Future<ProductTableData> getProductById({String productId}) {
    return (select(db.productTable)..where((t) => t.id.equals(productId)))
        .getSingle();
  }

  Future<ProductTableData> getProductByIdLocal({int productId}) {
    return (select(db.productTable)..where((t) => t.idLocal.equals(productId)))
        .getSingle();
  }

  Future<ProductTableData> getItemById({String productId}) {
    return (select(db.productTable)..where((t) => t.id.equals(productId)))
        .getSingle();
  }

  Future<ProductTableData> getItemByIdBranch(
      {String productId, String branchId}) {
    return (select(db.productTable)..where((t) => t.id.equals(productId)))
        .getSingle();
  }

  //is there a product named like this in this given business.
  Future<ProductTableData> getItemByName({String name, String businessId}) {
    return (select(db.productTable)
          ..where((t) => t.name.equals(name))
          ..where((tbl) => tbl.businessId.equals(businessId)))
        .getSingle();
  }

  Future<List<ProductTableData>> getItems() => select(db.productTable).get();

  Stream<List<ProductTableData>> getItemByIdStream(String productId) {
    return (select(db.productTable)..where((t) => t.id.equals(productId)))
        .watch();
  }

  Stream<List<ProductTableData>> getProductStream({String branchId}) {
    return (select(db.branchProductTable)
          ..where((t) => t.branchId.equals(branchId))
          ..orderBy(
            ([
              (t) =>
                  OrderingTerm(expression: t.idLocal, mode: OrderingMode.desc),
              (t) => OrderingTerm(expression: t.idLocal),
            ]),
          ))
        .join([
          leftOuterJoin(db.productTable,
              db.productTable.id.equalsExp(db.branchProductTable.productId)),
        ])
        .watch()
        .map(
          (rows) => rows.map(
            (row) {
              return row.readTable(db.productTable);
            },
          ).toList(),
        );
  }
}
