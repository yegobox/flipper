-- =============================================================================
-- hr_employees — the people directory behind Flipper HR's /people page
-- =============================================================================
-- Run against the same Supabase project flipper_web uses (HR shares the
-- account, so it shares the database).
--
-- Design notes:
--
--   * business_id / branch_id are `uuid`, matching the rest of this schema:
--     public.procedures declares deduct_credits(branch_id UUID) against
--     credits.branch_id, and businesses/branches use uuid primary keys. The Dart
--     side holds them as `String` (supabase_models Branch.id is `final String
--     id`) because Dart has no uuid type — PostgREST casts the JSON string on
--     the way in, so the client needs no change.
--   * No foreign keys, despite the types now lining up. Ditto is authoritative
--     for branch and business documents on some sync paths, so a branch the app
--     legitimately works in may have no Postgres row yet; an FK would reject the
--     insert. See the optional ALTERs at the bottom to add them anyway.
--   * `status` and the other enum-ish columns are text + CHECK rather than
--     Postgres enums: adding a value to a CHECK is a one-line migration, while
--     adding one to an enum type cannot be done inside a transaction with other
--     DDL. The allowed values must match the `wire` values in
--     lib/features/people/data/employee.dart.
--   * A SELECT policy is mandatory even for a write-only client: the repository
--     writes with `.insert(...).select().single()`, so INSERT without SELECT
--     commits the row while the client raises.
--   * Salary and national ID make every row Confidential. RLS is not optional
--     here, and the anon role is granted nothing.
--
-- Rollback:
--   drop table if exists public.hr_employees;
-- =============================================================================

create extension if not exists "pgcrypto";

-- An earlier draft of this file scoped rows with a text-keyed
-- hr_employees_member_of(text). Dropped here so re-running leaves no dead
-- function behind that a future policy might pick up.
drop function if exists public.hr_employees_member_of(text);

create table if not exists public.hr_employees (
  id              uuid primary key default gen_random_uuid(),

  business_id     uuid not null,
  branch_id       uuid not null,

  first_name      text not null,
  last_name       text not null,
  phone           text not null default '',
  email           text,

  job_title       text not null default '',
  department      text not null default '',

  employment_type text not null default 'full_time'
                    check (employment_type in
                      ('full_time', 'part_time', 'contract', 'intern', 'casual')),
  status          text not null default 'active'
                    check (status in
                      ('active', 'on_leave', 'suspended', 'terminated')),

  hire_date       date not null,
  end_date        date,

  national_id     text,
  rssb_number     text,

  base_salary     numeric(14, 2) not null default 0
                    check (base_salary >= 0),
  currency        text not null default 'RWF',
  pay_frequency   text not null default 'monthly'
                    check (pay_frequency in
                      ('monthly', 'weekly', 'daily', 'hourly')),

  payment_method  text not null default 'mobile_money'
                    check (payment_method in
                      ('mobile_money', 'bank_transfer', 'cash')),
  momo_phone      text,
  bank_name       text,
  bank_account    text,

  -- Flipper account this person signs in with, when they have one. This is a
  -- public.users.id, the same thing businesses.user_id holds — NOT auth.uid().
  user_id         text,

  notes           text,

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),

  -- Terminating someone must record their last day; the app enforces this too,
  -- but a direct SQL edit should not be able to leave the pair inconsistent.
  constraint hr_employees_end_date_after_hire
    check (end_date is null or end_date >= hire_date),
  constraint hr_employees_terminated_needs_end_date
    check (status <> 'terminated' or end_date is not null)
);

-- The roster query: every person on one branch, ordered by first name.
create index if not exists hr_employees_branch_idx
  on public.hr_employees (branch_id, first_name);

-- Business-wide reporting (payroll totals across branches) comes next.
create index if not exists hr_employees_business_idx
  on public.hr_employees (business_id);

-- One person cannot be on the same branch twice under the same national ID.
-- Partial, because the national ID is optional for casual hires.
create unique index if not exists hr_employees_branch_national_id_key
  on public.hr_employees (branch_id, national_id)
  where national_id is not null;


-- -----------------------------------------------------------------------------
-- RLS — rows are visible to members of the owning business
-- -----------------------------------------------------------------------------
-- Membership is NOT `businesses.user_id = auth.uid()`. In this schema
-- businesses.user_id holds public.users.id, while auth.uid() matches
-- public.users.uuid — comparing them directly matches nothing and silently
-- denies every read and write. The mapping goes through users.uuid.
--
-- These two helpers are the same ones logs_rls_policies.sql defines, repeated
-- verbatim so this migration is self-contained and order-independent. They are
-- `create or replace`, so applying both files in either order is safe — but if
-- you change one copy, change the other.
--
-- SECURITY DEFINER so they read users/businesses without tripping those tables'
-- own RLS. The empty search_path is required: a mutable search_path on a
-- SECURITY DEFINER function is a privilege-escalation vector.

create or replace function public.current_app_user_id()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select u.id::text
  from public.users u
  where u.uuid::text = auth.uid()::text
  limit 1
$$;

comment on function public.current_app_user_id() is
  'Maps auth.uid() to public.users.id via users.uuid.';

create or replace function public.user_business_ids()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  select b.id::text
  from public.businesses b
  where b.user_id::text = public.current_app_user_id()
$$;

comment on function public.user_business_ids() is
  'Business ids owned by the calling user. Adjust the join if businesses.user_id does not hold users.id.';

revoke all on function public.current_app_user_id() from public, anon;
revoke all on function public.user_business_ids()   from public, anon;
grant execute on function public.current_app_user_id() to authenticated;
grant execute on function public.user_business_ids()   to authenticated;

-- Cast to text on both sides: user_business_ids() returns text, and this keeps
-- the comparison working whether a given project keeps these keys as uuid or
-- text.
alter table public.hr_employees enable row level security;

drop policy if exists hr_employees_select on public.hr_employees;
create policy hr_employees_select
  on public.hr_employees
  for select
  to authenticated
  using (business_id::text in (select public.user_business_ids()));

drop policy if exists hr_employees_insert on public.hr_employees;
create policy hr_employees_insert
  on public.hr_employees
  for insert
  to authenticated
  with check (business_id::text in (select public.user_business_ids()));

drop policy if exists hr_employees_update on public.hr_employees;
create policy hr_employees_update
  on public.hr_employees
  for update
  to authenticated
  using (business_id::text in (select public.user_business_ids()))
  with check (business_id::text in (select public.user_business_ids()));

-- No DELETE policy: people are terminated, never deleted, so payroll history
-- survives. Removing a record is a service-role operation.

revoke all on public.hr_employees from anon;
grant select, insert, update on public.hr_employees to authenticated;


-- -----------------------------------------------------------------------------
-- updated_at is maintained server-side as well as by the client
-- -----------------------------------------------------------------------------
create or replace function public.hr_employees_touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists hr_employees_touch_updated_at on public.hr_employees;
create trigger hr_employees_touch_updated_at
  before update on public.hr_employees
  for each row
  execute function public.hr_employees_touch_updated_at();


-- -----------------------------------------------------------------------------
-- Verify before trusting the policies
-- -----------------------------------------------------------------------------
-- Signed in as a real user (not the service role, which bypasses RLS):
--
--   select public.current_app_user_id();          -- must not be null
--   select * from public.user_business_ids();     -- must list your businesses
--
-- If the first is null, businesses.user_id does not hold users.id in this
-- project, or the JWT's sub does not match users.uuid — fix the helper rather
-- than loosening the policy.
--
-- Column types actually in place:
--
--   select column_name, data_type
--     from information_schema.columns
--    where table_schema = 'public'
--      and table_name in ('businesses', 'branches', 'hr_employees')
--      and column_name in ('id', 'user_id', 'business_id', 'branch_id')
--    order by table_name, column_name;


-- -----------------------------------------------------------------------------
-- Optional — foreign keys, once every branch you use exists in Postgres
-- -----------------------------------------------------------------------------
-- Run these only after confirming no branch or business the app writes to is
-- Ditto-only; otherwise legitimate inserts start failing with 23503.
--
--   alter table public.hr_employees
--     add constraint hr_employees_business_fk
--     foreign key (business_id) references public.businesses (id);
--
--   alter table public.hr_employees
--     add constraint hr_employees_branch_fk
--     foreign key (branch_id) references public.branches (id);
