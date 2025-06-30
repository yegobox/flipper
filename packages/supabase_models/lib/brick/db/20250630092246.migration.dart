// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250630092246_up = [
  InsertColumn('tags', Column.varchar, onTable: 'Log'),
  InsertColumn('extra', Column.varchar, onTable: 'Log')
];

const List<MigrationCommand> _migration_20250630092246_down = [
  DropColumn('tags', onTable: 'Log'),
  DropColumn('extra', onTable: 'Log')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250630092246',
  up: _migration_20250630092246_up,
  down: _migration_20250630092246_down,
)
class Migration20250630092246 extends Migration {
  const Migration20250630092246()
    : super(
        version: 20250630092246,
        up: _migration_20250630092246_up,
        down: _migration_20250630092246_down,
      );
}
