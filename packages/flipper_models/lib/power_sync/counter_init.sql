INSERT INTO "public"."counters" ("id", "business_id", "branch_id", "receipt_type", "tot_rcpt_no", "cur_rcpt_no", "invc_no", "last_touched", "action", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da51', '1', '1', 'NS', '1369', '1317', '1369', null, null, '2024-12-31 09:10:43.611415+00');
INSERT INTO "public"."counters" ("id", "business_id", "branch_id", "receipt_type", "tot_rcpt_no", "cur_rcpt_no", "invc_no", "last_touched", "action", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da52', '1', '1', 'TS', '1369', '1317', '1369', null, null, '2024-12-31 09:10:43.611415+00');
INSERT INTO "public"."counters" ("id", "business_id", "branch_id", "receipt_type", "tot_rcpt_no", "cur_rcpt_no", "invc_no", "last_touched", "action", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da53', '1', '1', 'NR', '1369', '1317', '1369', null, null, '2024-12-31 09:10:43.611415+00');
INSERT INTO "public"."counters" ("id", "business_id", "branch_id", "receipt_type", "tot_rcpt_no", "cur_rcpt_no", "invc_no", "last_touched", "action", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da54', '1', '1', 'CS', '1369', '1317', '1369', null, null, '2024-12-31 09:10:43.611415+00');
INSERT INTO "public"."counters" ("id", "business_id", "branch_id", "receipt_type", "tot_rcpt_no", "cur_rcpt_no", "invc_no", "last_touched", "action", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da55', '1', '1', 'PS', '1369', '1317', '1369', null, null, '2024-12-31 09:10:43.611415+00');
INSERT INTO "public"."counters" ("id", "business_id", "branch_id", "receipt_type", "tot_rcpt_no", "cur_rcpt_no", "invc_no", "last_touched", "action", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da56', '1', '1', 'CR', '1369', '1317', '1369', null, null, '2024-12-31 09:10:43.611415+00');
INSERT INTO "public"."counters" ("id", "business_id", "branch_id", "receipt_type", "tot_rcpt_no", "cur_rcpt_no", "invc_no", "last_touched", "action", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da57', '1', '1', 'TR', '1369', '1317', '1369', null, null, '2024-12-31 09:10:43.611415+00');


-- Tax config
INSERT INTO "public"."configurations" ("id", "tax_type", "tax_percentage", "business_id", "branch_id", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da51', 'B', '18.00', '1', '1', '2024-12-31 09:25:34.104248+00');
INSERT INTO "public"."configurations" ("id", "tax_type", "tax_percentage", "business_id", "branch_id", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da52', 'A', '0.00', '1', '1', '2024-12-31 09:25:34.104248+00');
INSERT INTO "public"."configurations" ("id", "tax_type", "tax_percentage", "business_id", "branch_id", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da53', 'C', '0.00', '1', '1', '2024-12-31 09:25:34.104248+00');
INSERT INTO "public"."configurations" ("id", "tax_type", "tax_percentage", "business_id", "branch_id", "created_at") VALUES ('44365f0d-cf05-44e4-9a29-cdf34831da54', 'D', '0.00', '1', '1', '2024-12-31 09:25:34.104248+00');




-- Create the trigger on the transactions table
-- Alter table to allow NULL values


-- Drop existing tables (if they exist)
DROP TABLE IF EXISTS public.branchs;
DROP TABLE IF EXISTS public.data_mapper
DROP TABLE IF EXISTS public.business;
DROP TABLE IF EXISTS public.category;
DROP TABLE IF EXISTS public.counters;
DROP TABLE IF EXISTS public.customer;
DROP TABLE IF EXISTS public.device;
DROP TABLE IF EXISTS public.discount;
DROP TABLE IF EXISTS public.drawers;

DROP TABLE IF EXISTS public.favorite;
DROP TABLE IF EXISTS public.location;
DROP TABLE IF EXISTS public.pcolor;
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
DROP TABLE IF EXISTS public.products;
DROP TABLE IF EXISTS public.access;
DROP TABLE IF EXISTS public.payment_plan;
DROP TABLE IF EXISTS public.flipper_sale_compaign;

DROP TABLE IF EXISTS public.todos;
DROP TABLE IF EXISTS public.lists CASCADE;
DROP TABLE IF EXISTS public.counters;
DROP TABLE IF EXISTS public.plans;
DROP TABLE IF EXISTS public.addons;
DROP TABLE IF EXISTS public.ebm;
DROP TABLE IF EXISTS public.composites;

DROP TABLE IF EXISTS public.transaction_items;
DROP TABLE IF EXISTS public.stocks CASCADE;

create table purchases (
  id UUID PRIMARY KEY,
  spplr_tin text not null,
  spplr_nm text not null,
  spplr_bhf_id text not null,
  spplr_invc_no int not null,
  rcpt_ty_cd text not null,
  pmt_ty_cd text not null,
  cfm_dt text not null,
  sales_dt text not null,
  stock_rls_dt text,
  tot_item_cnt int not null,
  taxbl_amt_a double precision not null,
  taxbl_amt_b double precision not null,
  taxbl_amt_c double precision not null,
  taxbl_amt_d double precision not null,
  tax_rt_a double precision not null,
  tax_rt_b double precision not null,
  tax_rt_c double precision not null,
  tax_rt_d double precision not null,
  tax_amt_a double precision not null,
  tax_amt_b double precision not null,
  tax_amt_c double precision not null,
  tax_amt_d double precision not null,
  tot_taxbl_amt double precision not null,
  tot_tax_amt double precision not null,
  tot_amt double precision not null,
  remark text
);

create table import_purchase_dates (
  id UUID PRIMARY KEY,
  branch_id UUID not null,
  request_date timestamp with time zone not null,
  request_type text,
  CONSTRAINT fk_branch
        FOREIGN KEY (branch_id)
         REFERENCES public.branches(id)
        ON DELETE CASCADE
);


SELECT 
    conname AS constraint_name, 
    conrelid::regclass AS table_name, 
    a.attname AS column_name,
    confrelid::regclass AS foreign_table_name, 
    af.attname AS foreign_column_name
FROM pg_constraint
JOIN pg_attribute a ON a.attnum = ANY(conkey) AND a.attrelid = conrelid
JOIN pg_attribute af ON af.attnum = ANY(confkey) AND af.attrelid = confrelid
WHERE conrelid = 'public.variants'::regclass;



-- Then add the foreign key constraint with a new name to avoid conflicts


-- these precision are required to avoid issues
-- Alter the column with increased precision
ALTER TABLE transactions
ALTER COLUMN sub_total TYPE NUMERIC(20,4);

ALTER TABLE transactions
ALTER COLUMN cash_received TYPE NUMERIC(20,4);

ALTER TABLE transactions
ALTER COLUMN customer_change_due TYPE NUMERIC(20,4);

ALTER TABLE transactions
ALTER COLUMN customer_change_due TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN tax_percentage TYPE NUMERIC(20,4);


ALTER TABLE variants
ALTER COLUMN prc TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN dft_prc TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN dc_rt TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN sply_amt TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN supply_price TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN retail_price TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN dc_rt TYPE NUMERIC(20,4);


ALTER TABLE transaction_items
ALTER COLUMN remaining_stock TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN price TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN qty TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN discount TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN dc_rt TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN dc_amt TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN taxbl_amt TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN tax_amt TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN tot_amt TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN prc TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN sply_amt TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN dft_prc TYPE NUMERIC(20,4);

ALTER TABLE transaction_items
ALTER COLUMN composite_price TYPE NUMERIC(20,4);

ALTER TABLE composites
ALTER COLUMN qty TYPE NUMERIC(20,4);

ALTER TABLE composites
ALTER COLUMN actual_price TYPE NUMERIC(20,4);


ALTER TABLE stocks
ALTER COLUMN current_stock TYPE NUMERIC(20,4);

ALTER TABLE stocks
ALTER COLUMN value TYPE NUMERIC(20,4);

ALTER TABLE stocks
ALTER COLUMN rsd_qty TYPE NUMERIC(20,4);

ALTER TABLE stocks
ALTER COLUMN initial_stock TYPE NUMERIC(20,4);



-- Alter stock table if needed
ALTER TABLE stocks
ALTER COLUMN current_stock TYPE NUMERIC(20,4);

ALTER TABLE stocks
ALTER COLUMN value TYPE NUMERIC(20,4);

ALTER TABLE stocks
ALTER COLUMN rsd_qty TYPE NUMERIC(20,4);
-- end of alter stock

-- alter transactions
ALTER TABLE transactions
ALTER COLUMN sub_total TYPE NUMERIC(20,4);

ALTER TABLE transactions
ALTER COLUMN cash_received TYPE NUMERIC(20,4);

ALTER TABLE transactions
ALTER COLUMN customer_change_due TYPE NUMERIC(20,4);

-- alter variants
ALTER TABLE variants
ALTER COLUMN tax_percentage TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN prc TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN sply_amt TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN dft_prc TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN supply_price TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN retail_price TYPE NUMERIC(20,4);

ALTER TABLE variants
ALTER COLUMN dc_rt TYPE NUMERIC(20,4);

ALTER TABLE plans
ADD COLUMN number_of_payments BIGINT;


DROP TABLE IF EXISTS public.favorites CASCADE;
CREATE TABLE public.favorites (
   id UUID PRIMARY KEY,
  fav_index UUID,
  product_id UUID,
   branch_id BIGINT NOT NULL,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);
DROP TABLE IF EXISTS public.customers CASCADE;
CREATE TABLE public.customers (
   id UUID PRIMARY KEY,
  cust_nm text,
  email text,
  tel_no text,
  adrs text,
  branch_id BIGINT NOT NULL,
  updated_at timestamp with time zone,
  cust_no text,
  cust_tin text,
  regr_id text,
  modr_nm text,
  regr_nm text,
  modr_id text,
  ebm_synced boolean,
 
  action text,
  tin bigint,
  bhf_id text,
  use_yn text,
  customer_type text,
  created_at timestamp with time zone DEFAULT now()
);

-- Stock Table
DROP TABLE IF EXISTS public.stocks CASCADE;
CREATE TABLE public.stocks (
  id UUID PRIMARY KEY,
  tin bigint,
  bhf_id text,
  branch_id BIGINT NOT NULL,
  
  current_stock numeric(15,2) ,
  sold numeric(15,2) ,
  low_stock numeric(15,2) ,
  can_tracking_stock boolean DEFAULT TRUE,
  show_low_stock_alert boolean DEFAULT TRUE,
  active boolean,
  value numeric(15,2) ,
  rsd_qty numeric(15,2) ,
  supply_price numeric(15,2) ,
  retail_price numeric(15,2) ,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  ebm_synced boolean DEFAULT FALSE,
  created_at timestamp with time zone DEFAULT now(),
  initial_stock numeric(15,2) 
  
);


CREATE TABLE public.variants (
     id UUID PRIMARY KEY,
      isrc_amt integer DEFAULT 0,
    deleted_at timestamp with time zone,
    name text,
    color text,
    sku text,
    product_id UUID NOT NULL,
    unit text,
    product_name text,
    branch_id BIGINT NOT NULL,
    tax_name text DEFAULT '',
    tax_percentage numeric(15,2) DEFAULT 18.0,  -- Changed from bigint to integer to match Dart int
    item_seq integer,  -- Changed from bigint to integer to match Dart int
    isrcc_cd text DEFAULT '',
    isrcc_nm text DEFAULT '',
    isrc_rt integer DEFAULT 0,
   
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
    prc numeric(15,2) ,
    sply_amt numeric(15,2) ,
    tin bigint,  -- Keeping as bigint since Dart int can handle it
    bhf_id text,
    dft_prc numeric(15,2) ,
    add_info text DEFAULT '',
    isrc_aplcb_yn text DEFAULT '',
    use_yn text DEFAULT '',
    regr_id text,
    regr_nm text,
    modr_id text,
    modr_nm text,
    last_touched timestamp with time zone,
    supply_price numeric(15,2) ,
    retail_price numeric(15,2) ,
    spplr_item_cls_cd text,
    spplr_item_cd text,
    spplr_item_nm text,
    ebm_synced boolean DEFAULT false,
    dc_rt numeric(15,2),  -- Changed from numeric(10,2) to double precision to match Dart double
    expiration_date timestamp with time zone DEFAULT now(),
    stock_id UUID,
    CONSTRAINT fk_stock
        FOREIGN KEY (stock_id)
         REFERENCES public.stocks(id)
        ON DELETE CASCADE
   
);


-- Unit Table
CREATE TABLE public.units (
id UUID PRIMARY KEY,
 branch_id BIGINT NOT NULL,
name text,
value text,
active boolean default false,
last_touched timestamp with time zone,
created_at text
);


-- category Table
DROP TABLE IF EXISTS public.categories;
CREATE TABLE public.categories (
   id UUID PRIMARY KEY,
  active boolean,
  focused boolean,
  name text,
   branch_id BIGINT NOT NULL,
  deleted_at timestamp with time zone,
  last_touched timestamp with time zone
);

-- SKU Table
DROP TABLE IF EXISTS public.uni_products;
CREATE TABLE public.uni_products (
   id UUID PRIMARY KEY,
  item_cls_cd text,
  item_cls_nm text,
  item_cls_lvl bigint,
  tax_ty_cd text,
  mjr_tg_yn text,
  use_yn text,
   business_id BIGINT NOT NULL,
  branch_id bigint
);

-- SKU Table
DROP TABLE IF EXISTS public.skus;
CREATE TABLE public.skus (
   id UUID PRIMARY KEY,
  
  sku bigint,
   branch_id BIGINT NOT NULL,
   business_id BIGINT NOT NULL,
  consumed boolean default false
);

--  {"id":830013631346076,"item_code":"RW2BJCT0000001","created_at":"2024-12-24T13:07:18.184525"}, 
-- item_codes
DROP TABLE IF EXISTS public.codes;
CREATE TABLE public.codes (
   id UUID PRIMARY KEY,
  
  code text,
  created_at timestamp with time zone);

-- accesses
DROP TABLE IF EXISTS public.accesses;
CREATE TABLE public.accesses (
   id UUID PRIMARY KEY,
  user_id bigint,
   branch_id BIGINT NOT NULL,
   business_id BIGINT NOT NULL,
  feature_name text,
  user_type text,
  access_level text,
  created_at timestamp with time zone,
  expires_at timestamp with time zone,
  status text);


-- permission
-- tenants
DROP TABLE IF EXISTS public.permissions;
CREATE TABLE public.permissions (
   id UUID PRIMARY KEY,
   
  name text,
  user_id bigint
);


-- tenants
DROP TABLE IF EXISTS public.tenants;
CREATE TABLE public.tenants (
   id UUID PRIMARY KEY,
  name text,
    phone_number text,
    email text,
    nfc_enabled boolean DEFAULT false,
     business_id BIGINT NOT NULL,
    user_id bigint,
    image_url text,
    last_touched timestamp with time zone,
    deleted_at timestamp with time zone,
    pin integer,
    session_active boolean DEFAULT false,
    is_default boolean DEFAULT false,
    is_long_pressed boolean DEFAULT false,
    type text DEFAULT 'Agent'
);


-- Pin Table
DROP TABLE IF EXISTS public.pins;
CREATE TABLE public.pins (
   id UUID PRIMARY KEY,
  user_id bigint,
  phone_number text,
  pin bigint,
   branch_id BIGINT NOT NULL,
   business_id BIGINT NOT NULL,
  owner_name text,
  token_uid text,
  uid text
);


-- -- Business Table
DROP TABLE IF EXISTS public.businesses;
CREATE TABLE public.businesses (
   id UUID PRIMARY KEY,
  server_id bigint,
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
  created_at text,
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
  deleted_at timestamp with time zone,
  encryption_key text
);
-- Branch Table
DROP TABLE IF EXISTS public.branches;
CREATE TABLE public.branches (
   id UUID PRIMARY KEY,
  name text,
  description text,
  business_id BIGINT NOT NULL,
  server_id bigint,
  longitude text,
  latitude text,
  location text,
  is_default boolean,
  
  is_online boolean DEFAULT false,
  active boolean DEFAULT false
);
-- TransactionItem Table
DROP TABLE IF EXISTS public.transaction_items;
CREATE TABLE public.transaction_items (
  id UUID PRIMARY KEY,
  name text NOT NULL, -- Added NOT NULL constraint (adjust as needed)
  quantity_requested bigint,
  quantity_approved bigint,
  quantity_shipped bigint,
  --  adding DEFERRABLE make foregin key to allos entries when it does not exist
  -- for our case this is okay since we are migrating from old system.
  transaction_id UUID NOT NULL,
  variant_id UUID NOT NULL,
  qty numeric(15,2), -- Increased precision to allow for larger values
  price numeric(15,2), -- Increased precision to allow for larger values
  discount numeric(15,2), -- Increased precision to allow for larger values
  type text,
  remaining_stock numeric(15,2), -- Increased precision
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
  use_yn text,
  prc numeric(15,2) NOT NULL, -- Added NOT NULL constraint (adjust as needed)
  sply_amt numeric(15,2) NOT NULL, -- Added NOT NULL constraint (adjust as needed)
  tin bigint,
  bhf_id text,
  dft_prc numeric(15,2), -- Increased precision
  add_info text,
  isrc_aplcb_yn text,
  regr_id text,
  regr_nm text,
  modr_id text,
  modr_nm text,
  last_touched timestamp with time zone,
  -- deleted_at timestamp with time zone,
  action text, -- Added to match the SQL table
  branch_id BIGINT NOT NULL,
  ebm_synced boolean,
  part_of_composite boolean,
  composite_price numeric(15,2) -- Increased precision
  created_at timestamp with time zone DEFAULT now()
);
-- 
DROP TABLE IF EXISTS public.transactions;
CREATE TABLE public.transactions (
    id UUID PRIMARY KEY,
    reference TEXT,
    category_id UUID,
    transaction_number TEXT,
     branch_id BIGINT NOT NULL,
    status TEXT,
    transaction_type TEXT,
    sub_total numeric(15,2) , 
    payment_type TEXT,
    cash_received numeric(15,2) ,
    customer_change_due numeric(15,2) ,
    created_at TIMESTAMP WITH TIME ZONE,  
    receipt_type TEXT,
    updated_at TIMESTAMP WITH TIME ZONE,
    customer_id UUID,
    customer_type TEXT,
    note TEXT,
    last_touched TIMESTAMP WITH TIME ZONE,
    ticket_name TEXT,
    deleted_at TIMESTAMP WITH TIME ZONE,
    supplier_id UUID,
    ebm_synced BOOLEAN DEFAULT FALSE,
    is_income BOOLEAN DEFAULT FALSE,
    is_expense BOOLEAN DEFAULT FALSE,
    is_refunded BOOLEAN,
    customer_name TEXT,
    customer_tin TEXT,
    remark TEXT,
    customer_bhf_id TEXT,
    sar_ty_cd TEXT,
    receipt_number bigint,
    total_receipt_number bigint,
    invoice_number bigint
);



-- later add foreign key reference

-- addons
DROP TABLE IF EXISTS public.products CASCADE;
CREATE TABLE public.products (
   id UUID PRIMARY KEY,
  
  name text,
  description text,
  color text,
  business_id BIGINT NOT NULL,
  branch_id BIGINT NOT NULL,
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
  composites jsonb,
  created_at timestamp with time zone DEFAULT now()
);

DROP TABLE IF EXISTS public.composites CASCADE;

CREATE TABLE public.composites (
   id UUID PRIMARY KEY,
  product_id UUID NOT NULL,
  variant_id UUID NOT NULL,
  qty numeric(10,2),
   branch_id BIGINT NOT NULL,
   business_id BIGINT NOT NULL,
  actual_price numeric(10,2),
  CONSTRAINT fk_product
    FOREIGN KEY (product_id) 
    REFERENCES public.products(id)
    ON DELETE CASCADE
);
-- Create Product



-- Counter Table
-- Drop existing trigger and function if they exist
-- Drop existing trigger and function
-- Drop existing trigger and function
-- Drop the existing trigger and function if they exist
DROP TRIGGER IF EXISTS update_all_invc_no_trigger ON counters;
DROP FUNCTION IF EXISTS update_all_invc_no();

-- Create improved function with recursive check
CREATE OR REPLACE FUNCTION update_all_invc_no()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if we're in a recursive update
    IF tg_op = 'UPDATE' AND pg_trigger_depth() > 1 THEN
        RETURN NEW;
    END IF;

    -- Update other rows with matching branch_id, excluding the current row
    UPDATE counters
    SET 
        invc_no = NEW.invc_no,
        tot_rcpt_no = NEW.tot_rcpt_no,
        cur_rcpt_no = NEW.cur_rcpt_no
    WHERE branch_id = NEW.branch_id
    AND id != NEW.id;  -- Exclude the current row being updated
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER update_all_invc_no_trigger
AFTER UPDATE OF invc_no, tot_rcpt_no, cur_rcpt_no
ON counters
FOR EACH ROW
EXECUTE FUNCTION update_all_invc_no();



DROP TABLE IF EXISTS public.counters CASCADE;

CREATE TABLE public.counters (
   id UUID PRIMARY KEY,
   business_id BIGINT NOT NULL,
   branch_id BIGINT NOT NULL,
  receipt_type text,
  tot_rcpt_no bigint,
  cur_rcpt_no bigint,
  invc_no bigint,
  last_touched timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now()
);
-- plans
-- ALTER TABLE plans ADD COLUMN number_of_payments bigint;

DROP TABLE IF EXISTS public.addons CASCADE;
DROP TABLE IF EXISTS public.plans CASCADE;

CREATE TABLE public.plans (
   id UUID PRIMARY KEY,
   business_id BIGINT NOT NULL,
   selected_plan text,
   
   additional_devices bigint,
   is_yearly_plan boolean,
   total_price bigint,
   payment_completed_by_user boolean,
   next_billing_date timestamp with time zone DEFAULT now(),
   rule text,
   number_of_payments bigint,
   addons jsonb,
   payment_method text,
   created_at timestamp with time zone DEFAULT now()
);

CREATE TABLE public.addons (
   id UUID PRIMARY KEY,
   plan_id UUID,
   addon_name TEXT,
   created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
   CONSTRAINT fk_plan
      FOREIGN KEY (plan_id)
      REFERENCES public.plans(id)
      ON DELETE CASCADE
);




-- ebm table
-- EBM Table

DROP TABLE IF EXISTS public.ebms CASCADE;
CREATE TABLE public.ebms (
   id UUID PRIMARY KEY,
  bhf_id text,
  tin_number bigint,
  dvc_srl_no text,
  user_id bigint,
  tax_server_url text,
   business_id BIGINT NOT NULL,
   branch_id BIGINT NOT NULL,
  last_touched timestamp with time zone DEFAULT now()
);


DROP TABLE IF EXISTS public.devices CASCADE;
-- Device Table
CREATE TABLE public.devices (
   id UUID PRIMARY KEY,
  linking_code text,
  device_name text,
  device_version text,
  pub_nub_published boolean,
  phone text,
   branch_id BIGINT NOT NULL,
   business_id BIGINT NOT NULL,
  user_id bigint,
  default_app text,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  action text,
  created_at timestamp with time zone DEFAULT now()
);

-- Discount Table
DROP TABLE IF EXISTS public.discounts CASCADE;
CREATE TABLE public.discounts (
   id UUID PRIMARY KEY,
  name text,
  amount numeric(10,2),
   branch_id BIGINT NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- Drawers Table
DROP TABLE IF EXISTS public.drawers CASCADE;
CREATE TABLE public.drawers (
   id UUID PRIMARY KEY,
  opening_balance numeric(10,2),
  closing_balance numeric(10,2),
  opening_date_time timestamp with time zone,
  closing_date_time timestamp with time zone,
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
  open boolean,
  deleted_at timestamp with time zone,
   business_id BIGINT NOT NULL,
   branch_id BIGINT NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);





-- Location Table
DROP TABLE IF EXISTS public.locations CASCADE;
CREATE TABLE public.locations(
   id UUID PRIMARY KEY,
  realm_id uuid,
  server_id bigint,
  active boolean,
  description text,
  name text,
   business_id BIGINT NOT NULL,
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
CREATE TABLE public.colors (
   id UUID PRIMARY KEY,
  name text,
  colors text[],
   branch_id BIGINT NOT NULL,
  active boolean,
  last_touched timestamp with time zone,
  action text,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);

-- Receipt Table
DROP TABLE IF EXISTS public.receipts;
CREATE TABLE public.receipts (
  id UUID PRIMARY KEY,
  result_cd text,
  result_msg text,
  result_dt text,
  invoice_number bigint,
  rcpt_no bigint,
  intrl_data text,
  rcpt_sign text,
  tot_rcpt_no bigint,
  vsdc_rcpt_pbct_date text,
  sdc_id text,
  mrc_no text,
  qr_code text,
  receipt_type text,
   branch_id BIGINT NOT NULL,
  transaction_id UUID,
  last_touched timestamp with time zone,
  invc_no bigint,
  when_created timestamp with time zone DEFAULT now()
);

-- Setting Table
DROP TABLE IF EXISTS public.settings CASCADE;
CREATE TABLE public.settings (
   id UUID PRIMARY KEY,
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
   business_id BIGINT NOT NULL,
  created_at timestamp with time zone,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone
);


-- StockRequest Table
DROP TABLE IF EXISTS public.stock_requests CASCADE;
CREATE TABLE public.stock_requests (
   id UUID PRIMARY KEY,
  main_branch_id BIGINT NOT NULL,
  sub_branch_id BIGINT NOT NULL,
  created_at timestamp with time zone,
  status text,
  delivery_date timestamp with time zone,
  delivery_note text,
  order_note text,
  customer_received_order boolean,
  driver_request_delivery_confirmation boolean,
  driver_id bigint,
  updated_at timestamp with time zone
);



-- IUnit Table

-- Tenant Table





-- Token Table
DROP TABLE IF EXISTS public.tokens CASCADE;
CREATE TABLE public.tokens (
   id UUID PRIMARY KEY,
  type text,
  token text,
  valid_from timestamp with time zone,
  valid_until timestamp with time zone,
   business_id BIGINT NOT NULL,
  last_touched timestamp with time zone,
  deleted_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now()
);



-- UnversalProduct Table
-- Configurations Table
DROP TABLE IF EXISTS public.configurations CASCADE;
CREATE TABLE public.configurations (
   id UUID PRIMARY KEY,
  tax_type text,
  tax_percentage numeric(10,2),
   business_id BIGINT NOT NULL,
   branch_id BIGINT NOT NULL,
  created_at timestamp with time zone DEFAULT now()
);

-- AppNotification Table
CREATE TABLE public.app_notifications (
   id UUID PRIMARY KEY,
  completed boolean,
  type text,
  message text,
  identifier bigint,
  created_at timestamp with time zone DEFAULT now()
);

-- Assets Table
DROP TABLE IF EXISTS public.assets CASCADE;
CREATE TABLE public.assets (
   id UUID PRIMARY KEY,
   branch_id BIGINT NOT NULL,
   business_id BIGINT NOT NULL,
  asset_name text,
  product_id UUID,
  created_at timestamp with time zone DEFAULT now()
);

-- Composite Table



-- Report Table
DROP TABLE IF EXISTS public.reports CASCADE;
CREATE TABLE public.reports (
   id UUID PRIMARY KEY,
   branch_id BIGINT NOT NULL,
   business_id BIGINT NOT NULL,
  filename text,
  s3_url text,
  downloaded boolean,
  created_at timestamp with time zone DEFAULT now()
);


-- FlipperSaleCompaign Table
DROP TABLE IF EXISTS public.flipper_sale_compaigns CASCADE;
CREATE TABLE public.flipper_sale_compaigns (
   id UUID PRIMARY KEY,
  compaign_id bigint,
  discount_rate bigint,
  created_at timestamp with time zone,
  coupon_code text
);


-- transaction_payment_records
DROP TABLE IF EXISTS public.transaction_payment_records;
CREATE TABLE public.transaction_payment_records (
id UUID PRIMARY KEY,
transaction_id UUID,
amount NUMERIC(10,2),
payment_method text,
created_at timestamp with time zone

);
-- end table from demo
-- Create publication for powersync
DROP PUBLICATION IF EXISTS powersync;
CREATE PUBLICATION powersync FOR TABLE products, lists, todos,stocks,variants,data_mapper,branchs;
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
ALTER TABLE public.branchs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.data_mapper ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.business ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.category ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.counters ENABLE ROW LEVEL SECURITY;
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

CREATE POLICY "Users can only access data from their device" 
ON public.data_mapper
FOR ALL
USING ("233333"  = secret_key);

CREATE POLICY "Users can only access their own data" ON public.branchs
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.business
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.category
  FOR ALL USING (auth.uid() = owner_id);

CREATE POLICY "Users can only access their own data" ON public.counters
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






