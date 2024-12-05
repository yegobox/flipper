// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20241114183152_up = [
  InsertTable('TransactionItem'),
  InsertColumn('id', Column.integer, onTable: 'TransactionItem', unique: true),
  InsertColumn('name', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('quantity_requested', Column.integer,
      onTable: 'TransactionItem'),
  InsertColumn('quantity_approved', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('quantity_shipped', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('transaction_id', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('variant_id', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('qty', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('price', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('discount', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('type', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('remaining_stock', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('created_at', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('updated_at', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('is_tax_exempted', Column.boolean, onTable: 'TransactionItem'),
  InsertColumn('is_refunded', Column.boolean, onTable: 'TransactionItem'),
  InsertColumn('done_with_transaction', Column.boolean,
      onTable: 'TransactionItem'),
  InsertColumn('active', Column.boolean, onTable: 'TransactionItem'),
  InsertColumn('dc_rt', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('dc_amt', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('taxbl_amt', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('tax_amt', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('tot_amt', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('item_seq', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('isrcc_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('isrcc_nm', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('isrc_r', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('isrc_am', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('tax_ty_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('bcd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('item_cls_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('item_ty_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('item_std_nm', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('orgn_nat_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('pkg', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('item_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('pkg_unit_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('qty_unit_cd', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('item_nm', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('prc', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('sply_amt', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('tin', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('bhf_id', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('dft_prc', Column.Double, onTable: 'TransactionItem'),
  InsertColumn('add_info', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('isrc_aplcb_yn', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('use_yn', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('regr_id', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('regr_nm', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('modr_id', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('modr_nm', Column.varchar, onTable: 'TransactionItem'),
  InsertColumn('last_touched', Column.datetime, onTable: 'TransactionItem'),
  InsertColumn('deleted_at', Column.datetime, onTable: 'TransactionItem'),
  InsertColumn('branch_id', Column.integer, onTable: 'TransactionItem'),
  InsertColumn('ebm_synced', Column.boolean, onTable: 'TransactionItem'),
  InsertColumn('part_of_composite', Column.boolean, onTable: 'TransactionItem'),
  InsertColumn('composite_price', Column.Double, onTable: 'TransactionItem')
];

const List<MigrationCommand> _migration_20241114183152_down = [
  DropTable('TransactionItem'),
  DropColumn('id', onTable: 'TransactionItem'),
  DropColumn('name', onTable: 'TransactionItem'),
  DropColumn('quantity_requested', onTable: 'TransactionItem'),
  DropColumn('quantity_approved', onTable: 'TransactionItem'),
  DropColumn('quantity_shipped', onTable: 'TransactionItem'),
  DropColumn('transaction_id', onTable: 'TransactionItem'),
  DropColumn('variant_id', onTable: 'TransactionItem'),
  DropColumn('qty', onTable: 'TransactionItem'),
  DropColumn('price', onTable: 'TransactionItem'),
  DropColumn('discount', onTable: 'TransactionItem'),
  DropColumn('type', onTable: 'TransactionItem'),
  DropColumn('remaining_stock', onTable: 'TransactionItem'),
  DropColumn('created_at', onTable: 'TransactionItem'),
  DropColumn('updated_at', onTable: 'TransactionItem'),
  DropColumn('is_tax_exempted', onTable: 'TransactionItem'),
  DropColumn('is_refunded', onTable: 'TransactionItem'),
  DropColumn('done_with_transaction', onTable: 'TransactionItem'),
  DropColumn('active', onTable: 'TransactionItem'),
  DropColumn('dc_rt', onTable: 'TransactionItem'),
  DropColumn('dc_amt', onTable: 'TransactionItem'),
  DropColumn('taxbl_amt', onTable: 'TransactionItem'),
  DropColumn('tax_amt', onTable: 'TransactionItem'),
  DropColumn('tot_amt', onTable: 'TransactionItem'),
  DropColumn('item_seq', onTable: 'TransactionItem'),
  DropColumn('isrcc_cd', onTable: 'TransactionItem'),
  DropColumn('isrcc_nm', onTable: 'TransactionItem'),
  DropColumn('isrc_r', onTable: 'TransactionItem'),
  DropColumn('isrc_am', onTable: 'TransactionItem'),
  DropColumn('tax_ty_cd', onTable: 'TransactionItem'),
  DropColumn('bcd', onTable: 'TransactionItem'),
  DropColumn('item_cls_cd', onTable: 'TransactionItem'),
  DropColumn('item_ty_cd', onTable: 'TransactionItem'),
  DropColumn('item_std_nm', onTable: 'TransactionItem'),
  DropColumn('orgn_nat_cd', onTable: 'TransactionItem'),
  DropColumn('pkg', onTable: 'TransactionItem'),
  DropColumn('item_cd', onTable: 'TransactionItem'),
  DropColumn('pkg_unit_cd', onTable: 'TransactionItem'),
  DropColumn('qty_unit_cd', onTable: 'TransactionItem'),
  DropColumn('item_nm', onTable: 'TransactionItem'),
  DropColumn('prc', onTable: 'TransactionItem'),
  DropColumn('sply_amt', onTable: 'TransactionItem'),
  DropColumn('tin', onTable: 'TransactionItem'),
  DropColumn('bhf_id', onTable: 'TransactionItem'),
  DropColumn('dft_prc', onTable: 'TransactionItem'),
  DropColumn('add_info', onTable: 'TransactionItem'),
  DropColumn('isrc_aplcb_yn', onTable: 'TransactionItem'),
  DropColumn('use_yn', onTable: 'TransactionItem'),
  DropColumn('regr_id', onTable: 'TransactionItem'),
  DropColumn('regr_nm', onTable: 'TransactionItem'),
  DropColumn('modr_id', onTable: 'TransactionItem'),
  DropColumn('modr_nm', onTable: 'TransactionItem'),
  DropColumn('last_touched', onTable: 'TransactionItem'),
  DropColumn('deleted_at', onTable: 'TransactionItem'),
  DropColumn('branch_id', onTable: 'TransactionItem'),
  DropColumn('ebm_synced', onTable: 'TransactionItem'),
  DropColumn('part_of_composite', onTable: 'TransactionItem'),
  DropColumn('composite_price', onTable: 'TransactionItem')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20241114183152',
  up: _migration_20241114183152_up,
  down: _migration_20241114183152_down,
)
class Migration20241114183152 extends Migration {
  const Migration20241114183152()
      : super(
          version: 20241114183152,
          up: _migration_20241114183152_up,
          down: _migration_20241114183152_down,
        );
}
