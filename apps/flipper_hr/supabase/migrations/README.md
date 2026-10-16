# Retired: write new HR migrations in the `supabase` repo

Do not add files here. New HR schema changes go in the shared Supabase repo
(`yego-project/supabase/migrations/`, GitHub `yegobox/Flipper-Database`) as a
timestamped `YYYYMMDDHHMMSS_hr_<topic>.sql`, and reach production through
`supabase db push` like every other table.

Why: these files were applied by hand in the SQL editor, so nothing recorded
which ones production had. `0011_hr_payroll.sql` shipped in the HR build but was
never applied. Payroll then failed with
`PGRST205 Could not find the table 'public.hr_advance_requests'` until it was
applied on 2026-10-16 (Flipper-Database #17).

What these files are now: the design history, which the app README and code
comments still refer to by number. Where each one lives in production:

| File | Production | Tracked in `supabase/migrations/` |
|------|------------|-----------------------------------|
| `0001`–`0009` | applied | inside the 2026-09-15 baseline (`20260915080037_remote_schema.sql`) |
| `0010_hr_mobile_phone_identity.sql` | **not applied, on purpose** | no |
| `0011_hr_payroll.sql` | applied 2026-10-16 | `20261016120000_hr_payroll.sql` |

`0010` stays out deliberately. The mobile app's Supabase account uses its own
email as the password, so with `0010` anyone who knows an owner's phone number
could read that business's HR rows. Until mobile HR uses the server-minted
session (the `refreshToken` from `/v2/api/login/verify-otp`), HR inside the
mobile app sees no data. When that lands, drop `0010` instead of applying it.
