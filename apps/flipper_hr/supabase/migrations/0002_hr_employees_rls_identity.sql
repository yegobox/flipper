-- =============================================================================
-- 0002 — fix hr_employees RLS: resolve the caller by phone, not users.uuid
-- =============================================================================
-- Symptom this fixes: POST /rest/v1/hr_employees returns 403 (42501, "new row
-- violates row-level security policy") for a user who genuinely owns the
-- business.
--
-- Why 0001's policy failed, confirmed against production rows:
--
--   0001 reused public.user_business_ids() from logs_rls_policies.sql, which
--   resolves the caller as `users.uuid = auth.uid()`. For a real Flipper account
--   that link does not exist:
--
--     auth.users     id = <a Supabase auth uuid>
--                 phone = 250700000000          (no '+')
--                 email = 250700000000@flipper.rw   <- synthetic Ditto key
--
--     public.users   id = <a different app uuid>
--                  uuid = NULL                  <- nothing to match on at all
--                   uid = NULL
--                 email = <the person's real gmail address>
--          phone_number = +250700000000         (E.164, with '+')
--
--   users.uuid is null, users.id is not the auth id, and the emails differ (the
--   auth email is the synthetic `<phone>@flipper.rw` key from
--   flipper_web/lib/core/api_login_key.dart, not the person's mailbox). So the
--   lookup matched nothing, user_business_ids() came back empty, and RLS denied
--   every read and write.
--
--   The one thing that does line up is the phone: `250700000000` in the JWT
--   against `+250700000000` in public.users.
--
-- So membership resolves the caller by, in order: auth.uid() against any id
-- column public.users happens to have, then the JWT phone, then the phone
-- encoded in a synthetic `<phone>@flipper.rw` email (used when a session carries
-- no phone claim), then a literal email match. This is the same set of login
-- keys UserRepository._resolveLoginKey already trusts to identify a session.
--
-- Scope is unchanged from 0001's intent: a row is only reachable by someone the
-- database can tie to the business that owns it.
--
-- These are HR-specific functions (hr_ prefix) on purpose. Redefining the shared
-- current_app_user_id() / user_business_ids() would silently change whatever
-- else uses them, logs RLS included — though note that those helpers are broken
-- for the same reason, so any policy relying on them is currently denying
-- everything too.
--
-- Columns are read through to_jsonb(row) ->> 'name' rather than named directly,
-- so a project where public.users spells these columns differently still gets a
-- function that creates and runs.
--
-- PARTLY SUPERSEDED BY 0003: the `<phone>@flipper.rw` reading below is wrong.
-- Those synthetic keys are `<pin>@flipper.rw` (public.pins.pin), so the local
-- part is a PIN, not a phone number — and matching users.email against the key
-- resolves a users row that owns nothing. 0003 replaces hr_identity_keys() with
-- a pins.user_id hop. Apply 0002 first (it creates hr_phones_match, the
-- policies and hr_whoami), then 0003.
--
-- Safe to re-run: everything here is create-or-replace / drop-then-create.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Phone comparison
-- -----------------------------------------------------------------------------
-- Digits only, then a suffix test, so `+250700000000`, `250700000000` and
-- `0700000000` all match each other. Suffix rather than "last 9 digits equal",
-- which would wrongly equate +250700000000 with +254700000000 — same trailing
-- nine, different country.
create or replace function public.hr_phones_match(a text, b text)
returns boolean
language sql
immutable
as $$
  with d as (
    select
      regexp_replace(coalesce(a, ''), '\D', '', 'g') as da,
      regexp_replace(coalesce(b, ''), '\D', '', 'g') as db
  )
  select
    length(da) >= 9
    and length(db) >= 9
    and (da = db or da like '%' || db or db like '%' || da)
  from d;
$$;

comment on function public.hr_phones_match(text, text) is
  'True when two phone strings denote the same number, ignoring formatting and country-code prefixes.';


-- -----------------------------------------------------------------------------
-- Identity: who is calling, in every id shape this schema might store
-- -----------------------------------------------------------------------------
create or replace function public.hr_identity_keys()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  with claims as (
    select
      auth.uid()::text                          as uid,
      nullif(auth.jwt() ->> 'phone', '')        as phone,
      nullif(lower(auth.jwt() ->> 'email'), '') as email
  ),
  resolved as (
    select
      c.*,
      -- A synthetic `<phone>@flipper.rw` login key carries the phone in its
      -- local part; that is the only phone some sessions expose.
      case
        when c.email like '%@flipper.rw'
        then split_part(c.email, '@', 1)
      end as email_phone
    from claims c
  ),
  me as (
    select distinct to_jsonb(u) as j
    from public.users u, resolved r
    where
      (r.uid is not null and (to_jsonb(u) ->> 'uuid')    = r.uid)
      or (r.uid is not null and (to_jsonb(u) ->> 'id')      = r.uid)
      or (r.uid is not null and (to_jsonb(u) ->> 'user_id') = r.uid)
      or (r.uid is not null and (to_jsonb(u) ->> 'uid')     = r.uid)
      or public.hr_phones_match(
           coalesce(to_jsonb(u) ->> 'phone_number', to_jsonb(u) ->> 'phone'),
           r.phone
         )
      or public.hr_phones_match(
           coalesce(to_jsonb(u) ->> 'phone_number', to_jsonb(u) ->> 'phone'),
           r.email_phone
         )
      or (r.email is not null
          and lower(coalesce(to_jsonb(u) ->> 'email', '')) = r.email)
  )
  select distinct k.key
  from me,
       lateral (values
         (me.j ->> 'id'),
         (me.j ->> 'uuid'),
         (me.j ->> 'user_id'),
         (me.j ->> 'uid')
       ) as k(key)
  where k.key is not null and k.key <> '';
$$;

comment on function public.hr_identity_keys() is
  'Identifiers for the calling user, resolved from auth.uid() or the JWT phone/email. HR-specific; does not replace current_app_user_id().';


-- -----------------------------------------------------------------------------
-- Membership: businesses owned by the caller
-- -----------------------------------------------------------------------------
create or replace function public.hr_user_business_ids()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  select b.id::text
  from public.businesses b
  where (to_jsonb(b) ->> 'user_id') in (select public.hr_identity_keys())
$$;

comment on function public.hr_user_business_ids() is
  'Business ids the calling user owns, via hr_identity_keys(). Used by hr_employees RLS.';


-- -----------------------------------------------------------------------------
-- Diagnostic: what the server resolves for the caller
-- -----------------------------------------------------------------------------
-- Returns nulls and empty arrays when run as the service role, because
-- auth.uid() is null there. Use the impersonation recipe at the bottom.
create or replace function public.hr_whoami()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'auth_uid',      auth.uid(),
    'jwt_role',      auth.jwt() ->> 'role',
    'jwt_phone',     auth.jwt() ->> 'phone',
    'jwt_email',     auth.jwt() ->> 'email',
    'identity_keys', (select coalesce(jsonb_agg(k), '[]'::jsonb)
                        from public.hr_identity_keys() k),
    'business_ids',  (select coalesce(jsonb_agg(b), '[]'::jsonb)
                        from public.hr_user_business_ids() b)
  );
$$;

comment on function public.hr_whoami() is
  'Diagnostic for hr_employees RLS: shows the caller as the policies see them.';

revoke all on function public.hr_phones_match(text, text) from public, anon;
revoke all on function public.hr_identity_keys()          from public, anon;
revoke all on function public.hr_user_business_ids()      from public, anon;
revoke all on function public.hr_whoami()                 from public, anon;
grant execute on function public.hr_phones_match(text, text) to authenticated;
grant execute on function public.hr_identity_keys()          to authenticated;
grant execute on function public.hr_user_business_ids()      to authenticated;
grant execute on function public.hr_whoami()                 to authenticated;


-- -----------------------------------------------------------------------------
-- Repoint the policies
-- -----------------------------------------------------------------------------
drop policy if exists hr_employees_select on public.hr_employees;
create policy hr_employees_select
  on public.hr_employees
  for select
  to authenticated
  using (business_id::text in (select public.hr_user_business_ids()));

drop policy if exists hr_employees_insert on public.hr_employees;
create policy hr_employees_insert
  on public.hr_employees
  for insert
  to authenticated
  with check (business_id::text in (select public.hr_user_business_ids()));

drop policy if exists hr_employees_update on public.hr_employees;
create policy hr_employees_update
  on public.hr_employees
  for update
  to authenticated
  using (business_id::text in (select public.hr_user_business_ids()))
  with check (business_id::text in (select public.hr_user_business_ids()));


-- =============================================================================
-- Verify — run after applying. Substitute your own values for the placeholders;
-- do not commit real phone numbers or user ids back into this file.
-- =============================================================================
-- 1. The Supabase auth user for the account that hit the 403:
--
--      select id, phone, email, created_at
--        from auth.users
--       where phone like '%<last 9 digits>%'
--          or email like '%<last 9 digits>%'
--       order by created_at desc;
--
-- 2. The matching app user, and which columns are actually populated:
--
--      select to_jsonb(u) from public.users u
--       where public.hr_phones_match(u.phone_number, '<phone from step 1>');
--
-- 3. Who owns the business the app is writing to:
--
--      select id, name, user_id from public.businesses
--       where id::text = '<business uuid the client sent>';
--
--    businesses.user_id must equal one of the ids from step 2 (id, uuid,
--    user_id or uid). If it does not, that join is the line to change in
--    hr_user_business_ids().
--
-- 4. Impersonate the caller and confirm the policies agree:
--
--      begin;
--        select set_config(
--          'request.jwt.claims',
--          json_build_object(
--            'sub',   '<auth uuid from step 1>',
--            'role',  'authenticated',
--            'phone', '<phone from step 1>',
--            'email', '<email from step 1>'
--          )::text,
--          true
--        );
--        set local role authenticated;
--
--        select public.hr_whoami();   -- identity_keys AND business_ids non-empty
--
--        -- The real test: does an insert pass the policy?
--        insert into public.hr_employees
--          (business_id, branch_id, first_name, last_name, job_title, hire_date)
--        values
--          ('<business uuid>', '<branch uuid>', 'RLS', 'Smoke test', 'Test',
--           current_date)
--        returning id;
--      rollback;                      -- nothing is kept
--
--    identity_keys empty  -> no link resolved; compare steps 1 and 2.
--    business_ids empty   -> businesses.user_id holds something else; see (3).
-- =============================================================================
