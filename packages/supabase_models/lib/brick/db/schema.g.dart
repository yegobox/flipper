// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250104131208.migration.dart';
part '20250127184733.migration.dart';
part '20250124185812.migration.dart';
part '20250102092703.migration.dart';
part '20250102092919.migration.dart';
part '20250102125905.migration.dart';
part '20250114092913.migration.dart';
part '20250117141102.migration.dart';
part '20250110094310.migration.dart';
part '20250101092622.migration.dart';
part '20250114144814.migration.dart';
part '20250102130727.migration.dart';
part '20250128051600.migration.dart';
part '20250102124844.migration.dart';
part '20250124180016.migration.dart';
part '20250124153826.migration.dart';
part '20250123095625.migration.dart';
part '20250102110336.migration.dart';
part '20250126102159.migration.dart';
part '20250102144742.migration.dart';
part '20250128050524.migration.dart';
part '20250114114345.migration.dart';
part '20250109125327.migration.dart';
part '20250123095657.migration.dart';
part '20250205095332.migration.dart';
part '20250205114646.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20250104131208(),
  const Migration20250127184733(),
  const Migration20250124185812(),
  const Migration20250102092703(),
  const Migration20250102092919(),
  const Migration20250102125905(),
  const Migration20250114092913(),
  const Migration20250117141102(),
  const Migration20250110094310(),
  const Migration20250101092622(),
  const Migration20250114144814(),
  const Migration20250102130727(),
  const Migration20250128051600(),
  const Migration20250102124844(),
  const Migration20250124180016(),
  const Migration20250124153826(),
  const Migration20250123095625(),
  const Migration20250102110336(),
  const Migration20250126102159(),
  const Migration20250102144742(),
  const Migration20250128050524(),
  const Migration20250114114345(),
  const Migration20250109125327(),
  const Migration20250123095657(),
  const Migration20250205095332(),
  const Migration20250205114646()
};

/// A consumable database structure including the latest generated migration.
final schema =
    Schema(20250205114646, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('ItemCode', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('code', Column.varchar),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('branch_id', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true),
    SchemaIndex(columns: ['code'], unique: false)
  }),
  SchemaTable('ImportPurchaseDates', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('last_request_date', Column.varchar),
    SchemaColumn('branch_id', Column.varchar),
    SchemaColumn('request_type', Column.varchar),
    SchemaColumn('purchase_id', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Stock', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('tin', Column.integer),
    SchemaColumn('bhf_id', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('current_stock', Column.Double),
    SchemaColumn('low_stock', Column.Double),
    SchemaColumn('can_tracking_stock', Column.boolean),
    SchemaColumn('show_low_stock_alert', Column.boolean),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('value', Column.Double),
    SchemaColumn('rsd_qty', Column.Double),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('ebm_synced', Column.boolean),
    SchemaColumn('initial_stock', Column.Double)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Counter', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('receipt_type', Column.varchar),
    SchemaColumn('tot_rcpt_no', Column.integer),
    SchemaColumn('cur_rcpt_no', Column.integer),
    SchemaColumn('invc_no', Column.integer),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('created_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Category', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('focused', Column.boolean),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('deleted_at', Column.datetime),
    SchemaColumn('last_touched', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('BusinessAnalytic', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('date', Column.datetime),
    SchemaColumn('item_name', Column.varchar),
    SchemaColumn('price', Column.num),
    SchemaColumn('profit', Column.num),
    SchemaColumn('units_sold', Column.integer),
    SchemaColumn('tax_rate', Column.num),
    SchemaColumn('traffic_count', Column.integer),
    SchemaColumn('branch_id', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('UnversalProduct', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('item_cls_cd', Column.varchar),
    SchemaColumn('item_cls_nm', Column.varchar),
    SchemaColumn('item_cls_lvl', Column.integer),
    SchemaColumn('tax_ty_cd', Column.varchar),
    SchemaColumn('mjr_tg_yn', Column.varchar),
    SchemaColumn('use_yn', Column.varchar),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Conversation', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('user_name', Column.varchar),
    SchemaColumn('body', Column.varchar),
    SchemaColumn('avatar', Column.varchar),
    SchemaColumn('channel_type', Column.varchar),
    SchemaColumn('from_number', Column.varchar),
    SchemaColumn('to_number', Column.varchar),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('message_type', Column.varchar),
    SchemaColumn('phone_number_id', Column.varchar),
    SchemaColumn('message_id', Column.varchar),
    SchemaColumn('responded_by', Column.varchar),
    SchemaColumn('conversation_id', Column.varchar),
    SchemaColumn('business_phone_number', Column.varchar),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('scheduled_at', Column.datetime),
    SchemaColumn('delivered', Column.boolean),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('CustomerPayments', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('customer_id', Column.varchar),
    SchemaColumn('phone_number', Column.varchar),
    SchemaColumn('payment_status', Column.varchar),
    SchemaColumn('transaction_id', Column.varchar),
    SchemaColumn('amount_payable', Column.Double)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('ITransaction', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('reference', Column.varchar),
    SchemaColumn('category_id', Column.varchar),
    SchemaColumn('transaction_number', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('status', Column.varchar),
    SchemaColumn('transaction_type', Column.varchar),
    SchemaColumn('sub_total', Column.Double),
    SchemaColumn('payment_type', Column.varchar),
    SchemaColumn('cash_received', Column.Double),
    SchemaColumn('customer_change_due', Column.Double),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('receipt_type', Column.varchar),
    SchemaColumn('updated_at', Column.datetime),
    SchemaColumn('customer_id', Column.varchar),
    SchemaColumn('customer_type', Column.varchar),
    SchemaColumn('note', Column.varchar),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('ticket_name', Column.varchar),
    SchemaColumn('supplier_id', Column.integer),
    SchemaColumn('ebm_synced', Column.boolean),
    SchemaColumn('is_income', Column.boolean),
    SchemaColumn('is_expense', Column.boolean),
    SchemaColumn('is_refunded', Column.boolean),
    SchemaColumn('customer_name', Column.varchar),
    SchemaColumn('customer_tin', Column.varchar),
    SchemaColumn('remark', Column.varchar),
    SchemaColumn('customer_bhf_id', Column.varchar),
    SchemaColumn('sar_ty_cd', Column.varchar),
    SchemaColumn('receipt_number', Column.integer),
    SchemaColumn('total_receipt_number', Column.integer),
    SchemaColumn('invoice_number', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Configurations', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('tax_type', Column.varchar),
    SchemaColumn('tax_percentage', Column.Double),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Branch', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
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
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('PlanAddon', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('plan_id', Column.integer),
    SchemaColumn('addon_name', Column.varchar),
    SchemaColumn('created_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('PColor', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Country', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('sort_order', Column.integer),
    SchemaColumn('description', Column.varchar),
    SchemaColumn('code', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('BranchPaymentIntegration', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('branch_id', Column.varchar),
    SchemaColumn('is_enabled', Column.boolean)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('TransactionItem', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('quantity_requested', Column.integer),
    SchemaColumn('quantity_approved', Column.integer),
    SchemaColumn('quantity_shipped', Column.integer),
    SchemaColumn('transaction_id', Column.varchar),
    SchemaColumn('variant_id', Column.varchar),
    SchemaColumn('qty', Column.Double),
    SchemaColumn('price', Column.Double),
    SchemaColumn('discount', Column.Double),
    SchemaColumn('remaining_stock', Column.Double),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('updated_at', Column.datetime),
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
    SchemaColumn('isrc_rt', Column.integer),
    SchemaColumn('isrc_amt', Column.integer),
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
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('ebm_synced', Column.boolean),
    SchemaColumn('part_of_composite', Column.boolean),
    SchemaColumn('composite_price', Column.Double)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('LPermission', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('user_id', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Variant', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('purchase_id', Column.varchar),
    SchemaColumn('stock_Stock_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Stock',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('stock_id', Column.varchar),
    SchemaColumn('tax_percentage', Column.num),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('color', Column.varchar),
    SchemaColumn('sku', Column.varchar),
    SchemaColumn('product_id', Column.varchar),
    SchemaColumn('unit', Column.varchar),
    SchemaColumn('product_name', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('tax_name', Column.varchar),
    SchemaColumn('item_seq', Column.integer),
    SchemaColumn('isrcc_cd', Column.varchar),
    SchemaColumn('isrcc_nm', Column.varchar),
    SchemaColumn('isrc_rt', Column.integer),
    SchemaColumn('isrc_amt', Column.integer),
    SchemaColumn('tax_ty_cd', Column.varchar),
    SchemaColumn('bcd', Column.varchar),
    SchemaColumn('item_cls_cd', Column.varchar),
    SchemaColumn('item_ty_cd', Column.varchar),
    SchemaColumn('item_std_nm', Column.varchar),
    SchemaColumn('orgn_nat_cd', Column.varchar),
    SchemaColumn('pkg', Column.integer),
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
    SchemaColumn('supply_price', Column.Double),
    SchemaColumn('retail_price', Column.Double),
    SchemaColumn('spplr_item_cls_cd', Column.varchar),
    SchemaColumn('spplr_item_cd', Column.varchar),
    SchemaColumn('spplr_item_nm', Column.varchar),
    SchemaColumn('ebm_synced', Column.boolean),
    SchemaColumn('dc_rt', Column.Double),
    SchemaColumn('expiration_date', Column.datetime),
    SchemaColumn('tot_wt', Column.integer),
    SchemaColumn('net_wt', Column.integer),
    SchemaColumn('spplr_nm', Column.varchar),
    SchemaColumn('agnt_nm', Column.varchar),
    SchemaColumn('invc_fcur_amt', Column.integer),
    SchemaColumn('invc_fcur_cd', Column.varchar),
    SchemaColumn('invc_fcur_excrt', Column.Double),
    SchemaColumn('expt_nat_cd', Column.varchar),
    SchemaColumn('dcl_no', Column.varchar),
    SchemaColumn('task_cd', Column.varchar),
    SchemaColumn('dcl_de', Column.varchar),
    SchemaColumn('hs_cd', Column.varchar),
    SchemaColumn('impt_item_stts_cd', Column.varchar),
    SchemaColumn('taxbl_amt', Column.Double),
    SchemaColumn('tax_amt', Column.Double),
    SchemaColumn('tot_amt', Column.Double),
    SchemaColumn('pchs_stts_cd', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true),
    SchemaIndex(columns: ['purchase_id'], unique: false)
  }),
  SchemaTable('_brick_Purchase_variants', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('l_Purchase_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Purchase',
        onDeleteCascade: true,
        onDeleteSetDefault: false),
    SchemaColumn('f_Variant_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Variant',
        onDeleteCascade: true,
        onDeleteSetDefault: false)
  }, indices: <SchemaIndex>{
    SchemaIndex(
        columns: ['l_Purchase_brick_id', 'f_Variant_brick_id'], unique: true)
  }),
  SchemaTable('Purchase', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('variants', Column.varchar),
    SchemaColumn('spplr_tin', Column.varchar),
    SchemaColumn('spplr_nm', Column.varchar),
    SchemaColumn('spplr_bhf_id', Column.varchar),
    SchemaColumn('spplr_invc_no', Column.integer),
    SchemaColumn('rcpt_ty_cd', Column.varchar),
    SchemaColumn('pmt_ty_cd', Column.varchar),
    SchemaColumn('cfm_dt', Column.varchar),
    SchemaColumn('sales_dt', Column.varchar),
    SchemaColumn('stock_rls_dt', Column.varchar),
    SchemaColumn('tot_item_cnt', Column.integer),
    SchemaColumn('taxbl_amt_a', Column.num),
    SchemaColumn('taxbl_amt_b', Column.num),
    SchemaColumn('taxbl_amt_c', Column.num),
    SchemaColumn('taxbl_amt_d', Column.num),
    SchemaColumn('tax_rt_a', Column.num),
    SchemaColumn('tax_rt_b', Column.num),
    SchemaColumn('tax_rt_c', Column.num),
    SchemaColumn('tax_rt_d', Column.num),
    SchemaColumn('tax_amt_a', Column.num),
    SchemaColumn('tax_amt_b', Column.num),
    SchemaColumn('tax_amt_c', Column.num),
    SchemaColumn('tax_amt_d', Column.num),
    SchemaColumn('tot_taxbl_amt', Column.num),
    SchemaColumn('tot_tax_amt', Column.num),
    SchemaColumn('tot_amt', Column.num),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('remark', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Device', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('linking_code', Column.varchar),
    SchemaColumn('device_name', Column.varchar),
    SchemaColumn('device_version', Column.varchar),
    SchemaColumn('pub_nub_published', Column.boolean),
    SchemaColumn('phone', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('user_id', Column.integer),
    SchemaColumn('default_app', Column.varchar),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Favorite', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('fav_index', Column.varchar),
    SchemaColumn('product_id', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Composite', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('product_id', Column.varchar),
    SchemaColumn('variant_id', Column.varchar),
    SchemaColumn('qty', Column.Double),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('actual_price', Column.Double)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('TransactionPaymentRecord', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('transaction_id', Column.varchar),
    SchemaColumn('amount', Column.Double),
    SchemaColumn('payment_method', Column.varchar),
    SchemaColumn('created_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Setting', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('email', Column.varchar),
    SchemaColumn('user_id', Column.integer),
    SchemaColumn('open_receipt_file_o_sale_complete', Column.boolean),
    SchemaColumn('auto_print', Column.boolean),
    SchemaColumn('send_daily_report', Column.boolean),
    SchemaColumn('default_language', Column.varchar),
    SchemaColumn('attendnace_doc_created', Column.boolean),
    SchemaColumn('is_attendance_enabled', Column.boolean),
    SchemaColumn('type', Column.varchar),
    SchemaColumn('enrolled_in_bot', Column.boolean),
    SchemaColumn('device_token', Column.varchar),
    SchemaColumn('business_phone_number', Column.varchar),
    SchemaColumn('auto_respond', Column.boolean),
    SchemaColumn('token', Column.varchar),
    SchemaColumn('has_pin', Column.boolean),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('created_at', Column.varchar),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Tenant', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('phone_number', Column.varchar),
    SchemaColumn('email', Column.varchar),
    SchemaColumn('nfc_enabled', Column.boolean),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('user_id', Column.integer),
    SchemaColumn('image_url', Column.varchar),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime),
    SchemaColumn('pin', Column.integer),
    SchemaColumn('session_active', Column.boolean),
    SchemaColumn('is_default', Column.boolean),
    SchemaColumn('is_long_pressed', Column.boolean),
    SchemaColumn('type', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Pin', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('user_id', Column.integer),
    SchemaColumn('phone_number', Column.varchar),
    SchemaColumn('pin', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('owner_name', Column.varchar),
    SchemaColumn('token_uid', Column.varchar),
    SchemaColumn('uid', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Access', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('user_id', Column.integer),
    SchemaColumn('feature_name', Column.varchar),
    SchemaColumn('user_type', Column.varchar),
    SchemaColumn('access_level', Column.varchar),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('expires_at', Column.datetime),
    SchemaColumn('status', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Customer', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('cust_nm', Column.varchar),
    SchemaColumn('email', Column.varchar),
    SchemaColumn('tel_no', Column.varchar),
    SchemaColumn('adrs', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('updated_at', Column.datetime),
    SchemaColumn('cust_no', Column.varchar),
    SchemaColumn('cust_tin', Column.varchar),
    SchemaColumn('regr_nm', Column.varchar),
    SchemaColumn('regr_id', Column.varchar),
    SchemaColumn('modr_nm', Column.varchar),
    SchemaColumn('modr_id', Column.varchar),
    SchemaColumn('ebm_synced', Column.boolean),
    SchemaColumn('bhf_id', Column.varchar),
    SchemaColumn('use_yn', Column.varchar),
    SchemaColumn('customer_type', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Report', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('filename', Column.varchar),
    SchemaColumn('s3_url', Column.varchar),
    SchemaColumn('downloaded', Column.boolean)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
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
    SchemaColumn('id', Column.varchar, unique: true),
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
    SchemaColumn('items', Column.varchar),
    SchemaColumn('updated_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('AppNotification', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('type', Column.varchar),
    SchemaColumn('message', Column.varchar),
    SchemaColumn('identifier', Column.integer),
    SchemaColumn('completed', Column.boolean)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Discount', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('amount', Column.Double),
    SchemaColumn('branch_id', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Business', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('server_id', Column.integer),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('currency', Column.varchar),
    SchemaColumn('category_id', Column.varchar),
    SchemaColumn('latitude', Column.varchar),
    SchemaColumn('longitude', Column.varchar),
    SchemaColumn('user_id', Column.integer),
    SchemaColumn('time_zone', Column.varchar),
    SchemaColumn('country', Column.varchar),
    SchemaColumn('business_url', Column.varchar),
    SchemaColumn('hex_color', Column.varchar),
    SchemaColumn('image_url', Column.varchar),
    SchemaColumn('type', Column.varchar),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('chat_uid', Column.varchar),
    SchemaColumn('metadata', Column.varchar),
    SchemaColumn('role', Column.varchar),
    SchemaColumn('last_seen', Column.integer),
    SchemaColumn('first_name', Column.varchar),
    SchemaColumn('last_name', Column.varchar),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('device_token', Column.varchar),
    SchemaColumn('back_up_enabled', Column.boolean),
    SchemaColumn('subscription_plan', Column.varchar),
    SchemaColumn('next_billing_date', Column.varchar),
    SchemaColumn('previous_billing_date', Column.varchar),
    SchemaColumn('is_last_subscription_payment_succeeded', Column.boolean),
    SchemaColumn('backup_file_id', Column.varchar),
    SchemaColumn('email', Column.varchar),
    SchemaColumn('last_db_backup', Column.varchar),
    SchemaColumn('full_name', Column.varchar),
    SchemaColumn('tin_number', Column.integer),
    SchemaColumn('bhf_id', Column.varchar),
    SchemaColumn('dvc_srl_no', Column.varchar),
    SchemaColumn('adrs', Column.varchar),
    SchemaColumn('tax_enabled', Column.boolean),
    SchemaColumn('tax_server_url', Column.varchar),
    SchemaColumn('is_default', Column.boolean),
    SchemaColumn('business_type_id', Column.integer),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime),
    SchemaColumn('encryption_key', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('SKU', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('sku', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('consumed', Column.boolean)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('IUnit', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('value', Column.varchar),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('created_at', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Location', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('server_id', Column.integer),
    SchemaColumn('active', Column.boolean),
    SchemaColumn('description', Column.varchar),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('longitude', Column.varchar),
    SchemaColumn('latitude', Column.varchar),
    SchemaColumn('location', Column.varchar),
    SchemaColumn('is_default', Column.boolean),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime),
    SchemaColumn('is_online', Column.boolean)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Receipt', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('result_cd', Column.varchar),
    SchemaColumn('result_msg', Column.varchar),
    SchemaColumn('result_dt', Column.varchar),
    SchemaColumn('rcpt_no', Column.integer),
    SchemaColumn('intrl_data', Column.varchar),
    SchemaColumn('rcpt_sign', Column.varchar),
    SchemaColumn('tot_rcpt_no', Column.integer),
    SchemaColumn('vsdc_rcpt_pbct_date', Column.varchar),
    SchemaColumn('sdc_id', Column.varchar),
    SchemaColumn('mrc_no', Column.varchar),
    SchemaColumn('qr_code', Column.varchar),
    SchemaColumn('receipt_type', Column.varchar),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('transaction_id', Column.varchar),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('invc_no', Column.integer),
    SchemaColumn('when_created', Column.datetime),
    SchemaColumn('invoice_number', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Token', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('type', Column.varchar),
    SchemaColumn('token', Column.varchar),
    SchemaColumn('valid_from', Column.datetime),
    SchemaColumn('valid_until', Column.datetime),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('last_touched', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Ebm', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('bhf_id', Column.varchar),
    SchemaColumn('tin_number', Column.integer),
    SchemaColumn('dvc_srl_no', Column.varchar),
    SchemaColumn('user_id', Column.integer),
    SchemaColumn('tax_server_url', Column.varchar),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('last_touched', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('_brick_Product_composites', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('l_Product_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Product',
        onDeleteCascade: true,
        onDeleteSetDefault: false),
    SchemaColumn('f_Composite_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Composite',
        onDeleteCascade: true,
        onDeleteSetDefault: false)
  }, indices: <SchemaIndex>{
    SchemaIndex(
        columns: ['l_Product_brick_id', 'f_Composite_brick_id'], unique: true)
  }),
  SchemaTable('Product', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('description', Column.varchar),
    SchemaColumn('tax_id', Column.varchar),
    SchemaColumn('color', Column.varchar),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('supplier_id', Column.varchar),
    SchemaColumn('category_id', Column.integer),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('unit', Column.varchar),
    SchemaColumn('image_url', Column.varchar),
    SchemaColumn('expiry_date', Column.varchar),
    SchemaColumn('bar_code', Column.varchar),
    SchemaColumn('nfc_enabled', Column.boolean),
    SchemaColumn('binded_to_tenant_id', Column.varchar),
    SchemaColumn('is_favorite', Column.boolean),
    SchemaColumn('last_touched', Column.datetime),
    SchemaColumn('spplr_nm', Column.varchar),
    SchemaColumn('is_composite', Column.boolean),
    SchemaColumn('search_match', Column.boolean)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Assets', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('branch_id', Column.integer),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('asset_name', Column.varchar),
    SchemaColumn('product_id', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
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
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('selected_plan', Column.varchar),
    SchemaColumn('additional_devices', Column.integer),
    SchemaColumn('is_yearly_plan', Column.boolean),
    SchemaColumn('total_price', Column.integer),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('payment_completed_by_user', Column.boolean),
    SchemaColumn('rule', Column.varchar),
    SchemaColumn('payment_method', Column.varchar),
    SchemaColumn('next_billing_date', Column.datetime),
    SchemaColumn('number_of_payments', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Drawers', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('opening_balance', Column.Double),
    SchemaColumn('closing_balance', Column.Double),
    SchemaColumn('opening_date_time', Column.datetime),
    SchemaColumn('closing_date_time', Column.datetime),
    SchemaColumn('cs_sale_count', Column.integer),
    SchemaColumn('trade_name', Column.varchar),
    SchemaColumn('total_ns_sale_income', Column.Double),
    SchemaColumn('total_cs_sale_income', Column.Double),
    SchemaColumn('nr_sale_count', Column.integer),
    SchemaColumn('ns_sale_count', Column.integer),
    SchemaColumn('tr_sale_count', Column.integer),
    SchemaColumn('ps_sale_count', Column.integer),
    SchemaColumn('incomplete_sale', Column.integer),
    SchemaColumn('other_transactions', Column.integer),
    SchemaColumn('payment_mode', Column.varchar),
    SchemaColumn('cashier_id', Column.integer),
    SchemaColumn('open', Column.boolean),
    SchemaColumn('deleted_at', Column.datetime),
    SchemaColumn('business_id', Column.integer),
    SchemaColumn('branch_id', Column.integer)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  })
});
