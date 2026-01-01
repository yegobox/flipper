// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260101131413_up = [
  DropColumn('tin_number', onTable: 'Branch')
];

const List<MigrationCommand> _migration_20260101131413_down = [
  
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260101131413',
  up: _migration_20260101131413_up,
  down: _migration_20260101131413_down,
)
class Migration20260101131413 extends Migration {
  const Migration20260101131413()
    : super(
        version: 20260101131413,
        up: _migration_20260101131413_up,
        down: _migration_20260101131413_down,
      );
}
