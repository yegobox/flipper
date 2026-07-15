#!/usr/bin/env python3
"""Fail if any 64-bit .so in an Android App Bundle has ELF LOAD p_align < 16384."""

from __future__ import annotations

import os
import struct
import sys
import tempfile
import zipfile


def load_aligns(path: str) -> list[int] | None:
    with open(path, "rb") as f:
        hdr = f.read(64)
    if hdr[:4] != b"\x7fELF" or hdr[4] != 2:
        return None
    endian = "<" if hdr[5] == 1 else ">"
    e_phoff = struct.unpack_from(endian + "Q", hdr, 32)[0]
    e_phentsize = struct.unpack_from(endian + "H", hdr, 54)[0]
    e_phnum = struct.unpack_from(endian + "H", hdr, 56)[0]
    with open(path, "rb") as f:
        f.seek(e_phoff)
        ph = f.read(e_phentsize * e_phnum)
    out: list[int] = []
    for i in range(e_phnum):
        off = i * e_phentsize
        if struct.unpack_from(endian + "I", ph, off)[0] == 1:  # PT_LOAD
            out.append(struct.unpack_from(endian + "Q", ph, off + 48)[0])
    return out


def main() -> int:
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <app-release.aab>", file=sys.stderr)
        return 2

    aab = sys.argv[1]
    if not os.path.isfile(aab):
        print(f"::error::AAB not found: {aab}", file=sys.stderr)
        return 1

    print(f"Checking ELF LOAD alignment in: {aab}")
    fails: list[str] = []
    with zipfile.ZipFile(aab) as z, tempfile.TemporaryDirectory() as td:
        for name in z.namelist():
            if not name.endswith(".so"):
                continue
            if "/arm64-v8a/" not in name and "/x86_64/" not in name:
                continue
            out = os.path.join(td, os.path.basename(name))
            with z.open(name) as src, open(out, "wb") as dst:
                dst.write(src.read())
            aligns = load_aligns(out)
            if not aligns:
                print(f"SKIP (not ELF64): {name}")
                continue
            ok = min(aligns) >= 16384
            status = "OK" if ok else "FAIL"
            print(f"{status:4} min_align={min(aligns):<6} {name}")
            if not ok:
                fails.append(name)

    if fails:
        print("\n::error::Native libraries without 16KB ELF alignment:")
        for failed in fails:
            print(f"  - {failed}")
        print("Google Play will reject this AAB for 16KB page-size devices.")
        return 1

    print("\nAll 64-bit native libraries are 16KB ELF-aligned.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
