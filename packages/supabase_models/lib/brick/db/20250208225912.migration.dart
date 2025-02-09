// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250208225912_up = [
  DropTable('_brick_StockRequest_items'),
  DropColumn('items', onTable: 'StockRequest'),
  InsertTable('_brick_StockRequest_transaction_items'),
  InsertColumn('stock_request_id', Column.varchar, onTable: 'TransactionItem'),
  InsertForeignKey('_brick_StockRequest_transaction_items', 'StockRequest',
      foreignKeyColumn: 'l_StockRequest_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('_brick_StockRequest_transaction_items', 'TransactionItem',
      foreignKeyColumn: 'f_TransactionItem_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertColumn('transaction_items', Column.varchar, onTable: 'StockRequest'),
  InsertColumn('item_counts', Column.num, onTable: 'StockRequest'),
  CreateIndex(
      columns: ['l_StockRequest_brick_id', 'f_TransactionItem_brick_id'],
      onTable: '_brick_StockRequest_transaction_items',
      unique: true),
  CreateIndex(
      columns: ['l_StockRequest_brick_id', 'f_TransactionItem_brick_id'],
      onTable: '_brick_StockRequest_items',
      unique: true)
];

const List<MigrationCommand> _migration_20250208225912_down = [
  InsertTable('_brick_StockRequest_items'),
  DropTable('_brick_StockRequest_transaction_items'),
  DropColumn('stock_request_id', onTable: 'TransactionItem'),
  DropColumn('l_StockRequest_brick_id',
      onTable: '_brick_StockRequest_transaction_items'),
  DropColumn('f_TransactionItem_brick_id',
      onTable: '_brick_StockRequest_transaction_items'),
  DropColumn('transaction_items', onTable: 'StockRequest'),
  DropColumn('item_counts', onTable: 'StockRequest'),
  DropIndex(
      'index__brick_StockRequest_transaction_items_on_l_StockRequest_brick_id_f_TransactionItem_brick_id'),
  DropIndex(
      'index__brick_StockRequest_items_on_l_StockRequest_brick_id_f_TransactionItem_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250208225912',
  up: _migration_20250208225912_up,
  down: _migration_20250208225912_down,
)
class Migration20250208225912 extends Migration {
  const Migration20250208225912()
      : super(
          version: 20250208225912,
          up: _migration_20250208225912_up,
          down: _migration_20250208225912_down,
        );
}
