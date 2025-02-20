// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250215085812_up = [
  InsertTable('Financing'),
  InsertForeignKey('InventoryRequest', 'Financing',
      foreignKeyColumn: 'financing_Financing_brick_id',
      onDeleteCascade: true,
      onDeleteSetDefault: true),
  InsertColumn('id', Column.varchar, onTable: 'Financing', unique: true),
  InsertColumn('requested', Column.boolean, onTable: 'Financing'),
  InsertColumn('status', Column.varchar, onTable: 'Financing'),
  InsertColumn('amount', Column.Double, onTable: 'Financing'),
  InsertColumn('approval_date', Column.datetime, onTable: 'Financing'),
  CreateIndex(columns: ['id'], onTable: 'Financing', unique: true)
];

const List<MigrationCommand> _migration_20250215085812_down = [
  DropTable('Financing'),
  DropColumn('financing_Financing_brick_id', onTable: 'InventoryRequest'),
  DropColumn('id', onTable: 'Financing'),
  DropColumn('requested', onTable: 'Financing'),
  DropColumn('status', onTable: 'Financing'),
  DropColumn('amount', onTable: 'Financing'),
  DropColumn('approval_date', onTable: 'Financing'),
  DropIndex('index_Financing_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250215085812',
  up: _migration_20250215085812_up,
  down: _migration_20250215085812_down,
)
class Migration20250215085812 extends Migration {
  const Migration20250215085812()
      : super(
          version: 20250215085812,
          up: _migration_20250215085812_up,
          down: _migration_20250215085812_down,
        );
}
