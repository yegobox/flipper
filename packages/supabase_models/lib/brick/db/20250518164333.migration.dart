// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250518164333_up = [
  InsertColumn('is_uploaded', Column.boolean, onTable: 'Assets'),
  InsertColumn('local_path', Column.varchar, onTable: 'Assets'),
];

const List<MigrationCommand> _migration_20250518164333_down = [
  DropColumn('is_uploaded', onTable: 'Assets'),
  DropColumn('local_path', onTable: 'Assets'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250518164333',
  up: _migration_20250518164333_up,
  down: _migration_20250518164333_down,
)
class Migration20250518164333 extends Migration {
  const Migration20250518164333()
      : super(
          version: 20250518164333,
          up: _migration_20250518164333_up,
          down: _migration_20250518164333_down,
        );
}
