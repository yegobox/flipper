# Flipper Maestro flows

These flows target Flutter `Semantics.identifier` values, not visible copy.
That keeps Maestro stable across localization and UI wording changes.

## Local run

From the `flipper/` repo root:

```bash
./scripts/maestro/run_android.sh
```

The script expects an Android emulator or device to be running. It installs the
debug APK if `build/app/outputs/flutter-apk/app-debug.apk` exists, then runs the
fresh-install smoke flow:

```bash
APP_ID=rw.flipper maestro test .maestro/00_landing_to_pin_smoke.yaml
```

Run a specific seeded flow with:

```bash
FLOW_PATH=.maestro/10_pin_entry_smoke.yaml ./scripts/maestro/run_android.sh
```

## CI

GitHub Actions runs `.github/workflows/maestro_android.yaml` on manual dispatch
and on pull requests that touch app, login, dashboard, Android, or Maestro files.

Required repository secrets match the existing Flipper Android workflows:

- `CONFIGDART`
- `SECRETS`
- `FIREBASEOPTIONS`
- `AMPLIFY_CONFIG`
- `AMPLIFY_TEAM_PROVIDER`
- `GOOGLE_SERVICE_JSON`

## Stable IDs

Login IDs live in `packages/flipper_login/lib/login_semantics.dart`.
mPOS IDs live in `packages/flipper_dashboard/lib/maestro_semantics.dart`.
