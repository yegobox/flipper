// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250523210831_up = [
  InsertTable('Credit'),
  InsertColumn('id', Column.varchar, onTable: 'Credit', unique: true),
  InsertColumn('branch_id', Column.varchar, onTable: 'Credit'),
  InsertColumn('business_id', Column.varchar, onTable: 'Credit'),
  InsertColumn('credits', Column.Double, onTable: 'Credit'),
  InsertColumn('created_at', Column.datetime, onTable: 'Credit'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Credit'),
  InsertColumn('branch_server_id', Column.integer, onTable: 'Credit'),
  CreateIndex(columns: ['id'], onTable: 'Credit', unique: true),
];

const List<MigrationCommand> _migration_20250523210831_down = [
  DropTable('Credit'),
  DropColumn('id', onTable: 'Credit'),
  DropColumn('branch_id', onTable: 'Credit'),
  DropColumn('business_id', onTable: 'Credit'),
  DropColumn('credits', onTable: 'Credit'),
  DropColumn('created_at', onTable: 'Credit'),
  DropColumn('updated_at', onTable: 'Credit'),
  DropColumn('branch_server_id', onTable: 'Credit'),
  DropIndex('index_Credit_on_id'),
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250523210831',
  up: _migration_20250523210831_up,
  down: _migration_20250523210831_down,
)
class Migration20250523210831 extends Migration {
  const Migration20250523210831()
      : super(
          version: 20250523210831,
          up: _migration_20250523210831_up,
          down: _migration_20250523210831_down,
        );
}
