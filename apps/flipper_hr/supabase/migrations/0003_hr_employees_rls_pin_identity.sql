-- =============================================================================
-- 0003 — resolve the caller through pins.pin, not a phone in the email
-- =============================================================================
-- Apply after 0002. Read-only diagnosis that led here, from the app's own
-- "Why was this denied?" report on a live session:
--
--     session: present
--     role: authenticated
--     sub: <an app user uuid>
--     phone: absent                     <- no phone claim at all
--     email: present (…3456@flipper.rw) <- <pin>@flipper.rw
--     server identity_keys: <that same uuid, and nothing else>
--     server business_ids: NONE
--
-- Two things were wrong in 0002:
--
--   1. It treated a `<something>@flipper.rw` login key as `<phone>@flipper.rw`
--      and tried to read a phone number out of the local part. Those keys are
--      `<pin>@flipper.rw` — the local part is a PIN (public.pins.pin, an int), not a
--      phone. The extraction produced a 6-digit string that matched no phone.
--
--   2. Falling back to `users.email = <jwt email>` then resolved the WRONG app
--      user: there is a public.users row whose email literally is the synthetic
--      key, and that row owns no business. So identity resolved (one key) while
--      business_ids stayed empty, and every write was denied.
--
-- The client already knows the correct hop. For a `@flipper.rw` login key,
-- flipper_web skips POST /v2/api/user and resolves the profile through
-- `pins.user_id` (UserRepository.fetchAndSaveUserProfile logs "Skipping
-- /v2/api/user for Ditto login key ...; using pins.user_id="). This migration
-- makes RLS take the same hop, so the database agrees with the app about who is
-- calling.
--
-- It also treats the phone number as the account's real identity, per how the
-- login key is normalised (api_login_key.dart) — compared on digits only, so a
-- stored `+250…` matches a claim or a pins row without the `+`. That matters
-- because public.users holds more than one row for the same person, and only one
-- of them owns the business.
--
-- Security shape, stated plainly: holding a PIN grants the businesses owned by
-- the app user that PIN points at, plus any users row sharing that person's
-- phone number. That is the same identity model the app itself applies — the PIN
-- is what signs you in — not a widening of it.
--
-- Self-contained: it defines public.hr_phones_match() rather than assuming 0002
-- created it (0002 was revised mid-rollout, and only its later form had that
-- helper). It does still need 0002's policies and hr_user_business_ids(), which
-- the first form of 0002 created.
--
-- Safe to re-run.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Phone comparison (defined here, not assumed)
-- -----------------------------------------------------------------------------
-- 0002 went through a revision: its first form compared phones inline, and only
-- the later form added this helper. Rather than depend on which revision landed,
-- 0003 defines it. Harmless if it already exists.
--
-- Digits only, then a suffix test, so `+250700000000`, `250700000000` and
-- `0700000000` all match. Suffix rather than "last 9 digits equal", which would
-- wrongly equate +250700000000 with +254700000000 — same trailing nine,
-- different country.
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

revoke all on function public.hr_phones_match(text, text) from public, anon;
grant execute on function public.hr_phones_match(text, text) to authenticated;


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
  parsed as (
    select
      c.*,
      -- `<pin>@flipper.rw` -> the PIN. Never a phone number.
      case
        when c.email like '%@flipper.rw' then split_part(c.email, '@', 1)
      end as login_key
    from claims c
  ),
  -- The PIN row this session signed in with. pins carries user_id, phone_number
  -- and business_id (see supabase_models Pin model).
  pin_rows as (
    select to_jsonb(p) as j
      from public.pins p, parsed s
     where s.login_key is not null
       and (to_jsonb(p) ->> 'pin') = s.login_key
  ),
  -- Ids the session hands us directly.
  direct as (
    select s.uid as key from parsed s where s.uid is not null
    union select (j ->> 'user_id') from pin_rows
    union select (j ->> 'uid')     from pin_rows
  ),
  -- Every phone this session can be tied to: the JWT claim when present, and
  -- the one recorded on the PIN row when it is not.
  phones as (
    select s.phone as phone from parsed s where s.phone is not null
    union select (j ->> 'phone_number') from pin_rows
  ),
  -- App user rows reachable from the session.
  seed as (
    select to_jsonb(u) as j
      from public.users u
     where (to_jsonb(u) ->> 'id')      in (select key from direct)
        or (to_jsonb(u) ->> 'uuid')    in (select key from direct)
        or (to_jsonb(u) ->> 'user_id') in (select key from direct)
        or exists (
             select 1 from phones ph
              where public.hr_phones_match(
                      coalesce(to_jsonb(u) ->> 'phone_number',
                               to_jsonb(u) ->> 'phone'),
                      ph.phone)
           )
  ),
  -- The phone number is the account's identity, so rows sharing it are the same
  -- person. This is what bridges a PIN-resolved row to the sibling row that
  -- actually owns the business.
  family as (
    select j from seed
    union
    select to_jsonb(u)
      from public.users u
     where exists (
             select 1 from seed s
              where public.hr_phones_match(
                      coalesce(to_jsonb(u) ->> 'phone_number',
                               to_jsonb(u) ->> 'phone'),
                      coalesce(s.j ->> 'phone_number',
                               s.j ->> 'phone'))
           )
  )
  select distinct k.key
    from (
      select f.j ->> 'id'      as key from family f
      union select f.j ->> 'uuid'     from family f
      union select f.j ->> 'user_id'  from family f
      union select d.key              from direct d
    ) k
   where k.key is not null and k.key <> '';
$$;

comment on function public.hr_identity_keys() is
  'Identifiers for the calling user: auth.uid(), the pins row behind a <pin>@flipper.rw login key, and any users row sharing that person''s phone number. HR-specific.';

-- Deliberately NOT matching users.email against the JWT email any more: for a
-- synthetic key there is a users row whose email IS that key, and it is not the
-- row that owns anything. Matching it resolved an identity that owned no
-- business, which is the bug 0003 fixes.

-- Policies are unchanged — they call hr_user_business_ids(), which calls this.


-- =============================================================================
-- Verify
-- =============================================================================
-- Impersonate the real session exactly as the diagnostic reported it — note NO
-- phone claim, and the synthetic email:
--
--   begin;
--     select set_config('request.jwt.claims', json_build_object(
--       'sub','<auth uuid>','role','authenticated',
--       'email','<pin>@flipper.rw')::text, true);
--     set local role authenticated;
--     select public.hr_whoami();
--     -- identity_keys should now include the app user that owns the business,
--     -- and business_ids must be non-empty.
--   rollback;
--
-- If business_ids is still empty, check that the PIN resolves at all:
--
--   select id, user_id, phone_number, business_id, branch_id
--     from public.pins where pin::text = '<pin>';
--
-- and that the owner lines up:
--
--   select id, name, user_id from public.businesses
--    where id::text = '<business uuid the client sent>';
-- =============================================================================
