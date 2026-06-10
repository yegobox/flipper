// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20260610091903_up = [
  InsertTable('Supplier'),
  InsertColumn('id', Column.varchar, onTable: 'Supplier', unique: true),
  InsertColumn('cust_nm', Column.varchar, onTable: 'Supplier'),
  InsertColumn('email', Column.varchar, onTable: 'Supplier'),
  InsertColumn('tel_no', Column.varchar, onTable: 'Supplier'),
  InsertColumn('adrs', Column.varchar, onTable: 'Supplier'),
  InsertColumn('branch_id', Column.varchar, onTable: 'Supplier'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Supplier'),
  InsertColumn('cust_no', Column.varchar, onTable: 'Supplier'),
  InsertColumn('cust_tin', Column.varchar, onTable: 'Supplier'),
  InsertColumn('regr_nm', Column.varchar, onTable: 'Supplier'),
  InsertColumn('regr_id', Column.varchar, onTable: 'Supplier'),
  InsertColumn('modr_nm', Column.varchar, onTable: 'Supplier'),
  InsertColumn('modr_id', Column.varchar, onTable: 'Supplier'),
  InsertColumn('ebm_synced', Column.boolean, onTable: 'Supplier'),
  InsertColumn('bhf_id', Column.varchar, onTable: 'Supplier'),
  InsertColumn('use_yn', Column.varchar, onTable: 'Supplier'),
  InsertColumn('customer_type', Column.varchar, onTable: 'Supplier'),
  CreateIndex(columns: ['id'], onTable: 'Supplier', unique: true)
];

const List<MigrationCommand> _migration_20260610091903_down = [
  DropTable('Supplier'),
  DropColumn('id', onTable: 'Supplier'),
  DropColumn('cust_nm', onTable: 'Supplier'),
  DropColumn('email', onTable: 'Supplier'),
  DropColumn('tel_no', onTable: 'Supplier'),
  DropColumn('adrs', onTable: 'Supplier'),
  DropColumn('branch_id', onTable: 'Supplier'),
  DropColumn('updated_at', onTable: 'Supplier'),
  DropColumn('cust_no', onTable: 'Supplier'),
  DropColumn('cust_tin', onTable: 'Supplier'),
  DropColumn('regr_nm', onTable: 'Supplier'),
  DropColumn('regr_id', onTable: 'Supplier'),
  DropColumn('modr_nm', onTable: 'Supplier'),
  DropColumn('modr_id', onTable: 'Supplier'),
  DropColumn('ebm_synced', onTable: 'Supplier'),
  DropColumn('bhf_id', onTable: 'Supplier'),
  DropColumn('use_yn', onTable: 'Supplier'),
  DropColumn('customer_type', onTable: 'Supplier'),
  DropIndex('index_Supplier_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20260610091903',
  up: _migration_20260610091903_up,
  down: _migration_20260610091903_down,
)
class Migration20260610091903 extends Migration {
  const Migration20260610091903()
    : super(
        version: 20260610091903,
        up: _migration_20260610091903_up,
        down: _migration_20260610091903_down,
      );
}
