// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250522185231_up = [
  InsertTable('Log'),
  InsertColumn('id', Column.varchar, onTable: 'Log', unique: true),
  InsertColumn('message', Column.varchar, onTable: 'Log'),
  InsertColumn('type', Column.varchar, onTable: 'Log'),
  InsertColumn('business_id', Column.integer, onTable: 'Log'),
  InsertColumn('created_at', Column.datetime, onTable: 'Log'),
  CreateIndex(columns: ['id'], onTable: 'Log', unique: true),
  CreateIndex(columns: ['branch_id'], onTable: 'BranchSmsConfig', unique: true)
];

const List<MigrationCommand> _migration_20250522185231_down = [
  DropTable('Log'),
  DropColumn('id', onTable: 'Log'),
  DropColumn('message', onTable: 'Log'),
  DropColumn('type', onTable: 'Log'),
  DropColumn('business_id', onTable: 'Log'),
  DropColumn('created_at', onTable: 'Log'),
  DropIndex('index_Log_on_id'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250522185231',
  up: _migration_20250522185231_up,
  down: _migration_20250522185231_down,
)
class Migration20250522185231 extends Migration {
  const Migration20250522185231()
      : super(
          version: 20250522185231,
          up: _migration_20250522185231_up,
          down: _migration_20250522185231_down,
        );
}
