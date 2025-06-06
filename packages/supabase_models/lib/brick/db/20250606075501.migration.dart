// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250606075501_up = [
  // DropColumn('billing_amount', onTable: 'ITransaction'),
  // DropColumn('original_loan_amount', onTable: 'ITransaction'),
  // DropColumn('remaining_balance', onTable: 'ITransaction'),
  // DropColumn('last_payment_amount', onTable: 'ITransaction'),
  // DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  // DropColumn('plan_id', onTable: 'PlanAddon'),
  // DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  // DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  // // DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('financing_bhf_id', onTable: 'InventoryRequest'),
  // // DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  // // DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('business_id', onTable: 'Plan'),
  // InsertColumn('billing_amount', Column.num, onTable: 'ITransaction'),
  // InsertColumn('original_loan_amount', Column.num, onTable: 'ITransaction'),
  // InsertColumn('remaining_balance', Column.num, onTable: 'ITransaction'),
  // InsertColumn('last_payment_amount', Column.num, onTable: 'ITransaction'),
  // InsertForeignKey('Financing', 'FinanceProvider', foreignKeyColumn: 'provider_FinanceProvider_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertColumn('plan_id', Column.varchar, onTable: 'PlanAddon'),
  // InsertForeignKey('TransactionItem', 'InventoryRequest', foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('Variant', 'Stock', foreignKeyColumn: 'stock_Stock_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // // InsertForeignKey('InventoryRequest', 'Branch', foreignKeyColumn: 'branch_Branch_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertForeignKey('InventoryRequest', 'Financing', foreignKeyColumn: 'financing_Financing_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  // InsertColumn('business_id', Column.varchar, onTable: 'Plan'),
  // InsertColumn('branch_id', Column.varchar, onTable: 'Plan'),
  // InsertColumn('phone_number', Column.varchar, onTable: 'Plan'),
  // CreateIndex(columns: ['branch_id'], onTable: 'BranchSmsConfig', unique: true)
];

const List<MigrationCommand> _migration_20250606075501_down = [
  // DropColumn('billing_amount', onTable: 'ITransaction'),
  // DropColumn('original_loan_amount', onTable: 'ITransaction'),
  // DropColumn('remaining_balance', onTable: 'ITransaction'),
  // DropColumn('last_payment_amount', onTable: 'ITransaction'),
  // DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  // DropColumn('plan_id', onTable: 'PlanAddon'),
  // DropColumn('inventory_request_InventoryRequest_brick_id', onTable: 'TransactionItem'),
  // DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  // // DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  // // DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  // DropColumn('business_id', onTable: 'Plan'),
  // DropColumn('branch_id', onTable: 'Plan'),
  // DropColumn('phone_number', onTable: 'Plan'),
  // DropIndex('index_BranchSmsConfig_on_branch_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250606075501',
  up: _migration_20250606075501_up,
  down: _migration_20250606075501_down,
)
class Migration20250606075501 extends Migration {
  const Migration20250606075501()
      : super(
          version: 20250606075501,
          up: _migration_20250606075501_up,
          down: _migration_20250606075501_down,
        );
}
