#!/usr/bin/env python3
"""Merge a Crowdin download into the committed ARB instead of replacing it.

`app_en.arb` is both the Crowdin source file and — because English is one of
the project's target languages — the path the English "translation" downloads
to, since `app_%two_letters_code%.arb` resolves to the source itself. A plain
download therefore overwrites the template every `FlipperAppLocalizations`
getter is generated from, and with `skip_untranslated_strings` any string not
marked translated in English is simply absent from the download. That is how
PR #540 and PR #639 emptied the file: 469 keys replaced by `{}`.

Merging keeps both halves working. English copy edits made in Crowdin land,
and every key the download omitted keeps the text already in git, so the file
can only gain keys this way — never lose them.

Usage: merge_l10n_download.py <arb-path> [<arb-path> ...]
"""

import json
import subprocess
import sys


def committed(path: str):
    """The version of `path` in HEAD, or None when HEAD has no such file."""
    result = subprocess.run(
        ["git", "show", f"HEAD:{path}"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return None
    return json.loads(result.stdout)


def downloaded(path: str) -> dict:
    """The working-tree version of `path`, or {} when it is unusable.

    A download that is not valid JSON is worth nothing to us, and treating it
    as empty means the committed text survives intact.
    """
    try:
        with open(path) as fh:
            return json.load(fh)
    except (OSError, json.JSONDecodeError) as err:
        print(f"{path}: download is unusable ({err}); keeping the committed file")
        return {}


def message_keys(data: dict) -> list:
    return [k for k in data if not k.startswith("@")]


def merge(base: dict, incoming: dict) -> dict:
    """`base` with `incoming`'s non-empty values laid over it.

    Key order follows `base` so the diff on a normal sync stays readable, with
    genuinely new keys appended in the order the download listed them.
    """
    merged = dict(base)
    for key, value in incoming.items():
        # An empty string is what Crowdin sends for a string that exists but
        # has no translation. It is not an edit, and it would blank a getter.
        if isinstance(value, str) and not value.strip():
            continue
        merged[key] = value
    return merged


def main(paths: list) -> int:
    failed = False

    for path in paths:
        base = committed(path)
        if base is None:
            print(f"{path}: not in HEAD; leaving the download as-is")
            continue

        incoming = downloaded(path)
        merged = merge(base, incoming)
        before, after = len(message_keys(base)), len(message_keys(merged))

        if after < before:
            # merge() cannot drop keys, so this means the invariant this script
            # exists to hold has been broken by a change to the script itself.
            print(f"::error file={path}::merge dropped keys ({before} -> {after}); refusing to write")
            failed = True
            continue

        with open(path) as fh:
            current = fh.read()
        rendered = json.dumps(merged, indent=4, ensure_ascii=False) + "\n"

        if rendered == current:
            print(f"{path}: {after} keys, unchanged")
            continue

        with open(path, "w") as fh:
            fh.write(rendered)

        edits = sum(
            1
            for k in message_keys(merged)
            if k in base and merged[k] != base[k]
        )
        print(
            f"{path}: {before} committed keys -> {after} keys "
            f"({after - before} new, {edits} edited)"
        )

    return 1 if failed else 0


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1:]))
