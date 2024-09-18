-- Drop existing tables (if they exist)
DROP TABLE IF EXISTS public.branch;
DROP TABLE IF EXISTS public.business;
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS public.counter;
DROP TABLE IF EXISTS public.customer;
DROP TABLE IF EXISTS public.device;
DROP TABLE IF EXISTS public.discount;
DROP TABLE IF EXISTS public.drawers;
DROP TABLE IF EXISTS public.ebm;
DROP TABLE IF EXISTS public.favorite;
DROP TABLE IF EXISTS public.location;
DROP TABLE IF EXISTS public.pcolor;
DROP TABLE IF EXISTS public.product;
DROP TABLE IF EXISTS public.receipt;
DROP TABLE IF EXISTS public.setting;
DROP TABLE IF EXISTS public.stock;
DROP TABLE IF EXISTS public.stock_request;
DROP TABLE IF EXISTS public.transaction_item;
DROP TABLE IF EXISTS public.itransaction;
DROP TABLE IF EXISTS public.iunit;
DROP TABLE IF EXISTS public.voucher;
DROP TABLE IF EXISTS public.tenant;
DROP TABLE IF EXISTS public.pin;
DROP TABLE IF EXISTS public.lpermission;
DROP TABLE IF EXISTS public.token;
DROP TABLE IF EXISTS public.conversation;
DROP TABLE IF EXISTS public.activity;
DROP TABLE IF EXISTS public.unversal_product;
DROP TABLE IF EXISTS public.configurations;
DROP TABLE IF EXISTS public.app_notification;
DROP TABLE IF EXISTS public.assets;
DROP TABLE IF EXISTS public.composite;
DROP TABLE IF EXISTS public.sku;
DROP TABLE IF EXISTS public.report;
DROP TABLE IF EXISTS public.computed;
DROP TABLE IF EXISTS public.access;
DROP TABLE IF EXISTS public.payment_plan;
DROP TABLE IF EXISTS public.flipper_sale_compaign;

-- Create the tables
-- Branch Table
CREATE TABLE public.branch (
  id int PRIMARY KEY,
  name text,
  description text,
  businessId integer,
  serverId integer,
  longitude text,
  latitude text,
  location text,
  isDefault boolean,
  lastTouched timestamp with time zone,
  action text,
  deletedAt timestamp with time zone,
  isOnline boolean
);

-- Business Table
CREATE TABLE public.business (
  id int PRIMARY KEY,
  name text,
  currency text,
  category_id text,
  latitude text,
  longitude text,
  user_id integer,
  time_zone text,
  country text,
  business_url text,
  hex_color text,
  image_url text,
  type text,
  active boolean,
  chat_uid text,
  metadata text,
  role text,
  last_seen integer,
  first_name text,
  last_name text,
  created_at timestamp with time zone DEFAULT now(),
  device_token text,
  back_up_enabled boolean,
  subscription_plan text,
  next_billing_date text,
  previous_billing_date text,
  is_last_subscription_payment_succeeded boolean,
  backup_file_id text,
  email text,
  last_db_backup text,
  full_name text,
  tin_number integer,
  bhf_id text,
  dvc_srl_no text,
  adrs text,
  tax_enabled boolean,
  tax_server_url text,
  is_default boolean,
  business_type_id integer,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  encryption_key text
);

-- Category Table
CREATE TABLE public.category (
   id int PRIMARY KEY,
  active boolean,
  focused boolean,
  name text,
  branch_id integer,
  deleted_at timestamp with time zone,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now()
);

-- Counter Table
CREATE TABLE public.counter (
   id int PRIMARY KEY,
  business_id integer,
  branch_id integer,
  receipt_type text,
  tot_rcpt_no integer,
  cur_rcpt_no integer,
  invc_no integer,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now()
);

-- Customer Table
CREATE TABLE public.customer (
   id int PRIMARY KEY,
  cust_nm text,
  email text,
  tel_no text,
  adrs text,
  branch_id integer,
  updated_at timestamp with time zone,
  cust_no text,
  cust_tin text,
  regn_nm text,
  regn_id text,
  modr_nm text,
  modr_id text,
  ebm_synced boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  tin integer,
  bhf_id text,
  use_yn text,
  customer_type text,
  created_at timestamp with time zone DEFAULT now()
);

-- Device Table
CREATE TABLE public.device (
   id int PRIMARY KEY,
  linking_code text,
  device_name text,
  device_version text,
  pub_nub_published boolean,
  phone text,
  branch_id integer,
  business_id integer,
  user_id integer,
  default_app text,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now()
);

-- Discount Table
CREATE TABLE public.discount (
   id int PRIMARY KEY,
  name text,
  amount numeric(10,2),
  branch_id integer,
  created_at timestamp with time zone DEFAULT now()
);

-- Drawers Table
CREATE TABLE public.drawers (
   id int PRIMARY KEY,
  opening_balance numeric(10,2),
  closing_balance numeric(10,2),
  opening_date_time text,
  closing_date_time text,
  cs_sale_count integer,
  trade_name text,
  total_ns_sale_income numeric(10,2),
  total_cs_sale_income numeric(10,2),
  nr_sale_count integer,
  ns_sale_count integer,
  tr_sale_count integer,
  ps_sale_count integer,
  incomplete_sale integer,
  other_transactions integer,
  payment_mode text,
  cashier_id integer,
  "open" boolean,
  deleted_at timestamp with time zone,
  business_id integer,
  branch_id integer,
  created_at timestamp with time zone DEFAULT now()
);

-- EBM Table
CREATE TABLE public.ebm (
   id int PRIMARY KEY,
  bhf_id text,
  tin_number integer,
  dvc_srl_no text,
  user_id integer,
  tax_server_url text,
  business_id integer,
  branch_id integer,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now()
);

-- Favorite Table
CREATE TABLE public.favorite (
   id int PRIMARY KEY,
  fav_index integer,
  product_id integer,
  branch_id integer,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);

-- Location Table
CREATE TABLE public.location (
   id int PRIMARY KEY,
  realm_id uuid,
  server_id integer,
  active boolean,
  description text,
  name text,
  business_id integer,
  longitude text,
  latitude text,
  location text,
  is_default boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  is_online boolean,
  created_at timestamp with time zone DEFAULT now()
);

-- PColor Table
CREATE TABLE public.pcolor (
   id int PRIMARY KEY,
  name text,
  colors text[],
  branch_id integer,
  active boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);

-- Product Table
CREATE TABLE public.product (
   id int PRIMARY KEY,
  name text,
  description text,
  tax_id text,
  color text,
  business_id integer,
  branch_id integer,
  supplier_id text,
  category_id integer,
  unit text,
  image_url text,
  expiry_date text,
  bar_code text,
  nfc_enabled boolean,
  binded_to_tenant_id integer,
  is_favorite boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  spplr_nm text,
  is_composite boolean,
  created_at timestamp with time zone DEFAULT now()
);

-- Receipt Table
CREATE TABLE public.receipt (
   id int PRIMARY KEY,
  result_cd text,
  result_msg text,
  result_dt text,
  rcpt_no integer,
  intrl_data text,
  rcpt_sign text,
  tot_rcpt_no integer,
  vsdc_rcpt_pbct_date text,
  sdc_id text,
  mrc_no text,
  qr_code text,
  receipt_type text,
  branch_id integer,
  transaction_id integer,
  last_touched timestamp with time zone,
  action text,
  invc_no integer,
  created_at timestamp with time zone DEFAULT now()
);

-- Setting Table
CREATE TABLE public.setting (
   id int PRIMARY KEY,
  email text,
  user_id integer,
  open_receipt_file_o_sale_complete boolean,
  auto_print boolean,
  send_daily_report boolean,
  default_language text,
  attendnace_doc_created boolean,
  is_attendance_enabled boolean,
  type text,
  enrolled_in_bot boolean,
  device_token text,
  business_phone_number text,
  auto_respond boolean,
  token text,
  has_pin boolean,
  business_id integer,
  created_at timestamp with time zone,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  action text
);

-- Stock Table
CREATE TABLE public.stock (
   id int PRIMARY KEY,
  tin integer,
  bhf_id text,
  branch_id integer,
  variant_id integer,
  current_stock numeric(10,2) DEFAULT 0.0,
  sold numeric(10,2) DEFAULT 0.0,
  low_stock numeric(10,2) DEFAULT 0.0,
  can_tracking_stock boolean DEFAULT TRUE,
  show_low_stock_alert boolean DEFAULT TRUE,
  product_id integer,
  active boolean,
  value numeric(10,2) DEFAULT 0.0,
  rsd_qty numeric(10,2) DEFAULT 0.0,
  supply_price numeric(10,2) DEFAULT 0.0,
  retail_price numeric(10,2) DEFAULT 0.0,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  ebm_synced boolean DEFAULT FALSE,
  created_at timestamp with time zone DEFAULT now()
);

-- StockRequest Table
CREATE TABLE public.stock_request (
   id int PRIMARY KEY,
  main_branch_id integer,
  sub_branch_id integer,
  created_at timestamp with time zone,
  status text,
  delivery_date timestamp with time zone,
  delivery_note text,
  order_note text,
  customer_received_order boolean,
  driver_request_delivery_confirmation boolean,
  driver_id integer,
  updated_at timestamp with time zone
);

-- TransactionItem Table
CREATE TABLE public.transaction_item (
   id int PRIMARY KEY,
  name text,
  quantity_requested integer,
  quantity_approved integer,
  quantity_shipped integer,
  transaction_id integer,
  variant_id integer,
  qty numeric(10,2),
  price numeric(10,2),
  discount numeric(10,2),
  type text,
  remaining_stock numeric(10,2),
  updated_at timestamp with time zone,
  is_tax_exempted boolean,
  is_refunded boolean,
  done_with_transaction boolean,
  active boolean,
  dc_rt numeric(10,2),
  dc_amt numeric(10,2),
  taxbl_amt numeric(10,2),
  tax_amt numeric(10,2),
  tot_amt numeric(10,2),
  item_seq integer,
  isrcc_cd text,
  isrcc_nm text,
  isrc_rt integer,
  isrc_amt integer,
  tax_ty_cd text,
  bcd text,
  item_cls_cd text,
  item_ty_cd text,
  item_std_nm text,
  orgn_nat_cd text,
  pkg text,
  item_cd text,
  pkg_unit_cd text,
  qty_unit_cd text,
  item_nm text,
  prc numeric(10,2),
  sply_amt numeric(10,2),
  tin integer,
  bhf_id text,
  dft_prc numeric(10,2),
  add_info text,
  isrc_aplcby_yn text,
  use_yn text,
  regn_id text,
  regn_nm text,
  modr_id text,
  modr_nm text,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  action text,
  branch_id integer,
  ebm_synced boolean,
  part_of_composite boolean,
  composite_price numeric(10,2),
  created_at timestamp with time zone DEFAULT now()
);

-- ITransaction Table
CREATE TABLE public.itransaction (
   id int PRIMARY KEY,
  reference text,
  category_id text,
  transaction_number text,
  branch_id integer,
  status text,
  transaction_type text,
  sub_total numeric(10,2),
  payment_type text,
  cash_received numeric(10,2),
  customer_change_due numeric(10,2),
  receipt_type text,
  updated_at timestamp with time zone,
  customer_id integer,
  customer_type text,
  note text,
  last_touched timestamp with time zone,
  action text,
  ticket_name text,
  deleted_at timestamp with time zone,
  supplier_id integer,
  ebm_synced boolean,
  created_at timestamp with time zone DEFAULT now()
);

-- IUnit Table
CREATE TABLE public.iunit (
   id int PRIMARY KEY,
  branch_id integer,
  name text,
  value text,
  active boolean,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone,
  deleted_at timestamp with time zone
);

-- Voucher Table
CREATE TABLE public.voucher (
   id int PRIMARY KEY,
  value integer,
  interval integer,
  used boolean,
  used_at integer,
  descriptor text,
  created_at timestamp with time zone DEFAULT now()
);

-- Tenant Table
CREATE TABLE public.tenant (
   id int PRIMARY KEY,
  name text,
  phone_number text,
  email text,
  nfc_enabled boolean,
  business_id integer,
  user_id integer,
  image_url text,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  pin integer,
  session_active boolean,
  is_default boolean,
  created_at timestamp with time zone DEFAULT now()
);

-- Pin Table
CREATE TABLE public.pin (
   id int PRIMARY KEY,
  user_id text,
  phone_number text,
  pin integer,
  branch_id integer,
  business_id integer,
  created_at timestamp with time zone DEFAULT now()
);

-- LPermission Table
CREATE TABLE public.lpermission (
   id int PRIMARY KEY,
  name text,
  user_id integer,
  created_at timestamp with time zone DEFAULT now()
);

-- Token Table
CREATE TABLE public.token (
   id int PRIMARY KEY,
  type text,
  token text,
  valid_from timestamp with time zone,
  valid_until timestamp with time zone,
  business_id integer,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);

-- Conversation Table
CREATE TABLE public.conversation (
   id int PRIMARY KEY,
  user_name text,
  body text,
  avatar text,
  channel_type text,
  from_number text,
  to_number text,
  message_type text,
  phone_number_id text,
  message_id text,
  responded_by text,
  conversation_id text,
  business_phone_number text,
  business_id integer,
  scheduled_at timestamp with time zone,
  delivered boolean,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);

-- Activity Table
CREATE TABLE public.activity (
   id int PRIMARY KEY,
  timestamp timestamp with time zone,
  last_touched timestamp with time zone,
  user_id integer,
  event text,
  details jsonb,
  action text,
  created_at timestamp with time zone DEFAULT now()
);

-- UnversalProduct Table
CREATE TABLE public.unversal_product (
   id int PRIMARY KEY,
  item_cls_cd text,
  item_cls_nm text,
  item_cls_lvl integer,
  tax_ty_cd text,
  mjr_tg_yn text,
  use_yn text,
  business_id integer,
  branch_id integer,
  created_at timestamp with time zone DEFAULT now()
);

-- Configurations Table
CREATE TABLE public.configurations (
   id int PRIMARY KEY,
  tax_type text,
  tax_percentage numeric(10,2),
  business_id integer,
  branch_id integer,
  created_at timestamp with time zone DEFAULT now()
);

-- AppNotification Table
CREATE TABLE public.app_notification (
   id int PRIMARY KEY,
  completed boolean,
  type text,
  message text,
  identifier integer,
  created_at timestamp with time zone DEFAULT now()
);

-- Assets Table
CREATE TABLE public.assets (
   id int PRIMARY KEY,
  branch_id integer,
  business_id integer,
  asset_name text,
  product_id integer,
  created_at timestamp with time zone DEFAULT now()
);

-- Composite Table
CREATE TABLE public.composite (
   id int PRIMARY KEY,
  product_id integer,
  variant_id integer,
  qty numeric(10,2),
  branch_id integer,
  business_id integer,
  actual_price numeric(10,2),
  created_at timestamp with time zone DEFAULT now()
);

-- SKU Table
CREATE TABLE public.sku (
   id int PRIMARY KEY,
  sku integer,
  branch_id integer,
  business_id integer,
  consumed boolean,
  created_at timestamp with time zone DEFAULT now()
);

-- Report Table
CREATE TABLE public.report (
   id int PRIMARY KEY,
  branch_id integer,
  business_id integer,
  filename text,
  s3_url text,
  downloaded boolean,
  created_at timestamp with time zone DEFAULT now()
);

-- Computed Table
CREATE TABLE public.computed (
   id int PRIMARY KEY,
  branch_id integer,
  business_id integer,
  gross_profit numeric(10,2),
  net_profit numeric(10,2),
  total_stock_value numeric(10,2),
  total_stock_sold_value numeric(10,2),
  total_stock_items numeric(10,2),
  created_at timestamp with time zone
);

-- Access Table
CREATE TABLE public.access (
   id int PRIMARY KEY,
  branch_id integer,
  business_id integer,
  user_id integer,
  feature_name text,
  user_type text,
  access_level text,
  created_at timestamp with time zone,
  expires_at timestamp with time zone,
  status text
);

-- PaymentPlan Table
CREATE TABLE public.payment_plan (
   id int PRIMARY KEY,
  business_id integer,
  selected_plan text,
  additional_devices integer,
  is_yearly_plan boolean,
  total_price numeric(10,2),
  payment_completed_by_user boolean,
  paystack_customer_id integer,
  rule text,
  payment_method text,
  customer_code text,
  paystack_plan_id text,
  created_at timestamp with time zone DEFAULT now()
);

-- FlipperSaleCompaign Table
CREATE TABLE public.flipper_sale_compaign (
   id int PRIMARY KEY,
  compaign_id integer,
  discount_rate integer,
  created_at timestamp with time zone,
  coupon_code text
);

-- Create publication for powersync
DROP PUBLICATION IF EXISTS powersync;
-- Create publication for powersync
DROP PUBLICATION IF EXISTS powersync;
CREATE PUBLICATION powersync FOR TABLE public.branch, public.business, public.category, public.counter, public.customer, public.device, public.discount, public.drawers, public.ebm, public.favorite, public.location, public.pcolor, public.product, public.receipt, public.setting, public.stock, public.stock_request, public.transaction_item, public.itransaction, public.iunit, public.voucher, public.tenant, public.pin, public.lpermission, public.token, public.conversation, public.activity, public.unversal_product, public.configurations, public.app_notification, public.assets, public.composite, public.sku, public.report, public.computed, public.access, public.payment_plan, public.flipper_sale_compaign;