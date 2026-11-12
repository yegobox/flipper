#!/usr/bin/env python3
"""material_ui readiness ratchet.

Flutter 3.50 deprecates `package:flutter/material.dart` and
`package:flutter/cupertino.dart` in favour of the standalone `material_ui` and
`cupertino_ui` packages. Those are a separate copy of Material with their own
types, so the app can only switch over in one step once the packages it renders
through have switched too. A third-party widget still built on the legacy
library loses our component themes and `FlipperThemeExtension`, and finds no
`Material` ancestor of its own type (see docs/flutter_version.md).

This lists every third-party or vendored package that our own `lib/` code
imports and whose sources still import the legacy libraries. The list is
recorded in .github/baselines/material_ui.json and may only shrink: a PR fails
if it adds a new legacy-Material dependency. When the list is empty (or the
remaining entries are bridged), the switch can happen.

Run after `melos bootstrap`: packages are resolved through the
.dart_tool/package_config.json files it writes.

Usage
  scripts/ci/material_ui_readiness.py           # check against the baseline
  scripts/ci/material_ui_readiness.py --update  # rewrite the baseline
  scripts/ci/material_ui_readiness.py --list    # print the current list only

Env
  BASELINE   default .github/baselines/material_ui.json
"""

import glob
import json
import os
import re
import sys
from urllib.parse import unquote, urlparse

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
os.chdir(ROOT)
BASELINE = os.environ.get("BASELINE", ".github/baselines/material_ui.json")

IMPORT_RE = re.compile(r"""^\s*(?:import|export)\s+['"]package:([A-Za-z0-9_]+)/""", re.M)
LEGACY_RE = re.compile(
    r"""^\s*(?:import|export)\s+['"]package:flutter/(?:material|cupertino)\.dart['"]""",
    re.M,
)
# Packages that ship with the Flutter SDK. flutter_localizations is handled by
# the migration itself (material_ui brings its own GlobalMaterialLocalizations).
SDK_PACKAGES = {
    "flutter",
    "flutter_test",
    "flutter_localizations",
    "flutter_web_plugins",
    "flutter_driver",
    "integration_test",
}
SKIP_DIRS = ("/build/", "/.dart_tool/", "/.symlinks/", "/ephemeral/")


def read_name(pubspec):
    with open(pubspec, encoding="utf-8") as f:
        for line in f:
            m = re.match(r"^name:\s*([A-Za-z0-9_]+)", line)
            if m:
                return m.group(1)
    return None


def own_packages():
    """apps/* and packages/*: the code we migrate ourselves."""
    names = set()
    for pubspec in glob.glob("apps/*/pubspec.yaml") + glob.glob("packages/*/pubspec.yaml"):
        name = read_name(pubspec)
        if name:
            names.add(name)
    return names


def package_roots():
    """Package name -> source root, from every bootstrapped package_config."""
    roots = {}
    configs = glob.glob("apps/*/.dart_tool/package_config.json") + glob.glob(
        "packages/*/.dart_tool/package_config.json"
    )
    for config in configs:
        base = os.path.dirname(os.path.abspath(config))
        with open(config, encoding="utf-8") as f:
            data = json.load(f)
        for pkg in data.get("packages", []):
            uri = pkg["rootUri"]
            if uri.startswith("file://"):
                path = unquote(urlparse(uri).path)
            else:
                path = os.path.normpath(os.path.join(base, unquote(uri)))
            roots.setdefault(pkg["name"], path)
    return roots, len(configs)


def dart_files(directory):
    for path in glob.glob(os.path.join(directory, "**", "*.dart"), recursive=True):
        if not any(s in path.replace(os.sep, "/") for s in SKIP_DIRS):
            yield path


def used_packages(own):
    used = set()
    for lib in glob.glob("apps/*/lib") + glob.glob("packages/*/lib"):
        for path in dart_files(lib):
            with open(path, encoding="utf-8", errors="replace") as f:
                used.update(IMPORT_RE.findall(f.read()))
    return {name for name in used if name not in own and name not in SDK_PACKAGES}


def is_legacy(root):
    for path in dart_files(os.path.join(root, "lib")):
        with open(path, encoding="utf-8", errors="replace") as f:
            if LEGACY_RE.search(f.read()):
                return True
    return False


def current_list():
    own = own_packages()
    roots, config_count = package_roots()
    if config_count == 0:
        sys.exit("material_ui_readiness: no package_config.json found -- run `melos bootstrap` first")
    legacy, unresolved = [], []
    for name in sorted(used_packages(own)):
        root = roots.get(name)
        if root is None or not os.path.isdir(root):
            unresolved.append(name)
            continue
        if is_legacy(root):
            kind = "vendored" if os.path.abspath(root).startswith(ROOT + os.sep) else "pub"
            legacy.append({"name": name, "kind": kind})
    if unresolved:
        sys.exit(
            "material_ui_readiness: imported but not resolved by any package_config.json "
            f"(run `melos bootstrap`): {', '.join(unresolved)}"
        )
    return legacy


def main(argv):
    mode = argv[1] if len(argv) > 1 else "--check"
    if mode not in ("--check", "--update", "--list"):
        sys.exit(f"material_ui_readiness: unknown mode {mode!r} (use --check, --update or --list)")

    legacy = current_list()
    names = [item["name"] for item in legacy]

    if mode == "--list":
        for item in legacy:
            print(f"{item['name']} ({item['kind']})")
        print(f"{len(legacy)} legacy-Material dependencies")
        return 0

    if mode == "--update":
        os.makedirs(os.path.dirname(BASELINE), exist_ok=True)
        with open(BASELINE, "w", encoding="utf-8") as f:
            json.dump({"legacy_material_dependencies": legacy}, f, indent=2)
            f.write("\n")
        print(f"material_ui_readiness: wrote {BASELINE} ({len(legacy)} entries)")
        return 0

    try:
        with open(BASELINE, encoding="utf-8") as f:
            baseline = {item["name"] for item in json.load(f)["legacy_material_dependencies"]}
    except FileNotFoundError:
        sys.exit(f"material_ui_readiness: {BASELINE} missing -- run with --update")

    added = sorted(set(names) - baseline)
    removed = sorted(baseline - set(names))
    for name in removed:
        print(f"  improved: {name} no longer needs the legacy library (run --update to lock it in)")
    if added:
        print("FAIL: new dependencies that still build on package:flutter/material.dart or cupertino.dart:")
        for name in added:
            print(f"  {name}")
        print(
            "Every one of these must be migrated or bridged before the material_ui switch "
            "(docs/flutter_version.md). Prefer a package that has moved to material_ui; "
            "if there is none, justify it in review and run --update."
        )
        return 1
    print(f"OK: {len(names)} legacy-Material dependencies, none new.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
