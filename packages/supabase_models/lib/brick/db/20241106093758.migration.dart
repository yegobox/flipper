// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241106093758_up = [
  DropColumn('last_t', onTable: 'Counter'),
  InsertColumn('last_touched', Column.datetime, onTable: 'Counter')
];

const List<MigrationCommand> _migration_20241106093758_down = [
  DropColumn('last_touched', onTable: 'Counter')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241106093758',
  up: _migration_20241106093758_up,
  down: _migration_20241106093758_down,
)
class Migration20241106093758 extends Migration {
  const Migration20241106093758()
    : super(
        version: 20241106093758,
        up: _migration_20241106093758_up,
        down: _migration_20241106093758_down,
      );
}
