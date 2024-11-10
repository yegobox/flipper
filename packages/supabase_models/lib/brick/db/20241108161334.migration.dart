// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241108161334_up = [
  InsertTable('Plan'),
  InsertColumn('id', Column.integer, onTable: 'Plan', unique: true),
  InsertColumn('business_id', Column.integer, onTable: 'Plan'),
  InsertColumn('selected_plan', Column.varchar, onTable: 'Plan'),
  InsertColumn('additional_devices', Column.integer, onTable: 'Plan'),
  InsertColumn('is_yearly_plan', Column.boolean, onTable: 'Plan'),
  InsertColumn('total_price', Column.Double, onTable: 'Plan'),
  InsertColumn('created_at', Column.datetime, onTable: 'Plan'),
  InsertColumn('payment_completed_by_user', Column.boolean, onTable: 'Plan'),
  InsertColumn('pay_stack_customer_id', Column.integer, onTable: 'Plan'),
  InsertColumn('rule', Column.varchar, onTable: 'Plan'),
  InsertColumn('payment_method', Column.varchar, onTable: 'Plan')
];

const List<MigrationCommand> _migration_20241108161334_down = [
  DropTable('Plan'),
  DropColumn('id', onTable: 'Plan'),
  DropColumn('business_id', onTable: 'Plan'),
  DropColumn('selected_plan', onTable: 'Plan'),
  DropColumn('additional_devices', onTable: 'Plan'),
  DropColumn('is_yearly_plan', onTable: 'Plan'),
  DropColumn('total_price', onTable: 'Plan'),
  DropColumn('created_at', onTable: 'Plan'),
  DropColumn('payment_completed_by_user', onTable: 'Plan'),
  DropColumn('pay_stack_customer_id', onTable: 'Plan'),
  DropColumn('rule', onTable: 'Plan'),
  DropColumn('payment_method', onTable: 'Plan')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241108161334',
  up: _migration_20241108161334_up,
  down: _migration_20241108161334_down,
)
class Migration20241108161334 extends Migration {
  const Migration20241108161334()
    : super(
        version: 20241108161334,
        up: _migration_20241108161334_up,
        down: _migration_20241108161334_down,
      );
}
