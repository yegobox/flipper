// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250308112114_up = [
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id',
      onTable: 'TransactionItem'),
  DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  InsertColumn('is_digital_receipt_generated', Column.boolean,
      onTable: 'ITransaction'),
  InsertForeignKey('Financing', 'FinanceProvider',
      foreignKeyColumn: 'provider_FinanceProvider_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('TransactionItem', 'InventoryRequest',
      foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('Variant', 'Stock',
      foreignKeyColumn: 'stock_Stock_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Branch',
      foreignKeyColumn: 'branch_Branch_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Financing',
      foreignKeyColumn: 'financing_Financing_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false)
];

const List<MigrationCommand> _migration_20250308112114_down = [
  DropColumn('is_digital_receipt_generated', onTable: 'ITransaction'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id',
      onTable: 'TransactionItem'),
  DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250308112114',
  up: _migration_20250308112114_up,
  down: _migration_20250308112114_down,
)
class Migration20250308112114 extends Migration {
  const Migration20250308112114()
      : super(
          version: 20250308112114,
          up: _migration_20250308112114_up,
          down: _migration_20250308112114_down,
        );
}
