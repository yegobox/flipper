// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250221173108_up = [
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id',
      onTable: 'TransactionItem'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  InsertTable('VariantBranch'),
  InsertForeignKey('Financing', 'FinanceProvider',
      foreignKeyColumn: 'provider_FinanceProvider_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('TransactionItem', 'InventoryRequest',
      foreignKeyColumn: 'inventory_request_InventoryRequest_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Branch',
      foreignKeyColumn: 'branch_Branch_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertForeignKey('InventoryRequest', 'Financing',
      foreignKeyColumn: 'financing_Financing_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: false),
  InsertColumn('id', Column.varchar, onTable: 'VariantBranch', unique: true),
  InsertColumn('variant_id', Column.varchar, onTable: 'VariantBranch'),
  InsertColumn('new_variant_id', Column.varchar, onTable: 'VariantBranch'),
  InsertColumn('source_branch_id', Column.integer, onTable: 'VariantBranch'),
  InsertColumn('destination_branch_id', Column.integer,
      onTable: 'VariantBranch'),
  CreateIndex(columns: ['id'], onTable: 'VariantBranch', unique: true)
];

const List<MigrationCommand> _migration_20250221173108_down = [
  DropTable('VariantBranch'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id',
      onTable: 'TransactionItem'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropColumn('id', onTable: 'VariantBranch'),
  DropColumn('variant_id', onTable: 'VariantBranch'),
  DropColumn('new_variant_id', onTable: 'VariantBranch'),
  DropColumn('source_branch_id', onTable: 'VariantBranch'),
  DropColumn('destination_branch_id', onTable: 'VariantBranch'),
  DropIndex('index_VariantBranch_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250221173108',
  up: _migration_20250221173108_up,
  down: _migration_20250221173108_down,
)
class Migration20250221173108 extends Migration {
  const Migration20250221173108()
      : super(
          version: 20250221173108,
          up: _migration_20250221173108_up,
          down: _migration_20250221173108_down,
        );
}
