# Web: local debugging and CI coverage

## `flutter run -d chrome` hangs, then "Failed to connect to the web debug service"

### Symptom

The app compiles, Chrome opens, the page loads — and then the run dies:

```
Waiting for connection from debug service on Chrome...            329.6s
Flutter run key commands.
...
Failed to establish connection with the web debug service:
TimeoutException after 0:00:05.000000: Future not completed
#1  WebkitDebugger.enable (package:dwds/src/debugging/webkit_debugger.dart:158:9)
Failed to connect to the web debug service.
```

Only the *debugger attach* fails. The app itself is fine.

### Cause

Before Flutter 3.50.1, `dwds` gave Chrome 4 attempts x 5s = 20s to answer the
Chrome DevTools Protocol `Debugger.enable` call. DDC emits one JS module per
library, and `flipper_web` / `flipper_hr` resolve roughly 378 packages.
`Debugger.enable` makes Chrome report every parsed script, and it could not
finish that inside 20s.

### Fix

Fixed upstream in dwds 27.2.1, which Flutter 3.50.1 ships: it now waits up to
3 minutes and resends `Debugger.enable` every 5s. Up to 3.47.9 we patched the
timeout in `~/.pub-cache` with `scripts/patch_dwds_timeout.sh`. That script and
its CI guard were removed with the 3.50.1 bump. If you see this symptom, check
`flutter --version` first.

### What is NOT the cause

High CPU load. This was tested and ruled out: a run failed at load average 33
(a parallel `cargo test`) *and still failed at load 7* once that finished. Load
changes only compile time — 415.8s busy versus 193.2s quiet. It does not decide
the attach. Do not spend time chasing it.

### If it still fails

`flutter build web --release` and serve `build/web` statically. No DWDS, so no
attach problem — but no debugger either. Note that `python3 -m http.server` has
no SPA rewrite, so deep-link refreshes 404 locally; Firebase Hosting rewrites
`**` to `/index.html`.

### Cleanup

An aborted attempt can leave an orphaned Chrome pointed at the dead run's port,
which makes a later run fail with `ERR_CONNECTION_REFUSED` on
`ws://localhost:<port>/$dwdsSseHandler`:

```sh
pkill -f flutter_tools_chrome_device
```

## CI: `.github/workflows/web_ci.yml`

Runs on every PR to `main` / `dev`. Before it existed, `flutter build web
--release` ran only in `release.yml`, so the web apps could break and nothing
said so until a release.

Per app (`flipper_web`, `flipper_hr`):

1. **Unit tests** — `flutter test` in the app.
2. **Release build** — `flutter build web --release`, asserting `main.dart.js`
   exists, then deleting `main.dart.mjs` / `main.dart.wasm`. This mirrors
   `release.yml`; keep the two in step. dart2js only — dual-target WASM serves
   `main.dart.mjs` to Chrome and the Ditto DQL read-after-write cold start
   breaks replication bootstrap.
3. **Boot smoke** — serves the built bundle and loads it in headless Chrome via
   `scripts/ci/web_boot_smoke.mjs`, failing if `<flutter-view>` never mounts,
   renders at zero size, or the page raises console/page errors while booting.
   A screenshot is uploaded as an artifact on every run, pass or fail.

A build gate alone would not catch a bundle that compiles and then serves a
blank page — precisely the dart2wasm failure `release.yml` documents. That is
what the boot smoke is for.

Measure `<flutter-view>`, not `<flt-glass-pane>`: the glass pane is a shadow
host whose own bounding rect is 0x0 even on a perfectly healthy app.
