// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241114183418_up = [
  InsertTable('_brick_StockRequest_items'),
  InsertTable('StockRequest'),
  InsertForeignKey('_brick_StockRequest_items', 'StockRequest',
      foreignKeyColumn: 'l_StockRequest_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('_brick_StockRequest_items', 'TransactionItem',
      foreignKeyColumn: 'f_TransactionItem_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertColumn('id', Column.integer, onTable: 'StockRequest', unique: true),
  InsertColumn('main_branch_id', Column.integer, onTable: 'StockRequest'),
  InsertColumn('sub_branch_id', Column.integer, onTable: 'StockRequest'),
  InsertColumn('created_at', Column.datetime, onTable: 'StockRequest'),
  InsertColumn('status', Column.varchar, onTable: 'StockRequest'),
  InsertColumn('delivery_date', Column.datetime, onTable: 'StockRequest'),
  InsertColumn('delivery_note', Column.varchar, onTable: 'StockRequest'),
  InsertColumn('order_note', Column.varchar, onTable: 'StockRequest'),
  InsertColumn('customer_received_order', Column.boolean,
      onTable: 'StockRequest'),
  InsertColumn('driver_request_delivery_confirmation', Column.boolean,
      onTable: 'StockRequest'),
  InsertColumn('driver_id', Column.integer, onTable: 'StockRequest'),
  InsertColumn('updated_at', Column.datetime, onTable: 'StockRequest'),
  CreateIndex(
      columns: ['l_StockRequest_brick_id', 'f_TransactionItem_brick_id'],
      onTable: '_brick_StockRequest_items',
      unique: true)
];

const List<MigrationCommand> _migration_20241114183418_down = [
  DropTable('_brick_StockRequest_items'),
  DropTable('StockRequest'),
  DropColumn('l_StockRequest_brick_id', onTable: '_brick_StockRequest_items'),
  DropColumn('f_TransactionItem_brick_id',
      onTable: '_brick_StockRequest_items'),
  DropColumn('id', onTable: 'StockRequest'),
  DropColumn('main_branch_id', onTable: 'StockRequest'),
  DropColumn('sub_branch_id', onTable: 'StockRequest'),
  DropColumn('created_at', onTable: 'StockRequest'),
  DropColumn('status', onTable: 'StockRequest'),
  DropColumn('delivery_date', onTable: 'StockRequest'),
  DropColumn('delivery_note', onTable: 'StockRequest'),
  DropColumn('order_note', onTable: 'StockRequest'),
  DropColumn('customer_received_order', onTable: 'StockRequest'),
  DropColumn('driver_request_delivery_confirmation', onTable: 'StockRequest'),
  DropColumn('driver_id', onTable: 'StockRequest'),
  DropColumn('updated_at', onTable: 'StockRequest'),
  DropIndex(
      'index__brick_StockRequest_items_on_l_StockRequest_brick_id_f_TransactionItem_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241114183418',
  up: _migration_20241114183418_up,
  down: _migration_20241114183418_down,
)
class Migration20241114183418 extends Migration {
  const Migration20241114183418()
      : super(
          version: 20241114183418,
          up: _migration_20241114183418_up,
          down: _migration_20241114183418_down,
        );
}
