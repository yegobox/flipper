-- =============================================================================
-- 0008 — the subscription gate: nobody uses HR until the business has paid
-- =============================================================================
-- Apply after 0007, against the same Supabase project flipper_web uses.
--
-- Until now a business could sign up and open the roster for nothing. This adds
-- the one question HR asks before it opens — "has this business paid?" — and the
-- two calls that let it pay:
--
--   hr_access_state(business)      → entitled / needs_payment / needs_setup
--   hr_plan_quote(business, plan)  → what it costs, priced HERE, not by the app
--   hr_start_subscription(...)     → writes the `plans` row at that price and
--                                    hands back the plan id to charge
--
-- WHAT THIS DOES NOT DO, deliberately: it does not take money and it does not
-- mark anything paid. Mobile Money settlement belongs to data-connector
-- (`src/billing/charge.rs`), which owns `plans.payment_completed_by_user`,
-- `next_billing_date` and the `subscription_charges` ledger. A second settler
-- writing the same columns from a client session is how a plan gets marked paid
-- without money moving — see PAYMENT_COMPLETED_WITHOUT_MONEY_ANALYSIS.md. The
-- app charges through `POST /v2/api/payNow` exactly as Books does; this file
-- only prices the plan and reads the verdict back.
--
-- WHY PRICING LIVES HERE. data-connector treats `plans.total_price` as an
-- authoritative override (`BillingEngine::resolve_price`, `override_price`). If
-- the client wrote that column, a modified build would buy the 350,000 RWF plan
-- for 1 RWF. So `plans` is written by hr_start_subscription(), a security
-- definer function that recomputes the price from
-- `subscription_plan_templates` and ignores whatever the caller thinks it costs.
--
-- Scope of authority is unchanged from the rest of HR: every function here is
-- scoped by hr_user_business_ids() (migration 0006), so only someone who owns
-- the business or holds a live HR/admin grant can quote, subscribe, or read the
-- billing state.
--
-- Safe to re-run: create-or-replace / add column if not exists / on conflict.
--
-- Rollback:
--   drop function if exists public.hr_access_state(text);
--   drop function if exists public.hr_start_subscription(text, text, boolean, text);
--   drop function if exists public.hr_plan_quote(text, text, boolean);
--   drop trigger  if exists hr_employees_seat_cap on public.hr_employees;
--   drop function if exists public.hr_enforce_employee_cap();
--   (the seeded template and hr_billing_settings can stay; they are inert)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1. What a tier entitles you to
-- -----------------------------------------------------------------------------
-- `subscription_plan_templates` (root migration 20260701160000) priced tiers but
-- said nothing about what they include, so "5 POS users, 1 branch, 50 employees"
-- lived only in marketing copy. These columns make the package a fact the server
-- can quote and the app can display without hardcoding it.
--
-- NULL means unlimited, which is what every pre-existing tier keeps.
alter table public.subscription_plan_templates
  add column if not exists max_pos_users     integer,
  add column if not exists max_branches      integer,
  add column if not exists max_hr_employees  integer,
  add column if not exists features          text[] not null default '{}';

do $$
begin
  if not exists (
    select 1 from pg_constraint
     where conname = 'subscription_plan_templates_limits_positive'
  ) then
    alter table public.subscription_plan_templates
      add constraint subscription_plan_templates_limits_positive
      check (
        (max_pos_users    is null or max_pos_users    > 0) and
        (max_branches     is null or max_branches     > 0) and
        (max_hr_employees is null or max_hr_employees > 0)
      );
  end if;
end $$;

comment on column public.subscription_plan_templates.max_hr_employees is
  'Employee records this tier covers per business. NULL = unlimited. Enforced by the hr_employees_seat_cap trigger.';


-- -----------------------------------------------------------------------------
-- 2. The Basic package — 350,000 RWF / month
-- -----------------------------------------------------------------------------
-- Priced like every other tier: `monthly_price` is the monthly figure and a
-- yearly purchase is twelve of them less `yearly_discount_percent`
-- (350,000 → 3,360,000 RWF/year at 20%). Sorted before Mobile so it is the first
-- thing a new business is offered.
insert into public.subscription_plan_templates (
  id, slug, name, description,
  monthly_price, yearly_discount_percent, tier, icon, sort_order,
  max_pos_users, max_branches, max_hr_employees, features
) values (
  'a0000004-0000-4000-8000-000000000004',
  'basic',
  'Basic',
  'Flipper POS, Books and HR for one branch',
  350000,
  20.00,
  'standard',
  'business',
  0,
  5,
  1,
  50,
  array[
    'All Flipper apps — POS, Books and HR',
    'Up to 5 POS users',
    '1 branch',
    'Up to 50 HR employees'
  ]
)
on conflict (slug) do update set
  name                    = excluded.name,
  description             = excluded.description,
  monthly_price           = excluded.monthly_price,
  yearly_discount_percent = excluded.yearly_discount_percent,
  tier                    = excluded.tier,
  icon                    = excluded.icon,
  sort_order              = excluded.sort_order,
  max_pos_users           = excluded.max_pos_users,
  max_branches            = excluded.max_branches,
  max_hr_employees        = excluded.max_hr_employees,
  features                = excluded.features,
  is_active               = true,
  updated_at              = now();


-- -----------------------------------------------------------------------------
-- 3. Test pricing — a real charge, for a small amount, that expires
-- -----------------------------------------------------------------------------
-- Testing Mobile Money needs real money to move: MTN prompts a real handset and
-- settles a real reference. Paying 350,000 RWF to check a button is not viable.
--
-- Ported from eduAi's `supabase/migrations/0005_test_pricing.sql`, and for the
-- same reason: overriding the QUOTE (rather than letting the client send a
-- smaller amount) keeps both sides agreeing by construction. The plan row is
-- still written server-side, data-connector still charges what the plan says,
-- and the entitlement it grants is still a real one.
--
-- Two safety properties, because this is a switch that gives the product away
-- if it is ever left on:
--
--   1. Only a service-role / SQL-editor connection may turn it on. A signed-in
--      client is refused.
--   2. It expires on its own. A forgotten override stops applying rather than
--      quietly discounting a real customer forever.
create table if not exists public.hr_billing_settings (
  id                     boolean primary key default true check (id),
  -- Days past next_billing_date that still count as paid. 0 by design: the
  -- product is pay-before-use. Kept as a column so support can grant grace
  -- without a code change.
  grace_days             integer not null default 0 check (grace_days >= 0),
  test_charge_amount_rwf integer check (test_charge_amount_rwf is null
                                        or test_charge_amount_rwf > 0),
  test_charge_until      timestamptz
);
insert into public.hr_billing_settings (id) values (true) on conflict (id) do nothing;

-- The override in force right now, or null when normal pricing applies.
create or replace function public.hr_test_charge_amount()
returns integer
language sql
stable
security definer
set search_path = ''
as $$
  select s.test_charge_amount_rwf
    from public.hr_billing_settings s
   where s.id
     and s.test_charge_amount_rwf is not null
     -- No expiry means "not enabled": leaving it open-ended is the mistake the
     -- expiry exists to prevent.
     and s.test_charge_until is not null
     and s.test_charge_until > now();
$$;

-- Reported by hr_access_state() as well as by every quote, so a discounted
-- charge can never be presented as a full one.
create or replace function public.hr_billing_test_mode()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.hr_test_charge_amount() is not null;
$$;

create or replace function public.hr_enable_test_pricing(
  p_amount_rwf integer default 100,
  p_hours      integer default 24
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_hours integer := greatest(least(coalesce(p_hours, 24), 24 * 30), 1);
begin
  if auth.uid() is not null then
    raise exception 'test pricing cannot be enabled by a signed-in client';
  end if;
  if coalesce(p_amount_rwf, 0) <= 0 then
    raise exception 'the test amount must be greater than zero';
  end if;

  update public.hr_billing_settings
     set test_charge_amount_rwf = p_amount_rwf,
         test_charge_until      = now() + make_interval(hours => v_hours)
   where id;

  return jsonb_build_object(
    'test_charge_amount_rwf', p_amount_rwf,
    'expires_at', (select test_charge_until from public.hr_billing_settings where id)
  );
end;
$$;

create or replace function public.hr_disable_test_pricing()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is not null then
    raise exception 'test pricing cannot be changed by a signed-in client';
  end if;
  update public.hr_billing_settings
     set test_charge_amount_rwf = null, test_charge_until = null
   where id;
end;
$$;


-- -----------------------------------------------------------------------------
-- 4. Usage — what the business is actually consuming
-- -----------------------------------------------------------------------------
-- Counted live rather than stored, so a seat count can never silently disagree
-- with the roster. All three are security definer because a paywall has to be
-- able to say "you are at 50 of 50" to someone whose RLS scope is narrower than
-- the business.

create or replace function public.hr_employee_count(p_business_id text)
returns integer
language sql
stable
security definer
set search_path = ''
as $$
  select count(*)::integer
    from public.hr_employees e
   where e.business_id::text = p_business_id
     -- A terminated record is history, not a seat.
     and e.status <> 'terminated';
$$;

create or replace function public.hr_branch_count(p_business_id text)
returns integer
language sql
stable
security definer
set search_path = ''
as $$
  select count(*)::integer
    from public.branches b
   where (to_jsonb(b) ->> 'business_id') = p_business_id
     and coalesce((to_jsonb(b) ->> 'active')::boolean, true);
$$;

-- POS users: live feature grants in `accesses`, counted per person rather than
-- per grant (one user with Sales + Inventory is one user, not two).
create or replace function public.hr_pos_user_count(p_business_id text)
returns integer
language sql
stable
security definer
set search_path = ''
as $$
  select count(distinct (to_jsonb(a) ->> 'user_id'))::integer
    from public.accesses a
   where (to_jsonb(a) ->> 'business_id') = p_business_id
     and lower(coalesce(to_jsonb(a) ->> 'status', '')) = 'active'
     and (
       (to_jsonb(a) ->> 'expires_at') is null
       or (to_jsonb(a) ->> 'expires_at')::timestamptz > now()
     )
     and (to_jsonb(a) ->> 'user_id') is not null;
$$;


-- -----------------------------------------------------------------------------
-- 5. Pricing — the server's figure, and the only one anybody may pay
-- -----------------------------------------------------------------------------
-- Returns the price list entry for one tier plus this business's usage against
-- its limits, so the paywall can show "3 of 5 POS users" without a second read.
--
-- `amount_rwf` is what will be charged; `full_amount_rwf` is what the plan
-- really costs. They differ only while test pricing is on, and `test_mode` says
-- so rather than leaving the app to infer it from a suspiciously small number.
create or replace function public.hr_plan_quote(
  p_business_id text,
  p_slug        text default 'basic',
  p_is_yearly   boolean default false
)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_tpl    public.subscription_plan_templates;
  v_full   integer;
  v_test   integer := public.hr_test_charge_amount();
  v_yearly boolean := coalesce(p_is_yearly, false);
begin
  if p_business_id is null or p_business_id = '' then
    raise exception 'a business is required to price a subscription';
  end if;
  if p_business_id not in (select public.hr_user_business_ids()) then
    raise exception 'you do not manage this business';
  end if;

  select * into v_tpl
    from public.subscription_plan_templates
   where slug = coalesce(p_slug, 'basic')
     and is_active;
  if not found then
    raise exception 'unknown subscription plan %', p_slug;
  end if;

  -- Same arithmetic as SubscriptionPlanTemplate.calculateTotal (Dart) and
  -- Catalog::price_for (Rust): a yearly purchase is twelve months less the
  -- tier's discount, rounded once at the end.
  v_full := case
              when v_yearly then
                round(v_tpl.monthly_price * 12 * (1 - v_tpl.yearly_discount_percent / 100.0))
              else v_tpl.monthly_price
            end::integer;

  return jsonb_build_object(
    'business_id',      p_business_id,
    'template_id',      v_tpl.id,
    'slug',             v_tpl.slug,
    'name',             v_tpl.name,
    'description',      v_tpl.description,
    'features',         to_jsonb(v_tpl.features),
    'monthly_price',    v_tpl.monthly_price,
    'is_yearly',        v_yearly,
    'amount_rwf',       coalesce(v_test, v_full),
    'full_amount_rwf',  v_full,
    'test_mode',        v_test is not null,
    'period_days',      case when v_yearly then 365 else 30 end,
    'max_pos_users',    v_tpl.max_pos_users,
    'max_branches',     v_tpl.max_branches,
    'max_hr_employees', v_tpl.max_hr_employees,
    'pos_users_used',   public.hr_pos_user_count(p_business_id),
    'branches_used',    public.hr_branch_count(p_business_id),
    'employees_used',   public.hr_employee_count(p_business_id)
  );
end;
$$;


-- -----------------------------------------------------------------------------
-- 6. Starting a subscription — writing the plan row at the server's price
-- -----------------------------------------------------------------------------
-- Creates (or re-points) the business's `plans` row and returns its id, which is
-- what the app then sends to `POST /v2/api/payNow` as `planId`.
--
-- Notes on the columns, since data-connector reads all of them:
--
--   total_price     the quoted amount. Read as `override_price`, so this is the
--                   figure MTN will be asked for.
--   plan_template_id / selected_plan
--                   both written, because the catalogue is resolved by id first
--                   and by name second (Catalog::resolve).
--   rule            'monthly' | 'yearly' — drives the next cycle's date.
--   next_billing_date
--                   set one period out. data-connector's `anchor_first_cycle`
--                   re-anchors an unpaid plan onto today before charging, so
--                   this is a starting point, not a promise.
--   payment_completed_by_user / payment_status
--                   left unpaid. Only settlement may move them.
--
-- An already-paid plan is returned untouched: re-opening the paywall on a live
-- subscription must not reset its billing date or its price.
create or replace function public.hr_start_subscription(
  p_business_id text,
  p_slug        text default 'basic',
  p_is_yearly   boolean default false,
  p_phone       text default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_quote    jsonb;
  v_plan     public.plans;
  v_branch   uuid;
  v_amount   integer;
  v_yearly   boolean := coalesce(p_is_yearly, false);
  v_has_plan boolean;
  v_rule     text;
  v_interval interval;
  v_phone    text := nullif(regexp_replace(coalesce(p_phone, ''), '\D', '', 'g'), '');
begin
  v_quote  := public.hr_plan_quote(p_business_id, p_slug, v_yearly);
  v_amount := (v_quote ->> 'amount_rwf')::integer;
  v_rule   := case when v_yearly then 'yearly' else 'monthly' end;
  v_interval := case when v_yearly then interval '1 year' else interval '1 month' end;

  select * into v_plan
    from public.plans
   where business_id::text = p_business_id
   order by created_at desc nulls last
   limit 1;
  -- Captured now: the branch lookup below overwrites FOUND.
  v_has_plan := found;

  -- Live subscription: nothing to start. Hand back what is already there so the
  -- caller can poll it rather than creating a second plan for the same business.
  if v_has_plan
     and v_plan.next_billing_date is not null
     and v_plan.next_billing_date > now()
     and (coalesce(v_plan.payment_completed_by_user, false)
          or upper(coalesce(v_plan.payment_status, '')) = 'COMPLETED')
  then
    return jsonb_build_object(
      'plan_id',    v_plan.id,
      'amount_rwf', coalesce(v_plan.total_price, v_amount)::integer,
      'already_active', true,
      'quote',      v_quote
    );
  end if;

  select b.id into v_branch
    from public.branches b
   where (to_jsonb(b) ->> 'business_id') = p_business_id
   order by (to_jsonb(b) ->> 'created_at')
   limit 1;

  if v_has_plan then
    update public.plans
       set selected_plan     = v_quote ->> 'name',
           plan_template_id  = (v_quote ->> 'template_id')::uuid,
           is_yearly_plan    = v_yearly,
           total_price       = v_amount,
           rule              = v_rule,
           payment_method    = 'MTNMOMO',
           phone_number      = coalesce(v_phone, phone_number),
           branch_id         = coalesce(branch_id, v_branch),
           next_billing_date = now() + v_interval,
           payment_status    = 'PENDING',
           processing_status = 'PENDING',
           payment_completed_by_user = false,
           updated_at        = now(),
           last_updated      = now()
     where id = v_plan.id
    returning * into v_plan;
  else
    insert into public.plans (
      id, business_id, branch_id, selected_plan, plan_template_id,
      additional_devices, is_yearly_plan, total_price, rule, payment_method,
      phone_number, next_billing_date, payment_status, processing_status,
      payment_completed_by_user, number_of_payments, created_at, updated_at
    ) values (
      gen_random_uuid(), p_business_id::uuid, v_branch,
      v_quote ->> 'name', (v_quote ->> 'template_id')::uuid,
      0, v_yearly, v_amount, v_rule, 'MTNMOMO',
      v_phone, now() + v_interval, 'PENDING', 'PENDING',
      false, 1, now(), now()
    )
    returning * into v_plan;
  end if;

  return jsonb_build_object(
    'plan_id',        v_plan.id,
    'amount_rwf',     v_amount,
    'already_active', false,
    'quote',          v_quote
  );
end;
$$;


-- -----------------------------------------------------------------------------
-- 7. hr_access_state() — the one question the app asks
-- -----------------------------------------------------------------------------
-- Deliberately one round trip returning one verdict, so no two screens can
-- assemble entitlement differently and disagree.
--
-- "Paid" is decided by the same rule Books uses (`AuthMixin.hasActiveSubscription`
-- in flipper_models): the next billing date is in the future AND the plan is
-- marked complete, either by the payer or by the processor. Two implementations
-- of "is this subscription live" that disagree is how a till keeps selling on a
-- lapsed plan, so this one copies that rule rather than inventing a second.
--
-- Statuses:
--   no_business    the session manages no business — an invited employee. HR's
--                  self-service pages stay open for them; there is nothing here
--                  for them to buy.
--   needs_setup    they manage a business but it has no plan yet.
--   needs_payment  a plan exists and is not paid (never paid, or lapsed).
--   entitled       paid and current.
create or replace function public.hr_access_state(p_business_id text default null)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_business text;
  v_plan     public.plans;
  v_tpl      public.subscription_plan_templates;
  v_grace    integer;
  v_valid    timestamptz;
  v_paid     boolean := false;
  v_status   text;
begin
  -- A caller who names a business must manage it; one who names none gets their
  -- own, which is the single-business case.
  if p_business_id is not null and p_business_id <> '' then
    if p_business_id not in (select public.hr_user_business_ids()) then
      raise exception 'you do not manage this business';
    end if;
    v_business := p_business_id;
  else
    select b into v_business from public.hr_user_business_ids() b limit 1;
  end if;

  if v_business is null then
    return jsonb_build_object(
      'status',      'no_business',
      'business_id', null,
      'test_mode',   public.hr_billing_test_mode()
    );
  end if;

  select coalesce(grace_days, 0) into v_grace
    from public.hr_billing_settings where id;

  select * into v_plan
    from public.plans
   where business_id::text = v_business
   order by created_at desc nulls last
   limit 1;

  if not found then
    v_status := 'needs_setup';
  else
    select * into v_tpl
      from public.subscription_plan_templates
     where id = v_plan.plan_template_id
        or lower(trim(name)) = lower(trim(coalesce(v_plan.selected_plan, '')))
     limit 1;

    v_valid := v_plan.next_billing_date;
    v_paid  := v_valid is not null
               and v_valid + make_interval(days => coalesce(v_grace, 0)) > now()
               and (coalesce(v_plan.payment_completed_by_user, false)
                    or upper(coalesce(v_plan.payment_status, '')) = 'COMPLETED');
    v_status := case when v_paid then 'entitled' else 'needs_payment' end;
  end if;

  return jsonb_build_object(
    'status',           v_status,
    'business_id',      v_business,
    'plan_id',          v_plan.id,
    'plan_name',        v_plan.selected_plan,
    'template_id',      v_tpl.id,
    'slug',             v_tpl.slug,
    'is_yearly',        coalesce(v_plan.is_yearly_plan, false),
    'amount_rwf',       v_plan.total_price,
    'payment_status',   v_plan.payment_status,
    'phone_number',     v_plan.phone_number,
    'valid_until',      v_valid,
    'grace_days',       coalesce(v_grace, 0),
    'test_mode',        public.hr_billing_test_mode(),
    'max_pos_users',    v_tpl.max_pos_users,
    'max_branches',     v_tpl.max_branches,
    'max_hr_employees', v_tpl.max_hr_employees,
    'pos_users_used',   public.hr_pos_user_count(v_business),
    'branches_used',    public.hr_branch_count(v_business),
    'employees_used',   public.hr_employee_count(v_business)
  );
end;
$$;


-- -----------------------------------------------------------------------------
-- 8. The employee cap, enforced where the rows are
-- -----------------------------------------------------------------------------
-- "50 HR employees" is only a promise until something refuses the 51st. A UI
-- check is not that something: the roster is a PostgREST table any signed-in
-- session can insert into within its RLS scope.
--
-- Only the HR seat is enforced here. Branch and POS-user caps belong to the
-- surfaces that create branches and grant access — enforcing them from an HR
-- migration would reject writes made by POS with an error mentioning HR, and a
-- business already over its limit could no longer edit what it has. They are
-- reported by hr_access_state() (`branches_used` / `pos_users_used` against the
-- limits) so both apps can show and act on them.
--
-- A business with no plan is not capped: the paywall is what stops it, and a
-- trigger that refused every insert for a plan-less business would also break
-- the rows POS and the invite flow create.
create or replace function public.hr_enforce_employee_cap()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_limit integer;
  v_used  integer;
begin
  if new.status = 'terminated' then
    return new;
  end if;

  select t.max_hr_employees into v_limit
    from public.plans p
    join public.subscription_plan_templates t
      on t.id = p.plan_template_id
      or lower(trim(t.name)) = lower(trim(coalesce(p.selected_plan, '')))
   where p.business_id = new.business_id
   order by p.created_at desc nulls last
   limit 1;

  if v_limit is null then
    return new;
  end if;

  select count(*)::integer into v_used
    from public.hr_employees e
   where e.business_id = new.business_id
     and e.status <> 'terminated'
     and e.id <> new.id;

  if v_used >= v_limit then
    raise exception
      'This plan covers % employees and % are already on the roster. Upgrade the subscription to add more.',
      v_limit, v_used
      using errcode = 'check_violation';
  end if;

  return new;
end;
$$;

drop trigger if exists hr_employees_seat_cap on public.hr_employees;
create trigger hr_employees_seat_cap
  before insert or update of status, business_id on public.hr_employees
  for each row
  execute function public.hr_enforce_employee_cap();


-- -----------------------------------------------------------------------------
-- 9. Grants
-- -----------------------------------------------------------------------------
revoke all on function public.hr_plan_quote(text, text, boolean) from public, anon;
revoke all on function public.hr_start_subscription(text, text, boolean, text) from public, anon;
revoke all on function public.hr_access_state(text) from public, anon;
revoke all on function public.hr_employee_count(text) from public, anon;
revoke all on function public.hr_branch_count(text) from public, anon;
revoke all on function public.hr_pos_user_count(text) from public, anon;

grant execute on function public.hr_plan_quote(text, text, boolean)              to authenticated;
grant execute on function public.hr_start_subscription(text, text, boolean, text) to authenticated;
grant execute on function public.hr_access_state(text)                            to authenticated;
grant execute on function public.hr_employee_count(text)                          to authenticated;
grant execute on function public.hr_branch_count(text)                            to authenticated;
grant execute on function public.hr_pos_user_count(text)                          to authenticated;
grant execute on function public.hr_test_charge_amount()                          to authenticated;
grant execute on function public.hr_billing_test_mode()                           to authenticated;

-- Turning a discount on is an operator action, not something a signed-in
-- account can reach. Both are refused for a session with an auth.uid() anyway;
-- this stops them being callable at all.
revoke all on function public.hr_enable_test_pricing(integer, integer) from public, anon, authenticated;
revoke all on function public.hr_disable_test_pricing() from public, anon, authenticated;

-- hr_billing_settings holds an operator switch, not user data. No policy grants
-- anyone access; it is read through the security definer functions above.
alter table public.hr_billing_settings enable row level security;
revoke all on table public.hr_billing_settings from public, anon, authenticated;
grant all on table public.hr_billing_settings to service_role;
