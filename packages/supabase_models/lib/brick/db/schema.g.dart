// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20241117083433.migration.dart';
part '20241113144615.migration.dart';
part '20241113200548.migration.dart';
part '20241114183152.migration.dart';
part '20241114183418.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20241117083433(),
  const Migration20241113144615(),
  const Migration20241113200548(),
  const Migration20241114183152(),
  const Migration20241114183418()
};

/// A consumable database structure including the latest generated migration.
final schema = Schema(20241117083433, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('Counter', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('receipt_type', Column.varchar),
    SchemaColumn('tot_rcpt_no', Column.integer),
    SchemaColumn('cur_rcpt_no', Column.integer),
    SchemaColumn('invc_no', Column.integer),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('created_at', Column.datetime)
  }, indices: <SchemaIndex>{}),
  SchemaTable('Branch', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('server_id', Column.integer),
    SchemaColumn('location', Column.varchar),
    SchemaColumn('description', Column.varchar),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('latitude', Column.varchar),
    SchemaColumn('longitude', Column.varchar),
    SchemaColumn('is_default', Column.boolean),
    SchemaColumn('is_online', Column.boolean)
  }, indices: <SchemaIndex>{}),
  SchemaTable('_brick_Plan_addons', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('l_Plan_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Plan',
        onDeleteCascade: true,
        onDeleteSetDefault: false),
    SchemaColumn('f_PlanAddon_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'PlanAddon',
        onDeleteCascade: true,
        onDeleteSetDefault: false)
  }, indices: <SchemaIndex>{
    SchemaIndex(
        columns: ['l_Plan_brick_id', 'f_PlanAddon_brick_id'], unique: true)
  }),
  SchemaTable('Plan', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('selected_plan', Column.varchar),
    SchemaColumn('additional_devices', Column.integer),
    SchemaColumn('is_yearly_plan', Column.boolean),
    SchemaColumn('total_price', Column.integer),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('payment_completed_by_user', Column.boolean),
    SchemaColumn('pay_stack_customer_id', Column.integer),
    SchemaColumn('rule', Column.varchar),
    SchemaColumn('payment_method', Column.varchar),
    SchemaColumn('next_billing_date', Column.datetime)
  }, indices: <SchemaIndex>{}),
  SchemaTable('PlanAddon', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('plan_id', Column.integer),
    SchemaColumn('addon_name', Column.varchar),
    SchemaColumn('created_at', Column.datetime)
  }, indices: <SchemaIndex>{}),
  SchemaTable('TransactionItem', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('quantity_requested', Column.integer),
    SchemaColumn('quantity_approved', Column.integer),
    SchemaColumn('quantity_shipped', Column.integer),
    SchemaColumn('transaction_id', Column.integer),
    SchemaColumn('variant_id', Column.integer),
    SchemaColumn('qty', Column.Double),
    SchemaColumn('price', Column.Double),
    SchemaColumn('discount', Column.Double),
    SchemaColumn('type', Column.varchar),
    SchemaColumn('remaining_stock', Column.Double),
    SchemaColumn('created_at', Column.varchar),
    SchemaColumn('updated_at', Column.varchar),
    SchemaColumn('is_tax_exempted', Column.boolean),
    SchemaColumn('is_refunded', Column.boolean),
    SchemaColumn('done_with_transaction', Column.boolean),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('dc_rt', Column.Double),
    SchemaColumn('dc_amt', Column.Double),
    SchemaColumn('taxbl_amt', Column.Double),
    SchemaColumn('tax_amt', Column.Double),
    SchemaColumn('tot_amt', Column.Double),
    SchemaColumn('item_seq', Column.integer),
    SchemaColumn('isrcc_cd', Column.varchar),
    SchemaColumn('isrcc_nm', Column.varchar),
    SchemaColumn('isrc_r', Column.integer),
    SchemaColumn('isrc_am', Column.integer),
    SchemaColumn('tax_ty_cd', Column.varchar),
    SchemaColumn('bcd', Column.varchar),
    SchemaColumn('item_cls_cd', Column.varchar),
    SchemaColumn('item_ty_cd', Column.varchar),
    SchemaColumn('item_std_nm', Column.varchar),
    SchemaColumn('orgn_nat_cd', Column.varchar),
    SchemaColumn('pkg', Column.varchar),
    SchemaColumn('item_cd', Column.varchar),
    SchemaColumn('pkg_unit_cd', Column.varchar),
    SchemaColumn('qty_unit_cd', Column.varchar),
    SchemaColumn('item_nm', Column.varchar),
    SchemaColumn('prc', Column.Double),
    SchemaColumn('sply_amt', Column.Double),
    SchemaColumn('tin', Column.integer),
    SchemaColumn('bhf_id', Column.varchar),
    SchemaColumn('dft_prc', Column.Double),
    SchemaColumn('add_info', Column.varchar),
    SchemaColumn('isrc_aplcb_yn', Column.varchar),
    SchemaColumn('use_yn', Column.varchar),
    SchemaColumn('regr_id', Column.varchar),
    SchemaColumn('regr_nm', Column.varchar),
    SchemaColumn('modr_id', Column.varchar),
    SchemaColumn('modr_nm', Column.varchar),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('ebm_synced', Column.boolean),
    SchemaColumn('part_of_composite', Column.boolean),
    SchemaColumn('composite_price', Column.Double)
  }, indices: <SchemaIndex>{}),
  SchemaTable('_brick_StockRequest_items', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('l_StockRequest_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'StockRequest',
        onDeleteCascade: true,
        onDeleteSetDefault: false),
    SchemaColumn('f_TransactionItem_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'TransactionItem',
        onDeleteCascade: true,
        onDeleteSetDefault: false)
  }, indices: <SchemaIndex>{
    SchemaIndex(
        columns: ['l_StockRequest_brick_id', 'f_TransactionItem_brick_id'],
        unique: true)
  }),
  SchemaTable('StockRequest', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.integer, unique: true),
    SchemaColumn('main_branch_id', Column.integer),
    SchemaColumn('sub_branch_id', Column.integer),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('status', Column.varchar),
    SchemaColumn('delivery_date', Column.datetime),
    SchemaColumn('delivery_note', Column.varchar),
    SchemaColumn('order_note', Column.varchar),
    SchemaColumn('customer_received_order', Column.boolean),
    SchemaColumn('driver_request_delivery_confirmation', Column.boolean),
    SchemaColumn('driver_id', Column.integer),
    SchemaColumn('updated_at', Column.datetime)
  }, indices: <SchemaIndex>{})
});
