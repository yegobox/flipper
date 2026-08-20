-- =============================================================================
-- 0007 — the reporting line: leave goes to your direct manager
-- =============================================================================
-- Apply after 0006.
--
-- The gap this closes: approving leave was a property of the BUSINESS, not of a
-- relationship. `hr_leave_update_owner` (0004) lets anyone in
-- hr_user_business_ids() decide any request in the business, and nothing else
-- can decide at all. So the only way to let a shift supervisor approve their own
-- team's leave was to invite them as HrRole.manager — which hands them the whole
-- roster, salaries included (see the BLAST RADIUS note in 0006). A record had no
-- notion of who someone reports to, so the queue could not say who a request was
-- waiting on.
--
-- What this adds:
--
--   * hr_employees.manager_id — the direct manager, a self-reference on the same
--     table. Nullable: someone with no manager (the owner, a new hire not yet
--     placed) falls back to the business-wide approvers, which is the behaviour
--     that exists today.
--   * A manager may read and decide the leave of anyone below them, WITHOUT any
--     business scope and without seeing pay. That is the whole point: the
--     authority comes from the relationship, not from a grant.
--   * hr_my_line() — the non-sensitive slice of the people a caller is tied to
--     (themselves, their manager, their reports), so a line manager can put a
--     name on a request without being able to read salary. Deliberately NOT a
--     new SELECT policy on hr_employees: a row-level grant there would expose
--     base_salary, national_id and bank details to every team lead, which is the
--     narrower-grant argument 0006's header makes.
--
-- What this deliberately does NOT change:
--
--   * Owners and invited HR managers keep business-wide approval. A line manager
--     going on leave themselves, or sitting on a request, must not deadlock the
--     business — hr_leave_update_owner stays exactly as it was. The app shows
--     whose queue a request is really in so an owner overriding knows they are
--     overriding.
--   * Editing the roster. Only business-scoped HR sets manager_id, because
--     hr_employees INSERT/UPDATE is unchanged — a manager cannot re-parent
--     themselves onto a richer team.
--   * Attendance. Corrections stay business-scoped; only leave is delegated.
--
-- Nobody can approve their own leave through the new path: hr_my_report_ids()
-- excludes the caller's own rows, and the cycle trigger makes a self-referencing
-- chain impossible in the first place.
--
-- Rollback:
--   drop policy if exists hr_leave_select_reports  on public.hr_leave_requests;
--   drop policy if exists hr_leave_update_manager  on public.hr_leave_requests;
--   drop trigger if exists hr_employees_no_manager_cycle on public.hr_employees;
--   drop function if exists public.hr_employees_no_manager_cycle();
--   drop function if exists public.hr_my_line();
--   drop function if exists public.hr_my_report_ids();
--   drop function if exists public.hr_my_manager_ids();
--   alter table public.hr_employees drop column if exists manager_id;
--   -- then re-apply 0004's hr_leave_insert to drop the report clause.
--
-- Safe to re-run.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- hr_employees.manager_id
-- -----------------------------------------------------------------------------
-- A real foreign key, unlike business_id / branch_id: the target is a row in
-- this same table, so there is no Ditto-authoritative-elsewhere problem to work
-- around. ON DELETE SET NULL rather than CASCADE — losing a manager's record
-- must orphan their team back to business-wide approval, never delete the team.
alter table public.hr_employees
  add column if not exists manager_id uuid;

do $$
begin
  alter table public.hr_employees
    add constraint hr_employees_manager_fk
    foreign key (manager_id) references public.hr_employees (id)
    on delete set null;
exception
  when duplicate_object then null;
end;
$$;

-- The one-hop cycle. Longer ones need the trigger below, but this one is worth a
-- constraint: it is the mistake a UI bug actually makes, and a CHECK is enforced
-- even by a data load that disables triggers.
do $$
begin
  alter table public.hr_employees
    add constraint hr_employees_manager_not_self
    check (manager_id is null or manager_id <> id);
exception
  when duplicate_object then null;
end;
$$;

-- Partial: the interesting query is "who reports to X", and rows with no manager
-- are never the answer.
create index if not exists hr_employees_manager_idx
  on public.hr_employees (manager_id)
  where manager_id is not null;

comment on column public.hr_employees.manager_id is
  'Direct manager, an hr_employees row. Null means no line manager, so leave falls back to the business-wide approvers. Cycles are refused by hr_employees_no_manager_cycle.';


-- -----------------------------------------------------------------------------
-- No loops in the reporting line
-- -----------------------------------------------------------------------------
-- A → B → A is not just untidy: hr_my_report_ids() walks the chain downward, and
-- a cycle would make everyone in it their own report — which would let them
-- approve their own leave. So this is a permission boundary, not data hygiene.
--
-- Walks upward from the proposed manager and refuses if it arrives back at the
-- row being written. The depth cap is a backstop for a cycle that predates the
-- trigger; a real org chart is nowhere near 64 deep.
create or replace function public.hr_employees_no_manager_cycle()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  v_next uuid := new.manager_id;
  v_hops int  := 0;
begin
  while v_next is not null loop
    if v_next = new.id then
      raise exception
        'That reporting line loops back to the same person'
        using errcode = 'check_violation';
    end if;

    v_hops := v_hops + 1;
    if v_hops > 64 then
      raise exception
        'That reporting line is more than 64 managers deep, so it loops'
        using errcode = 'check_violation';
    end if;

    -- SELECT INTO with no matching row assigns null, which ends the walk.
    select e.manager_id into v_next
      from public.hr_employees e
     where e.id = v_next;
  end loop;

  return new;
end;
$$;

comment on function public.hr_employees_no_manager_cycle() is
  'BEFORE trigger on hr_employees.manager_id: refuses a reporting line that loops. A cycle would make people their own reports, and so their own approvers.';

drop trigger if exists hr_employees_no_manager_cycle on public.hr_employees;
create trigger hr_employees_no_manager_cycle
  before insert or update of manager_id on public.hr_employees
  for each row
  when (new.manager_id is not null)
  execute function public.hr_employees_no_manager_cycle();


-- -----------------------------------------------------------------------------
-- Identity, third path: who reports to the caller?
-- -----------------------------------------------------------------------------
-- 0004 answered "which rows ARE me" (hr_my_employee_ids) and 0006 answered
-- "which businesses may I act in" (hr_user_business_ids). This answers "whose
-- work do I answer for", which is what leave approval should have keyed on all
-- along.
--
-- Recursive, so a manager's manager can approve too. That is not scope creep: a
-- supervisor on leave, off sick or gone must not leave their team unable to book
-- anything, and an org chart already says the person above them is accountable.
-- The caller's own rows are the recursion's anchor and are then excluded from the
-- result — they are not their own report, and self-approval must stay impossible.
create or replace function public.hr_my_report_ids()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  with recursive mine as (
    select e.id
      from public.hr_employees e
     where e.id::text in (select public.hr_my_employee_ids())
    union
    select below.id
      from public.hr_employees below
      join mine m on below.manager_id = m.id
  )
  select m.id::text
    from mine m
   where m.id::text not in (select public.hr_my_employee_ids());
$$;

comment on function public.hr_my_report_ids() is
  'hr_employees ids at or below the caller in the reporting line, excluding the caller. What the leave-approval policies for a line manager key on.';

-- The direct managers of the caller's own rows. Display only — it is how the
-- self-service page can say who a request is waiting on.
create or replace function public.hr_my_manager_ids()
returns setof text
language sql
stable
security definer
set search_path = ''
as $$
  select distinct e.manager_id::text
    from public.hr_employees e
   where e.id::text in (select public.hr_my_employee_ids())
     and e.manager_id is not null;
$$;

comment on function public.hr_my_manager_ids() is
  'The direct managers of the caller''s own employee rows. Display only: it names who will decide their leave.';

revoke all on function public.hr_my_report_ids()  from public, anon;
revoke all on function public.hr_my_manager_ids() from public, anon;
grant execute on function public.hr_my_report_ids()  to authenticated;
grant execute on function public.hr_my_manager_ids() to authenticated;


-- -----------------------------------------------------------------------------
-- hr_my_line() — names, without pay
-- -----------------------------------------------------------------------------
-- The people a caller is tied to by the reporting line: themselves, their
-- manager, and everyone below them. Returns the columns needed to render a name
-- on an approval card and nothing else.
--
-- A function rather than a SELECT policy on hr_employees, because policies are
-- row-level: granting a team lead the right to see their report's row grants them
-- base_salary, national_id, rssb_number and bank_account along with the name.
-- Column-level privileges cannot express "these columns for these rows", so the
-- projection lives here, where security definer can be audited in one place.
--
-- No salary. If a line manager is ever meant to see pay, that is a deliberate
-- feature with its own function — not a column quietly added to this list.
create or replace function public.hr_my_line()
returns table (
  id          text,
  business_id text,
  branch_id   text,
  first_name  text,
  last_name   text,
  job_title   text,
  department  text,
  status      text,
  manager_id  text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    e.id::text,
    e.business_id::text,
    e.branch_id::text,
    e.first_name,
    e.last_name,
    e.job_title,
    e.department,
    e.status,
    e.manager_id::text
  from public.hr_employees e
  where e.id::text in (select public.hr_my_employee_ids())
     or e.id::text in (select public.hr_my_manager_ids())
     or e.id::text in (select public.hr_my_report_ids())
  order by e.first_name, e.last_name;
$$;

comment on function public.hr_my_line() is
  'The caller''s own row, their manager and all their reports, projected to non-sensitive columns (no pay, no national id, no bank). Lets a line manager name a request without reading the roster.';

revoke all on function public.hr_my_line() from public, anon;
grant execute on function public.hr_my_line() to authenticated;


-- -----------------------------------------------------------------------------
-- hr_whoami_employee(): report and manager ids
-- -----------------------------------------------------------------------------
-- Recreated with two more keys. The client reads this once per sign-in to decide
-- which modules to show, and "do I have reports?" is now one of those decisions —
-- a line manager with no business scope still needs the approvals tab.
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
    'manager_ids',   (select coalesce(jsonb_agg(m), '[]'::jsonb)
                        from public.hr_my_manager_ids() m),
    'report_ids',    (select coalesce(jsonb_agg(r), '[]'::jsonb)
                        from public.hr_my_report_ids() r),
    'business_ids',  (select coalesce(jsonb_agg(b), '[]'::jsonb)
                        from public.hr_user_business_ids() b)
  );
$$;

comment on function public.hr_whoami_employee() is
  'Diagnostic and session resolve for HR: shows the caller as the policies see them — identity keys, phones, own employee rows, their manager, their reports, and the businesses they may act in.';

revoke all on function public.hr_whoami_employee() from public, anon;
grant execute on function public.hr_whoami_employee() to authenticated;


-- -----------------------------------------------------------------------------
-- hr_leave_requests: the manager's read and decision
-- -----------------------------------------------------------------------------
-- Permissive policies OR together, so these widen what a line manager can do
-- without touching what an owner can do.

-- Read: everything belonging to anyone below you in the line.
drop policy if exists hr_leave_select_reports on public.hr_leave_requests;
create policy hr_leave_select_reports
  on public.hr_leave_requests
  for select
  to authenticated
  using (employee_id::text in (select public.hr_my_report_ids()));

-- Decide: approve or reject a report's request, and nothing else.
--
-- USING keeps it to rows still pending, so a manager cannot revisit a decision
-- an owner already made. WITH CHECK keeps the result to approved/rejected, so
-- this policy cannot be used to edit the dates, the days or the type of someone
-- else's request — only to answer it. 'cancelled' is excluded on purpose:
-- withdrawing is the requester's own act (hr_leave_cancel_self), and a manager
-- who wants it gone rejects it, leaving a decider on the record.
drop policy if exists hr_leave_update_manager on public.hr_leave_requests;
create policy hr_leave_update_manager
  on public.hr_leave_requests
  for update
  to authenticated
  using (
    status = 'pending'
    and employee_id::text in (select public.hr_my_report_ids())
  )
  with check (
    status in ('approved', 'rejected')
    and employee_id::text in (select public.hr_my_report_ids())
  );

-- Insert: recreated from 0004 with the report clause added, so a manager can
-- file leave on behalf of someone on their team — the person who phones in sick
-- has a manager, not necessarily an HR admin. Still forced to 'pending': filing
-- and deciding stay two acts, and the audit trail records both.
drop policy if exists hr_leave_insert on public.hr_leave_requests;
create policy hr_leave_insert
  on public.hr_leave_requests
  for insert
  to authenticated
  with check (
    status = 'pending'
    and (
      employee_id::text in (select public.hr_my_employee_ids())
      or employee_id::text in (select public.hr_my_report_ids())
      or employee_id::text in (
           select e.id::text from public.hr_employees e
            where e.business_id::text in (select public.hr_user_business_ids())
         )
    )
  );


-- =============================================================================
-- Verify
-- =============================================================================
-- As a line manager who owns nothing (the case that did not work before):
--
--   select set_config('request.jwt.claims', json_build_object(
--     'sub',   '<their auth.users.id>',
--     'role',  'authenticated',
--     'phone', '<their phone>'
--   )::text, true);
--   set role authenticated;
--
--   select public.hr_whoami_employee();
--   -- expect: employee_ids = [their row], report_ids = their team,
--   --         business_ids = []  ← no grant, and none needed
--
--   select * from public.hr_my_line();     -- their team, by name, no salary
--   select count(*) from public.hr_employees;   -- just their own row
--
--   -- decide one of their reports' requests
--   update public.hr_leave_requests
--      set status = 'approved', decided_by = '<their users.id>',
--          decided_at = now(), decision_note = 'ok'
--    where id = '<a pending request of a report>';   -- 1 row
--
--   -- and not their own
--   update public.hr_leave_requests set status = 'approved'
--    where id = '<their own pending request>';       -- 0 rows
--
-- Cycle refusal:
--
--   update public.hr_employees set manager_id = id where id = '<x>';
--   -- ERROR: violates hr_employees_manager_not_self
--
--   -- with a → b already set:
--   update public.hr_employees set manager_id = '<a>' where id = '<b's manager>';
--   -- ERROR: That reporting line loops back to the same person
-- =============================================================================
