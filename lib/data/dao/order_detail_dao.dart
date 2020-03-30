import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/order_detail_table.dart';
import 'package:moor/moor.dart';

part 'order_detail_dao.g.dart';

@UseDao(tables: [OrderDetailTable])
class OrderDetailDao extends DatabaseAccessor<Database>
    with _$OrderDetailDaoMixin {
  final Database db;

  OrderDetailDao(this.db) : super(db);

  Future insert(Insertable<OrderDetailTableData> cart) =>
      into(db.orderDetailTable).insert(cart);

  Stream<List<OrderDetailTableData>> getCartsStream(String orderId) {
    return (select(db.orderDetailTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.orderId.equals(orderId)))
        .watch();
  }

  Future<List<OrderDetailTableData>> getCarts(String orderId) {
    return (select(db.orderDetailTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])
          ..where((t) => t.orderId.equals(orderId)))
        .get();
  }

  Future<OrderDetailTableData> getExistingCartItem(String variationId) {
    return (select(db.orderDetailTable)
          ..where((t) => t.variationId.equals(variationId)))
        .getSingle();
  }

  Future updateCart(OrderDetailTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.orderDetailTable).replace(entry);
  }
}
