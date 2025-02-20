// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250215090308_up = [
  InsertTable('FinanceProvider'),
  InsertForeignKey('Financing', 'FinanceProvider',
      foreignKeyColumn: 'provider_FinanceProvider_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: true),
  InsertColumn('id', Column.varchar, onTable: 'FinanceProvider', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'FinanceProvider'),
  InsertColumn('interest_rate', Column.Double, onTable: 'FinanceProvider'),
  InsertColumn('suppliers_that_accept_this_finance_facility', Column.varchar,
      onTable: 'FinanceProvider'),
  CreateIndex(columns: ['id'], onTable: 'FinanceProvider', unique: true)
];

const List<MigrationCommand> _migration_20250215090308_down = [
  DropTable('FinanceProvider'),
  DropColumn('provider_FinanceProvider_brick_id', onTable: 'Financing'),
  DropColumn('id', onTable: 'FinanceProvider'),
  DropColumn('name', onTable: 'FinanceProvider'),
  DropColumn('interest_rate', onTable: 'FinanceProvider'),
  DropColumn('suppliers_that_accept_this_finance_facility',
      onTable: 'FinanceProvider'),
  DropIndex('index_FinanceProvider_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250215090308',
  up: _migration_20250215090308_up,
  down: _migration_20250215090308_down,
)
class Migration20250215090308 extends Migration {
  const Migration20250215090308()
      : super(
          version: 20250215090308,
          up: _migration_20250215090308_up,
          down: _migration_20250215090308_down,
        );
}
