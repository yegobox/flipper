-- =============================================================================
-- 0010 — let the Flipper mobile app's Supabase session reach HR
-- =============================================================================
-- Apply after 0009. Needed for HR under More → Apps in the mobile app.
--
-- The mobile app does not use the web PIN + OTP session. It signs into
-- Supabase on its own (flipper_services SupabaseSessionService) as
-- `<phone digits>@flipper.rw`. Since 0003 the local part of a
-- `…@flipper.rw` key is read only as a PIN, so that session resolved no
-- identity: an empty roster and 403s on every HR table.
--
-- This adds one path and changes nothing else: a local part of 9+ digits is
-- also tried as a phone, through the same hr_phones_match() / users-family
-- expansion 0003 uses for the PIN row's phone. PIN keys (short ints) behave
-- exactly as before.
--
-- KNOWN RISK, accepted deliberately (2026-10-08): that mobile account's
-- password is its own email (SupabaseSessionService.ensureAccessToken signs up
-- and in with password = email). Anyone who knows an owner's phone number can
-- therefore obtain this session and, with this migration, read that business's
-- HR rows — salaries, national IDs, bank details. The web session is not
-- affected (flipper-turbo mints it after PIN + OTP). The fix is to give mobile
-- HR the server-minted session: keep the refreshToken /v2/api/login/verify-otp
-- already returns at mobile login, use it for HR's Supabase client, and then
-- revert this migration.
-- =============================================================================

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
      -- `<pin>@flipper.rw` -> the PIN; `<phone digits>@flipper.rw` from the
      -- mobile app -> a phone, tried in `phones` below (0010).
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
    -- 0010: the mobile app's session, `<phone digits>@flipper.rw`. PINs are
    -- short ints, and hr_phones_match() ignores anything under 9 digits.
    union select s.login_key from parsed s where s.login_key ~ '^[0-9]{9,}$'
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
  'Identifiers for the calling user: auth.uid(), the pins row behind a <pin>@flipper.rw login key, the phone behind a mobile <phone>@flipper.rw key (0010), and any users row sharing that person''s phone number. HR-specific.';

-- Policies are unchanged — they call hr_user_business_ids(), which calls this.


-- =============================================================================
-- Verify
-- =============================================================================
-- Impersonate a mobile session (no phone claim, phone-digits email). Use a
-- real owner's number; it should list that owner's business:
--
--   begin;
--   select set_config('request.jwt.claims',
--     '{"sub":"00000000-0000-0000-0000-000000000000","role":"authenticated","email":"250788000000@flipper.rw"}',
--     true);
--   set local role authenticated;
--   select public.hr_whoami();
--   select * from public.hr_user_business_ids();
--   rollback;
--
-- And a web PIN session must resolve exactly as it did under 0003:
--   same block with "email":"<pin>@flipper.rw".
