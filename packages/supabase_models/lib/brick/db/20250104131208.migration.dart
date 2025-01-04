// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250104131208_up = [
  InsertColumn('tot_wt', Column.integer, onTable: 'Variant'),
  InsertColumn('net_wt', Column.integer, onTable: 'Variant'),
  InsertColumn('spplr_nm', Column.varchar, onTable: 'Variant'),
  InsertColumn('agnt_nm', Column.varchar, onTable: 'Variant'),
  InsertColumn('invc_fcur_amt', Column.integer, onTable: 'Variant'),
  InsertColumn('invc_fcur_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('invc_fcur_excrt', Column.Double, onTable: 'Variant'),
  InsertColumn('expt_nat_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('dcl_no', Column.varchar, onTable: 'Variant'),
  InsertColumn('task_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('dcl_de', Column.varchar, onTable: 'Variant'),
  InsertColumn('hs_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('impt_itemstts_cd', Column.varchar, onTable: 'Variant')
];

const List<MigrationCommand> _migration_20250104131208_down = [
  DropColumn('tot_wt', onTable: 'Variant'),
  DropColumn('net_wt', onTable: 'Variant'),
  DropColumn('spplr_nm', onTable: 'Variant'),
  DropColumn('agnt_nm', onTable: 'Variant'),
  DropColumn('invc_fcur_amt', onTable: 'Variant'),
  DropColumn('invc_fcur_cd', onTable: 'Variant'),
  DropColumn('invc_fcur_excrt', onTable: 'Variant'),
  DropColumn('expt_nat_cd', onTable: 'Variant'),
  DropColumn('dcl_no', onTable: 'Variant'),
  DropColumn('task_cd', onTable: 'Variant'),
  DropColumn('dcl_de', onTable: 'Variant'),
  DropColumn('hs_cd', onTable: 'Variant'),
  DropColumn('impt_itemstts_cd', onTable: 'Variant')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250104131208',
  up: _migration_20250104131208_up,
  down: _migration_20250104131208_down,
)
class Migration20250104131208 extends Migration {
  const Migration20250104131208()
    : super(
        version: 20250104131208,
        up: _migration_20250104131208_up,
        down: _migration_20250104131208_down,
      );
}
