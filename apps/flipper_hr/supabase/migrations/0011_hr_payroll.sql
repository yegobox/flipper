-- =============================================================================
-- 0011 — payroll: pay settings, advances, payslips, payments
-- =============================================================================
-- Apply after 0010.
--
-- What an owner asked for, in their words: "I pay my staff. Sometimes I give
-- them an advance before pay day. When I am about to pay them I need to know
-- how much I already paid." So the model is a pay book:
--
--   hr_payslips            what was earned for a period, and what was withheld
--   hr_payments            every amount of money handed to a person
--   hr_advances            money given ahead of pay; a debt the person owes
--   hr_advance_recoveries  the part of an advance taken back out of a payslip
--   hr_advance_requests    an employee asking for an advance (self-service)
--
-- Where the arithmetic lives. The statutory calculation (PAYE bands, RSSB
-- pension, maternity, CBHI) is done in the app (lib/features/pay/data/
-- rwanda_payroll.dart) where it is unit-tested against worked examples and its
-- rates carry effective dates. The database does not trust it blindly: every
-- payslip must add up (CHECK constraints below), an advance can never be
-- recovered past what is owed, recovery is capped at half of pay (Law 66/2018
-- art. 73), and amounts are immutable once written — a mistake is voided, not
-- edited. Derived columns (paid so far, recovered so far, status) are kept by
-- triggers, never by the client.
--
-- Same conventions as every HR table: business_id/branch_id are stamped from
-- the employee row by a BEFORE trigger; two read policies (the business's
-- managers via hr_user_business_ids(), the person themselves via
-- hr_my_employee_ids()); writes are managers only; no DELETE anywhere — these
-- rows are pay evidence.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1. Pay settings on the employee
-- -----------------------------------------------------------------------------
alter table public.hr_employees
  add column if not exists pay_day smallint
    check (pay_day is null or pay_day between 1 and 31),
  add column if not exists allowances numeric(14,2) not null default 0
    check (allowances >= 0),
  add column if not exists tax_category text not null default 'primary'
    check (tax_category in ('primary', 'secondary', 'casual')),
  add column if not exists rssb_enrolled boolean not null default true;

comment on column public.hr_employees.pay_day is
  'Day of the month a monthly employee is paid (1-31, clamped to the month''s last day). Null = last day of the month.';
comment on column public.hr_employees.allowances is
  'Fixed monthly taxable allowances (transport, housing, ...) paid on top of base_salary.';
comment on column public.hr_employees.tax_category is
  'PAYE treatment: primary employment (banded), secondary employer (flat 30%), casual labourer (15% above the monthly threshold).';
comment on column public.hr_employees.rssb_enrolled is
  'Whether RSSB pension, occupational-hazard and maternity contributions are computed for this person.';


-- -----------------------------------------------------------------------------
-- 2. Tables
-- -----------------------------------------------------------------------------
create table if not exists public.hr_advances (
  id                 uuid primary key default gen_random_uuid(),
  business_id        uuid not null,
  branch_id          uuid,
  employee_id        uuid not null references public.hr_employees (id),
  amount             numeric(14,2) not null check (amount > 0),
  currency           text not null default 'RWF',
  given_on           date not null default ((now() at time zone 'Africa/Kigali')::date),
  method             text not null default 'cash'
                       check (method in ('cash', 'mobile_money', 'bank_transfer')),
  reference          text,
  reason             text,
  -- Null: take it all back from the next payslip. Otherwise: at most this much
  -- per payslip.
  installment_amount numeric(14,2) check (installment_amount is null or installment_amount > 0),
  recovered          numeric(14,2) not null default 0,
  status             text not null default 'open'
                       check (status in ('open', 'recovered', 'written_off', 'void')),
  written_off_at     timestamptz,
  write_off_reason   text,
  voided_at          timestamptz,
  void_reason        text,
  created_by         uuid default auth.uid(),
  created_at         timestamptz not null default now(),
  constraint hr_advances_void_reason
    check (voided_at is null or length(trim(coalesce(void_reason, ''))) > 0),
  constraint hr_advances_write_off_reason
    check (written_off_at is null or length(trim(coalesce(write_off_reason, ''))) > 0)
);

create index if not exists hr_advances_employee_idx on public.hr_advances (employee_id, given_on desc);
create index if not exists hr_advances_business_idx on public.hr_advances (business_id, given_on desc);

create table if not exists public.hr_payslips (
  id                   uuid primary key default gen_random_uuid(),
  business_id          uuid not null,
  branch_id            uuid,
  employee_id          uuid not null references public.hr_employees (id),
  period_start         date not null,
  period_end           date not null,
  currency             text not null default 'RWF',
  base_pay             numeric(14,2) not null check (base_pay >= 0),
  allowances           numeric(14,2) not null default 0 check (allowances >= 0),
  extra_earnings       numeric(14,2) not null default 0 check (extra_earnings >= 0),
  gross                numeric(14,2) not null,
  paye                 numeric(14,2) not null default 0 check (paye >= 0),
  pension_employee     numeric(14,2) not null default 0 check (pension_employee >= 0),
  maternity_employee   numeric(14,2) not null default 0 check (maternity_employee >= 0),
  cbhi                 numeric(14,2) not null default 0 check (cbhi >= 0),
  other_deductions     numeric(14,2) not null default 0 check (other_deductions >= 0),
  advance_recovery     numeric(14,2) not null default 0 check (advance_recovery >= 0),
  net_pay              numeric(14,2) not null check (net_pay >= 0),
  pension_employer     numeric(14,2) not null default 0 check (pension_employer >= 0),
  maternity_employer   numeric(14,2) not null default 0 check (maternity_employer >= 0),
  occupational_hazards numeric(14,2) not null default 0 check (occupational_hazards >= 0),
  -- Which statutory rate set produced the figures, e.g. 'RW-2025-01'.
  rates_version        text,
  worked_minutes       integer check (worked_minutes is null or worked_minutes >= 0),
  note                 text,
  paid_amount          numeric(14,2) not null default 0,
  status               text not null default 'unpaid'
                         check (status in ('unpaid', 'partially_paid', 'paid', 'void')),
  voided_at            timestamptz,
  void_reason          text,
  created_by           uuid default auth.uid(),
  created_at           timestamptz not null default now(),
  constraint hr_payslips_period check (period_end >= period_start),
  constraint hr_payslips_gross_adds_up
    check (gross = base_pay + allowances + extra_earnings),
  constraint hr_payslips_net_adds_up
    check (net_pay = gross - paye - pension_employee - maternity_employee
                     - cbhi - other_deductions - advance_recovery),
  -- Law 66/2018 art. 73: no more than half of the salary may be withheld to
  -- repay an advance or a loan. "Salary" here is what is left after the
  -- compulsory deductions, which the law puts outside the limit.
  constraint hr_payslips_recovery_cap
    check (advance_recovery + other_deductions
           <= 0.5 * (gross - paye - pension_employee - maternity_employee - cbhi)),
  constraint hr_payslips_void_reason
    check (voided_at is null or length(trim(coalesce(void_reason, ''))) > 0)
);

-- One live payslip per person per period. A voided one frees the period.
create unique index if not exists hr_payslips_one_per_period
  on public.hr_payslips (employee_id, period_start, period_end)
  where voided_at is null;
create index if not exists hr_payslips_business_idx on public.hr_payslips (business_id, period_end desc);

create table if not exists public.hr_payments (
  id          uuid primary key default gen_random_uuid(),
  business_id uuid not null,
  branch_id   uuid,
  employee_id uuid not null references public.hr_employees (id),
  kind        text not null check (kind in ('salary', 'advance', 'reimbursement', 'other')),
  amount      numeric(14,2) not null check (amount > 0),
  currency    text not null default 'RWF',
  paid_on     date not null default ((now() at time zone 'Africa/Kigali')::date),
  method      text not null default 'cash'
                check (method in ('cash', 'mobile_money', 'bank_transfer')),
  reference   text,
  note        text,
  payslip_id  uuid references public.hr_payslips (id),
  advance_id  uuid references public.hr_advances (id),
  voided_at   timestamptz,
  void_reason text,
  created_by  uuid default auth.uid(),
  created_at  timestamptz not null default now(),
  constraint hr_payments_salary_has_payslip check (kind <> 'salary' or payslip_id is not null),
  constraint hr_payments_advance_has_advance check (kind <> 'advance' or advance_id is not null),
  constraint hr_payments_void_reason
    check (voided_at is null or length(trim(coalesce(void_reason, ''))) > 0)
);

create index if not exists hr_payments_employee_idx on public.hr_payments (employee_id, paid_on desc);
create index if not exists hr_payments_business_idx on public.hr_payments (business_id, paid_on desc);
create index if not exists hr_payments_payslip_idx on public.hr_payments (payslip_id);

create table if not exists public.hr_advance_recoveries (
  id         uuid primary key default gen_random_uuid(),
  advance_id uuid not null references public.hr_advances (id),
  payslip_id uuid not null references public.hr_payslips (id),
  amount     numeric(14,2) not null check (amount > 0),
  created_at timestamptz not null default now(),
  unique (advance_id, payslip_id)
);

create index if not exists hr_advance_recoveries_payslip_idx on public.hr_advance_recoveries (payslip_id);

create table if not exists public.hr_advance_requests (
  id            uuid primary key default gen_random_uuid(),
  business_id   uuid not null,
  branch_id     uuid,
  employee_id   uuid not null references public.hr_employees (id),
  amount        numeric(14,2) not null check (amount > 0),
  reason        text,
  status        text not null default 'pending'
                  check (status in ('pending', 'approved', 'declined', 'cancelled')),
  decided_by    text,
  decided_at    timestamptz,
  decision_note text,
  advance_id    uuid references public.hr_advances (id),
  created_at    timestamptz not null default now()
);

create index if not exists hr_advance_requests_business_idx on public.hr_advance_requests (business_id, created_at desc);
create index if not exists hr_advance_requests_employee_idx on public.hr_advance_requests (employee_id, created_at desc);


-- -----------------------------------------------------------------------------
-- 3. Scope: business and branch always come from the employee row
-- -----------------------------------------------------------------------------
create or replace function public.hr_pay_set_scope()
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
  return new;
end;
$$;

drop trigger if exists hr_advances_scope on public.hr_advances;
create trigger hr_advances_scope before insert on public.hr_advances
  for each row execute function public.hr_pay_set_scope();
drop trigger if exists hr_payslips_scope on public.hr_payslips;
create trigger hr_payslips_scope before insert on public.hr_payslips
  for each row execute function public.hr_pay_set_scope();
drop trigger if exists hr_payments_scope on public.hr_payments;
create trigger hr_payments_scope before insert on public.hr_payments
  for each row execute function public.hr_pay_set_scope();
drop trigger if exists hr_advance_requests_scope on public.hr_advance_requests;
create trigger hr_advance_requests_scope before insert on public.hr_advance_requests
  for each row execute function public.hr_pay_set_scope();


-- -----------------------------------------------------------------------------
-- 4. Derived state, kept by the database
-- -----------------------------------------------------------------------------
-- Security definer: these write the derived columns, which authenticated users
-- are not granted (see the column grants in section 6).

create or replace function public.hr_refresh_advance(p_advance_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_recovered numeric(14,2);
begin
  select coalesce(sum(r.amount), 0)
    into v_recovered
    from public.hr_advance_recoveries r
    join public.hr_payslips s on s.id = r.payslip_id
   where r.advance_id = p_advance_id
     and s.voided_at is null;

  update public.hr_advances a
     set recovered = v_recovered,
         status = case
           when a.voided_at is not null       then 'void'
           when v_recovered >= a.amount       then 'recovered'
           when a.written_off_at is not null  then 'written_off'
           else 'open'
         end
   where a.id = p_advance_id;
end;
$$;

create or replace function public.hr_refresh_payslip(p_payslip_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_paid numeric(14,2);
begin
  select coalesce(sum(p.amount), 0)
    into v_paid
    from public.hr_payments p
   where p.payslip_id = p_payslip_id
     and p.voided_at is null;

  update public.hr_payslips s
     set paid_amount = v_paid,
         status = case
           when s.voided_at is not null then 'void'
           when v_paid >= s.net_pay     then 'paid'
           when v_paid > 0              then 'partially_paid'
           else 'unpaid'
         end
   where s.id = p_payslip_id;
end;
$$;

revoke all on function public.hr_refresh_advance(uuid) from public, anon, authenticated;
revoke all on function public.hr_refresh_payslip(uuid) from public, anon, authenticated;


-- A recovery may only take back what is still owed, from the same person, and
-- only from an advance that is live.
create or replace function public.hr_advance_recovery_guard()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_adv  public.hr_advances%rowtype;
  v_slip public.hr_payslips%rowtype;
  v_live numeric(14,2);
begin
  select * into v_adv from public.hr_advances where id = new.advance_id for update;
  select * into v_slip from public.hr_payslips where id = new.payslip_id;

  if v_adv.id is null or v_slip.id is null then
    raise exception 'Unknown advance or payslip';
  end if;
  if v_adv.employee_id <> v_slip.employee_id then
    raise exception 'An advance can only be recovered from the same person''s pay';
  end if;
  if v_adv.voided_at is not null or v_adv.written_off_at is not null then
    raise exception 'This advance is closed';
  end if;

  select coalesce(sum(r.amount), 0)
    into v_live
    from public.hr_advance_recoveries r
    join public.hr_payslips s on s.id = r.payslip_id
   where r.advance_id = new.advance_id
     and s.voided_at is null;

  if v_live + new.amount > v_adv.amount then
    raise exception 'Recovering % would exceed the % still owed on this advance',
      new.amount, v_adv.amount - v_live;
  end if;
  return new;
end;
$$;

drop trigger if exists hr_advance_recoveries_guard on public.hr_advance_recoveries;
create trigger hr_advance_recoveries_guard before insert on public.hr_advance_recoveries
  for each row execute function public.hr_advance_recovery_guard();

create or replace function public.hr_advance_recoveries_after()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform public.hr_refresh_advance(new.advance_id);
  return null;
end;
$$;

drop trigger if exists hr_advance_recoveries_refresh on public.hr_advance_recoveries;
create trigger hr_advance_recoveries_refresh after insert on public.hr_advance_recoveries
  for each row execute function public.hr_advance_recoveries_after();


-- Payments: a salary payment belongs to a live payslip of the same person, and
-- the payslip's paid amount follows every insert and void.
create or replace function public.hr_payment_guard()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_slip public.hr_payslips%rowtype;
  v_paid numeric(14,2);
begin
  if new.payslip_id is not null then
    select * into v_slip from public.hr_payslips where id = new.payslip_id for update;
    if v_slip.employee_id <> new.employee_id then
      raise exception 'This payslip belongs to someone else';
    end if;
    if v_slip.voided_at is not null then
      raise exception 'This payslip has been voided';
    end if;
    select coalesce(sum(amount), 0) into v_paid
      from public.hr_payments
     where payslip_id = new.payslip_id and voided_at is null;
    if v_paid + new.amount > v_slip.net_pay then
      raise exception 'Paying % would exceed the % still due on this payslip',
        new.amount, v_slip.net_pay - v_paid;
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists hr_payments_guard on public.hr_payments;
create trigger hr_payments_guard before insert on public.hr_payments
  for each row execute function public.hr_payment_guard();

create or replace function public.hr_payments_after()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.payslip_id is not null then
    perform public.hr_refresh_payslip(new.payslip_id);
  end if;
  return null;
end;
$$;

drop trigger if exists hr_payments_refresh on public.hr_payments;
create trigger hr_payments_refresh after insert or update of voided_at on public.hr_payments
  for each row execute function public.hr_payments_after();


-- Voids: one way only, and in order. A payslip with money paid against it is
-- voided after its payments; an advance that has been partly recovered cannot
-- be voided (void the payslips that recovered it, or write it off).
create or replace function public.hr_pay_void_guard()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if old.voided_at is not null and new.voided_at is distinct from old.voided_at then
    raise exception 'A voided record stays voided';
  end if;

  if new.voided_at is not null and old.voided_at is null then
    if tg_table_name = 'hr_payslips' then
      if exists (select 1 from public.hr_payments
                  where payslip_id = new.id and voided_at is null) then
        raise exception 'Void the payments made against this payslip first';
      end if;
    elsif tg_table_name = 'hr_advances' then
      if exists (select 1 from public.hr_advance_recoveries r
                   join public.hr_payslips s on s.id = r.payslip_id
                  where r.advance_id = new.id and s.voided_at is null) then
        raise exception 'Part of this advance was already recovered; write it off instead';
      end if;
    end if;
  end if;

  if tg_table_name = 'hr_advances' then
    if old.written_off_at is not null
       and new.written_off_at is distinct from old.written_off_at then
      raise exception 'A write-off cannot be undone';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists hr_payslips_void_guard on public.hr_payslips;
create trigger hr_payslips_void_guard before update on public.hr_payslips
  for each row execute function public.hr_pay_void_guard();
drop trigger if exists hr_advances_void_guard on public.hr_advances;
create trigger hr_advances_void_guard before update on public.hr_advances
  for each row execute function public.hr_pay_void_guard();
drop trigger if exists hr_payments_void_guard on public.hr_payments;
create trigger hr_payments_void_guard before update on public.hr_payments
  for each row execute function public.hr_pay_void_guard();

create or replace function public.hr_payslips_after_void()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_advance uuid;
begin
  perform public.hr_refresh_payslip(new.id);
  -- Its recoveries no longer count: the advances are owed again.
  for v_advance in
    select advance_id from public.hr_advance_recoveries where payslip_id = new.id
  loop
    perform public.hr_refresh_advance(v_advance);
  end loop;
  return null;
end;
$$;

drop trigger if exists hr_payslips_voided on public.hr_payslips;
create trigger hr_payslips_voided after update of voided_at on public.hr_payslips
  for each row when (new.voided_at is not null and old.voided_at is null)
  execute function public.hr_payslips_after_void();

create or replace function public.hr_advances_after_close()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  -- Voiding an advance voids the money recorded as handed over for it.
  if new.voided_at is not null and old.voided_at is null then
    update public.hr_payments
       set voided_at = new.voided_at,
           void_reason = new.void_reason
     where advance_id = new.id and voided_at is null;
  end if;
  perform public.hr_refresh_advance(new.id);
  return null;
end;
$$;

drop trigger if exists hr_advances_closed on public.hr_advances;
create trigger hr_advances_closed after update of voided_at, written_off_at on public.hr_advances
  for each row execute function public.hr_advances_after_close();


-- -----------------------------------------------------------------------------
-- 5. Atomic writes
-- -----------------------------------------------------------------------------
-- SECURITY INVOKER throughout: RLS decides who may write; these only make the
-- multi-row writes happen together or not at all.

-- Give an advance: the debt and the money handed over, as one write.
create or replace function public.hr_give_advance(
  p_employee_id        uuid,
  p_amount             numeric,
  p_given_on           date default null,
  p_method             text default 'cash',
  p_reference          text default null,
  p_reason             text default null,
  p_installment_amount numeric default null
)
returns public.hr_advances
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_adv public.hr_advances;
begin
  insert into public.hr_advances (
    employee_id, amount, currency, given_on, method, reference, reason, installment_amount
  )
  select e.id, p_amount, coalesce(nullif(e.currency, ''), 'RWF'),
         coalesce(p_given_on, (now() at time zone 'Africa/Kigali')::date),
         coalesce(p_method, 'cash'), nullif(trim(p_reference), ''),
         nullif(trim(p_reason), ''), p_installment_amount
    from public.hr_employees e
   where e.id = p_employee_id
  returning * into v_adv;

  if v_adv.id is null then
    raise exception 'No such employee: %', p_employee_id;
  end if;

  insert into public.hr_payments (
    employee_id, kind, amount, currency, paid_on, method, reference, note, advance_id
  ) values (
    v_adv.employee_id, 'advance', v_adv.amount, v_adv.currency, v_adv.given_on,
    v_adv.method, v_adv.reference, v_adv.reason, v_adv.id
  );

  return v_adv;
end;
$$;

-- Create a payslip with its advance recoveries and, optionally, the payment
-- that settles it — so "Pay" in the app is one tap that either fully lands or
-- leaves nothing behind.
--
-- p_recoveries: [{"advance_id": "...", "amount": 1000}, ...]
-- p_payment:    {"amount": 1000, "method": "cash", "reference": "...", "paid_on": "2026-10-31"} or null
create or replace function public.hr_create_payslip(
  p_employee_id          uuid,
  p_period_start         date,
  p_period_end           date,
  p_base_pay             numeric,
  p_allowances           numeric,
  p_extra_earnings       numeric,
  p_paye                 numeric,
  p_pension_employee     numeric,
  p_maternity_employee   numeric,
  p_cbhi                 numeric,
  p_other_deductions     numeric,
  p_pension_employer     numeric,
  p_maternity_employer   numeric,
  p_occupational_hazards numeric,
  p_rates_version        text,
  p_worked_minutes       integer default null,
  p_note                 text default null,
  p_recoveries           jsonb default '[]'::jsonb,
  p_payment              jsonb default null
)
returns public.hr_payslips
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_slip     public.hr_payslips;
  v_recovery numeric(14,2);
  v_gross    numeric(14,2);
  v_item     jsonb;
begin
  select coalesce(sum((r ->> 'amount')::numeric), 0)
    into v_recovery
    from jsonb_array_elements(coalesce(p_recoveries, '[]'::jsonb)) r;

  v_gross := coalesce(p_base_pay, 0) + coalesce(p_allowances, 0) + coalesce(p_extra_earnings, 0);

  insert into public.hr_payslips (
    employee_id, period_start, period_end, currency,
    base_pay, allowances, extra_earnings, gross,
    paye, pension_employee, maternity_employee, cbhi, other_deductions,
    advance_recovery, net_pay,
    pension_employer, maternity_employer, occupational_hazards,
    rates_version, worked_minutes, note
  )
  select e.id, p_period_start, p_period_end, coalesce(nullif(e.currency, ''), 'RWF'),
         coalesce(p_base_pay, 0), coalesce(p_allowances, 0), coalesce(p_extra_earnings, 0), v_gross,
         coalesce(p_paye, 0), coalesce(p_pension_employee, 0), coalesce(p_maternity_employee, 0),
         coalesce(p_cbhi, 0), coalesce(p_other_deductions, 0),
         v_recovery,
         v_gross - coalesce(p_paye, 0) - coalesce(p_pension_employee, 0)
           - coalesce(p_maternity_employee, 0) - coalesce(p_cbhi, 0)
           - coalesce(p_other_deductions, 0) - v_recovery,
         coalesce(p_pension_employer, 0), coalesce(p_maternity_employer, 0),
         coalesce(p_occupational_hazards, 0),
         p_rates_version, p_worked_minutes, nullif(trim(p_note), '')
    from public.hr_employees e
   where e.id = p_employee_id
  returning * into v_slip;

  if v_slip.id is null then
    raise exception 'No such employee: %', p_employee_id;
  end if;

  for v_item in select * from jsonb_array_elements(coalesce(p_recoveries, '[]'::jsonb))
  loop
    if coalesce((v_item ->> 'amount')::numeric, 0) > 0 then
      insert into public.hr_advance_recoveries (advance_id, payslip_id, amount)
      values ((v_item ->> 'advance_id')::uuid, v_slip.id, (v_item ->> 'amount')::numeric);
    end if;
  end loop;

  if p_payment is not null and coalesce((p_payment ->> 'amount')::numeric, 0) > 0 then
    insert into public.hr_payments (
      employee_id, kind, amount, currency, paid_on, method, reference, payslip_id
    ) values (
      v_slip.employee_id, 'salary', (p_payment ->> 'amount')::numeric, v_slip.currency,
      coalesce((p_payment ->> 'paid_on')::date, (now() at time zone 'Africa/Kigali')::date),
      coalesce(p_payment ->> 'method', 'cash'),
      nullif(trim(coalesce(p_payment ->> 'reference', '')), ''),
      v_slip.id
    );
  end if;

  select * into v_slip from public.hr_payslips where id = v_slip.id;
  return v_slip;
end;
$$;

-- Approve an employee's advance request: gives the advance and links it.
create or replace function public.hr_approve_advance_request(
  p_request_id         uuid,
  p_decided_by         text default null,
  p_method             text default 'cash',
  p_reference          text default null,
  p_installment_amount numeric default null,
  p_note               text default null
)
returns public.hr_advance_requests
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_req public.hr_advance_requests;
  v_adv public.hr_advances;
begin
  select * into v_req from public.hr_advance_requests
   where id = p_request_id for update;
  if v_req.id is null then
    raise exception 'No such request';
  end if;
  if v_req.status <> 'pending' then
    raise exception 'This request was already %', v_req.status;
  end if;

  v_adv := public.hr_give_advance(
    v_req.employee_id, v_req.amount, null, p_method, p_reference,
    coalesce(v_req.reason, p_note), p_installment_amount
  );

  update public.hr_advance_requests
     set status = 'approved', decided_by = p_decided_by, decided_at = now(),
         decision_note = nullif(trim(p_note), ''), advance_id = v_adv.id
   where id = p_request_id
  returning * into v_req;
  return v_req;
end;
$$;

revoke all on function public.hr_give_advance(uuid, numeric, date, text, text, text, numeric) from public, anon;
revoke all on function public.hr_create_payslip(uuid, date, date, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, text, integer, text, jsonb, jsonb) from public, anon;
revoke all on function public.hr_approve_advance_request(uuid, text, text, text, numeric, text) from public, anon;
grant execute on function public.hr_give_advance(uuid, numeric, date, text, text, text, numeric) to authenticated;
grant execute on function public.hr_create_payslip(uuid, date, date, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, text, integer, text, jsonb, jsonb) to authenticated;
grant execute on function public.hr_approve_advance_request(uuid, text, text, text, numeric, text) to authenticated;


-- -----------------------------------------------------------------------------
-- 6. RLS and grants
-- -----------------------------------------------------------------------------
alter table public.hr_advances           enable row level security;
alter table public.hr_payslips           enable row level security;
alter table public.hr_payments           enable row level security;
alter table public.hr_advance_recoveries enable row level security;
alter table public.hr_advance_requests   enable row level security;

revoke all on public.hr_advances, public.hr_payslips, public.hr_payments,
              public.hr_advance_recoveries, public.hr_advance_requests
  from public, anon, authenticated;

-- Amounts are written once. The only thing a client may change afterwards is
-- the void (and, for an advance, the write-off); the derived columns belong to
-- the triggers above.
grant select, insert on public.hr_advances, public.hr_payslips, public.hr_payments,
                       public.hr_advance_recoveries, public.hr_advance_requests
  to authenticated;
grant update (voided_at, void_reason) on public.hr_payslips, public.hr_payments to authenticated;
grant update (voided_at, void_reason, written_off_at, write_off_reason) on public.hr_advances to authenticated;
grant update (status, decided_by, decided_at, decision_note, advance_id) on public.hr_advance_requests to authenticated;

-- hr_advances, hr_payslips, hr_payments: same shape of policy each.
do $$
declare
  t text;
begin
  foreach t in array array['hr_advances', 'hr_payslips', 'hr_payments'] loop
    execute format('drop policy if exists %1$s_select on public.%1$s', t);
    execute format($p$
      create policy %1$s_select on public.%1$s for select to authenticated
      using (
        business_id::text in (select public.hr_user_business_ids())
        or employee_id::text in (select public.hr_my_employee_ids())
      )$p$, t);

    execute format('drop policy if exists %1$s_insert on public.%1$s', t);
    execute format($p$
      create policy %1$s_insert on public.%1$s for insert to authenticated
      with check (
        employee_id::text in (
          select e.id::text from public.hr_employees e
           where e.business_id::text in (select public.hr_user_business_ids())
        )
      )$p$, t);

    execute format('drop policy if exists %1$s_update on public.%1$s', t);
    execute format($p$
      create policy %1$s_update on public.%1$s for update to authenticated
      using (business_id::text in (select public.hr_user_business_ids()))
      with check (business_id::text in (select public.hr_user_business_ids()))
      $p$, t);
  end loop;
end;
$$;

drop policy if exists hr_advance_recoveries_select on public.hr_advance_recoveries;
create policy hr_advance_recoveries_select on public.hr_advance_recoveries
  for select to authenticated
  using (payslip_id in (select s.id from public.hr_payslips s));

drop policy if exists hr_advance_recoveries_insert on public.hr_advance_recoveries;
create policy hr_advance_recoveries_insert on public.hr_advance_recoveries
  for insert to authenticated
  with check (
    payslip_id in (
      select s.id from public.hr_payslips s
       where s.business_id::text in (select public.hr_user_business_ids())
    )
  );

-- Advance requests: the person asks, a manager of the business decides.
drop policy if exists hr_advance_requests_select on public.hr_advance_requests;
create policy hr_advance_requests_select on public.hr_advance_requests
  for select to authenticated
  using (
    business_id::text in (select public.hr_user_business_ids())
    or employee_id::text in (select public.hr_my_employee_ids())
  );

drop policy if exists hr_advance_requests_insert_self on public.hr_advance_requests;
create policy hr_advance_requests_insert_self on public.hr_advance_requests
  for insert to authenticated
  with check (
    status = 'pending'
    and employee_id::text in (select public.hr_my_employee_ids())
  );

drop policy if exists hr_advance_requests_decide on public.hr_advance_requests;
create policy hr_advance_requests_decide on public.hr_advance_requests
  for update to authenticated
  using (business_id::text in (select public.hr_user_business_ids()))
  with check (business_id::text in (select public.hr_user_business_ids()));

-- Cancel your own request while it is still pending, and do nothing else.
drop policy if exists hr_advance_requests_cancel_self on public.hr_advance_requests;
create policy hr_advance_requests_cancel_self on public.hr_advance_requests
  for update to authenticated
  using (status = 'pending' and employee_id::text in (select public.hr_my_employee_ids()))
  with check (status = 'cancelled' and employee_id::text in (select public.hr_my_employee_ids()));


-- =============================================================================
-- Verify (SQL editor, as the service role, then impersonating an owner)
-- =============================================================================
--   select public.hr_give_advance('<employee uuid>', 20000, null, 'cash', null, 'school fees', null);
--   select * from public.hr_create_payslip('<employee uuid>', '2026-10-01', '2026-10-31',
--     200000, 0, 0, 20000, 12000, 600, 837, 0, 12000, 600, 4000, 'RW-2025-01', null, null,
--     '[{"advance_id":"<advance uuid>","amount":20000}]', '{"amount":146563,"method":"cash"}');
--   select status, recovered from public.hr_advances where employee_id = '<employee uuid>';
--     -> recovered
