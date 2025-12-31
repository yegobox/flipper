// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227202731_up = [
  DropColumn('user_id', onTable: 'Device'),
  DropColumn('user_id', onTable: 'Setting'),
  InsertColumn('user_id', Column.varchar, onTable: 'Device'),
  InsertColumn('user_id', Column.varchar, onTable: 'Setting')
];

const List<MigrationCommand> _migration_20251227202731_down = [
  DropColumn('user_id', onTable: 'Device'),
  DropColumn('user_id', onTable: 'Setting')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227202731',
  up: _migration_20251227202731_up,
  down: _migration_20251227202731_down,
)
class Migration20251227202731 extends Migration {
  const Migration20251227202731()
    : super(
        version: 20251227202731,
        up: _migration_20251227202731_up,
        down: _migration_20251227202731_down,
      );
}
