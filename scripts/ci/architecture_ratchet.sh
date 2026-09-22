#!/usr/bin/env bash
#
# Architecture ratchet.
#
# Three structural rules that the build can check but prose cannot. Each is
# recorded in .github/baselines/architecture.json at today's value and may
# only ever move DOWN.
#
#   1. LAYERING -- nothing under packages/ may depend on an app under apps/.
#      Today `flipper_models` (the model layer) depends on the `flipper_web`
#      and `flipper_personal` APPS, and `flipper_dashboard` pulls in
#      `flipper_web`, `flipper_auth` and `flipper_personal`. That inverted edge
#      is why tests need a near-complete app boot to run, and why a change in
#      one app can break a package that has no business knowing the app exists.
#      We do not unwind it here -- we stop it spreading.
#
#   2. SERVICE LOCATOR -- the number of `ProxyService.` call sites may not grow.
#      ProxyService is a static, globally reachable service locator with 42
#      getters and thousands of call sites. Every one of them is a dependency
#      that no test can substitute, which is the direct cause of the thin test
#      coverage over the largest packages. New code should take what it needs
#      as a constructor argument or a Riverpod provider.
#
#   3. FILE SIZE -- the number of source files over MAX_FILE_LINES may not grow,
#      and no file may cross the line that is not already over it. A 4,000-line
#      widget cannot be reviewed properly, and merge conflicts in it are brutal.
#
# None of these rewrite anything. They are counters with a maximum.
#
# Usage
#   scripts/ci/architecture_ratchet.sh           # check
#   scripts/ci/architecture_ratchet.sh --update  # rewrite the baseline
#
# Env
#   BASELINE         default .github/baselines/architecture.json
#   MAX_FILE_LINES   default 1500
set -euo pipefail
cd "$(dirname "$0")/../.."

BASELINE="${BASELINE:-.github/baselines/architecture.json}"
MAX_FILE_LINES="${MAX_FILE_LINES:-1500}"
MODE="check"
[[ "${1:-}" == "--update" ]] && MODE="update"
[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { sed -n '2,36p' "$0"; exit 0; }

python3 - "$PWD" "$BASELINE" "$MODE" "$MAX_FILE_LINES" <<'PY'
import json, os, re, sys

repo, baseline_path, mode, max_lines = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
os.chdir(repo)

# ---------------------------------------------------------------- helpers
def pubspec_name(path):
    """The `name:` field of a pubspec, i.e. the package's dependency key."""
    with open(path, encoding='utf-8', errors='replace') as fh:
        for line in fh:
            m = re.match(r'^name:\s*(\S+)', line)
            if m:
                return m.group(1)
    return None

def pubspec_deps(path):
    """Dependency keys under dependencies:/dev_dependencies:.

    A deliberately small parser rather than PyYAML, which is not guaranteed to
    be present on a bare CI runner. Pubspecs are flat enough that tracking the
    current top-level section and reading two-space-indented keys is exact.
    """
    deps, section = set(), None
    with open(path, encoding='utf-8', errors='replace') as fh:
        for raw in fh:
            line = raw.rstrip('\n')
            if not line.strip() or line.lstrip().startswith('#'):
                continue
            if re.match(r'^[A-Za-z_]', line):                       # top-level key
                section = line.split(':', 1)[0].strip()
                continue
            if section in ('dependencies', 'dev_dependencies'):
                m = re.match(r'^  ([A-Za-z_][A-Za-z0-9_]*):', line)  # exactly 2 spaces
                if m:
                    deps.add(m.group(1))
    return deps

def walk_dart(roots):
    skip = ('/build/', '/.dart_tool/', '/.symlinks/', '/ephemeral/',
            '/open-sources/', '/third_party/', '/node_modules/', '/l10n/')
    drop_suffix = ('.g.dart', '.freezed.dart', '.mocks.dart', '.config.dart',
                   'app.router.dart', 'app.locator.dart', 'app.dialogs.dart',
                   'app.bottomsheets.dart', 'generated_plugin_registrant.dart')
    for root in roots:
        for dirpath, dirnames, filenames in os.walk(root):
            posix = '/' + dirpath.replace(os.sep, '/') + '/'
            if any(s in posix for s in skip):
                dirnames[:] = []
                continue
            for fn in filenames:
                if not fn.endswith('.dart') or fn.endswith(drop_suffix):
                    continue
                yield os.path.join(dirpath, fn)

# ------------------------------------------------------- rule 1: layering
app_names = {}
for entry in sorted(os.listdir('apps')):
    ps = os.path.join('apps', entry, 'pubspec.yaml')
    if os.path.isfile(ps):
        name = pubspec_name(ps)
        if name:
            app_names[name] = f'apps/{entry}'

layering = {}
for entry in sorted(os.listdir('packages')):
    ps = os.path.join('packages', entry, 'pubspec.yaml')
    if not os.path.isfile(ps):
        continue
    offending = sorted(d for d in pubspec_deps(ps) if d in app_names)
    if offending:
        layering[f'packages/{entry}'] = offending

# ------------------------------------------------ rules 2 and 3: counters
proxy_hits, big_files = 0, {}
pattern = re.compile(r'ProxyService\s*\.')
for path in walk_dart(['packages', 'apps']):
    try:
        with open(path, encoding='utf-8', errors='replace') as fh:
            text = fh.read()
    except OSError:
        continue
    proxy_hits += len(pattern.findall(text))
    n = text.count('\n') + 1
    if n > max_lines:
        big_files[path.replace(os.sep, '/')] = n

current = {
    'layering_violations': layering,
    'proxy_service_call_sites': proxy_hits,
    'files_over_line_limit': {'limit': max_lines, 'files': dict(sorted(big_files.items()))},
}

# ------------------------------------------------------------- baselines
try:
    with open(baseline_path) as fh:
        baseline = json.load(fh)
except FileNotFoundError:
    baseline = {}

if mode == 'update':
    current['_comment'] = ('Generated by scripts/ci/architecture_ratchet.sh --update. '
                           'Every number here is a ceiling. It may fall, never rise.')
    os.makedirs(os.path.dirname(baseline_path), exist_ok=True)
    with open(baseline_path, 'w') as fh:
        json.dump(current, fh, indent=2, sort_keys=True)
        fh.write('\n')
    print(f"Baseline updated:\n"
          f"  layering violations      : {len(layering)} package(s)\n"
          f"  ProxyService call sites  : {proxy_hits}\n"
          f"  files over {max_lines} lines   : {len(big_files)}")
    sys.exit(0)

failed = False

# Rule 1 -- no NEW inverted edge, per package.
was_layering = baseline.get('layering_violations', {})
for pkg, deps in sorted(layering.items()):
    allowed = set(was_layering.get(pkg, []))
    added = sorted(set(deps) - allowed)
    if added:
        failed = True
        print(f"FAIL layering: {pkg} now depends on app package(s): {', '.join(added)}")
        print(f"      A package under packages/ must not depend on an app under apps/.")
        print(f"      Move the shared code down into a package both can depend on.")
for pkg, deps in sorted(was_layering.items()):
    removed = sorted(set(deps) - set(layering.get(pkg, [])))
    if removed:
        print(f"  layering improved: {pkg} no longer depends on {', '.join(removed)} "
              f"(run --update to lock it in)")

# Rule 2 -- ProxyService call sites.
was_proxy = baseline.get('proxy_service_call_sites')
if was_proxy is not None:
    if proxy_hits > was_proxy:
        failed = True
        print(f"FAIL service locator: ProxyService call sites {was_proxy} -> {proxy_hits} "
              f"(+{proxy_hits - was_proxy})")
        print( "      New code should receive its dependencies (constructor argument or")
        print( "      Riverpod provider) instead of reaching for the global locator,")
        print( "      otherwise it cannot be tested without booting the whole app.")
    elif proxy_hits < was_proxy:
        print(f"  service locator improved: {was_proxy} -> {proxy_hits} "
              f"(run --update to lock it in)")

# Rule 3 -- oversized files. Both the count and the specific files matter:
# a brand-new 2,000-line file must fail even if an old one shrank below the line.
was_big = baseline.get('files_over_line_limit', {}).get('files', {})
newly_over = sorted(set(big_files) - set(was_big))
if newly_over:
    failed = True
    for path in newly_over:
        print(f"FAIL file size: {path} is {big_files[path]} lines (limit {max_lines})")
    print( "      Split it. A file this size cannot be reviewed carefully and turns")
    print( "      every concurrent edit into a merge conflict.")
for path in sorted(set(was_big) - set(big_files)):
    print(f"  file size improved: {path} is now under {max_lines} lines "
          f"(run --update to lock it in)")

if failed:
    print("""
------------------------------------------------------------------
These are ratchets, not style opinions: they only fire when a PR
makes an existing structural problem BIGGER. If the change is a
deliberate, reviewed exception, run:
    scripts/ci/architecture_ratchet.sh --update
and say why in the PR description.
------------------------------------------------------------------""")
    sys.exit(1)

print(f"OK: layering {len(layering)} known violation(s), "
      f"ProxyService {proxy_hits} call sites, "
      f"{len(big_files)} file(s) over {max_lines} lines -- none worse than baseline.")
PY
