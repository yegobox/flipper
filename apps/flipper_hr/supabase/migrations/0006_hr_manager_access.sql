-- =============================================================================
-- 0006 — make the invited HR manager role actually work
-- =============================================================================
-- Apply after 0005.
--
-- The bug: HrRole.manager promises "roster and approvals" and the invite duly
-- writes an `accesses` row for it (feature_name 'HR', access_level 'admin',
-- status 'active', via create_agent). But NO HR policy has ever read `accesses`.
-- Every one of them scopes on hr_user_business_ids(), which resolved businesses
-- by OWNERSHIP alone — `businesses.user_id` being the caller. So an invited
-- manager signed in, got an empty business list, and saw only their own leave and
-- their own time. The role label promised authority the database did not grant.
--
-- The fix: hr_user_business_ids() now answers "which businesses may this caller
-- act in as HR?" — owned, OR carrying a live HR/admin grant. Nothing else
-- changes, because every HR policy already routes through this one function.
--
-- BLAST RADIUS — everything that inherits this, deliberately:
--
--   0002  hr_employees        select / insert / update   → the roster, INCLUDING
--                                                          salary and national id
--   0004  hr_leave_requests   select / insert / update   → approvals
--   0005  hr_attendance_*     select / insert / update   → board and corrections
--
-- That is the whole of "roster and approvals", which is what the role says. Note
-- the salary consequence explicitly: an HR manager can read and edit pay. If that
-- is not wanted, the answer is a narrower grant (a separate feature name for pay,
-- with its own column-level policy), not a quieter version of this function.
--
-- Why keying on feature_name = 'HR' is safe: it is not one of Flipper's POS
-- features (see AppFeature in flipper_services/constants.dart — Sales, Inventory,
-- Reports, ...). Only an HR invite writes it, so this cannot silently promote an
-- existing POS user.
--
-- Types are read through to_jsonb(row) ->> 'col' and compared as text on purpose.
-- The schema snapshot in the project's root supabase/migrations declares
-- accesses.user_id / business_id as bigint, while production carries uuid
-- business ids — that snapshot is stale, and a hard-typed comparison would fail
-- on one of the two.
--
-- Rollback (returns to ownership-only):
--   see the ownership-only body at the bottom of this file.
--
-- Safe to re-run.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- A live HR manager grant
-- -----------------------------------------------------------------------------
-- Requirements, each for a reason:
--
--   feature_name  = 'HR'      the grant HR issues; nothing else uses it
--   access_level  = 'admin'   HrRole.manager. 'read' is what STAFF get, and must
--                             not carry business scope — staff self-service comes
--                             from hr_my_employee_ids() instead
--   status        = 'active'  revoking means moving it off 'active' (or deleting
--                             it). A null status does NOT count as active: an
--                             HR grant is always written with one, so a null
--                             there is a row of unknown provenance
--   expires_at    unexpired   honoured when present
--
-- Comparisons are case-insensitive because these strings come from app code, not
-- from a CHECK constraint.
create or replace function public.hr_manager_business_ids()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  select distinct (to_jsonb(a) ->> 'business_id')
    from public.accesses a
   where (to_jsonb(a) ->> 'user_id') in (select public.hr_identity_keys())
     and lower(coalesce(to_jsonb(a) ->> 'feature_name', '')) = 'hr'
     and lower(coalesce(to_jsonb(a) ->> 'access_level', '')) = 'admin'
     and lower(coalesce(to_jsonb(a) ->> 'status', '')) = 'active'
     and (
       (to_jsonb(a) ->> 'expires_at') is null
       or (to_jsonb(a) ->> 'expires_at')::timestamptz > now()
     )
     and (to_jsonb(a) ->> 'business_id') is not null
$$;

comment on function public.hr_manager_business_ids() is
  'Businesses where the caller holds a live HR/admin grant in public.accesses. The invited-manager half of hr_user_business_ids().';


-- -----------------------------------------------------------------------------
-- Businesses the caller may act in as HR: owned, or managed
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
  union
  select m from public.hr_manager_business_ids() m
$$;

comment on function public.hr_user_business_ids() is
  'Businesses the caller may act in as HR: owned outright, or held via a live HR/admin grant in accesses. Used by every hr_* policy.';

revoke all on function public.hr_manager_business_ids() from public, anon;
grant execute on function public.hr_manager_business_ids() to authenticated;


-- -----------------------------------------------------------------------------
-- Diagnostics: separate the two halves
-- -----------------------------------------------------------------------------
-- hr_whoami() and hr_whoami_employee() both report business_ids through the
-- function above, so they pick this up for free. What they could not show is WHY
-- a business is listed, which is the first question when a manager sees too much
-- or too little.
create or replace function public.hr_whoami_access()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'identity_keys',  (select coalesce(jsonb_agg(k), '[]'::jsonb)
                         from public.hr_identity_keys() k),
    'owned',          (select coalesce(jsonb_agg(b.id::text), '[]'::jsonb)
                         from public.businesses b
                        where (to_jsonb(b) ->> 'user_id')
                              in (select public.hr_identity_keys())),
    'managed',        (select coalesce(jsonb_agg(m), '[]'::jsonb)
                         from public.hr_manager_business_ids() m),
    'effective',      (select coalesce(jsonb_agg(e), '[]'::jsonb)
                         from public.hr_user_business_ids() e),
    'employee_ids',   (select coalesce(jsonb_agg(e), '[]'::jsonb)
                         from public.hr_my_employee_ids() e)
  );
$$;

comment on function public.hr_whoami_access() is
  'Diagnostic: which HR businesses are owned, which are managed via accesses, and the union the policies use.';

revoke all on function public.hr_whoami_access() from public, anon;
grant execute on function public.hr_whoami_access() to authenticated;


-- =============================================================================
-- Verify
-- =============================================================================
-- As the invited manager:
--
--   begin;
--     select set_config('request.jwt.claims', json_build_object(
--       'sub','<their auth uuid>','role','authenticated',
--       'email','<their pin>@flipper.rw')::text, true);
--     set local role authenticated;
--
--     select public.hr_whoami_access();
--     -- owned: []            (they own nothing — correct)
--     -- managed: [<business>] (the HR/admin grant)
--     -- effective: the same one business
--
--     select count(*) from public.hr_employees;        -- the branch roster
--     update public.hr_leave_requests                  -- and they may decide
--        set status = 'approved', decided_at = now(), decided_by = 'x'
--      where status = 'pending';
--   rollback;
--
-- As an invited STAFF member, the same block must show managed: [] — their grant
-- is 'read', which carries no business scope:
--
--   select public.hr_whoami_access();
--
-- If managed is empty for someone who should be a manager, look at the grant:
--
--   select business_id, feature_name, access_level, status, expires_at
--     from public.accesses
--    where user_id::text in (select public.hr_identity_keys());
--
-- The usual causes are access_level 'write' rather than 'admin' (re-invite as a
-- manager), or a status that is not 'active'.
--
-- -----------------------------------------------------------------------------
-- Rollback body — ownership only, as 0003 left it
-- -----------------------------------------------------------------------------
--   create or replace function public.hr_user_business_ids()
--   returns setof text language sql stable security definer set search_path = ''
--   as $$
--     select b.id::text from public.businesses b
--      where (to_jsonb(b) ->> 'user_id') in (select public.hr_identity_keys())
--   $$;
-- =============================================================================
