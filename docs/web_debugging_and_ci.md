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

`dwds` gives Chrome 4 attempts x 5s = 20s to answer the Chrome DevTools
Protocol `Debugger.enable` call:

```dart
// dwds/lib/src/debugging/webkit_debugger.dart
var attempts = 3;
while (true) {
  try {
    await _wipDebugger.enable().timeout(const Duration(seconds: 5));
    return;
  } on TimeoutException {
    if (attempts-- == 0) rethrow;
  }
}
```

DDC emits one JS module per library, and `flipper_web` / `flipper_hr` resolve
roughly 378 packages. `Debugger.enable` makes Chrome report every parsed script,
and it cannot finish that inside 20s. Upstream acknowledges the race in a TODO
on the same function.

### Fix

```sh
scripts/patch_dwds_timeout.sh
```

Idempotent. It finds whichever dwds your `flutter_tools` resolves (it does not
hardcode a version), raises the timeout to 60s, backs up the original beside it
as `webkit_debugger.dart.orig`, and rebuilds `flutter_tools.snapshot` — that
rebuild is required, because dwds is compiled *into* the snapshot.

```sh
scripts/patch_dwds_timeout.sh --check    # is it applied on this machine?
scripts/patch_dwds_timeout.sh --revert   # restore the original
DWDS_ENABLE_TIMEOUT=120 scripts/patch_dwds_timeout.sh   # allow even longer
```

**This patch is not permanent.** It lives in `~/.pub-cache`, which is not in
git, so it is undone by `flutter upgrade`, `dart pub cache repair`, a Flutter
bump that moves dwds to a new version, or a new machine. Re-run the script.

### What is NOT the cause

High CPU load. This was tested and ruled out: a run failed at load average 33
(a parallel `cargo test`) *and still failed at load 7* once that finished. Load
changes only compile time — 415.8s busy versus 193.2s quiet. It does not decide
the attach. Do not spend time chasing it.

### If you cannot patch

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

### The `dwds-guard` job

Web release builds do not use dwds, so this never blocks shipping. It runs
`scripts/patch_dwds_timeout.sh --ci`, which checks that the patch *still
applies* — not that it is applied, since CI always has a pristine pub-cache. It
fails when the resolved dwds version drifts from `EXPECTED_DWDS` in the script,
so a Flutter bump tells you immediately instead of someone rediscovering the
20s timeout mid-debug.

When it fails: re-run the script locally, confirm `flutter run -d chrome`
attaches for `apps/flipper_web`, then bump `EXPECTED_DWDS` and commit.
