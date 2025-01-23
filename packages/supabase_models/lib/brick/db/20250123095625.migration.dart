// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250123095625_up = [
  DropColumn('pkg', onTable: 'Variant'),
  DropColumn('impt_itemstts_cd', onTable: 'Variant'),
  InsertTable('Purchase'),
  InsertColumn('purchase_id', Column.varchar, onTable: 'Variant'),
  InsertColumn('pkg', Column.integer, onTable: 'Variant'),
  InsertColumn('impt_item_stts_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('id', Column.varchar, onTable: 'Purchase', unique: true),
  InsertColumn('spplr_tin', Column.varchar, onTable: 'Purchase'),
  InsertColumn('spplr_nm', Column.varchar, onTable: 'Purchase'),
  InsertColumn('spplr_bhf_id', Column.varchar, onTable: 'Purchase'),
  InsertColumn('spplr_invc_no', Column.integer, onTable: 'Purchase'),
  InsertColumn('rcpt_ty_cd', Column.varchar, onTable: 'Purchase'),
  InsertColumn('pmt_ty_cd', Column.varchar, onTable: 'Purchase'),
  InsertColumn('cfm_dt', Column.varchar, onTable: 'Purchase'),
  InsertColumn('sales_dt', Column.varchar, onTable: 'Purchase'),
  InsertColumn('stock_rls_dt', Column.varchar, onTable: 'Purchase'),
  InsertColumn('tot_item_cnt', Column.integer, onTable: 'Purchase'),
  InsertColumn('taxbl_amt_a', Column.num, onTable: 'Purchase'),
  InsertColumn('taxbl_amt_b', Column.num, onTable: 'Purchase'),
  InsertColumn('taxbl_amt_c', Column.num, onTable: 'Purchase'),
  InsertColumn('taxbl_amt_d', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_rt_a', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_rt_b', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_rt_c', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_rt_d', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_amt_a', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_amt_b', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_amt_c', Column.num, onTable: 'Purchase'),
  InsertColumn('tax_amt_d', Column.num, onTable: 'Purchase'),
  InsertColumn('tot_taxbl_amt', Column.num, onTable: 'Purchase'),
  InsertColumn('tot_tax_amt', Column.num, onTable: 'Purchase'),
  InsertColumn('tot_amt', Column.num, onTable: 'Purchase'),
  InsertColumn('remark', Column.varchar, onTable: 'Purchase'),
  CreateIndex(columns: ['purchase_id'], onTable: 'Variant', unique: false),
  CreateIndex(columns: ['id'], onTable: 'Purchase', unique: true)
];

const List<MigrationCommand> _migration_20250123095625_down = [
  DropTable('Purchase'),
  DropColumn('purchase_id', onTable: 'Variant'),
  DropColumn('pkg', onTable: 'Variant'),
  DropColumn('impt_item_stts_cd', onTable: 'Variant'),
  DropColumn('id', onTable: 'Purchase'),
  DropColumn('spplr_tin', onTable: 'Purchase'),
  DropColumn('spplr_nm', onTable: 'Purchase'),
  DropColumn('spplr_bhf_id', onTable: 'Purchase'),
  DropColumn('spplr_invc_no', onTable: 'Purchase'),
  DropColumn('rcpt_ty_cd', onTable: 'Purchase'),
  DropColumn('pmt_ty_cd', onTable: 'Purchase'),
  DropColumn('cfm_dt', onTable: 'Purchase'),
  DropColumn('sales_dt', onTable: 'Purchase'),
  DropColumn('stock_rls_dt', onTable: 'Purchase'),
  DropColumn('tot_item_cnt', onTable: 'Purchase'),
  DropColumn('taxbl_amt_a', onTable: 'Purchase'),
  DropColumn('taxbl_amt_b', onTable: 'Purchase'),
  DropColumn('taxbl_amt_c', onTable: 'Purchase'),
  DropColumn('taxbl_amt_d', onTable: 'Purchase'),
  DropColumn('tax_rt_a', onTable: 'Purchase'),
  DropColumn('tax_rt_b', onTable: 'Purchase'),
  DropColumn('tax_rt_c', onTable: 'Purchase'),
  DropColumn('tax_rt_d', onTable: 'Purchase'),
  DropColumn('tax_amt_a', onTable: 'Purchase'),
  DropColumn('tax_amt_b', onTable: 'Purchase'),
  DropColumn('tax_amt_c', onTable: 'Purchase'),
  DropColumn('tax_amt_d', onTable: 'Purchase'),
  DropColumn('tot_taxbl_amt', onTable: 'Purchase'),
  DropColumn('tot_tax_amt', onTable: 'Purchase'),
  DropColumn('tot_amt', onTable: 'Purchase'),
  DropColumn('remark', onTable: 'Purchase'),
  DropIndex('index_Variant_on_purchase_id'),
  DropIndex('index_Purchase_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250123095625',
  up: _migration_20250123095625_up,
  down: _migration_20250123095625_down,
)
class Migration20250123095625 extends Migration {
  const Migration20250123095625()
      : super(
          version: 20250123095625,
          up: _migration_20250123095625_up,
          down: _migration_20250123095625_down,
        );
}
