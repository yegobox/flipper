// import 'package:powersync/powersync.dart';

// const String branch_table = 'branch';
// const String business_table = 'business';
// const String category_table = 'category';
// const String counter_table = 'counter';
// const String customer_table = 'customer';
// const String device_table = 'device';
// const String discount_table = 'discount';
// const String drawers_table = 'drawers';
// const String ebm_table = 'ebm';
// const String favorite_table = 'favorite';
// const String location_table = 'location';
// const String pcolor_table = 'pcolor';
// const String product_table = 'products';
// const String receipt_table = 'receipt';
// const String setting_table = 'setting';
// const String stock_table = 'stock';
// const String stock_request_table = 'stockRequest';
// const String transaction_item_table = 'transactionItem';
// const String itransaction_table = 'iTransaction';
// const String iunit_table = 'iUnit';
// const String voucher_table = 'voucher';
// const String tenant_table = 'tenant';
// const String pin_table = 'pin';
// const String lpermission_table = 'lPermission';
// const String token_table = 'token';
// const String conversation_table = 'conversation';
// const String activity_table = 'activity';
// const String unversal_product_table = 'unversalProduct';
// const String configurations_table = 'configurations';
// const String app_notification_table = 'appNotification';
// const String assets_table = 'assets';
// const String composite_table = 'composite';
// const String sku_table = 'sku';
// const String report_table = 'report';
// const String computed_table = 'computed';
// const String access_table = 'access';
// const String payment_plan_table = 'paymentPlan';
// const String flipper_sale_compaign_table = 'flipperSaleCompaign';

// Schema schema = Schema([
//   Table('lists', [
//     Column.text('created_at'),
//     Column.text('name'),
//     Column.text('owner_id')
//   ]),
//   Table('todos', [
//     Column.text('created_at'),
//     Column.text('completed_at'),
//     Column.text('description'),
//     Column.integer('completed'),
//     Column.text('created_by'),
//     Column.text('completed_by'),
//     Column.text('list_id'),
//     Column.text('photo_id')
//   ]),
//   Table('products', [
//     Column.integer('product_id'),
//     Column.text('name'),
//     Column.text('description'),
//     Column.text('color'),
//     Column.integer('business_id'),
//     Column.integer('branch_id'),
//     Column.text('supplier_id'),
//     Column.integer('category_id'),
//     Column.text('tax_id'),
//     Column.text('unit'),
//     Column.text('image_url'),
//     Column.text('expiry_date'),
//     Column.text('bar_code'),
//     Column.integer('nfc_enabled'),
//     Column.integer('binded_to_tenant_id'),
//     Column.integer('is_favorite'),
//     Column.text('last_touched'),
//     Column.text('action'),
//     Column.text('deleted_at'),
//     Column.text('spplr_nm'),
//     Column.integer('is_composite'),
//     Column.text('created_at'),
//     Column.text('owner_id')
//   ]),
//   Table('stocks', [
//     Column.integer('stock_id'),
//     Column.integer('tin'),
//     Column.text('bhf_id'),
//     Column.integer('branch_id'),
//     Column.integer('variant_id'),
//     Column.text('current_stock'),
//     Column.text('sold'),
//     Column.text('low_stock'),
//     Column.integer('can_tracking_stock'),
//     Column.integer('show_low_stock_alert'),
//     Column.integer('product_id'),
//     Column.integer('active'),
//     Column.text('value'),
//     Column.text('rsd_qty'),
//     Column.text('supply_price'),
//     Column.text('retail_price'),
//     Column.text('last_touched'),
//     Column.text('action'),
//     Column.text('deleted_at'),
//     Column.integer('ebm_synced'),
//     Column.text('created_at'),
//     Column.text('owner_id')
//   ]),
//   Table('variants', [
//     Column.integer('variant_id'),
//     Column.text('deleted_at'),
//     Column.text('name'),
//     Column.text('color'),
//     Column.text('sku'),
//     Column.integer('product_id'),
//     Column.text('unit'),
//     Column.text('product_name'),
//     Column.integer('branch_id'),
//     Column.text('tax_name'),
//     Column.real('tax_percentage'),
//     Column.integer('is_tax_exempted'),
//     Column.integer('item_seq'),
//     Column.text('isrcc_cd'),
//     Column.text('isrcc_nm'),
//     Column.integer('isrc_rt'),
//     Column.integer('isrc_amt'),
//     Column.text('tax_ty_cd'),
//     Column.text('bcd'),
//     Column.text('item_cls_cd'),
//     Column.text('item_ty_cd'),
//     Column.text('item_std_nm'),
//     Column.text('orgn_nat_cd'),
//     Column.text('pkg'),
//     Column.text('item_cd'),
//     Column.text('pkg_unit_cd'),
//     Column.text('qty_unit_cd'),
//     Column.text('item_nm'),
//     Column.real('qty'),
//     Column.real('prc'),
//     Column.real('sply_amt'),
//     Column.integer('tin'),
//     Column.text('bhf_id'),
//     Column.real('dft_prc'),
//     Column.text('add_info'),
//     Column.text('isrc_aplcb_yn'),
//     Column.text('use_yn'),
//     Column.text('regr_id'),
//     Column.text('regr_nm'),
//     Column.text('modr_id'),
//     Column.text('modr_nm'),
//     Column.real('rsd_qty'),
//     Column.text('last_touched'),
//     Column.real('supply_price'),
//     Column.real('retail_price'),
//     Column.text('action'),
//     Column.text('spplr_item_cls_cd'),
//     Column.text('spplr_item_cd'),
//     Column.text('spplr_item_nm'),
//     Column.integer('ebm_synced'),
//     Column.text('tax_type'),
//     Column.text('created_at'),
//     Column.text('owner_id')
//   ]),
//   Table('counters', [
//     Column.integer('counter_id'),
//     Column.integer('business_id'),
//     Column.integer('branch_id'),
//     Column.text('receipt_type'),
//     Column.integer('tot_rcpt_no'),
//     Column.integer('cur_rcpt_no'),
//     Column.integer('invc_no'),
//     Column.text('last_touched'),
//     Column.text('action'),
//     Column.text('created_at'),
//     Column.text('owner_id')
//   ])
// ]);
