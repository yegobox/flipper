// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251228185846_up = [
  DropColumn('latitude', onTable: 'Branch'),
  DropColumn('longitude', onTable: 'Branch'),
  InsertColumn('latitude', Column.num, onTable: 'Branch'),
  InsertColumn('longitude', Column.num, onTable: 'Branch')
];

const List<MigrationCommand> _migration_20251228185846_down = [
  DropColumn('latitude', onTable: 'Branch'),
  DropColumn('longitude', onTable: 'Branch')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251228185846',
  up: _migration_20251228185846_up,
  down: _migration_20251228185846_down,
)
class Migration20251228185846 extends Migration {
  const Migration20251228185846()
    : super(
        version: 20251228185846,
        up: _migration_20251228185846_up,
        down: _migration_20251228185846_down,
      );
}
