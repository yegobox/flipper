#!/usr/bin/env bash
# End-to-end test: generateReceiptUrl (queue SMS) + sendSms (deliver).
#
# Setup:
#   cp scripts/digital-receipt.test.env.example scripts/digital-receipt.test.env.local
#   # Set SMS_BRANCH_ID to branches.server_id, RECEIPT_FILE_NAME to a real S3 object
#
# Run from packages/edges:
#   ./scripts/test-digital-receipt.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENV_FILE="${DIGITAL_RECEIPT_ENV:-$SCRIPT_DIR/digital-receipt.test.env.local}"
if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  set -a && source "$ENV_FILE" && set +a
fi

PROJECT_REF="${SUPABASE_PROJECT_REF:-ombieopwqgfuzequezeq}"
SUPABASE_URL="${SUPABASE_URL:-https://${PROJECT_REF}.supabase.co}"

die() {
  echo "error: $*" >&2
  exit 1
}

require_var() {
  local name="$1"
  [[ -n "${!name:-}" ]] || die "Missing $name. Set it in $ENV_FILE"
}

require_var SUPABASE_ANON_KEY
require_var TEST_EMAIL
require_var TEST_PASSWORD
require_var BRANCH_ID
require_var SMS_BRANCH_ID
require_var TEST_PHONE
require_var RECEIPT_FILE_NAME

json_get_access_token() {
  if command -v jq >/dev/null 2>&1; then
    jq -r '.access_token // empty'
  else
    python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token') or '')"
  fi
}

invoke_function() {
  local name="$1"
  local body="$2"
  local outfile="/tmp/${name}-response.json"
  local code
  code="$(curl -s -o "$outfile" -w '%{http_code}' -X POST \
    "${SUPABASE_URL}/functions/v1/${name}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "apikey: ${SUPABASE_ANON_KEY}" \
    -H "Content-Type: application/json" \
    -d "$body")"
  echo "==> $name HTTP $code"
  cat "$outfile"
  echo ""
  rm -f "$outfile"
  [[ "$code" == "200" ]] || die "$name failed with HTTP $code"
}

echo "==> Signing in as $TEST_EMAIL"
AUTH_RESPONSE="$(curl -s -X POST \
  "${SUPABASE_URL}/auth/v1/token?grant_type=password" \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${TEST_EMAIL}\",\"password\":\"${TEST_PASSWORD}\"}")"

TOKEN="$(printf '%s' "$AUTH_RESPONSE" | json_get_access_token)"
[[ -n "$TOKEN" && "${#TOKEN}" -gt 200 ]] || die "Failed to obtain access token"

echo "==> Step 1: generateReceiptUrl (presign + queue messages row)"
GENERATE_BODY="$(cat <<EOF
{
  "branchId": "${BRANCH_ID}",
  "imageInS3": "${RECEIPT_FILE_NAME}",
  "phone": "${TEST_PHONE}",
  "smsBranchId": ${SMS_BRANCH_ID},
  "sendSms": true,
  "transactionId": "manual-test"
}
EOF
)"
invoke_function "generateReceiptUrl" "$GENERATE_BODY"

echo "==> Step 2: sendSms (deliver pending messages)"
invoke_function "sendSms" "{}"

echo "==> Done. Check phone ${TEST_PHONE}."
echo "    If no SMS: Supabase Dashboard → messages (delivered=false?) → Edge Function logs for sendSms."
