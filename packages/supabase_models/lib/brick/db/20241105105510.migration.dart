// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241105105510_up = [
  InsertTable('Counter'),
  InsertTable('Branch'),
  InsertColumn('id', Column.varchar, onTable: 'Counter', unique: true),
  InsertColumn('frozen', Column.boolean, onTable: 'Counter'),
  InsertForeignKey('Counter', 'Branch', foreignKeyColumn: 'branch_Branch_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('business_id', Column.integer, onTable: 'Counter'),
  InsertColumn('branch_id', Column.integer, onTable: 'Counter'),
  InsertColumn('receipt_type', Column.varchar, onTable: 'Counter'),
  InsertColumn('tot_rcpt_no', Column.integer, onTable: 'Counter'),
  InsertColumn('cur_rcpt_no', Column.integer, onTable: 'Counter'),
  InsertColumn('invc_no', Column.integer, onTable: 'Counter'),
  InsertColumn('id', Column.varchar, onTable: 'Branch', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'Branch')
];

const List<MigrationCommand> _migration_20241105105510_down = [
  DropTable('Counter'),
  DropTable('Branch'),
  DropColumn('id', onTable: 'Counter'),
  DropColumn('frozen', onTable: 'Counter'),
  DropColumn('branch_Branch_brick_id', onTable: 'Counter'),
  DropColumn('business_id', onTable: 'Counter'),
  DropColumn('branch_id', onTable: 'Counter'),
  DropColumn('receipt_type', onTable: 'Counter'),
  DropColumn('tot_rcpt_no', onTable: 'Counter'),
  DropColumn('cur_rcpt_no', onTable: 'Counter'),
  DropColumn('invc_no', onTable: 'Counter'),
  DropColumn('id', onTable: 'Branch'),
  DropColumn('name', onTable: 'Branch')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241105105510',
  up: _migration_20241105105510_up,
  down: _migration_20241105105510_down,
)
class Migration20241105105510 extends Migration {
  const Migration20241105105510()
    : super(
        version: 20241105105510,
        up: _migration_20241105105510_up,
        down: _migration_20241105105510_down,
      );
}
