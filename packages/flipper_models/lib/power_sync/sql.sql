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
DROP TABLE IF EXISTS public.receipt;
DROP TABLE IF EXISTS public.setting;
DROP TABLE IF EXISTS public.stocks;
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
DROP TABLE IF EXISTS public.products;
DROP TABLE IF EXISTS public.access;
DROP TABLE IF EXISTS public.payment_plan;
DROP TABLE IF EXISTS public.flipper_sale_compaign;
DROP TABLE IF EXISTS public.variants;
DROP TABLE IF EXISTS public.todos;
DROP TABLE IF EXISTS public.lists CASCADE;


-- Create the tables


-- Product Table
CREATE TABLE public.products (
  id uuid not null default gen_random_uuid (),
  product_id bigint,
  name text,
  description text,
  color text,
  business_id bigint,
  branch_id bigint,
  supplier_id text,
  category_id bigint,
  tax_id text,
  unit text,
  image_url text,
  expiry_date text,
  bar_code text,
  nfc_enabled boolean,
  binded_to_tenant_id bigint,
  is_favorite boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  spplr_nm text,
  is_composite boolean,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null,

  constraint products_pkey primary key (id),
  constraint products_owner_id_fkey foreign key (owner_id) references auth.users (id) on delete cascade
);

-- Variant
CREATE TABLE public.variants (
  id uuid not null default gen_random_uuid(),
  variant_id bigint,
  deleted_at timestamp with time zone,
  name text,
  color text,
  sku text,
  product_id bigint,
  unit text,
  product_name text,
  branch_id bigint,
  tax_name text DEFAULT '',
  tax_percentage double precision DEFAULT 0.0,
  is_tax_exempted boolean DEFAULT false,
  item_seq bigint,
  isrcc_cd text DEFAULT '',
  isrcc_nm text DEFAULT '',
  isrc_rt integer DEFAULT 0,
  isrc_amt integer DEFAULT 0,
  tax_ty_cd text DEFAULT 'B',
  bcd text DEFAULT '',
  item_cls_cd text,
  item_ty_cd text,
  item_std_nm text DEFAULT '',
  orgn_nat_cd text DEFAULT '',
  pkg text DEFAULT '1',
  item_cd text DEFAULT '',
  pkg_unit_cd text DEFAULT 'CT',
  qty_unit_cd text DEFAULT 'BX',
  item_nm text,
  qty double precision DEFAULT 0.0,
  prc double precision DEFAULT 0.0,
  sply_amt double precision DEFAULT 0.0,
  tin bigint,
  bhf_id text,
  dft_prc double precision DEFAULT 0.0,
  add_info text DEFAULT '',
  isrc_aplcb_yn text DEFAULT '',
  
  use_yn text DEFAULT '',
  regr_id text,
  regr_nm text,
  modr_id text,
  modr_nm text,
  rsd_qty double precision DEFAULT 0.0,
  last_touched timestamp with time zone,
  supply_price double precision DEFAULT 0.0,
  retail_price double precision DEFAULT 0.0,
  action text,
  spplr_item_cls_cd text,
  spplr_item_cd text,
  spplr_item_nm text,
  ebm_synced boolean DEFAULT false,
  tax_type text DEFAULT 'B',
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null,
  constraint variants_pkey primary key (id),
  constraint products_owner_id_fkey foreign key (owner_id) references auth.users (id) on delete cascade,
   CONSTRAINT variants_variant_id_unique UNIQUE (variant_id)  
);

-- Stock Table
CREATE TABLE public.stocks (
  id uuid not null default gen_random_uuid (),
  stock_id bigint,
  tin bigint,
  bhf_id text,
  branch_id bigint,
  variant_id bigint,
  current_stock numeric(10,2) DEFAULT 0.0,
  sold numeric(10,2) DEFAULT 0.0,
  low_stock numeric(10,2) DEFAULT 0.0,
  can_tracking_stock boolean DEFAULT TRUE,
  show_low_stock_alert boolean DEFAULT TRUE,
  product_id bigint,
  active boolean,
  value numeric(10,2) DEFAULT 0.0,
  rsd_qty numeric(10,2) DEFAULT 0.0,
  supply_price numeric(10,2) DEFAULT 0.0,
  retail_price numeric(10,2) DEFAULT 0.0,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  ebm_synced boolean DEFAULT FALSE,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null,

  constraint stocks_pkey primary key (id),
  constraint stocks_owner_id_fkey foreign key (owner_id) references auth.users (id) on delete cascade,
  constraint stocks_variant_id_fkey FOREIGN KEY (variant_id) REFERENCES public.variants (variant_id) ON DELETE CASCADE
);
-- Branch Table
CREATE TABLE public.branch (
  id uuid not null default gen_random_uuid (),
  name text,
  description text,
  businessId bigint,
  serverId bigint,
  longitude text,
  latitude text,
  location text,
  isDefault boolean,
  lastTouched timestamp with time zone,
  action text,
  deletedAt timestamp with time zone,
  isOnline boolean,
  owner_id uuid not null
);

-- -- Business Table
CREATE TABLE public.business (
  id uuid not null default gen_random_uuid (),
  name text,
  currency text,
  category_id text,
  latitude text,
  longitude text,
  user_id bigint,
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
  last_seen bigint,
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
  tin_number bigint,
  bhf_id text,
  dvc_srl_no text,
  adrs text,
  tax_enabled boolean,
  tax_server_url text,
  is_default boolean,
  business_type_id bigint,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  encryption_key text,
  owner_id uuid not null
);

-- -- Category Table
CREATE TABLE public.category (
   id uuid not null default gen_random_uuid (),
  active boolean,
  focused boolean,
  name text,
  branch_id bigint,
  deleted_at timestamp with time zone,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Counter Table
CREATE TABLE public.counter (
   id uuid not null default gen_random_uuid (),
  business_id bigint,
  branch_id bigint,
  receipt_type text,
  tot_rcpt_no bigint,
  cur_rcpt_no bigint,
  invc_no bigint,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Customer Table
CREATE TABLE public.customer (
   id uuid not null default gen_random_uuid (),
  cust_nm text,
  email text,
  tel_no text,
  adrs text,
  branch_id bigint,
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
  tin bigint,
  bhf_id text,
  use_yn text,
  customer_type text,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Device Table
CREATE TABLE public.device (
   id uuid not null default gen_random_uuid (),
  linking_code text,
  device_name text,
  device_version text,
  pub_nub_published boolean,
  phone text,
  branch_id bigint,
  business_id bigint,
  user_id bigint,
  default_app text,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Discount Table
CREATE TABLE public.discount (
   id uuid not null default gen_random_uuid (),
  name text,
  amount numeric(10,2),
  branch_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Drawers Table
CREATE TABLE public.drawers (
   id uuid not null default gen_random_uuid (),
  opening_balance numeric(10,2),
  closing_balance numeric(10,2),
  opening_date_time text,
  closing_date_time text,
  cs_sale_count bigint,
  trade_name text,
  total_ns_sale_income numeric(10,2),
  total_cs_sale_income numeric(10,2),
  nr_sale_count bigint,
  ns_sale_count bigint,
  tr_sale_count bigint,
  ps_sale_count bigint,
  incomplete_sale bigint,
  other_transactions bigint,
  payment_mode text,
  cashier_id bigint,
  "open" boolean,
  deleted_at timestamp with time zone,
  business_id bigint,
  branch_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- EBM Table
CREATE TABLE public.ebm (
   id uuid not null default gen_random_uuid (),
  bhf_id text,
  tin_number bigint,
  dvc_srl_no text,
  user_id bigint,
  tax_server_url text,
  business_id bigint,
  branch_id bigint,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Favorite Table
CREATE TABLE public.favorite (
   id uuid not null default gen_random_uuid (),
  fav_index bigint,
  product_id bigint,
  branch_id bigint,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Location Table
CREATE TABLE public.location (
   id uuid not null default gen_random_uuid (),
  realm_id uuid,
  server_id bigint,
  active boolean,
  description text,
  name text,
  business_id bigint,
  longitude text,
  latitude text,
  location text,
  is_default boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  is_online boolean,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- PColor Table
CREATE TABLE public.pcolor (
   id uuid not null default gen_random_uuid (),
  name text,
  colors text[],
  branch_id bigint,
  active boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Receipt Table
CREATE TABLE public.receipt (
  id uuid not null default gen_random_uuid (),
  result_cd text,
  result_msg text,
  result_dt text,
  rcpt_no bigint,
  intrl_data text,
  rcpt_sign text,
  tot_rcpt_no bigint,
  vsdc_rcpt_pbct_date text,
  sdc_id text,
  mrc_no text,
  qr_code text,
  receipt_type text,
  branch_id bigint,
  transaction_id bigint,
  last_touched timestamp with time zone,
  action text,
  invc_no bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Setting Table
CREATE TABLE public.setting (
   id uuid not null default gen_random_uuid (),
  email text,
  user_id bigint,
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
  business_id bigint,
  created_at timestamp with time zone,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  action text,
  owner_id uuid not null
);


-- StockRequest Table
CREATE TABLE public.stock_request (
   id uuid not null default gen_random_uuid (),
  main_branch_id bigint,
  sub_branch_id bigint,
  created_at timestamp with time zone,
  status text,
  delivery_date timestamp with time zone,
  delivery_note text,
  order_note text,
  customer_received_order boolean,
  driver_request_delivery_confirmation boolean,
  driver_id bigint,
  updated_at timestamp with time zone,
  owner_id uuid not null
);

-- TransactionItem Table
CREATE TABLE public.transaction_item (
   id uuid not null default gen_random_uuid (),
  name text,
  quantity_requested bigint,
  quantity_approved bigint,
  quantity_shipped bigint,
  transaction_id bigint,
  variant_id bigint,
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
  item_seq bigint,
  isrcc_cd text,
  isrcc_nm text,
  isrc_rt bigint,
  isrc_amt bigint,
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
  tin bigint,
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
  branch_id bigint,
  ebm_synced boolean,
  part_of_composite boolean,
  composite_price numeric(10,2),
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- ITransaction Table
CREATE TABLE public.itransaction (
   id uuid not null default gen_random_uuid (),
  reference text,
  category_id text,
  transaction_number text,
  branch_id bigint,
  status text,
  transaction_type text,
  sub_total numeric(10,2),
  payment_type text,
  cash_received numeric(10,2),
  customer_change_due numeric(10,2),
  receipt_type text,
  updated_at timestamp with time zone,
  customer_id bigint,
  customer_type text,
  note text,
  last_touched timestamp with time zone,
  action text,
  ticket_name text,
  deleted_at timestamp with time zone,
  supplier_id bigint,
  ebm_synced boolean,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- IUnit Table
CREATE TABLE public.iunit (
   id uuid not null default gen_random_uuid (),
  branch_id bigint,
  name text,
  value text,
  active boolean,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone,
  deleted_at timestamp with time zone,
  owner_id uuid not null
);

-- Voucher Table
CREATE TABLE public.voucher (
   id uuid not null default gen_random_uuid (),
  value bigint,
  interval bigint,
  used boolean,
  used_at bigint,
  descriptor text,
  created_at timestamp with time zone DEFAULT now()
);

-- Tenant Table
CREATE TABLE public.tenant (
   id uuid not null default gen_random_uuid (),
  name text,
  phone_number text,
  email text,
  nfc_enabled boolean,
  business_id bigint,
  user_id bigint,
  image_url text,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  pin bigint,
  session_active boolean,
  is_default boolean,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Pin Table
CREATE TABLE public.pin (
   id uuid not null default gen_random_uuid (),
  user_id text,
  phone_number text,
  pin bigint,
  branch_id bigint,
  business_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- LPermission Table
CREATE TABLE public.lpermission (
   id uuid not null default gen_random_uuid (),
  name text,
  user_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Token Table
CREATE TABLE public.token (
   id uuid not null default gen_random_uuid (),
  type text,
  token text,
  valid_from timestamp with time zone,
  valid_until timestamp with time zone,
  business_id bigint,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Conversation Table
CREATE TABLE public.conversation (
   id uuid not null default gen_random_uuid (),
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
  business_id bigint,
  scheduled_at timestamp with time zone,
  delivered boolean,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Activity Table
CREATE TABLE public.activity (
   id uuid not null default gen_random_uuid (),
  timestamp timestamp with time zone,
  last_touched timestamp with time zone,
  user_id bigint,
  event text,
  details jsonb,
  action text,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- UnversalProduct Table
CREATE TABLE public.unversal_product (
   id uuid not null default gen_random_uuid (),
  item_cls_cd text,
  item_cls_nm text,
  item_cls_lvl bigint,
  tax_ty_cd text,
  mjr_tg_yn text,
  use_yn text,
  business_id bigint,
  branch_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Configurations Table
CREATE TABLE public.configurations (
   id uuid not null default gen_random_uuid (),
  tax_type text,
  tax_percentage numeric(10,2),
  business_id bigint,
  branch_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- AppNotification Table
CREATE TABLE public.app_notification (
   id uuid not null default gen_random_uuid (),
  completed boolean,
  type text,
  message text,
  identifier bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Assets Table
CREATE TABLE public.assets (
   id uuid not null default gen_random_uuid (),
  branch_id bigint,
  business_id bigint,
  asset_name text,
  product_id bigint,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Composite Table
CREATE TABLE public.composite (
   id uuid not null default gen_random_uuid (),
  product_id bigint,
  variant_id bigint,
  qty numeric(10,2),
  branch_id bigint,
  business_id bigint,
  actual_price numeric(10,2),
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- SKU Table
CREATE TABLE public.sku (
   id uuid not null default gen_random_uuid (),
  sku bigint,
  branch_id bigint,
  business_id bigint,
  consumed boolean,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Report Table
CREATE TABLE public.report (
   id uuid not null default gen_random_uuid (),
  branch_id bigint,
  business_id bigint,
  filename text,
  s3_url text,
  downloaded boolean,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- Computed Table
CREATE TABLE public.computed (
   id uuid not null default gen_random_uuid (),
  branch_id bigint,
  business_id bigint,
  gross_profit numeric(10,2),
  net_profit numeric(10,2),
  total_stock_value numeric(10,2),
  total_stock_sold_value numeric(10,2),
  total_stock_items numeric(10,2),
  created_at timestamp with time zone,
  owner_id uuid not null
);

-- Access Table
CREATE TABLE public.access (
   id uuid not null default gen_random_uuid (),
  branch_id bigint,
  business_id bigint,
  user_id bigint,
  feature_name text,
  user_type text,
  access_level text,
  created_at timestamp with time zone,
  expires_at timestamp with time zone,
  status text,
  owner_id uuid not null
);

-- PaymentPlan Table
CREATE TABLE public.payment_plan (
   id uuid not null default gen_random_uuid (),
  business_id bigint,
  selected_plan text,
  additional_devices bigint,
  is_yearly_plan boolean,
  total_price numeric(10,2),
  payment_completed_by_user boolean,
  paystack_customer_id bigint,
  rule text,
  payment_method text,
  customer_code text,
  paystack_plan_id text,
  created_at timestamp with time zone DEFAULT now(),
  owner_id uuid not null
);

-- FlipperSaleCompaign Table
CREATE TABLE public.flipper_sale_compaign (
   id uuid not null default gen_random_uuid (),
  compaign_id bigint,
  discount_rate bigint,
  created_at timestamp with time zone,
  coupon_code text,
  owner_id uuid not null
);

-- from demo
create table
  public.lists (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    name text not null,
    owner_id uuid not null,
    constraint lists_pkey primary key (id),
    constraint lists_owner_id_fkey foreign key (owner_id) references auth.users (id) on delete cascade
  ) tablespace pg_default;

create table
  public.todos (
    id uuid not null default gen_random_uuid (),
    created_at timestamp with time zone not null default now(),
    completed_at timestamp with time zone null,
    description text not null,
    completed boolean not null default false,
    created_by uuid null,
    completed_by uuid null,
    list_id uuid not null,
    photo_id uuid null,
    constraint todos_pkey primary key (id),
    constraint todos_created_by_fkey foreign key (created_by) references auth.users (id) on delete set null,
    constraint todos_completed_by_fkey foreign key (completed_by) references auth.users (id) on delete set null,
    constraint todos_list_id_fkey foreign key (list_id) references lists (id) on delete cascade
  ) tablespace pg_default;

-- end table from demo
-- Create publication for powersync
DROP PUBLICATION IF EXISTS powersync;
CREATE PUBLICATION powersync FOR TABLE products, lists, todos,stocks,variants;
-- end of publication

-- Enable RLS on all tables
alter table public.lists
  enable row level security;

alter table public.todos
  enable row level security;

create policy "owned lists" on public.lists for ALL using (
  auth.uid() = owner_id
);

create policy "todos in owned lists" on public.todos for ALL using (
  auth.uid() IN (
    SELECT lists.owner_id FROM lists WHERE (lists.id = todos.list_id)
  )
);
ALTER TABLE public.branch ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.business ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.category ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.counter ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customer ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.device ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.discount ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drawers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ebm ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorite ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.location ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pcolor ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.receipt ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.setting ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_request ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transaction_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.itransaction ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.iunit ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.voucher ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tenant ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pin ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lpermission ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.token ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.unversal_product ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.configurations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_notification ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.composite ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sku ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.computed ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.access ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_plan ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.flipper_sale_compaign ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.variants ENABLE ROW LEVEL SECURITY;

-- Create policies for each table
CREATE POLICY "Users can only access their own data" ON public.variants
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.branch
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.business
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.category
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.counter
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.customer
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.device
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.discount
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.drawers
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.ebm
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.favorite
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.location
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.pcolor
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.products
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.receipt
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.setting
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.stocks
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.stock_request
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.transaction_item
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.itransaction
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.iunit
  FOR ALL USING (auth.uid() = owner_id);

-- CREATE POLICY "Users can only access their own data" ON public.voucher
--   FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.tenant
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.pin
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.lpermission
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.token
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.conversation
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.activity
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.unversal_product
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.configurations
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.app_notification
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.assets
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.composite
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.sku
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.report
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.computed
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.access
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.payment_plan
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.flipper_sale_compaign
  FOR ALL USING (auth.uid() = owner_id);


