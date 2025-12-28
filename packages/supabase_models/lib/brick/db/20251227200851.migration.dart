// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227200851_up = [
  DropColumn('branch_server_id', onTable: 'Credit'),
  InsertColumn('branch_server_id', Column.varchar, onTable: 'Credit')
];

const List<MigrationCommand> _migration_20251227200851_down = [
  DropColumn('branch_server_id', onTable: 'Credit')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227200851',
  up: _migration_20251227200851_up,
  down: _migration_20251227200851_down,
)
class Migration20251227200851 extends Migration {
  const Migration20251227200851()
    : super(
        version: 20251227200851,
        up: _migration_20251227200851_up,
        down: _migration_20251227200851_down,
      );
}
