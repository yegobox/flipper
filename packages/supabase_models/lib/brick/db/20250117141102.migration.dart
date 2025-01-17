// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250117141102_up = [
  InsertTable('Country'),
  InsertColumn('id', Column.varchar, onTable: 'Country', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'Country'),
  InsertColumn('sort_order', Column.integer, onTable: 'Country'),
  InsertColumn('description', Column.varchar, onTable: 'Country'),
  InsertColumn('code', Column.varchar, onTable: 'Country'),
  CreateIndex(columns: ['id'], onTable: 'Country', unique: true)
];

const List<MigrationCommand> _migration_20250117141102_down = [
  DropTable('Country'),
  DropColumn('id', onTable: 'Country'),
  DropColumn('name', onTable: 'Country'),
  DropColumn('sort_order', onTable: 'Country'),
  DropColumn('description', onTable: 'Country'),
  DropColumn('code', onTable: 'Country'),
  DropIndex('index_Country_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250117141102',
  up: _migration_20250117141102_up,
  down: _migration_20250117141102_down,
)
class Migration20250117141102 extends Migration {
  const Migration20250117141102()
    : super(
        version: 20250117141102,
        up: _migration_20250117141102_up,
        down: _migration_20250117141102_down,
      );
}
