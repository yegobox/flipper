// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250220114830_up = [
  DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  DropColumn('l_InventoryRequest_brick_id', onTable: '_brick_InventoryRequest_transaction_items'),
  DropColumn('f_TransactionItem_brick_id', onTable: '_brick_InventoryRequest_transaction_items'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  InsertForeignKey('TransactionItem', 'InventoryRequest', foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('branch_ids', Column.varchar, onTable: 'Variant'),
  InsertForeignKey('_brick_InventoryRequest_transaction_items', 'InventoryRequest', foreignKeyColumn: 'l_InventoryRequest_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('_brick_InventoryRequest_transaction_items', 'TransactionItem', foreignKeyColumn: 'f_TransactionItem_brick_id', onDeleteCascade: true, onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Branch', foreignKeyColumn: 'branch_Branch_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Financing', foreignKeyColumn: 'financing_Financing_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('Financing', 'FinanceProvider', foreignKeyColumn: 'provider_FinanceProvider_brick_id', onDeleteCascade: false, onDeleteSetDefault: false)
];

const List<MigrationCommand> _migration_20250220114830_down = [
  DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  DropColumn('branch_ids', onTable: 'Variant'),
  DropColumn('l_InventoryRequest_brick_id', onTable: '_brick_InventoryRequest_transaction_items'),
  DropColumn('f_TransactionItem_brick_id', onTable: '_brick_InventoryRequest_transaction_items'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250220114830',
  up: _migration_20250220114830_up,
  down: _migration_20250220114830_down,
)
class Migration20250220114830 extends Migration {
  const Migration20250220114830()
    : super(
        version: 20250220114830,
        up: _migration_20250220114830_up,
        down: _migration_20250220114830_down,
      );
}
