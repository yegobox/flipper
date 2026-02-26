// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260226120531_up = [
  InsertColumn('admin_pin', Column.varchar, onTable: 'Setting'),
  InsertColumn('is_admin_pin_enabled', Column.boolean, onTable: 'Setting'),
  InsertColumn('enable_price_quantity_adjustment', Column.boolean, onTable: 'Setting')
];

const List<MigrationCommand> _migration_20260226120531_down = [
  DropColumn('admin_pin', onTable: 'Setting'),
  DropColumn('is_admin_pin_enabled', onTable: 'Setting'),
  DropColumn('enable_price_quantity_adjustment', onTable: 'Setting')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260226120531',
  up: _migration_20260226120531_up,
  down: _migration_20260226120531_down,
)
class Migration20260226120531 extends Migration {
  const Migration20260226120531()
    : super(
        version: 20260226120531,
        up: _migration_20260226120531_up,
        down: _migration_20260226120531_down,
      );
}
