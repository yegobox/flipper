// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250124180016_up = [
  InsertTable('BusinessAnalytic'),
  InsertColumn('id', Column.varchar, onTable: 'BusinessAnalytic', unique: true),
  InsertColumn('date', Column.datetime, onTable: 'BusinessAnalytic'),
  InsertColumn('value', Column.Double, onTable: 'BusinessAnalytic'),
  InsertColumn('type', Column.varchar, onTable: 'BusinessAnalytic'),
  InsertColumn('branch_id', Column.integer, onTable: 'BusinessAnalytic'),
  InsertColumn('business_id', Column.integer, onTable: 'BusinessAnalytic'),
  CreateIndex(columns: ['id'], onTable: 'BusinessAnalytic', unique: true)
];

const List<MigrationCommand> _migration_20250124180016_down = [
  DropTable('BusinessAnalytic'),
  DropColumn('id', onTable: 'BusinessAnalytic'),
  DropColumn('date', onTable: 'BusinessAnalytic'),
  DropColumn('value', onTable: 'BusinessAnalytic'),
  DropColumn('type', onTable: 'BusinessAnalytic'),
  DropColumn('branch_id', onTable: 'BusinessAnalytic'),
  DropColumn('business_id', onTable: 'BusinessAnalytic'),
  DropIndex('index_BusinessAnalytic_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250124180016',
  up: _migration_20250124180016_up,
  down: _migration_20250124180016_down,
)
class Migration20250124180016 extends Migration {
  const Migration20250124180016()
    : super(
        version: 20250124180016,
        up: _migration_20250124180016_up,
        down: _migration_20250124180016_down,
      );
}
