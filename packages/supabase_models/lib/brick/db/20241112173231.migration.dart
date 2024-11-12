// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241112173231_up = [
  InsertTable('Counter'),
  InsertTable('Branch'),
  InsertTable('Plan'),
  InsertColumn('id', Column.integer, onTable: 'Counter', unique: true),
  InsertColumn('business_id', Column.integer, onTable: 'Counter'),
  InsertColumn('branch_id', Column.integer, onTable: 'Counter'),
  InsertColumn('receipt_type', Column.varchar, onTable: 'Counter'),
  InsertColumn('tot_rcpt_no', Column.integer, onTable: 'Counter'),
  InsertColumn('cur_rcpt_no', Column.integer, onTable: 'Counter'),
  InsertColumn('invc_no', Column.integer, onTable: 'Counter'),
  InsertColumn('last_touched', Column.datetime, onTable: 'Counter'),
  InsertColumn('created_at', Column.datetime, onTable: 'Counter'),
  InsertColumn('id', Column.integer, onTable: 'Branch', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'Branch'),
  InsertColumn('server_id', Column.integer, onTable: 'Branch'),
  InsertColumn('location', Column.varchar, onTable: 'Branch'),
  InsertColumn('description', Column.varchar, onTable: 'Branch'),
  InsertColumn('active', Column.boolean, onTable: 'Branch'),
  InsertColumn('business_id', Column.integer, onTable: 'Branch'),
  InsertColumn('latitude', Column.varchar, onTable: 'Branch'),
  InsertColumn('longitude', Column.varchar, onTable: 'Branch'),
  InsertColumn('is_default', Column.boolean, onTable: 'Branch'),
  InsertColumn('is_online', Column.boolean, onTable: 'Branch'),
  InsertColumn('id', Column.integer, onTable: 'Plan', unique: true),
  InsertColumn('business_id', Column.integer, onTable: 'Plan'),
  InsertColumn('selected_plan', Column.varchar, onTable: 'Plan'),
  InsertColumn('additional_devices', Column.integer, onTable: 'Plan'),
  InsertColumn('is_yearly_plan', Column.boolean, onTable: 'Plan'),
  InsertColumn('total_price', Column.integer, onTable: 'Plan'),
  InsertColumn('created_at', Column.datetime, onTable: 'Plan'),
  InsertColumn('payment_completed_by_user', Column.boolean, onTable: 'Plan'),
  InsertColumn('pay_stack_customer_id', Column.integer, onTable: 'Plan'),
  InsertColumn('rule', Column.varchar, onTable: 'Plan'),
  InsertColumn('payment_method', Column.varchar, onTable: 'Plan')
];

const List<MigrationCommand> _migration_20241112173231_down = [
  DropTable('Counter'),
  DropTable('Branch'),
  DropTable('Plan'),
  DropColumn('id', onTable: 'Counter'),
  DropColumn('business_id', onTable: 'Counter'),
  DropColumn('branch_id', onTable: 'Counter'),
  DropColumn('receipt_type', onTable: 'Counter'),
  DropColumn('tot_rcpt_no', onTable: 'Counter'),
  DropColumn('cur_rcpt_no', onTable: 'Counter'),
  DropColumn('invc_no', onTable: 'Counter'),
  DropColumn('last_touched', onTable: 'Counter'),
  DropColumn('created_at', onTable: 'Counter'),
  DropColumn('id', onTable: 'Branch'),
  DropColumn('name', onTable: 'Branch'),
  DropColumn('server_id', onTable: 'Branch'),
  DropColumn('location', onTable: 'Branch'),
  DropColumn('description', onTable: 'Branch'),
  DropColumn('active', onTable: 'Branch'),
  DropColumn('business_id', onTable: 'Branch'),
  DropColumn('latitude', onTable: 'Branch'),
  DropColumn('longitude', onTable: 'Branch'),
  DropColumn('is_default', onTable: 'Branch'),
  DropColumn('is_online', onTable: 'Branch'),
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
  version: '20241112173231',
  up: _migration_20241112173231_up,
  down: _migration_20241112173231_down,
)
class Migration20241112173231 extends Migration {
  const Migration20241112173231()
    : super(
        version: 20241112173231,
        up: _migration_20241112173231_up,
        down: _migration_20241112173231_down,
      );
}
