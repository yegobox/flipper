# Quality gates

Everything here runs from `.github/workflows/quality.yml` on every pull
request. All of it is **additive**: no existing Dart source was changed to
introduce any of it.

## The problem these solve

| Gap | Before |
|---|---|
| PR test coverage | `web_ci.yml` tested `flipper_web` and `flipper_hr` only. `melos run test:ci` — which covers `flipper_dashboard` (~216k LOC), `supabase_models`, `flipper_ai_feature`, `flipper_auth` — ran only in `release.yml`, on `push` to a fixed branch list that does **not** include `feat/*`. PRs from those branches ran no tests at all. |
| Static analysis | No CI job anywhere ran `dart analyze` or `dart format`. 18 of 35 packages had no `analysis_options.yaml` above them, including the two largest, so they were analyzed with no lint set. |
| Architecture | `packages/flipper_models` depends on the `flipper_web` and `flipper_personal` **apps**; `flipper_dashboard` pulls in three apps. Nothing stopped that spreading. |
| Documented rules | `AGENTS.md` and `docs/` record rules that cost real debugging time. Prose does not run in CI. `77b92324f` regressed the `sarNo` rule while the rule was written down. |

## Everything is a ratchet

The repo carries pre-existing analyzer findings (700, zero of them errors),
32 files over 1,500 lines, 5 inverted package dependencies and 3,498
`ProxyService.` call sites.

A gate demanding all of that be fixed first gets switched off within a day.
So each check records **today's** numbers in `.github/baselines/` and fails
only when a PR makes something **worse**. You are never asked to clean up
something you did not touch.

When you improve a number, the check says so and tells you to re-record it.
That is how the ceiling comes down and stays down.

## The checks

| Check | Script | Runtime | What fails it |
|---|---|---|---|
| Architecture | `scripts/ci/architecture_ratchet.sh` | ~10s | A new `packages/ → apps/` dependency; more `ProxyService.` call sites; a new file over 1,500 lines |
| Documented rules | `scripts/ci/documented_rules_check.py` | ~5s | `updateCounters` writing `Sar.sarNo` (**hard rule, no exceptions**); a new unlisted `LocalStorage` key; more `ProxyService.strategy` in report/export code |
| Formatting | `scripts/ci/format_changed.sh` | ~1min | A file **this PR changed** is not `dart format`-clean. Untouched files are ignored |
| Analyzer | `scripts/ci/analysis_ratchet.sh` | ~5min | A package this PR touched gained analyzer findings |
| Tests | `melos run test:<suite>` | ~15min | `dashboard`, `supabase_models`, `ai_feature` or `auth` tests fail |

Run any of them locally with the same command CI uses. All are bash-3.2
compatible, so they behave identically on macOS and on `ubuntu-latest`.

## When a gate fires

First: is the check right? Usually it is — that is the point.

If the change is a deliberate, reviewed exception, re-record the baseline and
**say why in the PR description**:

```bash
scripts/ci/analysis_ratchet.sh --update
scripts/ci/architecture_ratchet.sh --update
python3 scripts/ci/documented_rules_check.py --update
scripts/ci/format_changed.sh --fix
```

A baseline bump with no explanation in the PR is the one thing that makes this
whole system worthless. It is a ceiling, not a target.

## Known limitation

The analyzer ratchet compares **counts**, not issue identities. You could
remove one warning and add a different one in the same package without it
noticing. That trade buys immunity to file renames and code moves, which in
this repo happen often. Errors are handled strictly and separately — the
baseline is zero and must stay there.

## Paying the baselines down

Nothing here requires it, but if you want the numbers to fall:

1. **`supabase_models` (277 findings)** is the largest single block and the
   easiest — most are unused imports and unused locals.
2. **The 5 unlisted `LocalStorage` keys** are live bugs, not style: those
   writes silently do nothing today. See
   `.github/baselines/documented_rules.json` for the list.
3. **Layering** is the structurally important one, and the hardest. The edge
   to unwind first is `flipper_models → flipper_web`: a model layer should not
   know an app exists.

After any of these, re-run the relevant `--update` and commit the lower
baseline in the same PR.
