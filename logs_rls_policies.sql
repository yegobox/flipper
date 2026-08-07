-- =============================================================================
-- RLS for public.logs
-- =============================================================================
-- Depends on the offline-queue auth fixes in packages/supabase_models
-- (AuthRefreshingClient + EnqueuedUserStampClient). Before those, replayed
-- queue jobs carried an expired JWT and were rejected at 401 before any policy
-- ran, so RLS here would have been decorative.
--
-- Design notes:
--
--   * Rows are anchored to `user_id`, not `business_id`. LogService writes
--     exception logs during boot when ProxyService.box.getBusinessId() is
--     still null, so a business-scoped INSERT check would reject them.
--   * A SELECT policy is MANDATORY, not optional. Brick's insert does a
--     read-back (supabase_provider.dart:287) and throws StateError when the
--     returned representation is empty. INSERT without SELECT means rows
--     commit while the client reports failure.
--   * No UPDATE/DELETE policies: logs are append-only from clients.
--
-- IMPORTANT: with 403 removed from reattemptForStatusCodes, a policy that
-- rejects a write causes the queued job to be DISCARDED, not retried. Run this
-- against staging first and confirm logs still land.
--
-- Run as the postgres/service role (SQL editor or migration).
--
-- Verified end-to-end against a local PostgreSQL 15 instance with a
-- Supabase-shaped fixture (auth.uid() reading request.jwt.claims, the anon /
-- authenticated / service_role roles, and Supabase's default blanket grants):
--   - insert + read-back returns exactly one row (Brick's write path)
--   - a null business_id boot log inserts fine
--   - attributing a row to another uid is rejected, even by a business owner
--   - a second user sees none of the first user's logs
--   - update and delete are denied outright
--   - anon cannot read or write
--   - service_role still bypasses RLS entirely
--
-- Two caveats that follow from that last point:
--   1. Anything using the service_role/secret key is unaffected by this file.
--      data-connector reads SUPABASE_ANON_KEY, but its .env.example describes
--      the value as "anon_or_secret_key" -- check which one prod actually
--      holds before assuming these policies constrain it. It does not appear
--      to touch `logs`, so this file should not affect it either way.
--   2. Enabling the optional business-scoped SELECT in STEP 4 also exposes
--      legacy rows whose user_id is null, since they still carry a
--      business_id. Backfill or delete those first if that matters.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- STEP 0 — verify assumptions before applying anything below
-- -----------------------------------------------------------------------------
-- The client code implies users.uuid holds auth.uid(): login_viewmodel.dart:120
-- calls authUser(uuid: user.uid), which queries users WHERE uuid = <auth uid>.
-- Confirm, and confirm what businesses.user_id actually references -- the Dart
-- model coerces int -> String (business.model.dart:239-241), which suggests
-- some rows may still hold a legacy integer id rather than a users.id UUID.

-- (a) Column types on the tables involved.
select table_name, column_name, data_type, is_nullable
from information_schema.columns
where table_schema = 'public'
  and (table_name, column_name) in (
    ('logs','id'), ('logs','business_id'), ('logs','created_at'),
    ('users','id'), ('users','uuid'),
    ('businesses','id'), ('businesses','user_id')
  )
order by table_name, column_name;

-- (b) Does users.uuid line up with auth.users.id?
-- Everything is cast to text: these columns may be uuid or text depending on
-- how the table was created, and an uncast comparison would just error.
select count(*) filter (where a.id is not null) as matched,
       count(*)                                 as total_users
from public.users u
left join auth.users a on a.id::text = u.uuid::text;

-- (c) Does businesses.user_id hold users.id, or something else?
select count(*) filter (where u.id is not null)                      as matches_users_id,
       count(*) filter (where b.user_id::text ~ '^[0-9]+$')          as looks_like_legacy_int,
       count(*)                                                      as total_businesses
from public.businesses b
left join public.users u on u.id::text = b.user_id::text;

-- If (c) shows mostly legacy ints, fix the join inside user_business_ids()
-- below before enabling the optional business-scoped policy.


-- -----------------------------------------------------------------------------
-- STEP 1 — owner column
-- -----------------------------------------------------------------------------
-- Nullable on purpose: pre-existing rows have no owner and NOT NULL would fail
-- the migration. The DEFAULT is what actually populates it -- Brick does not
-- send this column, so Postgres fills it with the inserting user.

alter table public.logs
  add column if not exists user_id uuid default auth.uid();

comment on column public.logs.user_id is
  'auth.uid() of the writer. Populated by DEFAULT; clients never send it.';

create index if not exists logs_user_id_idx     on public.logs (user_id);
create index if not exists logs_business_id_idx on public.logs (business_id);
create index if not exists logs_created_at_idx  on public.logs (created_at desc);


-- -----------------------------------------------------------------------------
-- STEP 2 — membership helpers
-- -----------------------------------------------------------------------------
-- SECURITY DEFINER so these read users/businesses without tripping those
-- tables' own RLS (and without recursing back into this policy).
-- Empty search_path is required: a mutable search_path on a SECURITY DEFINER
-- function is a privilege-escalation vector.

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
  'Business ids owned by the calling user. Adjust the join if businesses.user_id does not hold users.id -- see STEP 0 (c).';

revoke all on function public.current_app_user_id() from public, anon;
revoke all on function public.user_business_ids()   from public, anon;
grant execute on function public.current_app_user_id() to authenticated;
grant execute on function public.user_business_ids()   to authenticated;


-- -----------------------------------------------------------------------------
-- STEP 3 — lock the table down
-- -----------------------------------------------------------------------------
alter table public.logs enable row level security;

-- Supabase grants ALL on public tables to anon/authenticated by default.
-- Defense in depth: no client may ever mutate or remove a log line, and the
-- anon role has no business here at all.
revoke all           on public.logs from anon;
revoke update, delete on public.logs from authenticated;
grant  insert, select on public.logs to  authenticated;


-- -----------------------------------------------------------------------------
-- STEP 4 — policies
-- -----------------------------------------------------------------------------
drop policy if exists logs_insert_own      on public.logs;
drop policy if exists logs_select_own      on public.logs;
drop policy if exists logs_select_business on public.logs;

-- Write: only rows attributed to yourself. Nothing here constrains
-- business_id, so boot-time logs with a null business_id still land.
create policy logs_insert_own
  on public.logs
  for insert
  to authenticated
  with check (user_id = auth.uid());

-- Read: your own rows. This is what satisfies Brick's post-insert read-back.
create policy logs_select_own
  on public.logs
  for select
  to authenticated
  using (user_id = auth.uid());

-- Optional, and OFF by default. Enable once STEP 0 (c) confirms the join, if
-- you want an owner to read every log for their business rather than only the
-- ones their own device produced. Policies for the same command are OR'd, so
-- this widens logs_select_own rather than replacing it.
--
-- create policy logs_select_business
--   on public.logs
--   for select
--   to authenticated
--   using (business_id::text in (select public.user_business_ids()));
--
-- The ::text cast defeats logs_business_id_idx. If log volume makes that hurt,
-- drop the cast once STEP 0 (a) confirms logs.business_id and businesses.id are
-- already the same type.


-- -----------------------------------------------------------------------------
-- STEP 5 — verify
-- -----------------------------------------------------------------------------
-- Should list exactly: logs_insert_own (INSERT), logs_select_own (SELECT).
select policyname, cmd, roles, qual, with_check
from pg_policies
where schemaname = 'public' and tablename = 'logs'
order by policyname;

-- Should be true.
select relrowsecurity from pg_class where oid = 'public.logs'::regclass;

-- Impersonate a real user and confirm a write round-trips. Replace the uid.
-- Run the whole block at once; the settings are transaction-local.
--
-- begin;
--   select set_config('role', 'authenticated', true);
--   select set_config('request.jwt.claims',
--     json_build_object('sub','d743e869-92f5-407e-a3d8-1473d3bcdd9f',
--                       'role','authenticated')::text, true);
--
--   insert into public.logs (id, message, type, created_at)
--   values (gen_random_uuid(), 'rls smoke test', 'test', now())
--   returning id, message, type, business_id, created_at, tags, extra;
--   -- ^ mirrors Brick's read-back. An empty result here means the client
--   --   would throw StateError('Upsert of Log failed').
-- rollback;
