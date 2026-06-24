#!/usr/bin/env bash
# Preflight SHOREBIRD_TOKEN before release/patch (fails fast with a clear message).
set -euo pipefail

if [ -z "${SHOREBIRD_TOKEN:-}" ]; then
  echo "::error::SHOREBIRD_TOKEN is empty. Create an API key at https://console.shorebird.dev (Account → API Keys)."
  exit 1
fi

# GitHub secret paste sometimes adds trailing newline/space — strip all whitespace.
TOKEN="$(printf '%s' "$SHOREBIRD_TOKEN" | tr -d '[:space:]')"

if [[ "$TOKEN" == sb_api_* ]]; then
  echo "SHOREBIRD_TOKEN: valid Shorebird API key prefix (sb_api_...)"
  exit 0
fi

if [ $(( ${#TOKEN} % 4 )) -eq 0 ]; then
  echo "SHOREBIRD_TOKEN: legacy CI token length looks valid (${#TOKEN} chars)"
  exit 0
fi

echo "::error::SHOREBIRD_TOKEN is truncated or malformed (length ${#TOKEN}, base64 must be a multiple of 4)."
echo "::error::Create a new API key at https://console.shorebird.dev → Account → API Keys."
echo "::error::Copy the full value once, paste into GitHub → Settings → Secrets → SHOREBIRD_TOKEN (no quotes, no spaces)."
exit 1
