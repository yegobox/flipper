## What this changes

<!-- One or two sentences. What behaviour is different after this merges? -->

## Why

<!-- The problem, not the solution. Link the issue if there is one. -->

## How it was verified

<!-- Delete what does not apply. "CI is green" on its own is not verification
     for anything touching sync, tax or money. -->

- [ ] Unit/widget tests added or updated
- [ ] Ran the affected app locally and exercised the path by hand
- [ ] Checked the offline path (Ditto disconnected) if this touches sync
- [ ] Checked against RRA sandbox if this touches tax sequences

## Risk

<!-- What breaks if this is wrong, and how would you notice? -->

## Quality gates

The `Quality` workflow ratchets analyzer findings, formatting, architecture and
the documented rules. It only fails when a PR makes something *worse* than the
recorded baseline -- you are never asked to fix pre-existing issues.

If a gate fires and the change is a deliberate, reviewed exception, say why
here and re-record the baseline:

```bash
scripts/ci/analysis_ratchet.sh --update
scripts/ci/architecture_ratchet.sh --update
python3 scripts/ci/documented_rules_check.py --update
```
