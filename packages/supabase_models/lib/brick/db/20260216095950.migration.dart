// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260216095950_up = [
  DropColumn('business_type_id', onTable: 'Business'),
  InsertColumn('business_type_id', Column.integer, onTable: 'Business'),
  InsertColumn('features', Column.varchar, onTable: 'BusinessType')
];

const List<MigrationCommand> _migration_20260216095950_down = [
  DropColumn('business_type_id', onTable: 'Business'),
  DropColumn('features', onTable: 'BusinessType')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260216095950',
  up: _migration_20260216095950_up,
  down: _migration_20260216095950_down,
)
class Migration20260216095950 extends Migration {
  const Migration20260216095950()
    : super(
        version: 20260216095950,
        up: _migration_20260216095950_up,
        down: _migration_20260216095950_down,
      );
}
