// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241117164713_up = [
  InsertTable('Ebm'),
  InsertColumn('id', Column.integer, onTable: 'Ebm', unique: true),
  InsertColumn('bhf_id', Column.varchar, onTable: 'Ebm'),
  InsertColumn('tin_number', Column.integer, onTable: 'Ebm'),
  InsertColumn('dvc_srl_no', Column.varchar, onTable: 'Ebm'),
  InsertColumn('user_id', Column.integer, onTable: 'Ebm'),
  InsertColumn('tax_server_url', Column.varchar, onTable: 'Ebm'),
  InsertColumn('business_id', Column.integer, onTable: 'Ebm'),
  InsertColumn('branch_id', Column.integer, onTable: 'Ebm'),
  InsertColumn('last_touched', Column.datetime, onTable: 'Ebm')
];

const List<MigrationCommand> _migration_20241117164713_down = [
  DropTable('Ebm'),
  DropColumn('id', onTable: 'Ebm'),
  DropColumn('bhf_id', onTable: 'Ebm'),
  DropColumn('tin_number', onTable: 'Ebm'),
  DropColumn('dvc_srl_no', onTable: 'Ebm'),
  DropColumn('user_id', onTable: 'Ebm'),
  DropColumn('tax_server_url', onTable: 'Ebm'),
  DropColumn('business_id', onTable: 'Ebm'),
  DropColumn('branch_id', onTable: 'Ebm'),
  DropColumn('last_touched', onTable: 'Ebm')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241117164713',
  up: _migration_20241117164713_up,
  down: _migration_20241117164713_down,
)
class Migration20241117164713 extends Migration {
  const Migration20241117164713()
    : super(
        version: 20241117164713,
        up: _migration_20241117164713_up,
        down: _migration_20241117164713_down,
      );
}
