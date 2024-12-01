// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241130163652_up = [
  DropColumn('qty', onTable: 'Variant'),
  DropColumn('rsd_qty', onTable: 'Variant'),
  DropColumn('branch_ids', onTable: 'Variant'),
  DropColumn('cloud_synced', onTable: 'Stock'),
  InsertColumn('stock_id', Column.integer, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20241130163652_down = [
  DropColumn('stock_id', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241130163652',
  up: _migration_20241130163652_up,
  down: _migration_20241130163652_down,
)
class Migration20241130163652 extends Migration {
  const Migration20241130163652()
    : super(
        version: 20241130163652,
        up: _migration_20241130163652_up,
        down: _migration_20241130163652_down,
      );
}
