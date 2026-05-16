#!/usr/bin/env bash
# Test notify-personal-goal-contribution (auth + FCM push).
#
# Setup (once):
#   cp scripts/personal-goal-push.test.env.example scripts/personal-goal-push.test.env.local
#   # edit personal-goal-push.test.env.local with your anon key, credentials, IDs
#
# Run from packages/edges:
#   ./scripts/test-personal-goal-push.sh
#
# Or from repo root:
#   packages/edges/scripts/test-personal-goal-push.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EDGES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

ENV_FILE="${PERSONAL_GOAL_PUSH_ENV:-$SCRIPT_DIR/personal-goal-push.test.env.local}"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  set -a && source "$ENV_FILE" && set +a
fi

PROJECT_REF="${SUPABASE_PROJECT_REF:-ombieopwqgfuzequezeq}"
SUPABASE_URL="${SUPABASE_URL:-https://${PROJECT_REF}.supabase.co}"
FUNCTION_NAME="${FUNCTION_NAME:-notify-personal-goal-contribution}"

GOAL_NAME="${GOAL_NAME:-Rent}"
AMOUNT="${AMOUNT:-110}"
CURRENCY_SYMBOL="${CURRENCY_SYMBOL:-RWF}"
SOURCE_DEVICE_KEY="${SOURCE_DEVICE_KEY:-manual-test}"

die() {
  echo "error: $*" >&2
  exit 1
}

require_var() {
  local name="$1"
  [[ -n "${!name:-}" ]] || die "Missing $name. Set it in $ENV_FILE or export it."
}

require_var SUPABASE_ANON_KEY
require_var TEST_EMAIL
require_var TEST_PASSWORD
require_var BUSINESS_ID
require_var BRANCH_ID

if ! command -v curl >/dev/null 2>&1; then
  die "curl is required"
fi

json_get_access_token() {
  if command -v jq >/dev/null 2>&1; then
    jq -r '.access_token // empty'
  else
    python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token') or '')"
  fi
}

echo "==> Project: $PROJECT_REF"
echo "==> Signing in as $TEST_EMAIL"

AUTH_RESPONSE="$(curl -s -X POST \
  "${SUPABASE_URL}/auth/v1/token?grant_type=password" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${TEST_EMAIL}\",\"password\":\"${TEST_PASSWORD}\"}")"

TOKEN="$(printf '%s' "$AUTH_RESPONSE" | json_get_access_token)"

if [[ -z "$TOKEN" || "${#TOKEN}" -lt 200 ]]; then
  echo "$AUTH_RESPONSE" >&2
  die "Failed to obtain access token (got length ${#TOKEN})"
fi

echo "==> Token OK (length ${#TOKEN})"
echo "==> Invoking ${FUNCTION_NAME} (business=$BUSINESS_ID branch=$BRANCH_ID amount=$AMOUNT)"

BODY="$(cat <<EOF
{
  "businessId": "${BUSINESS_ID}",
  "branchId": "${BRANCH_ID}",
  "goalName": "${GOAL_NAME}",
  "amount": ${AMOUNT},
  "sourceDeviceKey": "${SOURCE_DEVICE_KEY}",
  "currencySymbol": "${CURRENCY_SYMBOL}"
}
EOF
)"

HTTP_CODE="$(curl -s -o /tmp/personal-goal-push-response.json -w '%{http_code}' -X POST \
  "${SUPABASE_URL}/functions/v1/${FUNCTION_NAME}" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/json" \
  -d "$BODY")"

RESPONSE="$(cat /tmp/personal-goal-push-response.json)"
rm -f /tmp/personal-goal-push-response.json

echo "==> HTTP $HTTP_CODE"
echo "$RESPONSE"

if [[ "$HTTP_CODE" != "200" ]]; then
  die "Function call failed"
fi

echo "==> Done. Background a test device on business topic ${BUSINESS_ID} to see the notification."
