// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250314135245_up = [
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  InsertTable('Message'),
  InsertColumn('id', Column.varchar, onTable: 'Message', unique: true),
  InsertColumn('text', Column.varchar, onTable: 'Message'),
  InsertColumn('phone_number', Column.varchar, onTable: 'Message'),
  InsertColumn('delivered', Column.boolean, onTable: 'Message'),
  InsertColumn('branch_id', Column.integer, onTable: 'Message'),
  InsertColumn('role', Column.varchar, onTable: 'Message'),
  InsertColumn('timestamp', Column.datetime, onTable: 'Message'),
  InsertColumn('conversation_id', Column.varchar, onTable: 'Message'),
  InsertColumn('ai_response', Column.varchar, onTable: 'Message'),
  InsertColumn('ai_context', Column.varchar, onTable: 'Message'),
  InsertForeignKey('Financing', 'FinanceProvider', foreignKeyColumn: 'provider_FinanceProvider_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('TransactionItem', 'InventoryRequest', foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('Variant', 'Stock', foreignKeyColumn: 'stock_Stock_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Branch', foreignKeyColumn: 'branch_Branch_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Financing', foreignKeyColumn: 'financing_Financing_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  CreateIndex(columns: ['id'], onTable: 'Message', unique: true)
];

const List<MigrationCommand> _migration_20250314135245_down = [
  DropTable('Message'),
  DropColumn('id', onTable: 'Message'),
  DropColumn('text', onTable: 'Message'),
  DropColumn('phone_number', onTable: 'Message'),
  DropColumn('delivered', onTable: 'Message'),
  DropColumn('branch_id', onTable: 'Message'),
  DropColumn('role', onTable: 'Message'),
  DropColumn('timestamp', onTable: 'Message'),
  DropColumn('conversation_id', onTable: 'Message'),
  DropColumn('ai_response', onTable: 'Message'),
  DropColumn('ai_context', onTable: 'Message'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropIndex('index_Message_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250314135245',
  up: _migration_20250314135245_up,
  down: _migration_20250314135245_down,
)
class Migration20250314135245 extends Migration {
  const Migration20250314135245()
    : super(
        version: 20250314135245,
        up: _migration_20250314135245_up,
        down: _migration_20250314135245_down,
      );
}
