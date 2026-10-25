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
   A switch is cached with the time the server sent, never the device
   clock: a clock running ahead would outrank later switches made elsewhere.
   `accountModes` and `pendingAccountMode` are local-file-only in the box's
   Ditto prefs merge (`_localFileOnlyKeys`). Before that, the background
   Ditto copy, still holding the mode from before a switch, won the merge
   when Ditto attached and flipped personal back to business "after a while".
2. Without a doc, a personal signup the server has not confirmed yet (box
   `pendingAccountMode`), then the cache.
3. Otherwise **business**.

`localMode()` never touches the network. `resolve()` may ask the connector
**once per business per session**, and only on the paths that would show a
paywall. An account with a working plan never waits for it.

`accountModeProvider` follows the Ditto doc live. When the mode changes because of
another device, the home says so ("…switched … on another device"),
`shouldAnnounceModeSwitch`. Each value says whether a server Ditto doc backs
it (`fromServer`); the cached fallback never counts, and the first
server-backed value is only the baseline, however late it arrives. A switch
of the same business made here (in flight, or taken by the server in the
last 2 minutes, `switchedHereRecently(businessId)`) is never announced; a
switch the server refused clears that marker. `FlipperApp` (the
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
  POS. Behind the home, the paywall (and the commission screen) replaces the
  whole stack, so Android back cannot return to the POS. The blocking path
  still pushes it, as before. The startup grace is spent when the home opens,
  so a `plans` realtime event in the meantime cannot open a second home.
  After an active result, `reconcileCommissionOnlyHome()` re-asks whether
  the session is commission-only (the blocking path asked on every start)
  and swaps the home if the answer changed. Every other start (no session,
  QR `login-` identity, fresh signup) keeps the blocking path.
- Startup logs one `[startup] fast|blocking ditto=… requirements=… appInit=… home=…`
  line.
- **Notification taps**:
  - `openEngagementAction` queues an action when no handler is registered
    yet. That is a cold start, where the push is read during startup. The
    queued action runs once the home registers its handler, if within
    `kPendingEngagementTtl` (2 minutes).
  - FCM tap listeners are registered once per process.
  - A local notification that launched the app is routed the same way, once
    per process (`claimLaunchEngagementTap`): `NotificationManager.create`
    runs at boot and again lazily, and the launch details never change.
  - `new_sale` is a handler too, registered by the business home
    (`FlipperApp`), so a cold-start tap waits for the home instead of
    pushing the POS onto the splash screen.
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

## Loans (`flipper_models/lib/personal_loans/`, `features/personal_finance/loans/`)

Money the user borrowed: bank, SACCO, MoMo loans, family.

- **Storage.** Ditto-only collections `personal_loans` and
  `personal_loan_payments`, keyed by `businessId`, soft-deleted with
  `deletedAt`. They are not windowed or evicted (only `transactions` is).
- **Two ways to add a loan:**
  - *I know the details*: amount, start date, term or monthly payment, and
    optionally the rate.
  - *I know the monthly payment*: the payment and the month it ends, with the
    rate and today's balance optional. Many people only remember this much.
- **Maths** (`loan_math.dart`, pure and tested). It is reducing-balance,
  bank-style, with monthly interest at rate/12; rate 0 is plain subtraction.
  - The balance starts from an anchor, in this order: a balance the user
    entered today, then the amount on its start date, then an estimate (the
    present value of the remaining installments up to the end date).
  - From the anchor, interest is added every month and recorded repayments
    are subtracted.
  - The outlook simulates the installment forward: months left, payoff date,
    interest still to pay, or "never ends" when the payment is below the
    interest.
- **Repayments:**
  - The money-out form with category *Loan repayment* records a Cash Out
    (so it counts as spending) and a payment linked through `transactionId`.
  - SMS review does the same in personal mode: pick *Loan repayment*, then
    the loan.
  - A loan with no repayment this month shows "No repayment recorded".
- **What if I borrow…**:
  - It compares the new installment with the last 30 days of money in and
    money out, leaving loans out of both sides (30 days is the history the
    device keeps), and with current installments.
  - Verdict: up to 30% of income is comfortable, up to 40% is tight, more is
    risky. "Not covered" means nothing is left at the end of the month.

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
