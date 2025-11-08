// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20251108140031_up = [
  InsertColumn('value', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('supply_price', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('retail_price', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('current_stock', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('stock_value', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('payment_method', Column.varchar, onTable: 'BusinessAnalytic'),
  InsertColumn('customer_type', Column.varchar, onTable: 'BusinessAnalytic'),
  InsertColumn('discount_amount', Column.num, onTable: 'BusinessAnalytic'),
  InsertColumn('tax_amount', Column.num, onTable: 'BusinessAnalytic')
];

const List<MigrationCommand> _migration_20251108140031_down = [
  DropColumn('value', onTable: 'BusinessAnalytic'),
  DropColumn('supply_price', onTable: 'BusinessAnalytic'),
  DropColumn('retail_price', onTable: 'BusinessAnalytic'),
  DropColumn('current_stock', onTable: 'BusinessAnalytic'),
  DropColumn('stock_value', onTable: 'BusinessAnalytic'),
  DropColumn('payment_method', onTable: 'BusinessAnalytic'),
  DropColumn('customer_type', onTable: 'BusinessAnalytic'),
  DropColumn('discount_amount', onTable: 'BusinessAnalytic'),
  DropColumn('tax_amount', onTable: 'BusinessAnalytic')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20251108140031',
  up: _migration_20251108140031_up,
  down: _migration_20251108140031_down,
)
class Migration20251108140031 extends Migration {
  const Migration20251108140031()
    : super(
        version: 20251108140031,
        up: _migration_20251108140031_up,
        down: _migration_20251108140031_down,
      );
}
