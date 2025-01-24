// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250124185812_up = [
  DropColumn('value', onTable: 'BusinessAnalytic'),
  InsertColumn('value', Column.num, onTable: 'BusinessAnalytic')
];

const List<MigrationCommand> _migration_20250124185812_down = [
  DropColumn('value', onTable: 'BusinessAnalytic')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250124185812',
  up: _migration_20250124185812_up,
  down: _migration_20250124185812_down,
)
class Migration20250124185812 extends Migration {
  const Migration20250124185812()
    : super(
        version: 20250124185812,
        up: _migration_20250124185812_up,
        down: _migration_20250124185812_down,
      );
}
