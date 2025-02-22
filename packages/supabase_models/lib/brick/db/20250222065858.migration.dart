// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250222065858_up = [
  InsertColumn('bhf_id', Column.varchar, onTable: 'InventoryRequest'),
  InsertColumn('tin_number', Column.varchar, onTable: 'InventoryRequest')
];

const List<MigrationCommand> _migration_20250222065858_down = [
  DropColumn('bhf_id', onTable: 'InventoryRequest'),
  DropColumn('tin_number', onTable: 'InventoryRequest')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250222065858',
  up: _migration_20250222065858_up,
  down: _migration_20250222065858_down,
)
class Migration20250222065858 extends Migration {
  const Migration20250222065858()
    : super(
        version: 20250222065858,
        up: _migration_20250222065858_up,
        down: _migration_20250222065858_down,
      );
}
