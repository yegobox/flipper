// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250619090951_up = [
  InsertColumn('branch_id', Column.varchar, onTable: 'InventoryRequest'),
  InsertColumn('financing_id', Column.varchar, onTable: 'InventoryRequest')
];

const List<MigrationCommand> _migration_20250619090951_down = [
  DropColumn('branch_id', onTable: 'InventoryRequest'),
  DropColumn('financing_id', onTable: 'InventoryRequest')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250619090951',
  up: _migration_20250619090951_up,
  down: _migration_20250619090951_down,
)
class Migration20250619090951 extends Migration {
  const Migration20250619090951()
    : super(
        version: 20250619090951,
        up: _migration_20250619090951_up,
        down: _migration_20250619090951_down,
      );
}
