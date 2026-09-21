# CI fixtures

Non-secret stand-ins for the gitignored files the web build needs in order to
compile. `web_ci.yml` copies them into place.

## Why

`web_ci.yml` runs on `pull_request`, and its later steps — `flutter test`,
`flutter build web`, the browser smoke test — execute code from the pull
request. Writing real Actions secrets into source before that point puts live
credentials where PR-authored code can read them, on a public repository.

It also breaks fork pull requests outright: GitHub withholds secrets from fork
PRs, so the files would be written empty and the build would fail on a
confusing compile error.

## What these are not

They are **not** generated from the real secrets file. They are derived from
the members the committed source actually references (`AppSecrets.<member>`),
so no real value can leak into them by construction. Every endpoint points at
the reserved `.invalid` TLD, which never resolves.

They carry no real values, so CI never exercises a live backend. That is the
intended trade: these jobs verify the app compiles, its tests pass, and its
shell boots — not that a backend is reachable. Anything needing real
credentials belongs in a protected post-merge workflow.

## Regenerating after a secret is added

CI fails with `no member named X on AppSecrets` when the app starts using a
new secret. To fix, list what the source references and add the missing
members:

```sh
grep -rhoE 'AppSecrets\.[a-zA-Z_][a-zA-Z0-9_]*' --include='*.dart' apps packages \
  | sed 's/AppSecrets\.//' | sort -u
```

Add each missing name to both fixtures as `static const String <name> =
'ci-fixture-<name>';`, using an `https://ci-fixture.invalid/...` value for
anything URL-shaped and `false` for a bool. Never copy a real value here.

## Files

| Fixture | Copied to |
|---|---|
| `models_secrets.dart` | `packages/flipper_models/lib/secrets.dart` |
| `web_secrets.dart` | `apps/flipper_web/lib/core/secrets.dart` |

`packages/flipper_login/lib/config.dart` is deliberately absent: nothing in the
repo references `Config.` or imports that file. `firebase_options.dart` is also
absent, because neither web app imports it.
