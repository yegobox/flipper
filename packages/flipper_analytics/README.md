# flipper_analytics

Shared PostHog analytics for Flipper apps (`flipper`, `flipper_web`, …).

## PostHog: Activity vs dashboards

**Activity** (Data → Activity) is a raw event log — every event the SDK sends appears there immediately.

**Dashboards** (e.g. the default **Product analytics** template) run **pre-built queries**. The stock template targets **web SaaS** and uses **`$pageview`** for DAU/WAU/retention. Flipper is a **Flutter** app, so those charts stay empty even when Activity shows data.

That is normal until you point dashboards at Flipper’s events.

## Recommended “active user” event

Use **`product_active`** for DAU, WAU, retention, and growth charts.

| Event | When it fires | Use for |
|-------|----------------|---------|
| **`product_active`** | Cold start + each foreground resume | **DAU / WAU / retention** (recommended) |
| `login_success` | After successful login | Logged-in funnel |
| `Application Opened` | PostHog SDK lifecycle (auto) | Fallback if not using `product_active` |
| `$screen` | Books web route changes (`PosthogObserver`) | Web screen funnels only |

`product_active` is registered automatically when you call `FlipperAnalytics.initialize()` (see `ProductActiveLifecycle`).

## Configure the Product analytics dashboard

1. Open **Analytics → Dashboards → Product analytics**.
2. Edit each insight (pencil icon):
   - **Daily active users** → event: **`product_active`** (not `$pageview`).
   - **Weekly active users** → same.
   - **Retention** → starting event: **`product_active`**, returning event: **`product_active`**; set date range to include recent data.
   - **Growth accounting** → active event: **`product_active`**.
3. While testing, disable **Filter out internal and test users** (or add your test accounts to the allowlist).
4. Set the dashboard date range to **Last 7 days** (or **Last hour** while smoke-testing). Retention needs multiple days of data to be meaningful.

Quick sanity check: **Analytics → Trends** → event **`product_active`** → **Last hour**. You should see the same sessions as in Activity.

## Events emitted by Flipper

Defined in `lib/src/events/analytics_events.dart`:

| Event | Meaning |
|-------|---------|
| `product_active` | App opened or returned to foreground |
| `login_success` / `login_failed` | Auth outcome |
| `signup_completed` | New account |
| `transaction_completed` / `quick_sell_completed` | POS sales |
| `product_created` | Catalog add |
| `business_selected` / `branch_selected` | Session context |
| `books_session_started` | Books web session |
| `ditto_init_ready` / `ditto_init_failed` | Ditto bootstrap |
| `journal_entry_posted` / `expense_recorded` / `bank_statement_imported` | Books accounting |

PostHog also auto-captures (when enabled in `PostHogTransport`):

- `Application Opened`, `Application Backgrounded`, `Application Installed`, …
- `$identify`, `$groupidentify` from `identify()` / `group()` calls

## Per-app wiring

| App | Init | Screen tracking |
|-----|------|-----------------|
| `flipper` | `main.dart` → `FlipperAnalytics.initialize` | Lifecycle + `product_active` |
| `flipper_web` | `main.dart` → `FlipperAnalytics.initialize` | `PosthogObserver` on `GoRouter` + `product_active` |

Windows desktop uses HTTP fallback in `PostHogTransport` (no native SDK); events still reach PostHog.

## Local development

- Project token: `AppSecrets.postHogProjectToken` / `POSTHOG_API_KEY` in native builds.
- Debug builds set `build_mode: debug` on every event — filter or exclude in PostHog when analysing production usage.
- Events queue offline (`OfflineFirstAnalytics` + local store) and flush on connectivity / every 5 minutes.

## Duplicate dashboard (optional)

To keep the PostHog template intact:

1. **Dashboards → New dashboard** → “Flipper product”.
2. Add insights cloned from Product analytics but using **`product_active`**.
3. Pin that dashboard for the team.
