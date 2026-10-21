# Personal mode (personal money management)

Someone who uses Flipper for their own money, not a shop, gets a separate app:
money in and out, where it went, bank and MoMo SMS to review, savings goals and
Flo. There is no POS, no stock and no EBM. A business can switch to personal
and back. Nothing is deleted either way.

## Prerequisite: Supabase and data-connector

The client treats anything it cannot read as **business**, so shipping it
before the server changes is safe. Until those changes are live, nobody can
switch to personal mode, and a personal signup stays pending on its device.

- **Supabase** (Flipper-Database, migration `20261021120000_business_account_mode.sql`):
  adds `businesses.account_mode` (`'business'` by default, or `'personal'`) and
  `account_mode_changed_at`. A guard trigger keeps the stored value for
  anon/authenticated writers, so old builds that upsert whole Brick `Business`
  rows can never flip it. Only service_role (data-connector) changes it.
- **data-connector** (`src/account_mode.rs`, `src/api/account_mode.rs`):
  - `GET/POST /api/account-mode` writes the column and mirrors it into Ditto
    `business_account_modes/<businessId>` `{mode, changedAt}`. An hourly sweep
    repairs a lost mirror write.
  - Switching to personal pauses a live card (Dodo) subscription.
  - Server jobs skip personal businesses: the daily sales email, "no sale yet"
    nudges, and MoMo renewals and mandate prompts. Flo answers from Cash
    In/Out by category (`personal_spend.rs`).

## Why not `businessTypeId == 2`

Real shops have type 2 ("Individual"), because old web signup sent it.
"Individual" is also what a shop without a TIN picks at native signup, and
`CoreSync.signup` drops the id anyway. Routing on it would move shops out of
their POS. The old gamified `apps/flipper_personal` stays behind its kill
switch (`PaymentVerificationNavigator.personalAppEnabled = false`) and is
unrelated.

## How the device knows

`AccountModeStore` (`flipper_models/lib/account_mode/`) decides, in this order:

1. The Ditto doc, which the server wrote.
2. A personal signup the server has not confirmed yet (box
   `pendingAccountMode`).
3. The cached value (box `accountModes`, JSON keyed by business).
4. Otherwise **business**.

`localMode()` never touches the network. `resolve()` may ask the connector
**once per business per session**, and only on the paths that would show a
paywall. An account with a working plan never waits for it.

`accountModeProvider` follows the Ditto doc live. `FlipperApp` (the
`FlipperAppRoute` page) is a gate: it shows `PersonalShell` for personal and
the unchanged business app for everything else. A switch made on another
device therefore swaps shells without a navigation.

## Routing and billing

- `PaymentVerificationNavigator.handle`: for a personal account, a missing or
  failed plan is treated as active, so no paywall is shown.
- `_navigateToAuthenticatedHome`: a personal account goes straight to
  `FlipperAppRoute`. It skips the gamified app, the commission screen and the
  bar/hotel modes.
- `AuthMixin` login skips the subscription check for a personal account, next
  to the type-2 waiver.
- Switching back to business runs `verifyAndNavigate(userInitiated: true)`, so
  the normal plan screen decides.

## Recording money

The `+` sheet and confirming an SMS both go through `completeCashMovement`,
just like the Cash Book. Books, the ledger poster and Flo therefore see
ordinary Cash In / Cash Out rows. Category names are the branch's
`Category` rows. The personal suggestions (`kPersonalIncomeCategories` /
`kPersonalExpenseCategories`) are created on first use. A personal account
never registers its Cash Book's hidden "Utility" item with RRA: in
`CoreSync.getUtilityVariant`, `skipRRaCall` is set from the account mode.

## Entry points

- **Signup (native)**: "What will you use Flipper for?" defaults to *Run a
  business*. Picking *My personal money* registers the business as
  Individual (no TIN), marks the device pending, and confirms with the
  server.
- **Business → personal**: phone Settings, Account group → *Use Flipper for
  personal money*, or desktop Admin Control (above the danger zone). This is
  admin only, behind the admin PIN when it is on.
- **Personal → business**: personal app → More → *Use Flipper for a
  business*.

## Not covered yet

- Web (flipper_web / Books) has no personal shell or signup choice. A personal
  account that logs in there gets Books.
- The home shows this month's flow per account, not all-time balances.
- rw/sw strings need a native speaker's review.
- Local mode (`feat/local-mode`) has not been combined with this. A
  local-only device cannot reach the connector to switch.
