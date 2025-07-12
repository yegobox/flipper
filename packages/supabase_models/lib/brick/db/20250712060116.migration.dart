// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250712060116_up = [
  DropColumn('status', onTable: 'Shift'),
  InsertColumn('status', Column.varchar, onTable: 'Shift')
];

const List<MigrationCommand> _migration_20250712060116_down = [
  DropColumn('status', onTable: 'Shift')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250712060116',
  up: _migration_20250712060116_up,
  down: _migration_20250712060116_down,
)
class Migration20250712060116 extends Migration {
  const Migration20250712060116()
    : super(
        version: 20250712060116,
        up: _migration_20250712060116_up,
        down: _migration_20250712060116_down,
      );
}
