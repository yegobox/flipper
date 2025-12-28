// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227205309_up = [
  DropColumn('identifier', onTable: 'AppNotification'),
  InsertColumn('identifier', Column.varchar, onTable: 'AppNotification')
];

const List<MigrationCommand> _migration_20251227205309_down = [
  DropColumn('identifier', onTable: 'AppNotification')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227205309',
  up: _migration_20251227205309_up,
  down: _migration_20251227205309_down,
)
class Migration20251227205309 extends Migration {
  const Migration20251227205309()
    : super(
        version: 20251227205309,
        up: _migration_20251227205309_up,
        down: _migration_20251227205309_down,
      );
}
