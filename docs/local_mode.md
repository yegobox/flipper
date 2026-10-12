# Local mode (offline on this device, free forever)

A business can choose at signup to keep its data on one device only. Ditto runs
with no cloud connection, nothing syncs, and the user never sees a paywall.
EBM and Flo are unavailable. The user can later opt in to cloud sync, which is
one-way and brings back the normal paid flow.

Native only. Ditto on the web is cloud-only, so web signup has no such option.

## The flag

`LocalMode` (`apps/flipper_web/lib/core/local_mode/local_mode.dart`) is the
single source of truth. `LocalMode.isOn` is synchronous. `main.dart` calls
`LocalMode.load()` before the repository starts.

The flag is a property of the device's Ditto store, not of a user or a business.
Every login on the device shares `db2`, including staff PIN logins, so a
per-user flag would let one login reopen the store with cloud sync and upload
everything. It is stored as a marker file, `.flipper_local_mode`, inside the
store directory. That way it survives logout and `box.clear()` (which the login
and signup screens call), and it disappears with the store.

Only signup sets it (`LocalModeController.enterForSignup`). Existing businesses
can never enter local mode.

## What it switches off

| Area | Choke point |
|---|---|
| Ditto cloud | `DittoSingleton.initialize` opens with `DittoConfigConnectSmallPeersOnly`, turns every transport off, and never registers the JWT handler. `_performAuthentication`, `SyncMixin.startSync` and `ensureDittoCloudWriteReady` return early. |
| Supabase / Turso writes | `Repository.initialize` skips `offlineRequestQueue.start()` and the Turso push. Queued writes stay on disk. |
| S3 / EBM background jobs | `StartupViewModel` skips `EbmSyncService`, `AssetSyncService` and `ReceiptSyncService`. |
| Paywall | `PaymentVerificationService.verifyPaymentStatus` returns `active`, and `hasActiveSubscription` returns `true`. The navigator and `_handleStartupError` go home instead of to a paywall. Periodic and realtime checks never start. |
| EBM | `isTaxEnabled` returns false (CoreSync + CapellaSync). `LocalModeTaxGuard` wraps `RWTax`, so no path reaches the tax server. The EBM admin tiles, the ribbon tax settings and the tax-down banner are hidden. |
| Flo | The bottom-nav tab, the desktop side menu, and the Chat tile (`kLocalModeHiddenPages`, which also covers HR and Credits) are hidden. `navigateToDashboardAppPage` refuses those pages. The `Ai` widget shows a stub. `initLocalAi` is skipped. |
| Menus | flipper-turbo writes `business_features` into Ditto Cloud, which a local device never receives. `AppService.kLocalModeFeatures` stands in for it. |

## Opting in

The opt-in action, `confirmAndTurnOnCloudSync`, is offered from the drawer and
from Settings. It needs internet, because the next login talks to the server.
The steps are:

1. Delete the marker.
2. Resume the Supabase queue.
3. Open the standard sign-out dialog.

On the next login, Ditto reopens the same store with the server connect.
`local_mode_ditto_store_test.dart` proves the documents survive that reopen.
The documents then upload, and startup's payment check shows the plan picker
like it does for any new business.

## Tests

- `flipper_models/test/local_mode_gates_test.dart`: paywall bypass and tax guard, with the flag on and off.
- `flipper_models/test/local_mode_ditto_store_test.dart`: real Ditto store switching from local to server. Needs `LIBDITTOFFI_PATH`.
- `flipper_dashboard/test/local_mode_flo_hidden_test.dart`: the Flo tab and the hidden tiles.
