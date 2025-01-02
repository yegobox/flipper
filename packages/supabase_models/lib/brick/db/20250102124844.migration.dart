// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250102124844_up = [
  DropColumn('created_at', onTable: 'ITransaction'),
  DropColumn('updated_at', onTable: 'ITransaction'),
  InsertColumn('created_at', Column.datetime, onTable: 'ITransaction'),
  InsertColumn('updated_at', Column.datetime, onTable: 'ITransaction')
];

const List<MigrationCommand> _migration_20250102124844_down = [
  DropColumn('created_at', onTable: 'ITransaction'),
  DropColumn('updated_at', onTable: 'ITransaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250102124844',
  up: _migration_20250102124844_up,
  down: _migration_20250102124844_down,
)
class Migration20250102124844 extends Migration {
  const Migration20250102124844()
    : super(
        version: 20250102124844,
        up: _migration_20250102124844_up,
        down: _migration_20250102124844_down,
      );
}
