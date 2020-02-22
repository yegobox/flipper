import 'package:flipper/data/cart_table.dart';
import 'package:flipper/data/main_database.dart';
import 'package:moor/moor.dart';

part 'order_dao.g.dart';

@UseDao(tables: [CartTable])
class OrderDao extends DatabaseAccessor<Database> with _$OrderDaoMixin {
  final Database db;

  OrderDao(this.db) : super(db);

  Future insert(Insertable<OrderTableData> order) =>
      into(db.orderTable).insert(order);

  Future<OrderTableData> getExistingDraftOrder() {
    return (select(db.orderTable)..where((t) => t.status.equals("draft")))
        .getSingle();
  }

  Future<OrderTableData> getOrderById(int orderId) {
    return (select(db.orderTable)..where((t) => t.id.equals(orderId)))
        .getSingle();
  }

  Future updateOrder(OrderTableData entry) {
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.orderTable).replace(entry);
  }
}
