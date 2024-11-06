// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241106081113_up = [
  InsertColumn('server_id', Column.integer, onTable: 'Branch'),
  InsertColumn('location', Column.varchar, onTable: 'Branch'),
  InsertColumn('description', Column.varchar, onTable: 'Branch'),
  InsertColumn('active', Column.boolean, onTable: 'Branch'),
  InsertColumn('business_id', Column.integer, onTable: 'Branch'),
  InsertColumn('latitude', Column.varchar, onTable: 'Branch'),
  InsertColumn('longitude', Column.varchar, onTable: 'Branch')
];

const List<MigrationCommand> _migration_20241106081113_down = [
  DropColumn('server_id', onTable: 'Branch'),
  DropColumn('location', onTable: 'Branch'),
  DropColumn('description', onTable: 'Branch'),
  DropColumn('active', onTable: 'Branch'),
  DropColumn('business_id', onTable: 'Branch'),
  DropColumn('latitude', onTable: 'Branch'),
  DropColumn('longitude', onTable: 'Branch')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241106081113',
  up: _migration_20241106081113_up,
  down: _migration_20241106081113_down,
)
class Migration20241106081113 extends Migration {
  const Migration20241106081113()
    : super(
        version: 20241106081113,
        up: _migration_20241106081113_up,
        down: _migration_20241106081113_down,
      );
}
