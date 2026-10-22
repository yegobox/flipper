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

1. The Ditto doc (server-written) or the cached value (box `accountModes`,
   `{businessId: {mode, changedAt}}`), **whichever has the later server
   `changedAt`**. Right after a switch the cache is newer, because the doc
   only changes when the connector's write syncs back. Without this, a
   switch needed several taps. A cache entry with no time never beats a doc.
2. Without a doc, a personal signup the server has not confirmed yet (box
   `pendingAccountMode`), then the cache.
3. Otherwise **business**.

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
- A personal home is always opened with `clearStackAndShow`, and
  `PersonalShell` swallows back (another tab goes to Home first), so back
  never reaches `StartUpView`.

## Startup and notification taps (all accounts)

- **Cached-session fast path** (`StartupViewModel.fastStartupFor`). A
  signed-in device with its business and branch cached:
  - opens Ditto locally, without waiting on the apihub login;
  - runs the local requirement check and `appInit`;
  - opens the home through `PaymentVerificationNavigator.enterHomeFromCache()`,
    which makes no network calls and waits on no settings;
  - then runs the plan check behind it with `handle(alreadyHome: true)`.

  That check never opens the home a second time. It is *decisive*: a lapsed
  plan still reaches the paywall even if the user has already tapped into the
  POS. Every other start (no session, QR `login-` identity, fresh signup)
  keeps the blocking path.
- Startup logs one `[startup] fast|blocking ditto=… requirements=… appInit=… home=…`
  line.
- **Notification taps**:
  - `openEngagementAction` queues an action when no handler is registered
    yet. That is a cold start, where the push is read during startup. The
    queued action runs once the home registers its handler, if within
    `kPendingEngagementTtl` (2 minutes).
  - FCM tap listeners are registered once per process.
  - A local notification that launched the app is routed the same way.
- SMS review logs `[sms-review] branch=… pending=… syncActive=…` once per
  subscription, so "SMS not showing" can be read from logcat.

## Recording money

The `+` sheet and confirming an SMS both go through `completeCashMovement`,
just like the Cash Book. Books, the ledger poster and Flo therefore see
ordinary Cash In / Cash Out rows. Category names are the branch's
`Category` rows. The personal suggestions (`kPersonalIncomeCategories` /
`kPersonalExpenseCategories`) are created on first use. A personal account
never registers its Cash Book's hidden "Utility" item with RRA: in
`CoreSync.getUtilityVariant`, `skipRRaCall` is set from the account mode.

## SMS review in personal mode

- Home: `SmsReviewHomeCard` when SMS are waiting. Otherwise a
  "No bank or MoMo SMS waiting" row that links to SMS Bridge pairing.
- The Home nav item carries `SmsReviewCountBadge`.
- More → *SMS to review* (with the count) opens `showSmsReviewSheet`.
- `smsReviewBranchIdProvider` is auto-disposed, so a shell swap or a business
  switch reads the branch again.

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
