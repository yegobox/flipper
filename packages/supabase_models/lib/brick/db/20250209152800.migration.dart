// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250209152800_up = [
  
  InsertTable('_brick_InventoryRequest_transaction_items'),
  InsertTable('InventoryRequest'),
  InsertForeignKey('TransactionItem', 'InventoryRequest', foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('inventory_request_id', Column.varchar, onTable: 'TransactionItem'),
  InsertForeignKey('_brick_InventoryRequest_transaction_items', 'InventoryRequest', foreignKeyColumn: 'l_InventoryRequest_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('_brick_InventoryRequest_transaction_items', 'TransactionItem', foreignKeyColumn: 'f_TransactionItem_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertColumn('id', Column.varchar, onTable: 'InventoryRequest', unique: true),
  InsertColumn('main_branch_id', Column.integer, onTable: 'InventoryRequest'),
  InsertColumn('sub_branch_id', Column.integer, onTable: 'InventoryRequest'),
  InsertColumn('created_at', Column.datetime, onTable: 'InventoryRequest'),
  InsertColumn('status', Column.varchar, onTable: 'InventoryRequest'),
  InsertColumn('delivery_date', Column.datetime, onTable: 'InventoryRequest'),
  InsertColumn('delivery_note', Column.varchar, onTable: 'InventoryRequest'),
  InsertColumn('order_note', Column.varchar, onTable: 'InventoryRequest'),
  InsertColumn('customer_received_order', Column.boolean, onTable: 'InventoryRequest'),
  InsertColumn('driver_request_delivery_confirmation', Column.boolean, onTable: 'InventoryRequest'),
  InsertColumn('driver_id', Column.integer, onTable: 'InventoryRequest'),
  InsertColumn('transaction_items', Column.varchar, onTable: 'InventoryRequest'),
  InsertColumn('updated_at', Column.datetime, onTable: 'InventoryRequest'),
  InsertColumn('item_counts', Column.num, onTable: 'InventoryRequest'),
  CreateIndex(columns: ['l_InventoryRequest_brick_id', 'f_TransactionItem_brick_id'], onTable: '_brick_InventoryRequest_transaction_items', unique: true),
  CreateIndex(columns: ['id'], onTable: 'InventoryRequest', unique: true)
];

const List<MigrationCommand> _migration_20250209152800_down = [
  DropTable('_brick_InventoryRequest_transaction_items'),
  DropTable('InventoryRequest'),
  DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  DropColumn('inventory_request_id', onTable: 'TransactionItem'),
  DropColumn('l_InventoryRequest_brick_id', onTable: '_brick_InventoryRequest_transaction_items'),
  DropColumn('f_TransactionItem_brick_id', onTable: '_brick_InventoryRequest_transaction_items'),
  DropColumn('id', onTable: 'InventoryRequest'),
  DropColumn('main_branch_id', onTable: 'InventoryRequest'),
  DropColumn('sub_branch_id', onTable: 'InventoryRequest'),
  DropColumn('created_at', onTable: 'InventoryRequest'),
  DropColumn('status', onTable: 'InventoryRequest'),
  DropColumn('delivery_date', onTable: 'InventoryRequest'),
  DropColumn('delivery_note', onTable: 'InventoryRequest'),
  DropColumn('order_note', onTable: 'InventoryRequest'),
  DropColumn('customer_received_order', onTable: 'InventoryRequest'),
  DropColumn('driver_request_delivery_confirmation', onTable: 'InventoryRequest'),
  DropColumn('driver_id', onTable: 'InventoryRequest'),
  DropColumn('transaction_items', onTable: 'InventoryRequest'),
  DropColumn('updated_at', onTable: 'InventoryRequest'),
  DropColumn('item_counts', onTable: 'InventoryRequest'),
  DropIndex('index__brick_InventoryRequest_transaction_items_on_l_InventoryRequest_brick_id_f_TransactionItem_brick_id'),
  DropIndex('index_InventoryRequest_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250209152800',
  up: _migration_20250209152800_up,
  down: _migration_20250209152800_down,
)
class Migration20250209152800 extends Migration {
  const Migration20250209152800()
    : super(
        version: 20250209152800,
        up: _migration_20250209152800_up,
        down: _migration_20250209152800_down,
      );
}
