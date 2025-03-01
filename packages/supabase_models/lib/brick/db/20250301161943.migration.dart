// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250301161943_up = [
  DropTable('_brick_Purchase_variants'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id',
      onTable: 'TransactionItem'),
  DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropColumn('variants', onTable: 'Purchase'),
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
      onDeleteSetDefault: false),
  CreateIndex(
      columns: ['l_Purchase_brick_id', 'f_Variant_brick_id'],
      onTable: '_brick_Purchase_variants',
      unique: true)
];

const List<MigrationCommand> _migration_20250301161943_down = [
  InsertTable('_brick_Purchase_variants'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('inventory_request_InventoryRequest_brick_id',
      onTable: 'TransactionItem'),
  DropColumn('stock_Stock_brick_id', onTable: 'Variant'),
  DropColumn('branch_Branch_brick_id', onTable: 'InventoryRequest'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropIndex(
      'index__brick_Purchase_variants_on_l_Purchase_brick_id_f_Variant_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250301161943',
  up: _migration_20250301161943_up,
  down: _migration_20250301161943_down,
)
class Migration20250301161943 extends Migration {
  const Migration20250301161943()
      : super(
          version: 20250301161943,
          up: _migration_20250301161943_up,
          down: _migration_20250301161943_down,
        );
}
