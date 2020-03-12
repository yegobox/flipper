import 'package:flipper/data/branch.dart';
import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'category_dao.g.dart';

@UseDao(tables: [BranchTable])
class CategoryDao extends DatabaseAccessor<Database> with _$CategoryDaoMixin {
  final Database db;

  CategoryDao(this.db) : super(db);

  Future insert(Insertable<CategoryTableData> category) =>
      into(db.categoryTable).insert(category);

  Future updateCategory(CategoryTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.categoryTable).replace(entry);
  }

  Future<CategoryTableData> getCategoryById(String categoryId) {
    return (select(db.categoryTable)..where((t) => t.id.equals(categoryId)))
        .getSingle();
  }

  Stream<List<CategoryTableData>> getCategoryByIdStream(String categoryId) {
    return (select(db.categoryTable)..where((t) => t.id.equals(categoryId)))
        .watch();
  }

  Future<CategoryTableData> getCategoryName(String categoryName) {
    return (select(db.categoryTable)..where((t) => t.name.equals(categoryName)))
        .getSingle();
  }

  Future<CategoryTableData> getById({String id}) {
    return (select(db.categoryTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Future<CategoryTableData> getCategoryByNameBranchId(
      String name, String branchId) {
    return (select(db.categoryTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.branchId.equals(branchId)))
        .getSingle();
  }

  Future<List<CategoryTableData>> getCategories() =>
      select(db.categoryTable).get();
  Stream<List<CategoryTableData>> getCategoriesStream() =>
      select(db.categoryTable).watch();
}
