// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250102130727_up = [
  DropColumn('opening_date_time', onTable: 'Drawers'),
  InsertColumn('opening_date_time', Column.datetime, onTable: 'Drawers')
];

const List<MigrationCommand> _migration_20250102130727_down = [
  DropColumn('opening_date_time', onTable: 'Drawers')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250102130727',
  up: _migration_20250102130727_up,
  down: _migration_20250102130727_down,
)
class Migration20250102130727 extends Migration {
  const Migration20250102130727()
    : super(
        version: 20250102130727,
        up: _migration_20250102130727_up,
        down: _migration_20250102130727_down,
      );
}
