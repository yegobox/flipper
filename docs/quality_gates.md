# Quality gates

Everything here runs from `.github/workflows/quality.yml` on every pull
request. All of it is **additive**: no existing Dart source was changed to
introduce any of it.

## The problem these solve

| Gap | Before |
|---|---|
| PR test coverage | `web_ci.yml` tested `flipper_web` and `flipper_hr` only. `melos run test:ci` — which covers `flipper_dashboard` (~216k LOC), `supabase_models`, `flipper_ai_feature`, `flipper_auth` — ran only in `release.yml`, on `push` to a fixed branch list that does **not** include `feat/*`. PRs from those branches ran no tests at all. |
| Test results being believed | `melos run test:ci` reported green while 22 `flipper_dashboard` tests failed. See below. |
| Static analysis | No CI job anywhere ran `dart analyze` or `dart format`. 18 of 35 packages had no `analysis_options.yaml` above them, including the two largest, so they were analyzed with no lint set. |
| Architecture | `packages/flipper_models` depends on the `flipper_web` and `flipper_personal` **apps**; `flipper_dashboard` pulls in three apps. Nothing stopped that spreading. |
| Documented rules | `AGENTS.md` and `docs/` record rules that cost real debugging time. Prose does not run in CI. `77b92324f` regressed the `sarNo` rule while the rule was written down. |

## The `test:ci` script was discarding failures

This is the most serious thing the work turned up, so it is worth stating
plainly.

`melos.yaml` defines `test:ci` as a multi-line script:

```yaml
test:ci:
  run: |
    dart run melos run test:dashboard
    dart run melos run test:auth
    dart run melos run test:flipper_web
    dart run melos run test:supabase_models
    dart run melos run test:ai_feature
```

Melos executes such a script with `/bin/sh -c 'eval "$MELOS_SCRIPT"'`
(`melos-7.3.0/lib/src/common/utils.dart:431`) and **no `set -e`**. In POSIX sh
a script's exit status is that of its *last* command, so only
`test:ai_feature` could ever fail the job:

```console
$ /bin/sh -c 'false
true'; echo $?
0
```

`release.yml`'s "Unit Testing" job has therefore been reporting **success while
22 `flipper_dashboard` tests fail**. Those failures reproduce locally, on the
same Flutter version, with real secrets — they are genuine, not a CI artefact.

Two separate problems, two separate fixes:

1. **Reporting.** Each suite now runs as its own CI job, so a failure in one
   cannot be masked by another passing later.
2. **The 22 failures themselves.** They were all fixed rather than
   grandfathered — none turned out to be a product bug. They were tests that
   had drifted from deliberate design changes (upper-cased headings, one
   shared status glyph with the meaning in colour, a responsive action bar, a
   request-level rather than per-item Approve) plus an RBAC gate added to
   `tapAdd` that fails closed under a widget harness, and a golden whose bytes
   are macOS-specific.

The suite is green, so all four test jobs are **strict**: any failing test
fails the build. There is no known-failing list to maintain, which is the
point — a ratchet with an empty baseline is machinery holding nothing back.

**`melos.yaml` itself is deliberately not changed here.** Adding `set -e` to
`test:ci` would turn `release.yml` red immediately, which is a decision about
release process rather than a CI gate, and is not this change's to make.

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
| Tests | `melos run test:<suite>` | ~15min | any `dashboard`, `supabase_models`, `ai_feature` or `auth` test fails |

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

## The analyzer baseline is CI-authoritative

Analyzer output depends on which files exist. `secrets.dart` and
`firebase_options.dart` are gitignored, so a developer machine (real files) and
a CI runner (none) can legitimately disagree. CI installs stand-ins from
`.github/ci-fixtures/` to close that gap — that is why the fixture list covers
`flipper_auth` and `flipper` as well as `flipper_web`.

If `--update` locally produces different numbers from CI, **trust CI**: it is
what enforces the gate. The job prints every package whose count moved with
before → after figures, so the baseline can be reconciled from a run log
without guessing.

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
