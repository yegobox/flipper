# Ticket Review + Handover — debug briefing

## What this feature is

An opt-in, per-business workflow that inserts two extra ticket statuses between "payment collected" and "ticket completed":

```
parked/waiting/inProgress --[pay in full]--> pendingReview
                                 |  (hidden from normal Tickets list; only in Review Queue)
                       [Reviewer marks reviewed]
                                 v
                          awaitingHandover  (back in Tickets list, "Reviewed" badge, "Record handover" button)
                                 |
                       [Stock Manager records handover]
                                 v
                            completed   (disappears — same as today)
```

Payment/tax-signing timing is unchanged — only the *persisted status string* is redirected. When the business setting is off, behavior is byte-identical to before this feature existed.

## Git state — check this FIRST

Two commits on `main`:
```
4c3aaa861 feat(tickets): add opt-in Ticket Review + Handover workflow
5639babee chore(qa): temporarily disable kDebugMode access bypass for permission testing
```
Run `git log --oneline -5` on this machine and confirm both hashes are present. If they're missing, you're debugging stale code — pull first, everything below is moot until then.

## The reported symptom

> Created a user with **user type = "Reviewer"**, logged in as them, opened Tickets, and see no visible difference from a normal user.

**Important: "Reviewer" as a user type is JUST a text label in a dropdown.** It does not itself grant any permission. See `packages/flipper_dashboard/lib/features/tenant/mixins/tenant_management_mixin.dart` line ~260 — `'Reviewer'` and `'Stock Manager'` were added purely as convenience presets. The actual permission is a separate `Access` row for `AppFeature.TicketReview` (or `StockHandover`), granted via the permission-matrix checkboxes shown further down the same Add/Edit User form (`buildPermissionsSection()` → renders because `selectedUserType != 'Agent'`, so it should be visible for a "Reviewer" user). **If the admin only picked "Reviewer" from the dropdown and didn't also set the "TicketReview" row in that matrix to Write/Admin, then seeing no difference is the CORRECT, expected behavior — not a bug.**

Cosmetic note: that matrix renders the raw `AppFeature` constant as the label, so the two new rows show as **"TicketReview"** and **"StockHandover"** (no space) — easy to miss/misread, not a rendering bug.

## The two independent AND-gates for any visible UI difference

Both must be true simultaneously, or the Reviewer sees nothing different:

1. **Business setting**: `Setting.enableTicketReviewWorkflow == true` for the business the test user is logged into. Toggle lives in AdminControl → "Ticket Review + Handover" switch (`packages/flipper_dashboard/lib/AdminControl.dart`). Backed by `SettingsService.enableTicketReviewWorkflow` (`packages/flipper_services/lib/setting_service.dart`).
2. **User permission**: an active `Access` row for that specific `userId` with `featureName == 'TicketReview'` (or `'StockHandover'`) and `accessLevel` of `write` or `admin`, `status == 'active'`, not expired. Checked via `featureAccessProvider` in `packages/flipper_models/lib/providers/access_provider.dart`.

The exact gate condition (in `packages/flipper_dashboard/lib/features/tickets/screens/tickets_screen.dart`, ~line 479):
```dart
if (locator<SettingsService>().enableTicketReviewWorkflow &&
    ref.watch(featureAccessProvider(userId: ..., featureName: AppFeature.TicketReview)))
```
This gates the Review Queue icon+badge in the Tickets AppBar. Even with the icon showing, the badge count only shows a number if there's an actual ticket in `pendingReview` status (i.e., someone parked + fully paid a ticket while the workflow was on) — an empty badge is normal if no ticket has gone through the flow yet.

## ⚠️ The `kDebugMode` bypass is currently DISABLED (commit `5639babee`)

`packages/flipper_models/lib/providers/access_provider.dart`, inside `featureAccess()`:
```dart
// if (kDebugMode) {
//   return true;
// }
```
This was commented out on purpose so debug builds enforce real `Access` grants (otherwise every permission check — not just these two — always returns `true` in debug mode, which is normally a dev convenience but hides whether real gating works). **This affects the ENTIRE app's permission system**, not just this feature — if other screens seem to have lost access unexpectedly on this machine, this is why. Revert by uncommenting those two lines (and removing the `// ignore: unused_import` note above the `flutter/foundation.dart` import) once QA is done — do not merge it disabled.

## Debug checklist, in order of likelihood

1. **Confirm commits `4c3aaa861`/`5639babee` are present** on this machine (`git log --oneline -5`).
2. **Confirm the Supabase columns exist** — `transactions.reviewed_by/reviewed_at/handover_by/handover_at` and `settings.enable_ticket_review_workflow`. If missing, the setting/permission may silently fail to persist/sync. SQL:
   ```sql
   alter table public.transactions
     add column if not exists reviewed_by text,
     add column if not exists reviewed_at timestamptz,
     add column if not exists handover_by text,
     add column if not exists handover_at timestamptz;
   alter table public.settings
     add column if not exists enable_ticket_review_workflow boolean;
   ```
3. **Confirm the business toggle is actually ON** — log in as admin/owner on this machine, AdminControl → check the "Ticket Review + Handover" switch state directly (don't assume it synced from the other machine — see next point).
4. **Hydration timing**: `SettingsService.enableTicketReviewWorkflow` is only refreshed via `hydrateToggleStatesFromSettings()` at **login / session-resume** (`packages/flipper_services/lib/app_service.dart`, `_hydrateSettingsToggles()`), not via a live listener while the app is already running. If the toggle was flipped ON *after* the Reviewer was already logged in on this machine, they won't see it until they log out/in again (or restart the app).
5. **Confirm the Reviewer's `Access` row actually exists** — query the `accesses` table (or `Access` model) for that `userId` + `featureName = 'TicketReview'`, check `accessLevel` is `write`/`admin` (case-insensitive) and `status = 'active'`.
6. **Confirm you're checking the right symptom** — the Review Queue icon is a small icon button in the Tickets screen's AppBar (top-right area, `Icons.fact_check_outlined`), next to the existing "⋮" menu. It's easy to miss if it renders with no badge (0 pending-review tickets).
7. **Create an actual test ticket** to get real signal: park a ticket → pay it in full while the toggle is ON → it should vanish from the normal Tickets list (this alone proves the redirect logic fired) → then check whether the Reviewer's Review Queue badge shows `1`.
8. If step 7's ticket does NOT disappear (i.e., it completes normally instead of going to `pendingReview`), the redirect itself isn't firing — check the box-cached flag `ProxyService.box.readBool(key: 'ticketReviewWorkflowEnabled')` at the payment call sites (`packages/flipper_models/lib/view_models/mixins/_transaction.dart` and `packages/flipper_dashboard/lib/mixins/previewCart.dart`) — this is a separate, synchronous cache from `SettingsService`, also populated only by `hydrateToggleStatesFromSettings()`/`updateSettings()`, subject to the same staleness issue as point 4.

## Key files (for grepping)

- Status constants: `packages/flipper_services/lib/constants.dart` (`PENDING_REVIEW`, `AWAITING_HANDOVER`, `AppFeature.TicketReview/StockHandover`)
- Redirect logic: `packages/flipper_models/lib/helperModels/sale_completion_helpers.dart` (`applyTicketReviewWorkflowRedirect`)
- Payment call sites: `packages/flipper_models/lib/view_models/mixins/_transaction.dart`, `packages/flipper_dashboard/lib/mixins/previewCart.dart`
- Mutations: `packages/flipper_models/lib/helpers/ticket_review_actions.dart` (`markTicketReviewed`, `recordTicketHandover`)
- Settings toggle: `packages/flipper_services/lib/setting_service.dart`, `packages/flipper_dashboard/lib/AdminControl.dart`
- Permission checks: `packages/flipper_models/lib/providers/access_provider.dart` (`featureAccessProvider`)
- Tickets query / Review Queue stream: `packages/flipper_models/lib/sync/capella/mixins/transaction_mixin.dart`, `packages/flipper_models/lib/providers/tickets_provider.dart`
- UI: `packages/flipper_dashboard/lib/features/tickets/screens/tickets_screen.dart` (entry point), `.../screens/review_queue_screen.dart`, `.../widgets/tickets_list.dart` (`TicketCard`), `.../models/ticket_status.dart`
- Tenant permission matrix / user-type dropdown: `packages/flipper_dashboard/lib/features/tenant/mixins/tenant_management_mixin.dart`, `tenant_permissions_mixin.dart`
