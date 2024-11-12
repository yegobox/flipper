// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241112145602_up = [
  DropColumn('id', onTable: 'Plan'),
  InsertColumn('id', Column.integer, onTable: 'Plan', unique: true)
];

const List<MigrationCommand> _migration_20241112145602_down = [
  DropColumn('id', onTable: 'Plan')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241112145602',
  up: _migration_20241112145602_up,
  down: _migration_20241112145602_down,
)
class Migration20241112145602 extends Migration {
  const Migration20241112145602()
    : super(
        version: 20241112145602,
        up: _migration_20241112145602_up,
        down: _migration_20241112145602_down,
      );
}
