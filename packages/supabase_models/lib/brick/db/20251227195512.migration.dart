// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251227195512_up = [
  DropColumn('agent_id', onTable: 'ITransaction'),
  DropColumn('user_id', onTable: 'Pin'),
  DropColumn('user_id', onTable: 'Ebm'),
  DropColumn('user_id', onTable: 'Shift'),
  InsertColumn('user_id', Column.varchar, onTable: 'Ebm'),
  InsertColumn('user_id', Column.varchar, onTable: 'Pin'),
  InsertColumn('user_id', Column.varchar, onTable: 'Shift'),
  InsertColumn('agent_id', Column.varchar, onTable: 'ITransaction')
];

const List<MigrationCommand> _migration_20251227195512_down = [
  DropColumn('user_id', onTable: 'Ebm'),
  DropColumn('user_id', onTable: 'Pin'),
  DropColumn('user_id', onTable: 'Shift'),
  DropColumn('agent_id', onTable: 'ITransaction')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251227195512',
  up: _migration_20251227195512_up,
  down: _migration_20251227195512_down,
)
class Migration20251227195512 extends Migration {
  const Migration20251227195512()
    : super(
        version: 20251227195512,
        up: _migration_20251227195512_up,
        down: _migration_20251227195512_down,
      );
}
