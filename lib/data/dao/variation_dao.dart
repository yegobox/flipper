import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/variation_table.dart';
import 'package:moor/moor.dart';

part 'variation_dao.g.dart';

@UseDao(tables: [VariationTable])
class VariationDao extends DatabaseAccessor<Database> with _$VariationDaoMixin {
  final Database db;

  VariationDao(this.db) : super(db);

  Future insert(Insertable<VariationTableData> variation) =>
      into(db.variationTable).insert(variation);

  Future updateVariation(VariationTableData entry) {
    return update(db.variationTable).replace(entry);
  }

  Future<List<VariationTableData>> getItemVariations(int itemId) {
    return (select(db.variationTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.itemId.equals(itemId)))
        .get();
  }

  Stream<List<VariationTableData>> getItemVariations2(int itemId) {
    return (select(db.variationTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)])
          ..where((t) => t.itemId.equals(itemId)))
        .watch();
  }

  Future<VariationTableData> getVariationBy(String name, int branchId) {
    return (select(db.variationTable)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.name.equals(name))
          ..where((t) => t.branchId.equals(branchId)))
        .getSingle();
  }

  Future<List<VariationTableData>> getVariationByItemId(
      {int branchId, int itemId}) {
    return (select(db.variationTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.itemId.equals(itemId)))
        .get();
  }

  Future<VariationTableData> getVariationById(int variantId) {
    return (select(db.variationTable)..where((t) => t.id.equals(variantId)))
        .getSingle();
  }

  Stream<List<VariationTableData>> getVariationByIdStream(int variantId) {
    return (select(db.variationTable)..where((t) => t.id.equals(variantId)))
        .watch();
  }

  Future<List<VariationTableData>> getVariantByItemId(int itemId) {
    return (select(db.variationTable)..where((t) => t.itemId.equals(itemId)))
        .get();
  }

  Stream<List<VariationTableData>> getVariantByItemIdStream(int itemId) {
    return (select(db.variationTable)..where((t) => t.id.equals(itemId)))
        .watch();
  }

  Future softDelete(VariationTableData entry) {
    return update(db.variationTable)
        .replace(entry.copyWith(deletedAt: DateTime.now()));
  }

  Future deleteVariation(Insertable<VariationTableData> item) =>
      delete(db.variationTable).delete(item);

  Stream<List<VariationTableData>> getVariationByStream(
      String name, int branchId) {
    return (select(db.variationTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.branchId.equals(branchId)))
        .watch();
  }

  Stream<List<VariationTableData>> getVariationByItemIdStream(int itemId) {
    return (select(db.variationTable)..where((t) => t.itemId.equals(itemId)))
        .watch();
  }

  Stream<List<VariationTableData>> getVariationByStream2(
      String name, int itemId) {
    return (select(db.variationTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.itemId.equals(itemId)))
        .watch();
  }
}
