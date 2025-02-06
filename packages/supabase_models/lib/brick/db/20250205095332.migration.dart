// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250205095332_up = [
  DropColumn('type', onTable: 'BusinessAnalytic'),
  DropColumn('value', onTable: 'BusinessAnalytic'),
  InsertColumn('item_name', Column.varchar, onTable: 'BusinessAnalytic'),
  InsertColumn('price', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('profit', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('units_sold', Column.integer, onTable: 'BusinessAnalytic'),
  InsertColumn('tax_rate', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('traffic_count', Column.integer, onTable: 'BusinessAnalytic')
];

const List<MigrationCommand> _migration_20250205095332_down = [
  DropColumn('item_name', onTable: 'BusinessAnalytic'),
  DropColumn('price', onTable: 'BusinessAnalytic'),
  DropColumn('profit', onTable: 'BusinessAnalytic'),
  DropColumn('units_sold', onTable: 'BusinessAnalytic'),
  DropColumn('tax_rate', onTable: 'BusinessAnalytic'),
  DropColumn('traffic_count', onTable: 'BusinessAnalytic')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250205095332',
  up: _migration_20250205095332_up,
  down: _migration_20250205095332_down,
)
class Migration20250205095332 extends Migration {
  const Migration20250205095332()
    : super(
        version: 20250205095332,
        up: _migration_20250205095332_up,
        down: _migration_20250205095332_down,
      );
}
