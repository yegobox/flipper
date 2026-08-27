-- =============================================================================
-- 0009 — skip payment: a way in, a limited number of times, without money
-- =============================================================================
-- Apply after 0008, against the same Supabase project flipper_web uses.
--
-- The paywall in 0008 is binary: paid or blocked. This adds a third door — a
-- business stuck at `needs_payment` / `needs_setup` may skip, up to
-- `hr_billing_settings.max_payment_skips` times ever (default 2), each skip
-- opening the roster for `payment_skip_days` (default 30). Both numbers are
-- plain columns, not a dedicated setter, matching how `grace_days` is edited —
-- support changes the row when the policy changes, no deploy required.
--
-- WHAT THIS DOES NOT DO. A skip is not a payment, and is never written where a
-- payment would be. `plans.total_price` / `payment_completed_by_user` /
-- `payment_status` — the columns data-connector settles — are untouched. A
-- skip is its own row in `hr_payment_skips`, and `hr_access_state()` reports
-- it as its own status, `'skipped'`, which unlocks the app exactly like
-- `'entitled'` does but is never returned as `'entitled'`: nothing downstream
-- can mistake a skip for money having moved.
--
-- Real payment always wins: the skip lookup only runs once the ordinary
-- paid/unpaid computation below has already decided the business is unpaid.
-- A business that pays is `entitled` no matter how many skips it has used.
--
-- Safe to re-run: create-or-replace / add column if not exists.
--
-- Rollback:
--   drop function if exists public.hr_skip_payment(text);
--   drop table if exists public.hr_payment_skips;
--   -- reverting hr_access_state() to the pre-0009 body means re-running the
--   -- version of that function in 0008_hr_billing.sql.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1. Policy — how many skips, and how long each one buys
-- -----------------------------------------------------------------------------
alter table public.hr_billing_settings
  add column if not exists max_payment_skips integer not null default 2
    check (max_payment_skips >= 0),
  add column if not exists payment_skip_days integer not null default 30
    check (payment_skip_days > 0);

comment on column public.hr_billing_settings.max_payment_skips is
  'Lifetime cap on hr_skip_payment() calls per business, not per period. Edit directly to change the policy — same precedent as grace_days.';
comment on column public.hr_billing_settings.payment_skip_days is
  'Days of access one skip buys, counted from when it is used.';


-- -----------------------------------------------------------------------------
-- 2. The ledger — one row per skip, ever
-- -----------------------------------------------------------------------------
-- No RLS policy grants anyone direct access, same as hr_billing_settings: the
-- table is read and written only through the security-definer functions
-- below, so a client can never forge a skip or read another business's count.
create table if not exists public.hr_payment_skips (
  id          uuid primary key default gen_random_uuid(),
  business_id uuid not null,
  skipped_by  uuid,
  skipped_at  timestamptz not null default now(),
  expires_at  timestamptz not null
);

create index if not exists hr_payment_skips_business_idx
  on public.hr_payment_skips (business_id, expires_at desc);

alter table public.hr_payment_skips enable row level security;
revoke all on table public.hr_payment_skips from public, anon, authenticated;
grant all on table public.hr_payment_skips to service_role;


-- -----------------------------------------------------------------------------
-- 3. hr_skip_payment() — spend one, if any are left
-- -----------------------------------------------------------------------------
-- Reuses hr_access_state() for both checks a naive version of this function
-- would have to duplicate: "may this session act for this business" (it
-- raises "you do not manage this business" on its own) and "does this
-- business actually have a payment due right now". One place decides both,
-- so this function and the paywall can never disagree about either.
create or replace function public.hr_skip_payment(
  p_business_id text default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_state    jsonb := public.hr_access_state(p_business_id);
  v_business text  := v_state ->> 'business_id';
  v_status   text  := v_state ->> 'status';
  v_max      integer;
  v_days     integer;
  v_used     integer;
  v_expires  timestamptz;
begin
  if v_business is null then
    raise exception 'a business is required to skip payment';
  end if;

  if v_status not in ('needs_payment', 'needs_setup') then
    raise exception
      'This business does not have a payment to skip right now.';
  end if;

  select coalesce(max_payment_skips, 2), coalesce(payment_skip_days, 30)
    into v_max, v_days
    from public.hr_billing_settings where id;

  -- Serialise concurrent skips for the *same* business: without this, two
  -- calls can both count v_used = v_max - 1 and both insert, spending one
  -- skip more than the cap allows. Transaction-scoped, so it is released on
  -- commit/rollback, and keyed on the business, so other businesses are
  -- unaffected.
  perform pg_advisory_xact_lock(hashtextextended(v_business, 0));

  select count(*)::integer into v_used
    from public.hr_payment_skips
   where business_id::text = v_business;

  if v_used >= v_max then
    raise exception
      'This business has already skipped payment % of % allowed times. Pay to continue.',
      v_used, v_max
      using errcode = 'check_violation';
  end if;

  v_expires := now() + make_interval(days => v_days);

  insert into public.hr_payment_skips (business_id, skipped_by, expires_at)
  values (v_business::uuid, auth.uid(), v_expires);

  -- Hand back the fresh verdict rather than the count, so the caller does not
  -- have to make a second round trip to find out it is unlocked.
  return public.hr_access_state(v_business);
end;
$$;

revoke all on function public.hr_skip_payment(text) from public, anon;
grant execute on function public.hr_skip_payment(text) to authenticated;


-- -----------------------------------------------------------------------------
-- 4. hr_access_state() — report skip usage, and honour an active skip
-- -----------------------------------------------------------------------------
-- Full replace of the 0008 body. Every existing branch and returned key is
-- unchanged; the only additions are the skip lookup (gated on the same
-- needs_payment / needs_setup verdict the function already computes) and
-- three new keys on the returned object. `'entitled'` is never reassigned by
-- this: the skip check runs after v_status is already decided, and only when
-- it is not already 'entitled'.
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
  v_skip_max     integer;
  v_skip_days    integer;
  v_skip_used    integer;
  v_skip_expires timestamptz;
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

  -- Skip usage, reported regardless of status so the paywall can show
  -- "1 of 2 used" before the button is ever pressed.
  select coalesce(max_payment_skips, 2), coalesce(payment_skip_days, 30)
    into v_skip_max, v_skip_days
    from public.hr_billing_settings where id;

  select count(*)::integer into v_skip_used
    from public.hr_payment_skips
   where business_id::text = v_business;

  -- An unpaid business with a live skip is let in without being marked
  -- 'entitled' — that word is reserved for money that has actually moved.
  if v_status in ('needs_payment', 'needs_setup') then
    select expires_at into v_skip_expires
      from public.hr_payment_skips
     where business_id::text = v_business
       and expires_at > now()
     order by expires_at desc
     limit 1;

    if v_skip_expires is not null then
      v_status := 'skipped';
    end if;
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
    'test_mode',        public.hr_billing_test_mode(v_business),
    'max_pos_users',    v_tpl.max_pos_users,
    'max_branches',     v_tpl.max_branches,
    'max_hr_employees', v_tpl.max_hr_employees,
    'pos_users_used',   public.hr_pos_user_count(v_business),
    'branches_used',    public.hr_branch_count(v_business),
    'employees_used',   public.hr_employee_count(v_business),
    'skips_used',        v_skip_used,
    'max_payment_skips', v_skip_max,
    'skip_expires_at',   v_skip_expires
  );
end;
$$;
