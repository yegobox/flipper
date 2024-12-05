// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241201193049_up = [
  DropColumn('value', onTable: 'Stock'),
  DropColumn('rsd_qty', onTable: 'Stock'),
  DropColumn('initial_stock', onTable: 'Stock'),
  InsertColumn('value', Column.integer, onTable: 'Stock'),
  InsertColumn('rsd_qty', Column.integer, onTable: 'Stock'),
  InsertColumn('initial_stock', Column.integer, onTable: 'Stock')
];

const List<MigrationCommand> _migration_20241201193049_down = [
  DropColumn('value', onTable: 'Stock'),
  DropColumn('rsd_qty', onTable: 'Stock'),
  DropColumn('initial_stock', onTable: 'Stock')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241201193049',
  up: _migration_20241201193049_up,
  down: _migration_20241201193049_down,
)
class Migration20241201193049 extends Migration {
  const Migration20241201193049()
    : super(
        version: 20241201193049,
        up: _migration_20241201193049_up,
        down: _migration_20241201193049_down,
      );
}
