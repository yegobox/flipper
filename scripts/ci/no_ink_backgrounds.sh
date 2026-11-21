#!/usr/bin/env bash
#
# No `Ink(` backgrounds.
#
# `Ink` paints its decoration on the ancestor Material's ink layer instead of
# in the widget's own layer. On some Windows tills (Flutter 3.50.1) that layer
# is not drawn: the Bar "Confirm payment" button rendered as white text on a
# white panel, and the till could not close a table (2026-11-21).
#
# Paint the background with a Container/DecoratedBox and keep the InkWell on
# a transparent Material above it, so hover and press highlights still show:
#
#   Container(
#     decoration: ...,
#     child: Material(
#       type: MaterialType.transparency,
#       child: InkWell(onTap: ..., child: ...),
#     ),
#   )
#
# Usage: scripts/ci/no_ink_backgrounds.sh
set -euo pipefail
cd "$(dirname "$0")/../.."

# Paths are excluded by grep itself, never by filtering the matched text, so a
# string such as '/test/' inside a production line cannot hide a hit. Spaces
# or tabs between `Ink` and `(` still match (`dart format` never splits the
# name from its parenthesis across lines).
hits=$(grep -rnE '(^|[^A-Za-z0-9_])Ink(\.image)?[[:space:]]*\(' \
  --include='*.dart' --exclude='*.g.dart' \
  --exclude-dir=test --exclude-dir=build --exclude-dir=.dart_tool \
  packages apps 2>/dev/null || true)

if [[ -n "$hits" ]]; then
  echo "Ink( paints on the Material ink layer, which some Windows tills never draw."
  echo "Use Container(decoration) > Material(transparency) > InkWell instead:"
  echo "$hits"
  exit 1
fi
echo "OK: no Ink( backgrounds"
