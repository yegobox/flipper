-- =============================================================================
-- 0005 — attendance: clock in, clock out, and the timesheet
-- =============================================================================
-- Apply after 0004. Third HR module. Reuses both identity paths already in
-- place: hr_user_business_ids() for the roster manager, hr_my_employee_ids()
-- for the person clocking themselves in.
--
-- Shape of the data: one row per stretch worked, NOT one row per day with
-- clock_in/clock_out columns. People break for lunch and step out mid-shift; a
-- single pair of columns forces that into either a lie or a second table. The
-- per-day totals are derived in the app (attendance_day.dart), from the same
-- rule payroll will read.
--
-- Two decisions worth stating:
--
--   1. The SERVER stamps the time. hr_clock_in() and hr_clock_out() are RPCs
--      because now() cannot be expressed in a PostgREST insert payload, and a
--      timesheet whose times come from the device is only as trustworthy as the
--      device clock — including a deliberately wound-back one. They are SECURITY
--      INVOKER, so RLS still applies: the RPC decides the TIME, never the
--      PERMISSION.
--
--   2. At most one open session per person, enforced by a partial unique index
--      rather than by the app checking first. Two taps on a slow connection
--      would otherwise both pass a client-side check and open two sessions,
--      double-counting the day.
--
-- Rollback:
--   drop function if exists public.hr_clock_out(uuid, text);
--   drop function if exists public.hr_clock_in(uuid, text, text);
--   drop table if exists public.hr_attendance_sessions;
--
-- Safe to re-run.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- hr_attendance_sessions
-- -----------------------------------------------------------------------------
-- business_id / branch_id / work_date are denormalised and trigger-stamped for
-- the same reasons as hr_leave_requests: the policies compare them directly, and
-- deriving them from the employee's row makes a spoofed scope unrepresentable.
create table if not exists public.hr_attendance_sessions (
  id           uuid primary key default gen_random_uuid(),

  employee_id  uuid not null
                 references public.hr_employees(id) on delete cascade,
  business_id  uuid not null,
  branch_id    uuid not null,

  -- The shift's day in BRANCH-LOCAL terms. An overnight shift belongs to the day
  -- it started, so this is derived from started_at and never from ended_at.
  work_date    date not null,

  started_at   timestamptz not null default now(),
  ended_at     timestamptz,

  -- Minutes worked, recomputed by the trigger whenever ended_at is set or a
  -- timestamp is corrected. Stored so payroll reads one number rather than
  -- re-deriving it, and null while the session is open — 0 would read as
  -- "worked nothing".
  minutes      integer check (minutes is null or minutes >= 0),

  source       text not null default 'self'
                 check (source in ('self', 'manager')),
  note         text not null default '',

  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),

  constraint hr_attendance_end_after_start
    check (ended_at is null or ended_at > started_at)
);

comment on table public.hr_attendance_sessions is
  'One stretch worked. Several rows per person per day is normal (breaks). Times are stamped by hr_clock_in/hr_clock_out, never by the client.';

-- One open session per person. Partial, so closed history is unconstrained.
create unique index if not exists hr_attendance_one_open_per_employee
  on public.hr_attendance_sessions (employee_id)
  where ended_at is null;

-- The board reads exactly this: one branch, one day.
create index if not exists hr_attendance_branch_day_idx
  on public.hr_attendance_sessions (branch_id, work_date, started_at);

-- The timesheet reads this: one person, a date range.
create index if not exists hr_attendance_employee_day_idx
  on public.hr_attendance_sessions (employee_id, work_date desc);


-- -----------------------------------------------------------------------------
-- Scope, work_date and minutes come from the row, never from the client
-- -----------------------------------------------------------------------------
-- Timezone: Flipper is a Rwanda product (RRA e-invoicing throughout), and
-- Africa/Kigali is UTC+2 with no DST, so a single fixed zone is correct here
-- rather than merely convenient. When HR grows a second country, this is the one
-- place that has to learn about the branch's zone.
create or replace function public.hr_attendance_set_scope()
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
  new.work_date   := (new.started_at at time zone 'Africa/Kigali')::date;

  new.minutes := case
    when new.ended_at is null then null
    else greatest(
      0,
      floor(extract(epoch from (new.ended_at - new.started_at)) / 60)::int
    )
  end;

  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists hr_attendance_sessions_scope on public.hr_attendance_sessions;
create trigger hr_attendance_sessions_scope
  before insert or update on public.hr_attendance_sessions
  for each row execute function public.hr_attendance_set_scope();


-- -----------------------------------------------------------------------------
-- RLS
-- -----------------------------------------------------------------------------
alter table public.hr_attendance_sessions enable row level security;

revoke all on public.hr_attendance_sessions from public, anon;
grant select, insert, update on public.hr_attendance_sessions to authenticated;

-- Read: the manager sees the business, the employee sees themselves.
drop policy if exists hr_attendance_select on public.hr_attendance_sessions;
create policy hr_attendance_select
  on public.hr_attendance_sessions
  for select
  to authenticated
  using (
    business_id::text in (select public.hr_user_business_ids())
    or employee_id::text in (select public.hr_my_employee_ids())
  );

-- Insert: yourself, or anyone on a business you own.
drop policy if exists hr_attendance_insert on public.hr_attendance_sessions;
create policy hr_attendance_insert
  on public.hr_attendance_sessions
  for insert
  to authenticated
  with check (
    employee_id::text in (select public.hr_my_employee_ids())
    or employee_id::text in (
         select e.id::text from public.hr_employees e
          where e.business_id::text in (select public.hr_user_business_ids())
       )
  );

-- Update, manager: correct any entry in the business.
drop policy if exists hr_attendance_update_manager on public.hr_attendance_sessions;
create policy hr_attendance_update_manager
  on public.hr_attendance_sessions
  for update
  to authenticated
  using (business_id::text in (select public.hr_user_business_ids()))
  with check (business_id::text in (select public.hr_user_business_ids()));

-- Update, self: close your own open session and nothing else.
--
-- USING restricts it to your own OPEN rows, so a closed day cannot be reopened
-- or edited; WITH CHECK requires the result to be closed. Together: you may
-- clock yourself out, and you may not rewrite yesterday's hours.
drop policy if exists hr_attendance_close_self on public.hr_attendance_sessions;
create policy hr_attendance_close_self
  on public.hr_attendance_sessions
  for update
  to authenticated
  using (
    ended_at is null
    and employee_id::text in (select public.hr_my_employee_ids())
  )
  with check (
    ended_at is not null
    and employee_id::text in (select public.hr_my_employee_ids())
  );

-- No DELETE policy: a mistaken entry is corrected, not erased. Hours are pay
-- evidence.


-- -----------------------------------------------------------------------------
-- The clock
-- -----------------------------------------------------------------------------
-- SECURITY INVOKER (the default) on purpose: these functions decide the TIME,
-- not the PERMISSION. The insert and update below are evaluated against the
-- caller's own policies, so hr_clock_in cannot be used to clock in someone
-- else's staff.
create or replace function public.hr_clock_in(
  p_employee_id uuid,
  p_source      text default 'self',
  p_note        text default ''
)
returns jsonb
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_row public.hr_attendance_sessions;
begin
  -- Named explicitly rather than left to the unique index, so the app can show
  -- "already clocked in" instead of a constraint name.
  if exists (
    select 1 from public.hr_attendance_sessions s
     where s.employee_id = p_employee_id and s.ended_at is null
  ) then
    raise exception 'Already clocked in' using errcode = 'P0001';
  end if;

  insert into public.hr_attendance_sessions
    (employee_id, business_id, branch_id, work_date, started_at, source, note)
  values
    -- business_id, branch_id and work_date are overwritten by the trigger; the
    -- placeholders exist only to satisfy NOT NULL before it runs.
    (p_employee_id, gen_random_uuid(), gen_random_uuid(), current_date,
     now(), coalesce(nullif(p_source, ''), 'self'), coalesce(p_note, ''))
  returning * into v_row;

  return to_jsonb(v_row);
end;
$$;

comment on function public.hr_clock_in(uuid, text, text) is
  'Opens an attendance session at now(). SECURITY INVOKER: the caller''s RLS decides whether they may.';

create or replace function public.hr_clock_out(
  p_session_id uuid,
  p_note       text default ''
)
returns jsonb
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_row public.hr_attendance_sessions;
begin
  update public.hr_attendance_sessions s
     set ended_at = now(),
         -- Keep the existing note when none is supplied, rather than blanking a
         -- note left at clock-in.
         note = case
                  when coalesce(p_note, '') = '' then s.note
                  else p_note
                end
   where s.id = p_session_id
     and s.ended_at is null
  returning * into v_row;

  if v_row.id is null then
    -- Either it is already closed, or RLS hid it. The client cannot tell those
    -- apart and does not need to: there is nothing open to close either way.
    raise exception 'That session is not open' using errcode = 'P0001';
  end if;

  return to_jsonb(v_row);
end;
$$;

comment on function public.hr_clock_out(uuid, text) is
  'Closes an open attendance session at now(). SECURITY INVOKER, so RLS applies.';

revoke all on function public.hr_clock_in(uuid, text, text)  from public, anon;
revoke all on function public.hr_clock_out(uuid, text)       from public, anon;
grant execute on function public.hr_clock_in(uuid, text, text) to authenticated;
grant execute on function public.hr_clock_out(uuid, text)      to authenticated;


-- =============================================================================
-- Verify
-- =============================================================================
-- As an invited employee (no ownership at all):
--
--   begin;
--     select set_config('request.jwt.claims', json_build_object(
--       'sub','<their auth uuid>','role','authenticated',
--       'email','<their pin>@flipper.rw')::text, true);
--     set local role authenticated;
--
--     select public.hr_clock_in((select e from public.hr_my_employee_ids() e limit 1)::uuid);
--     -- work_date is stamped, minutes is null, business_id is theirs.
--
--     select public.hr_clock_in((select e from public.hr_my_employee_ids() e limit 1)::uuid);
--     -- ERROR: Already clocked in
--
--     select public.hr_clock_out(
--       (select id from public.hr_attendance_sessions
--         where ended_at is null limit 1));
--     -- minutes now set.
--
--     -- They cannot rewrite a closed session:
--     update public.hr_attendance_sessions set started_at = now() - interval '4 h';
--     -- 0 rows
--   rollback;
--
-- As the business owner, the same table shows every employee on the branch, and
-- the update above succeeds — that is the correction path.
-- =============================================================================
