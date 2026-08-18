# flipper_hr

Flipper HR — web app intended to serve https://hr.useflipper.com.

Authentication is shared with Books: HR reuses `flipper_web`'s PIN login, signup
and business/branch selection, so one Flipper account signs in to both apps. HR
modules get built on top of `HrHomeShell` from here.

## Auth wiring

HR depends on `flipper_web` as a package and mounts its screens in HR's own
router — nothing about the login flow is duplicated:

| Route                | Screen                                        |
| -------------------- | --------------------------------------------- |
| `/login`             | `PinScreen` (flipper_web) — PIN → OTP/TOTP     |
| `/signup`            | `SignupView` (flipper_web)                     |
| `/business-selection`| `BusinessSelectionWrapper` (flipper_web)       |
| `/people`            | `HrHomeShell` → `PeoplePage` (this app)        |
| `/`                  | `HrAuthGate` — routes by session + selection   |

Three host-app settings are applied in `main()` before the router is built:

- `flipperWebIsHostApp = true` — makes the shared stack persist login identity
  and the sale device id in `SharedPreferences` instead of Flipper POS's
  GetIt-registered box, which HR never registers.
- `postSelectionRouteName = HrRoute.home` — the shared business/branch selector
  lands on HR (`/people`) instead of Books (`/accounting`).
- `brandPanelBuilder = (_) => const HrBrandPanel()` — the right half of the
  sign-in / sign-up screens (desktop widths only) renders HR's panel instead of
  Books'. Unset, it falls back to flipper_web's `WebBrandPanel`.

`HrBrandPanel` keeps the shared panel geometry — gradient, glow, rings, three
floating cards — with HR's own content: payroll totals, a new-hire card and an
attendance streak, over the headline "Your team, your time, your people". It
implements `Flipper HR Right Panel.html` from the `personal` design project.

Same Supabase project and same `apihub` endpoints as flipper_web, so PINs, OTP
and TOTP behave identically. Sessions are per-origin browser storage: signing in
on `hr.useflipper.com` does not carry a session over from `useflipper.com`, it is
the *account* that is shared, not the browser session.

## People — the employee directory

`/people` is HR's first module: the roster for the selected branch. Every other
HR feature (attendance, leave, payroll) references an employee record, so this
is the table they all hang off.

Supabase is the only store. Unlike POS entities, HR records are never read
offline through Ditto, so there is no dual-write — `hr_employees` in the same
Supabase project flipper_web uses.

```
lib/features/people/
  data/employee.dart              DTO + employment enums (plain Dart)
  data/employee_row_mapper.dart   hr_employees row ↔ Employee
  data/employee_repository.dart   backend-agnostic contract
  data/supabase_employee_repository.dart
  data/employee_validation.dart   form rules (pure function)
  data/people_query.dart          search / filter / sort + summary tiles
  data/money_format.dart          RWF + date + tenure formatting
  data/people_providers.dart      repository, roster, query, write actions
  people_page.dart                the directory
  widgets/employee_form.dart      add / edit
lib/features/invite/            three-hop invite (apihub + create_agent)
lib/features/leave/             requests, balances, approvals
lib/features/attendance/        clock in/out, board, timesheet
lib/features/session/           what the database can prove about the caller
supabase/migrations/0001_hr_employees.sql
supabase/migrations/0002_hr_employees_rls_identity.sql
supabase/migrations/0003_hr_employees_rls_pin_identity.sql
supabase/migrations/0004_hr_leave.sql
supabase/migrations/0005_hr_attendance.sql
```

Everything except the two widgets is a pure function or a value object, so the
rules are tested without a backend; the page and form are tested against
`test/helpers/fake_employee_repository.dart`.

Migrations are applied by hand, lowest number first, in the Supabase SQL editor
as the service role — `0001` through `0005`, in order. `0002` and `0003` each fix
the identity mapping the previous one got wrong; stopping before `0003` means
every read and write returns 403.

`0001` creates `hr_employees` with RLS scoped to the businesses the signed-in
account owns; nothing loads until it is applied.

`business_id` and `branch_id` are `uuid`, like the rest of this schema; Dart
holds them as `String` and PostgREST casts on the way in, so nothing in the
client cares.

Membership is the fiddly part, and it took three migrations to get right:

- `0001` reused `user_business_ids()` from `logs_rls_policies.sql`, which
  resolves the caller as `users.uuid = auth.uid()`. That mapping is from the POS
  app's Firebase-era login; `public.users.uuid` is null for real accounts, so it
  resolved nobody and RLS denied everything with a 403.
- `0002` added `hr_identity_keys()` and `hr_phones_match()`, resolving the caller
  from `auth.uid()` or the JWT phone / email. It also assumed a
  `<something>@flipper.rw` login key was `<phone>@flipper.rw`.
- `0003` fixes that: those keys are **`<pin>@flipper.rw`** (`public.pins.pin`,
  an int). A PIN session carries no phone claim at all, and matching the
  synthetic key against `users.email` resolves a `users` row that owns nothing —
  identity resolved, `business_ids` empty, writes still denied. `0003` takes the
  hop the client already takes for these keys (`pins.user_id`, see
  `UserRepository.fetchAndSaveUserProfile`), then treats the phone number as the
  account identity so a PIN-resolved row reaches the sibling `users` row that
  owns the business.

Rows are still only reachable by someone the database can tie to the owning
business. Holding a PIN grants that PIN's user's businesses — the same identity
model the app applies, since the PIN is what signs you in.

`0002` also installs `public.hr_whoami()`, which returns the caller exactly as
the policies see them (`auth_uid`, `identity_keys`, `business_ids`). Its file
ends with the impersonation recipe for testing a policy from the SQL editor
without a browser, and a rolled-back smoke insert.

Two notes on what the data holds:

- Rows carry names, phone numbers, national IDs and salaries, which makes them
  Confidential under IPA's data classification. That is why there is no DELETE
  policy, `anon` is granted nothing, and RLS is not optional here.
- `PeopleSummary`'s payroll figure is an estimate, not a payslip — weekly pay is
  annualised over 52 weeks, and daily/hourly pay uses the 22-working-day and
  8-hour assumptions in `Employee.monthlyCostEstimate`.

## Local

```bash
melos bootstrap --scope="flipper_hr"
flutter run -d chrome        # from apps/flipper_hr
flutter test
```

## Hosting layout

Firebase project: `yegobox-2ee43` (same project as flipper_web production).

| App          | Hosting site   | Domains                                     |
| ------------ | -------------- | ------------------------------------------- |
| flipper_web  | `yegobox-2ee43`| flipper.yegobox.com, useflipper.com         |
| flipper_web  | `flipper-uat`  | preview/UAT channel                         |
| flipper_hr   | `flipper-hr`   | hr.useflipper.com (to be connected)         |

`hr.useflipper.com` must be attached to its **own** hosting site — the default
`yegobox-2ee43` site already owns `useflipper.com`, and a subdomain attached
there would serve flipper_web.

## Deploy

```bash
cd apps/flipper_hr
flutter build web --release

# one time, creates https://flipper-hr.web.app
firebase hosting:sites:create flipper-hr --project yegobox-2ee43

firebase deploy --only hosting --project yegobox-2ee43
```

`firebase.json` pins `hosting.site: "flipper-hr"`, so deploys never touch the
flipper_web sites.

## Connecting hr.useflipper.com

1. Firebase Console → Hosting → site `flipper-hr` → **Add custom domain** →
   `hr.useflipper.com`.
2. Add the records Firebase shows at Namecheap (`useflipper.com` nameservers are
   `dns1/dns2.registrar-servers.com`): a TXT record to verify ownership, then the
   A records for the `hr` host.
3. Wait for the certificate to provision, then sign in with a Flipper PIN and
   confirm HR opens on `/people` with the picked business and branch.

## Attendance — the clock and the timesheet

`0005` adds `hr_attendance_sessions`: **one row per stretch worked**, not one row
per day with clock-in/clock-out columns. People break for lunch and step out
mid-shift, and a single pair of columns forces that into either a lie or a second
table. Per-day totals are derived in `attendance_day.dart`, from the same rule
payroll will read.

| Route | Who | What |
| ----- | --- | ---- |
| `/attendance` | roster managers | the branch board for one day: who is in, since when, how long |
| `/my-time` | anyone with a record | own clock and the last 14 days |

Two things are load-bearing:

- **The server stamps the time.** `hr_clock_in()` / `hr_clock_out()` are RPCs
  because `now()` cannot be expressed in a PostgREST insert payload, and a
  timesheet whose times come from the device is only as trustworthy as the device
  clock — including a deliberately wound-back one. They are `SECURITY INVOKER`,
  so RLS still applies: the RPC decides the *time*, never the *permission*.
- **One open session per person**, enforced by a partial unique index rather than
  a client-side check. Two taps on a slow connection would otherwise both pass a
  check and double-count the day.

The board's rows come from the **roster**, not from the attendance rows, so
someone who has not clocked in reads as "Not in" rather than being invisible —
"who is missing?" is the question a manager opens it for.

Elapsed time for an open session is computed at build from `hrClockProvider`, not
ticked by a timer: a timer that never settles makes every widget test touching
the page hang, and a minute of staleness on "2h 14m" is not worth that.

Public holidays are not deducted anywhere in HR yet — see the note in
`leave_working_days.dart` for why a hardcoded Rwandan calendar would be wrong
within a year.

### The invited manager

`HrRole.manager` writes an `accesses` row (feature `HR`, level `admin`, via
`create_agent`) — but until `0006` **no HR policy read `accesses` at all**. Every
policy scoped on `hr_user_business_ids()`, which resolved businesses by ownership
alone, so an invited manager signed in and saw only their own leave and time. The
role promised authority the database did not grant.

`0006` makes that function answer "which businesses may this caller act in as
HR?" — owned, **or** carrying a live `HR`/`admin` grant. Since every HR policy
already routed through it, nothing else changed, and the client cannot tell the
two routes apart (that is why the session layer needed no new branch).

Worth being explicit about the consequence: an HR manager can read and edit the
roster, **salary included**. If that is ever not wanted, the answer is a narrower
grant — a separate feature name for pay, with its own policy — not a quieter
version of this function.

`hr_whoami_access()` reports the halves separately (`owned`, `managed`,
`effective`), which is the first thing to check when a manager sees too much or
too little. Keying on the feature name `HR` is safe because it is not one of
Flipper's POS features (`AppFeature` in flipper_services/constants.dart), so this
cannot silently promote an existing POS user.
