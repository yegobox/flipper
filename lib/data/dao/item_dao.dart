import 'package:flipper/data/dao/item_variation.dart';
import 'package:flipper/data/item_table.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/variation_table.dart';
import 'package:moor/moor.dart';

part 'item_dao.g.dart';

@UseDao(tables: [ItemTable, VariationTable])
class ItemDao extends DatabaseAccessor<Database> with _$ItemDaoMixin {
  final Database db;

  ItemDao(this.db) : super(db);

  Future insert(Insertable<ItemTableData> item) =>
      into(db.itemTable).insert(item);

  Future deleteItem(Insertable<ItemTableData> item) =>
      delete(db.itemTable).delete(item);

  //only updated deletedAt column
  Future softDelete(ItemTableData entry) {
    return update(db.itemTable)
        .replace(entry.copyWith(deletedAt: DateTime.now()));
  }

  Future updateItem(ItemTableData entry) {
    return update(db.itemTable).replace(entry);
  }

  Future<List<ItemVariation>> getItemVariations() {
    return (select(itemTable)
          ..orderBy(
            ([
              (t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc),
            ]),
          ))
        .join(
      [
        leftOuterJoin(variationTable,
            db.variationTable.branchId.equalsExp(db.itemTable.branchId)),
      ],
    ).map((row) {
      final items = row.readTable(itemTable);
      final variations = row.readTable(variationTable);

      return ItemVariation(items: items, variations: variations);
    }).get();
  }

  Future<ItemTableData> getItemByBranch({String name, int branchId}) {
    return (select(db.itemTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.branchId.equals(branchId)))
        .getSingle();
  }

  Future<ItemTableData> getItemBy({String name, int branchId, int itemId}) {
    return (select(db.itemTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.id.equals(itemId))
          ..where((t) => t.branchId.equals(branchId)))
        .getSingle();
  }

  Future<ItemTableData> getItemById({int itemId}) {
    return (select(db.itemTable)..where((t) => t.id.equals(itemId)))
        .getSingle();
  }

  Future<ItemTableData> getItemByName({String name, int branchId}) {
    return (select(db.itemTable)
          ..where((t) => t.name.equals(name))
          ..where((t) => t.branchId.equals(branchId)))
        .getSingle();
  }

  Future<List<ItemTableData>> getItems() => select(db.itemTable).get();

  Stream<List<ItemTableData>> getItemsStream() {
    return (select(db.itemTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)]))
        .watch();
  }

  Stream<List<ItemTableData>> getItemByIdStream(int itemId) {
    return (select(db.itemTable)..where((t) => t.id.equals(itemId))).watch();
  }
}
