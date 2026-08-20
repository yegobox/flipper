-- =============================================================================
-- 0004 — leave: requests, self-service identity, and the RLS to match
-- =============================================================================
-- Apply after 0003. Adds the second HR module: an employee books their own
-- leave and sees their own balance; whoever owns the business approves it.
--
-- Three things happen here, and the third is the interesting one:
--
--   1. public.hr_leave_requests — one row per request, with the decision on the
--      same row. No separate approvals table: a request has exactly one
--      decision, and splitting it would let the two disagree.
--
--   2. hr_employees.annual_leave_days — the per-person annual entitlement.
--      Nullable, and null means "use the statutory default" rather than "zero",
--      so existing rows keep the legal minimum without a backfill. Rwanda's
--      Law N° 66/2018 art. 63 sets 18 working days; the app's LeaveType carries
--      that default (lib/features/leave/data/leave_type.dart) and this column
--      only exists to override it for someone whose contract is better.
--
--   3. A SECOND identity path. Everything through 0003 answered one question:
--      "which businesses does the caller OWN?" That is the right question for
--      the roster, and the wrong one for an invited employee — they own nothing.
--      hr_my_employee_ids() answers "which hr_employees rows ARE the caller?",
--      and the leave policies below are written against whichever of the two
--      applies. An owner sees the branch; an employee sees themselves.
--
-- Security shape, stated plainly: an invited employee gains read access to their
-- own hr_employees row — salary and national id included — and full control of
-- their own pending leave requests. They gain nothing about anyone else. That is
-- narrower than the roster grant, not wider: the policies are separate, and
-- neither one implies the other.
--
-- Rollback:
--   drop table if exists public.hr_leave_requests;
--   alter table public.hr_employees drop column if exists annual_leave_days;
--   drop function if exists public.hr_my_employee_ids();
--   drop function if exists public.hr_identity_phones();
--   drop policy if exists hr_employees_select_self on public.hr_employees;
--
-- Safe to re-run.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Per-person annual entitlement
-- -----------------------------------------------------------------------------
alter table public.hr_employees
  add column if not exists annual_leave_days numeric(5, 1)
    check (annual_leave_days is null or annual_leave_days >= 0);

comment on column public.hr_employees.annual_leave_days is
  'Annual leave entitlement in working days. NULL means the statutory default (18) applies — not zero.';


-- -----------------------------------------------------------------------------
-- hr_leave_requests
-- -----------------------------------------------------------------------------
-- business_id / branch_id are denormalised onto every row on purpose: the RLS
-- policies compare business_id directly, and routing every check through a join
-- to hr_employees would make each policy a subquery on a table that has its own
-- policies. They are set from the employee's row by the trigger below, so they
-- cannot drift or be spoofed by a client that sends the wrong one.
--
-- days is stored, not computed: it is the number of WORKING days the request
-- consumes, which depends on a working-week (and, later, a holiday calendar)
-- that Postgres does not know about. The app computes it — see
-- leave_working_days.dart — and the CHECK only enforces that it is sane.
create table if not exists public.hr_leave_requests (
  id            uuid primary key default gen_random_uuid(),

  employee_id   uuid not null
                  references public.hr_employees(id) on delete cascade,
  business_id   uuid not null,
  branch_id     uuid not null,

  leave_type    text not null
                  check (leave_type in
                    ('annual', 'sick', 'maternity', 'paternity',
                     'compassionate', 'unpaid')),

  start_date    date not null,
  end_date      date not null,

  -- Working days consumed. Fractional so a half day is expressible later.
  days          numeric(5, 1) not null check (days > 0),

  reason        text not null default '',

  status        text not null default 'pending'
                  check (status in
                    ('pending', 'approved', 'rejected', 'cancelled')),

  -- Who asked and who decided, as public.users ids (the same thing
  -- hr_employees.user_id holds — NOT auth.uid()).
  requested_by  text,
  decided_by    text,
  decided_at    timestamptz,
  decision_note text not null default '',

  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),

  constraint hr_leave_end_after_start check (end_date >= start_date),

  -- A decision must record when it was made; a pending request must not claim
  -- one. Without this a rejected row can read as "decided by nobody, never".
  constraint hr_leave_decision_is_complete check (
    (status in ('pending', 'cancelled') and decided_at is null)
    or (status in ('approved', 'rejected') and decided_at is not null)
  )
);

comment on table public.hr_leave_requests is
  'Leave requests and their decisions. Employees insert their own (pending); the business owner approves or rejects.';

create index if not exists hr_leave_requests_employee_idx
  on public.hr_leave_requests (employee_id, start_date desc);

-- The approvals queue reads exactly this: one branch, still pending.
create index if not exists hr_leave_requests_branch_status_idx
  on public.hr_leave_requests (branch_id, status, start_date);


-- -----------------------------------------------------------------------------
-- Scope comes from the employee, never from the client
-- -----------------------------------------------------------------------------
-- A client that sent someone else's business_id alongside its own employee_id
-- would otherwise write a row the owner of neither business can see. Deriving
-- both ids from the referenced employee makes that unrepresentable.
create or replace function public.hr_leave_set_scope()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_business uuid;
  v_branch   uuid;
begin
  select e.business_id, e.branch_id
    into v_business, v_branch
    from public.hr_employees e
   where e.id = new.employee_id;

  if v_business is null then
    raise exception 'No such employee: %', new.employee_id;
  end if;

  new.business_id := v_business;
  new.branch_id   := v_branch;
  new.updated_at  := now();
  return new;
end;
$$;

drop trigger if exists hr_leave_requests_scope on public.hr_leave_requests;
create trigger hr_leave_requests_scope
  before insert or update on public.hr_leave_requests
  for each row execute function public.hr_leave_set_scope();


-- -----------------------------------------------------------------------------
-- Identity, second path: which employee rows ARE the caller?
-- -----------------------------------------------------------------------------
-- The phones a session can be tied to. 0003 works these out inside
-- hr_identity_keys() and does not expose them; leave needs them separately
-- because an employee invited through HR may have an hr_employees row whose
-- user_id was never filled in, and the phone is then the only link.
create or replace function public.hr_identity_phones()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  with claims as (
    select
      nullif(auth.jwt() ->> 'phone', '')        as phone,
      nullif(lower(auth.jwt() ->> 'email'), '') as email
  ),
  parsed as (
    select
      c.*,
      case when c.email like '%@flipper.rw'
           then split_part(c.email, '@', 1)
      end as login_pin
    from claims c
  ),
  -- The PIN row this session signed in with carries the number the OTP went to.
  pin_rows as (
    select to_jsonb(p) as j
      from public.pins p, parsed s
     where s.login_pin is not null
       and (to_jsonb(p) ->> 'pin') = s.login_pin
  )
  select distinct ph from (
    select s.phone as ph from parsed s where s.phone is not null
    union select (j ->> 'phone_number') from pin_rows
    -- Any users row already resolved for this caller.
    union select coalesce(to_jsonb(u) ->> 'phone_number', to_jsonb(u) ->> 'phone')
            from public.users u
           where (to_jsonb(u) ->> 'id')      in (select public.hr_identity_keys())
              or (to_jsonb(u) ->> 'uuid')    in (select public.hr_identity_keys())
              or (to_jsonb(u) ->> 'user_id') in (select public.hr_identity_keys())
  ) p
  where ph is not null and ph <> '';
$$;

comment on function public.hr_identity_phones() is
  'Phone numbers the calling session can be tied to: the JWT claim, the pins row behind a <pin>@flipper.rw key, and any resolved users row. HR-specific.';

-- The caller's own employee rows.
--
-- Matched on hr_employees.user_id first — that is what the invite writes back
-- (HrInviteStep.linkEmployee) and it is exact. The phone fallback covers the
-- person who was added to the roster before being invited, or invited from a
-- device that recorded a differently-formatted number; hr_phones_match compares
-- digits only, so +250…, 250… and 07… all resolve to the same person.
create or replace function public.hr_my_employee_ids()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  select e.id::text
    from public.hr_employees e
   where e.user_id in (select public.hr_identity_keys())
      or exists (
           select 1 from public.hr_identity_phones() ph
            where public.hr_phones_match(e.phone, ph)
         )
$$;

comment on function public.hr_my_employee_ids() is
  'hr_employees ids that ARE the calling user, by user_id or phone. The self-service counterpart to hr_user_business_ids().';

-- Diagnostic, matching hr_whoami()'s job for the roster: what does the server
-- resolve for a self-service session?
create or replace function public.hr_whoami_employee()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'auth_uid',      auth.uid(),
    'identity_keys', (select coalesce(jsonb_agg(k), '[]'::jsonb)
                        from public.hr_identity_keys() k),
    'phones',        (select coalesce(jsonb_agg(p), '[]'::jsonb)
                        from public.hr_identity_phones() p),
    'employee_ids',  (select coalesce(jsonb_agg(e), '[]'::jsonb)
                        from public.hr_my_employee_ids() e),
    'business_ids',  (select coalesce(jsonb_agg(b), '[]'::jsonb)
                        from public.hr_user_business_ids() b)
  );
$$;

comment on function public.hr_whoami_employee() is
  'Diagnostic for HR self-service RLS: shows the caller as the leave policies see them.';

revoke all on function public.hr_identity_phones()   from public, anon;
revoke all on function public.hr_my_employee_ids()   from public, anon;
revoke all on function public.hr_whoami_employee()   from public, anon;
grant execute on function public.hr_identity_phones() to authenticated;
grant execute on function public.hr_my_employee_ids() to authenticated;
grant execute on function public.hr_whoami_employee() to authenticated;


-- -----------------------------------------------------------------------------
-- hr_employees: let people read their own row
-- -----------------------------------------------------------------------------
-- Postgres ORs permissive policies together, so this widens SELECT without
-- touching the owner policy 0002 installed. It is SELECT only: an employee must
-- not be able to edit their own salary or job title.
drop policy if exists hr_employees_select_self on public.hr_employees;
create policy hr_employees_select_self
  on public.hr_employees
  for select
  to authenticated
  using (id::text in (select public.hr_my_employee_ids()));


-- -----------------------------------------------------------------------------
-- hr_leave_requests RLS
-- -----------------------------------------------------------------------------
alter table public.hr_leave_requests enable row level security;

revoke all on public.hr_leave_requests from public, anon;
grant select, insert, update on public.hr_leave_requests to authenticated;

-- Read: the owner sees the whole business, the employee sees their own.
drop policy if exists hr_leave_select on public.hr_leave_requests;
create policy hr_leave_select
  on public.hr_leave_requests
  for select
  to authenticated
  using (
    business_id::text in (select public.hr_user_business_ids())
    or employee_id::text in (select public.hr_my_employee_ids())
  );

-- Insert: for yourself, or by the owner on someone's behalf. Either way the row
-- starts pending — an employee must not be able to file pre-approved leave, and
-- an owner recording leave for someone still goes through the same approval so
-- the audit trail records who decided.
drop policy if exists hr_leave_insert on public.hr_leave_requests;
create policy hr_leave_insert
  on public.hr_leave_requests
  for insert
  to authenticated
  with check (
    status = 'pending'
    and (
      employee_id::text in (select public.hr_my_employee_ids())
      or employee_id::text in (
           select e.id::text from public.hr_employees e
            where e.business_id::text in (select public.hr_user_business_ids())
         )
    )
  );

-- Update, owner: approve or reject anything in the business.
drop policy if exists hr_leave_update_owner on public.hr_leave_requests;
create policy hr_leave_update_owner
  on public.hr_leave_requests
  for update
  to authenticated
  using (business_id::text in (select public.hr_user_business_ids()))
  with check (business_id::text in (select public.hr_user_business_ids()));

-- Update, self: withdraw a request that has not been decided yet.
--
-- USING restricts it to your own pending rows; WITH CHECK restricts the result
-- to cancelled. Together they say "you may cancel your own pending request and
-- nothing else" — in particular you cannot approve it, because 'approved' fails
-- the WITH CHECK.
drop policy if exists hr_leave_cancel_self on public.hr_leave_requests;
create policy hr_leave_cancel_self
  on public.hr_leave_requests
  for update
  to authenticated
  using (
    status = 'pending'
    and employee_id::text in (select public.hr_my_employee_ids())
  )
  with check (
    status = 'cancelled'
    and employee_id::text in (select public.hr_my_employee_ids())
  );

-- No DELETE policy, and none is wanted: a withdrawn request is cancelled, not
-- erased. Leave history is payroll evidence.


-- =============================================================================
-- Verify
-- =============================================================================
-- As an invited employee (no business ownership at all):
--
--   begin;
--     select set_config('request.jwt.claims', json_build_object(
--       'sub','<their auth uuid>','role','authenticated',
--       'email','<their pin>@flipper.rw')::text, true);
--     set local role authenticated;
--
--     select public.hr_whoami_employee();
--     -- employee_ids: exactly one, theirs.  business_ids: [] — expected.
--
--     -- They can see themselves...
--     select id, first_name from public.hr_employees;          -- 1 row
--     -- ...and book their own leave.
--     insert into public.hr_leave_requests
--       (employee_id, business_id, branch_id, leave_type, start_date, end_date, days)
--     values ('<their employee id>', '<any uuid>', '<any uuid>', 'annual',
--             current_date, current_date + 2, 3)
--     returning id, business_id;   -- business_id is the employee's, not the uuid sent
--
--     -- ...but not approve it.
--     update public.hr_leave_requests
--        set status = 'approved', decided_at = now();           -- 0 rows
--   rollback;
--
-- If employee_ids is empty, the link is missing. Check both hops:
--
--   select id, phone, user_id from public.hr_employees where id = '<id>';
--   select public.hr_identity_keys(), public.hr_identity_phones();
--
-- user_id null AND no phone match is the usual cause — invite the person from
-- HR (which writes user_id back), or correct the phone on their record.
-- =============================================================================
