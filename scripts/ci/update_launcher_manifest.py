#!/usr/bin/env python3
"""Patch one app/channel entry of the Yegobox Launcher catalog (apps.json).

The launcher (yegobox/flipper-launcher) reads apps.json from the fixed
`launcher-manifest` release of this repo and installs or updates every app in
it. Each desktop release rewrites only the platforms it built, under its own
app + channel: a beta build never touches stable, and a run that built only
Windows leaves the last macOS/Linux release in place. That is why version,
notes and min_launcher live on each platform rather than on the channel.

Usage
  update_launcher_manifest.py --manifest apps.json --app flipper \
      --name "Flipper POS" --channel beta --version 1.505.0 \
      --base-url https://github.com/yegobox/flipper/releases/download/desktop-v1.505.0 \
      --platform windows-x86_64=dist/flipper-windows-x86_64.zip:flipper.exe \
      --platform darwin-aarch64,darwin-x86_64=dist/flipper-darwin-universal.tar.gz:flipper.app

Each --platform is KEYS=ARCHIVE:ENTRY. KEYS is a comma list of launcher
platform keys ({os}-{arch}, as Tauri names them) served by the same archive.
ENTRY is the path of the executable inside the archive. ARCHIVE.sig must sit
next to the archive (`tauri signer sign` writes it there). A missing manifest
starts a new catalog.
"""
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
import re
import sys

SCHEMA = 1
PLATFORM_KEYS = {"windows-x86_64", "darwin-aarch64", "darwin-x86_64", "linux-x86_64"}
# MAJOR.MINOR.PATCH with an optional pre-release (1.505.0-beta.12), as the launcher compares them.
SEMVER = re.compile(r"^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?$")


def sha256(path: str) -> str:
    digest = hashlib.sha256()
    with open(path, "rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def parse_platform(spec: str, base_url: str, release: dict) -> dict[str, dict]:
    keys, sep, rest = spec.partition("=")
    archive, sep2, entry = rest.rpartition(":")
    if not sep or not sep2 or not archive or not entry:
        raise SystemExit(f"--platform must be KEYS=ARCHIVE:ENTRY, got {spec!r}")
    sig_path = archive + ".sig"
    if not os.path.isfile(archive):
        raise SystemExit(f"archive not found: {archive}")
    if not os.path.isfile(sig_path):
        raise SystemExit(f"signature not found: {sig_path} (run `tauri signer sign` first)")
    with open(sig_path, encoding="utf-8") as fh:
        signature = fh.read().strip()
    asset = {
        **release,
        "url": f"{base_url.rstrip('/')}/{os.path.basename(archive)}",
        "sha256": sha256(archive),
        "signature": signature,
        "size": os.path.getsize(archive),
        "entry": entry,
    }
    out = {}
    for key in filter(None, (k.strip() for k in keys.split(","))):
        if key not in PLATFORM_KEYS:
            raise SystemExit(f"unknown platform key {key!r}; expected one of {sorted(PLATFORM_KEYS)}")
        out[key] = asset
    return out


def load(path: str) -> dict:
    if not os.path.exists(path):
        return {"schema": SCHEMA, "apps": []}
    with open(path, encoding="utf-8") as fh:
        manifest = json.load(fh)
    if manifest.get("schema") != SCHEMA:
        raise SystemExit(f"{path}: schema {manifest.get('schema')!r}, this script writes {SCHEMA}")
    return manifest


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--manifest", required=True)
    ap.add_argument("--app", required=True, help="stable app id, e.g. flipper")
    ap.add_argument("--name", required=True)
    ap.add_argument("--icon", default="")
    ap.add_argument("--description", default="", help="one line under the name in the launcher")
    ap.add_argument("--website", default="", help="https link shown on the app's card")
    ap.add_argument("--accent", default="", help="card accent colour, #rrggbb")
    ap.add_argument("--channel", required=True, choices=["stable", "beta"])
    ap.add_argument("--version", required=True)
    ap.add_argument("--min-launcher", default="0.1.0")
    ap.add_argument("--notes-file", help="release notes shown in the launcher")
    ap.add_argument("--base-url", required=True, help="release download URL prefix for the archives")
    ap.add_argument("--platform", action="append", required=True)
    args = ap.parse_args(argv)

    for label, value in (("--version", args.version), ("--min-launcher", args.min_launcher)):
        if not SEMVER.match(value):
            raise SystemExit(f"{label} must be MAJOR.MINOR.PATCH[-PRE], got {value!r}")

    notes = ""
    if args.notes_file and os.path.isfile(args.notes_file):
        with open(args.notes_file, encoding="utf-8") as fh:
            notes = fh.read().strip()
    release = {
        "version": args.version,
        "pub_date": dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z"),
        "notes": notes,
        "min_launcher": args.min_launcher,
    }

    platforms: dict[str, dict] = {}
    for spec in args.platform:
        platforms.update(parse_platform(spec, args.base_url, release))

    manifest = load(args.manifest)
    app = next((a for a in manifest["apps"] if a.get("id") == args.app), None)
    if app is None:
        app = {"id": args.app, "channels": {}}
        manifest["apps"].append(app)
    app["name"] = args.name
    if args.accent and not re.match(r"^#[0-9a-fA-F]{6}$", args.accent):
        raise SystemExit(f"--accent must be #rrggbb, got {args.accent!r}")
    if args.website and not args.website.startswith("https://"):
        raise SystemExit(f"--website must be an https URL, got {args.website!r}")
    for key in ("icon", "description", "website", "accent"):
        if getattr(args, key):
            app[key] = getattr(args, key)
    channel = app.setdefault("channels", {}).setdefault(args.channel, {})
    merged = {**channel.get("platforms", {}), **platforms}
    channel["platforms"] = dict(sorted(merged.items()))

    tmp = args.manifest + ".tmp"
    with open(tmp, "w", encoding="utf-8") as fh:
        json.dump(manifest, fh, indent=2)
        fh.write("\n")
    os.replace(tmp, args.manifest)
    print(f"{args.app} {args.channel} -> {args.version} ({', '.join(sorted(platforms))})")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
