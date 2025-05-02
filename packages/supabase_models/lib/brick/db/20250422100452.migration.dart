// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250422100452_up = [
  InsertColumn('time_received_fromserver', Column.datetime, onTable: 'Receipt'),
];

const List<MigrationCommand> _migration_20250422100452_down = [
  DropColumn('time_received_fromserver', onTable: 'Receipt'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250422100452',
  up: _migration_20250422100452_up,
  down: _migration_20250422100452_down,
)
class Migration20250422100452 extends Migration {
  const Migration20250422100452()
      : super(
          version: 20250422100452,
          up: _migration_20250422100452_up,
          down: _migration_20250422100452_down,
        );
}
