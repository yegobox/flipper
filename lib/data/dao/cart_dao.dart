import 'package:flipper/data/cart_table.dart';
import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'cart_dao.g.dart';

@UseDao(tables: [CartTable])
class CartDao extends DatabaseAccessor<Database> with _$CartDaoMixin {
  final Database db;

  CartDao(this.db) : super(db);

  Future insert(Insertable<CartTableData> cart) =>
      into(db.cartTable).insert(cart);

  Stream<List<CartTableData>> getCartsStream(String orderId) {
    return (select(db.cartTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.orderId.equals(orderId)))
        .watch();
  }

  Future<List<CartTableData>> getCarts(String orderId) {
    return (select(db.cartTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.orderId.equals(orderId)))
        .get();
  }

  Future<CartTableData> getExistingCartItem(String variationId) {
    return (select(db.cartTable)
          ..where((t) => t.variationId.equals(variationId)))
        .getSingle();
  }

  Future updateCart(CartTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.cartTable).replace(entry);
  }
}
