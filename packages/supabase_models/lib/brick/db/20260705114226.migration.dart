// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260705114226_up = [
  InsertColumn('table_id', Column.varchar, onTable: 'ITransaction'),
  InsertColumn('logged_by_tenant_id', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('logged_by_name', Column.varchar, onTable: 'TransactionItem')
];

const List<MigrationCommand> _migration_20260705114226_down = [
  DropColumn('table_id', onTable: 'ITransaction'),
  DropColumn('logged_by_tenant_id', onTable: 'TransactionItem'),
  DropColumn('logged_by_name', onTable: 'TransactionItem')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260705114226',
  up: _migration_20260705114226_up,
  down: _migration_20260705114226_down,
)
class Migration20260705114226 extends Migration {
  const Migration20260705114226()
    : super(
        version: 20260705114226,
        up: _migration_20260705114226_up,
        down: _migration_20260705114226_down,
      );
}
