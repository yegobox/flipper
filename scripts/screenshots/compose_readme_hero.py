#!/usr/bin/env python3
"""Compose the README hero image from the desktop and phone screenshots.

Input : a directory of PNGs written by
        apps/flipper/integration_test/readme_screenshots_test.dart —
        `NN_name.png` from the desktop pass and `phone_NN_name.png` from the
        phone pass (the latter still surrounded by DevicePreview's magenta
        background, which is keyed out here).
Output: hero.png — a laptop showing the desktop app, with two phones
        overlapping it front-left and front-right, on a transparent
        background (the layout of ente's README product shots) — plus each
        cleaned screenshot copied next to it so the README can deep-link to
        any of them.

    python3 scripts/screenshots/compose_readme_hero.py \
        --src build/readme_screenshots --out .github/assets/screenshots

Falls back to a laptop-only hero when no phone shots are present. Only
depends on Pillow (`pip install pillow`).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter

# Which screens go where. Names match the test's `_screens` keys.
LAPTOP_SCREEN = "03_pos"
PHONE_LEFT = "phone_02_dashboard"
PHONE_RIGHT = "phone_05_cashbook"

# Layout (canvas pixels) --------------------------------------------------------
CANVAS_W = 2400
LAPTOP_SCREEN_W = 1640  # visible screen width
LAPTOP_BEZEL = 26
LAPTOP_RADIUS = 34
LAPTOP_BASE_H = 46  # the "keyboard deck" strip under the screen
PHONE_SCREEN_W = 400
PHONE_BEZEL = 16
PHONE_RADIUS = 72
PHONE_OVERLAP = 0.28  # fraction of a phone's width sitting over the laptop
MARGIN = 60

BEZEL = (24, 26, 31, 255)
BEZEL_EDGE = (74, 78, 88, 255)
DECK = (46, 49, 56, 255)
SHADOW = (0, 0, 0, 90)
CHROMA = (255, 0, 255)  # DevicePreview background in phone-capture mode


# Helpers --------------------------------------------------------------------------
def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, size[0] - 1, size[1] - 1), radius, fill=255
    )
    return mask


def fit_width(img: Image.Image, width: int) -> Image.Image:
    h = round(img.height * width / img.width)
    return img.resize((width, h), Image.Resampling.LANCZOS)


def key_out_chroma(img: Image.Image) -> Image.Image:
    """Crop a phone-pass shot to the app area by removing the magenta surround."""
    rgb = img.convert("RGB")
    diff = ImageChops.difference(rgb, Image.new("RGB", rgb.size, CHROMA))
    # Any channel differing by more than a little from chroma is app content.
    mask = diff.convert("L").point(lambda v: 255 if v > 12 else 0)
    box = mask.getbbox()
    if box is None:
        raise SystemExit("phone screenshot is entirely chroma; nothing to crop")
    return rgb.crop(box)


def shadow(canvas: Image.Image, box: tuple[int, int, int, int], radius: int,
           blur: int = 40, dy: int = 28) -> None:
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    x0, y0, x1, y1 = box
    ImageDraw.Draw(layer).rounded_rectangle(
        (x0, y0 + dy, x1, y1 + dy), radius, fill=SHADOW
    )
    canvas.alpha_composite(layer.filter(ImageFilter.GaussianBlur(blur)))


def laptop(screen: Image.Image) -> Image.Image:
    """A MacBook-ish frame: dark bezel around the screen, thin deck below."""
    scr = fit_width(screen.convert("RGB"), LAPTOP_SCREEN_W)
    w = scr.width + 2 * LAPTOP_BEZEL
    h = scr.height + 2 * LAPTOP_BEZEL + LAPTOP_BASE_H
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(out)
    # Screen housing
    d.rounded_rectangle((0, 0, w - 1, h - LAPTOP_BASE_H - 1), LAPTOP_RADIUS,
                        fill=BEZEL, outline=BEZEL_EDGE, width=2)
    # Deck: wider than the screen, only bottom corners rounded
    deck_top = h - LAPTOP_BASE_H - LAPTOP_RADIUS
    d.rounded_rectangle((0, deck_top, w - 1, h - 1), LAPTOP_RADIUS, fill=DECK)
    d.rectangle((0, deck_top, w - 1, h - LAPTOP_BASE_H), fill=DECK)
    # Hinge line
    d.line((LAPTOP_RADIUS, h - LAPTOP_BASE_H, w - LAPTOP_RADIUS, h - LAPTOP_BASE_H),
           fill=BEZEL_EDGE, width=2)
    # Screen with softly rounded corners
    scr_rgba = scr.convert("RGBA")
    scr_rgba.putalpha(rounded_mask(scr.size, 10))
    out.alpha_composite(scr_rgba, (LAPTOP_BEZEL, LAPTOP_BEZEL))
    # Camera dot
    d.ellipse((w // 2 - 5, LAPTOP_BEZEL // 2 - 5, w // 2 + 5, LAPTOP_BEZEL // 2 + 5),
              fill=(60, 64, 72, 255))
    return out


def phone(screen: Image.Image) -> Image.Image:
    """A modern edge-to-edge phone: thin dark bezel, big corner radius."""
    scr = fit_width(screen.convert("RGB"), PHONE_SCREEN_W)
    w = scr.width + 2 * PHONE_BEZEL
    h = scr.height + 2 * PHONE_BEZEL
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(out)
    d.rounded_rectangle((0, 0, w - 1, h - 1), PHONE_RADIUS, fill=BEZEL,
                        outline=BEZEL_EDGE, width=2)
    scr_rgba = scr.convert("RGBA")
    scr_rgba.putalpha(rounded_mask(scr.size, PHONE_RADIUS - PHONE_BEZEL))
    out.alpha_composite(scr_rgba, (PHONE_BEZEL, PHONE_BEZEL))
    # Side buttons
    d.rounded_rectangle((-2, 260, 2, 340), 2, fill=BEZEL_EDGE)
    d.rounded_rectangle((-2, 380, 2, 500), 2, fill=BEZEL_EDGE)
    d.rounded_rectangle((w - 3, 300, w + 1, 440), 2, fill=BEZEL_EDGE)
    return out


# Layout -----------------------------------------------------------------------
def compose(shots: dict[str, Image.Image]) -> Image.Image:
    lap = laptop(shots[LAPTOP_SCREEN])
    left = phone(shots[PHONE_LEFT]) if PHONE_LEFT in shots else None
    right = phone(shots[PHONE_RIGHT]) if PHONE_RIGHT in shots else None

    # Laptop is horizontally centred; phones hang off either side and sit
    # lower, like ente's shots. Canvas height follows the tallest element.
    lap_x = (CANVAS_W - lap.width) // 2
    lap_y = MARGIN
    bottom = lap_y + lap.height
    placements: list[tuple[Image.Image, int, int, int]] = [(lap, lap_x, lap_y, LAPTOP_RADIUS)]

    if left is not None:
        x = lap_x - left.width + round(left.width * PHONE_OVERLAP)
        y = lap_y + lap.height - left.height + 40
        placements.append((left, max(x, MARGIN // 2), y, PHONE_RADIUS))
        bottom = max(bottom, y + left.height)
    if right is not None:
        x = lap_x + lap.width - round(right.width * PHONE_OVERLAP)
        y = lap_y + lap.height - right.height + 80
        placements.append((right, min(x, CANVAS_W - right.width - MARGIN // 2), y, PHONE_RADIUS))
        bottom = max(bottom, y + right.height)

    canvas = Image.new("RGBA", (CANVAS_W, bottom + MARGIN + 40), (0, 0, 0, 0))
    for img, x, y, radius in placements:
        shadow(canvas, (x, y, x + img.width, y + img.height), radius)
        canvas.alpha_composite(img, (x, y))
    return canvas


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--src", required=True, type=Path)
    ap.add_argument("--out", required=True, type=Path)
    args = ap.parse_args()

    files = sorted(args.src.glob("*.png"))
    files = [f for f in files if not f.stem.startswith("zz_")]  # timeout diagnostics
    if not files:
        print(f"no PNGs in {args.src}", file=sys.stderr)
        return 1

    args.out.mkdir(parents=True, exist_ok=True)
    shots: dict[str, Image.Image] = {}
    for f in files:
        img = Image.open(f)
        if f.stem.startswith("phone_"):
            img = key_out_chroma(img)
        shots[f.stem] = img
        img.save(args.out / f.name, optimize=True)

    if LAPTOP_SCREEN not in shots:
        print(f"missing {LAPTOP_SCREEN}.png for the laptop screen", file=sys.stderr)
        return 1

    hero = compose(shots)
    hero.save(args.out / "hero.png", optimize=True)
    phones = sum(1 for k in (PHONE_LEFT, PHONE_RIGHT) if k in shots)
    print(f"wrote {args.out / 'hero.png'} ({hero.width}x{hero.height}) "
          f"from {len(shots)} screenshots ({phones} phone)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
