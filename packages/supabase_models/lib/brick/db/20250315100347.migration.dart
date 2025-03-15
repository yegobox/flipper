// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250315100347_up = [
  // DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  // DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  // DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  // DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  InsertTable('AiConversation'),
  // InsertForeignKey('Financing', 'FinanceProvider', foreignKeyColumn: 'provider_FinanceProvider_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('TransactionItem', 'InventoryRequest', foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('Variant', 'Stock', foreignKeyColumn: 'stock_Stock_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('InventoryRequest', 'Branch', foreignKeyColumn: 'branch_Branch_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('InventoryRequest', 'Financing', foreignKeyColumn: 'financing_Financing_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('id', Column.varchar, onTable: 'AiConversation', unique: true),
  InsertColumn('title', Column.varchar, onTable: 'AiConversation'),
  InsertColumn('branch_id', Column.integer, onTable: 'AiConversation'),
  InsertColumn('created_at', Column.datetime, onTable: 'AiConversation'),
  InsertColumn('last_message_at', Column.datetime, onTable: 'AiConversation'),
  CreateIndex(columns: ['conversation_id'], onTable: 'Message', unique: false),
  CreateIndex(columns: ['id'], onTable: 'AiConversation', unique: true),
  CreateIndex(columns: ['branch_id'], onTable: 'BranchSmsConfig', unique: true)
];

const List<MigrationCommand> _migration_20250315100347_down = [
  DropTable('AiConversation'),
  // DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  // DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  // DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  // DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropColumn('id', onTable: 'AiConversation'),
  DropColumn('title', onTable: 'AiConversation'),
  DropColumn('branch_id', onTable: 'AiConversation'),
  DropColumn('created_at', onTable: 'AiConversation'),
  DropColumn('last_message_at', onTable: 'AiConversation'),
  DropIndex('index_Message_on_conversation_id'),
  DropIndex('index_AiConversation_on_id'),
  DropIndex('index_BranchSmsConfig_on_branch_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250315100347',
  up: _migration_20250315100347_up,
  down: _migration_20250315100347_down,
)
class Migration20250315100347 extends Migration {
  const Migration20250315100347()
      : super(
          version: 20250315100347,
          up: _migration_20250315100347_up,
          down: _migration_20250315100347_down,
        );
}
