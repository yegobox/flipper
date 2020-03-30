import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/order_table.dart';
import 'package:moor/moor.dart';

part 'order_dao.g.dart';

@UseDao(tables: [OrderTable])
class OrderDao extends DatabaseAccessor<Database> with _$OrderDaoMixin {
  final Database db;

  OrderDao(this.db) : super(db);

  Future insert(Insertable<OrderTableData> order) =>
      into(db.orderTable).insert(order);

  Future<OrderTableData> getExistingDraftOrder() {
    return (select(db.orderTable)..where((t) => t.status.equals("draft")))
        .getSingle();
  }

  Future<OrderTableData> getOrderById(String orderId) {
    return (select(db.orderTable)..where((t) => t.id.equals(orderId)))
        .getSingle();
  }

  Future<List<OrderTableData>> getOrders() => select(db.orderTable).get();

  Stream<List<OrderTableData>> getOrdersStream() {
    return (select(db.orderTable)..where((t) => t.status.equals('completed')))
        .watch();
  }

  Future updateOrder(OrderTableData entry) {
    return update(db.orderTable).replace(entry);
  }
}
