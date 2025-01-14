// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250111130254_up = [
  DropColumn('pkg', onTable: 'Variant'),
  DropColumn('impt_itemstts_cd', onTable: 'Variant'),
  InsertTable('SaleList'),
  InsertColumn('pkg', Column.integer, onTable: 'Variant'),
  InsertColumn('impt_item_stts_cd', Column.varchar, onTable: 'Variant'),
  InsertColumn('purchase_id', Column.varchar, onTable: 'Variant'),
  InsertColumn('id', Column.varchar, onTable: 'SaleList', unique: true),
  InsertColumn('spplr_tin', Column.varchar, onTable: 'SaleList'),
  InsertColumn('spplr_nm', Column.varchar, onTable: 'SaleList'),
  InsertColumn('spplr_bhf_id', Column.varchar, onTable: 'SaleList'),
  InsertColumn('spplr_invc_no', Column.integer, onTable: 'SaleList'),
  InsertColumn('rcpt_ty_cd', Column.varchar, onTable: 'SaleList'),
  InsertColumn('pmt_ty_cd', Column.varchar, onTable: 'SaleList'),
  InsertColumn('cfm_dt', Column.varchar, onTable: 'SaleList'),
  InsertColumn('sales_dt', Column.varchar, onTable: 'SaleList'),
  InsertColumn('stock_rls_dt', Column.varchar, onTable: 'SaleList'),
  InsertColumn('tot_item_cnt', Column.integer, onTable: 'SaleList'),
  InsertColumn('taxbl_amt_a', Column.Double, onTable: 'SaleList'),
  InsertColumn('taxbl_amt_b', Column.Double, onTable: 'SaleList'),
  InsertColumn('taxbl_amt_c', Column.Double, onTable: 'SaleList'),
  InsertColumn('taxbl_amt_d', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_rt_a', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_rt_b', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_rt_c', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_rt_d', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_amt_a', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_amt_b', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_amt_c', Column.Double, onTable: 'SaleList'),
  InsertColumn('tax_amt_d', Column.Double, onTable: 'SaleList'),
  InsertColumn('tot_taxbl_amt', Column.Double, onTable: 'SaleList'),
  InsertColumn('tot_tax_amt', Column.Double, onTable: 'SaleList'),
  InsertColumn('tot_amt', Column.Double, onTable: 'SaleList'),
  InsertColumn('remark', Column.varchar, onTable: 'SaleList'),
  CreateIndex(columns: ['id'], onTable: 'SaleList', unique: true)
];

const List<MigrationCommand> _migration_20250111130254_down = [
  DropTable('SaleList'),
  DropColumn('pkg', onTable: 'Variant'),
  DropColumn('qty', onTable: 'Variant'),
  DropColumn('impt_item_stts_cd', onTable: 'Variant'),
  DropColumn('purchase_id', onTable: 'Variant'),
  DropColumn('id', onTable: 'SaleList'),
  DropColumn('spplr_tin', onTable: 'SaleList'),
  DropColumn('spplr_nm', onTable: 'SaleList'),
  DropColumn('spplr_bhf_id', onTable: 'SaleList'),
  DropColumn('spplr_invc_no', onTable: 'SaleList'),
  DropColumn('rcpt_ty_cd', onTable: 'SaleList'),
  DropColumn('pmt_ty_cd', onTable: 'SaleList'),
  DropColumn('cfm_dt', onTable: 'SaleList'),
  DropColumn('sales_dt', onTable: 'SaleList'),
  DropColumn('stock_rls_dt', onTable: 'SaleList'),
  DropColumn('tot_item_cnt', onTable: 'SaleList'),
  DropColumn('taxbl_amt_a', onTable: 'SaleList'),
  DropColumn('taxbl_amt_b', onTable: 'SaleList'),
  DropColumn('taxbl_amt_c', onTable: 'SaleList'),
  DropColumn('taxbl_amt_d', onTable: 'SaleList'),
  DropColumn('tax_rt_a', onTable: 'SaleList'),
  DropColumn('tax_rt_b', onTable: 'SaleList'),
  DropColumn('tax_rt_c', onTable: 'SaleList'),
  DropColumn('tax_rt_d', onTable: 'SaleList'),
  DropColumn('tax_amt_a', onTable: 'SaleList'),
  DropColumn('tax_amt_b', onTable: 'SaleList'),
  DropColumn('tax_amt_c', onTable: 'SaleList'),
  DropColumn('tax_amt_d', onTable: 'SaleList'),
  DropColumn('tot_taxbl_amt', onTable: 'SaleList'),
  DropColumn('tot_tax_amt', onTable: 'SaleList'),
  DropColumn('tot_amt', onTable: 'SaleList'),
  DropColumn('remark', onTable: 'SaleList'),
  DropIndex('index_SaleList_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250111130254',
  up: _migration_20250111130254_up,
  down: _migration_20250111130254_down,
)
class Migration20250111130254 extends Migration {
  const Migration20250111130254()
      : super(
          version: 20250111130254,
          up: _migration_20250111130254_up,
          down: _migration_20250111130254_down,
        );
}
