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

  Future<List<VariationTableData>> getVariations() =>
      select(db.variationTable).get();

  Future<List<VariationTableData>> getItemVariations(String productId) {
    return (select(db.variationTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.productId.equals(productId)))
        .get();
  }

  Stream<List<VariationTableData>> getItemVariationsByItemId(String itemId) {
    return (select(db.variationTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)])
          ..where((t) => t.productId.equals(itemId)))
        .watch();
  }

  Future<VariationTableData> getVariationBy(String variationId) {
    return (select(db.variationTable)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          )
          ..where((t) => t.id.equals(variationId)))
        .getSingle();
  }

  Future<List<VariationTableData>> getVariationByItemId({String productId}) {
    return (select(db.variationTable)
          ..where((t) => t.productId.equals(productId)))
        .get();
  }

  Future<VariationTableData> getVariationById({String variantId}) {
    return (select(db.variationTable)..where((t) => t.id.equals(variantId)))
        .getSingle();
  }

  Stream<List<VariationTableData>> getVariationByIdStream(String variantId) {
    return (select(db.variationTable)..where((t) => t.id.equals(variantId)))
        .watch();
  }

  Future<List<VariationTableData>> getVariantByProductId({String productId}) {
    return (select(db.variationTable)
          ..where((t) => t.productId.equals(productId)))
        .get();
  }

  Stream<List<VariationTableData>> getVariantByItemIdStream(String itemId) {
    return (select(db.variationTable)..where((t) => t.id.equals(itemId)))
        .watch();
  }

  Future softDelete(VariationTableData entry) {
    return update(db.variationTable)
        .replace(entry.copyWith(deletedAt: DateTime.now().toString()));
  }

  Future deleteVariation(Insertable<VariationTableData> item) =>
      delete(db.variationTable).delete(item);

  Stream<List<VariationTableData>> getVariationByStream(
      String name, String branchId) {
    return (select(db.variationTable)..where((t) => t.name.equals(name)))
        .watch();
  }

  Stream<List<VariationTableData>> getVariationByItemIdStream(String itemId) {
    return (select(db.variationTable)
          ..where((t) => t.productId.equals(itemId))
          ..where((t) => t.deletedAt.equals('null')))
        .watch();
  }

  Stream<List<VariationTableData>> getVariationByNameStream(
      String name, String productId) {
    return (select(db.variationTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.productId.equals(productId)))
        .watch();
  }

  Future<VariationTableData> getVariationByName(
      {String name, String productId}) {
    return (select(db.variationTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.productId.equals(productId)))
        .getSingle();
  }

  Future<VariationTableData> getVariationByIdLocal({int variantId}) {
    return (select(db.variationTable)
          ..where((t) => t.idLocal.equals(variantId)))
        .getSingle();
  }
}
