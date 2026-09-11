#!/usr/bin/env python3
"""Compose the README hero image from the desktop screenshots.

Input : a directory of PNGs written by
        apps/flipper/integration_test/readme_screenshots_test.dart
Output: hero.png — the first screen (after sign-in) large inside a window
        frame, the rest as a strip of framed thumbnails underneath — plus the
        individual screenshots copied next to it so the README can deep-link
        to any of them.

    python3 scripts/screenshots/compose_readme_hero.py \
        --src build/readme_screenshots --out .github/assets/screenshots

Only depends on Pillow (`pip install pillow`).
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

# Layout ---------------------------------------------------------------------
CANVAS_W = 1600
PAD = 56
GAP = 28
RADIUS = 18
TITLEBAR_H = 34
BG = (246, 248, 251)
FRAME = (255, 255, 255)
SHADOW = (15, 23, 42, 46)
DOTS = ((255, 95, 87), (255, 189, 46), (40, 201, 64))

# The sign-in screen is a fine screenshot to keep, but the hero should open
# on the product, so it goes last.
HERO_ORDER_LAST = ("01_sign_in",)


def framed(shot: Image.Image, width: int) -> Image.Image:
    """Scale `shot` to `width` and wrap it in a rounded macOS-style window."""
    scale = width / shot.width
    body = shot.convert("RGB").resize(
        (width, round(shot.height * scale)), Image.Resampling.LANCZOS
    )
    w, h = body.width, body.height + TITLEBAR_H

    frame = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, w - 1, h - 1), RADIUS, fill=255)
    frame.paste(FRAME + (255,), (0, 0, w, h))
    frame.paste(body, (0, TITLEBAR_H))
    d = ImageDraw.Draw(frame)
    for i, c in enumerate(DOTS):
        x = 16 + i * 20
        d.ellipse((x, 11, x + 12, 23), fill=c)
    frame.putalpha(mask)
    return frame


def drop_shadow(canvas: Image.Image, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(layer).rounded_rectangle(
        (x0, y0 + 10, x1, y1 + 10), RADIUS, fill=SHADOW
    )
    canvas.alpha_composite(layer.filter(ImageFilter.GaussianBlur(18)))


def compose(shots: list[Path]) -> Image.Image:
    ordered = sorted(
        shots, key=lambda p: (p.stem in HERO_ORDER_LAST, p.name)
    )
    hero, rest = ordered[0], ordered[1:]

    inner_w = CANVAS_W - 2 * PAD
    hero_img = framed(Image.open(hero), inner_w)

    thumbs: list[Image.Image] = []
    if rest:
        cols = min(len(rest), 3)
        thumb_w = (inner_w - GAP * (cols - 1)) // cols
        thumbs = [framed(Image.open(p), thumb_w) for p in rest[:cols]]

    height = PAD + hero_img.height + PAD
    if thumbs:
        height += max(t.height for t in thumbs) + GAP

    canvas = Image.new("RGBA", (CANVAS_W, height), BG + (255,))

    y = PAD
    drop_shadow(canvas, (PAD, y, PAD + hero_img.width, y + hero_img.height))
    canvas.alpha_composite(hero_img, (PAD, y))
    y += hero_img.height + GAP

    x = PAD
    for t in thumbs:
        drop_shadow(canvas, (x, y, x + t.width, y + t.height))
        canvas.alpha_composite(t, (x, y))
        x += t.width + GAP

    return canvas.convert("RGB")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--src", required=True, type=Path)
    ap.add_argument("--out", required=True, type=Path)
    args = ap.parse_args()

    shots = sorted(args.src.glob("*.png"))
    if not shots:
        print(f"no PNGs in {args.src}", file=sys.stderr)
        return 1

    args.out.mkdir(parents=True, exist_ok=True)
    for p in shots:
        shutil.copy2(p, args.out / p.name)

    hero = compose(shots)
    # optimize=True keeps the committed asset small; the README loads it on
    # every visit.
    hero.save(args.out / "hero.png", optimize=True)
    print(f"wrote {args.out / 'hero.png'} ({hero.width}x{hero.height}) "
          f"from {len(shots)} screenshots")
    return 0


if __name__ == "__main__":
    sys.exit(main())
