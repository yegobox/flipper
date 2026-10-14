# Flipper SMS Bridge

A small Android app that forwards **bank and mobile-money SMS** (BK, MTN MoMo,
Airtel Money, Equity, I&M) to Flipper. Each message becomes:

- a line in the **Books bank feed** (`bank_statement_lines`), and
- a **"To review" item in the Cash Book**. Confirming it creates the Cash In
  or Cash Out and matches the bank line, so nothing is entered twice.

Personal SMS never leave the phone. The app forwards only allowlisted senders,
and the connector checks the list again.

## Why a separate app

Google Play does not allow `READ_SMS`/`RECEIVE_SMS` for an app like Flipper,
so Flipper cannot read SMS itself. This app is installed outside Play. Google
requires apps installed that way to come from a verified developer, starting in
selected countries in September 2026 and everywhere in 2027. Register
`rw.flipper.smsbridge` and the release signing key in the Android Developer
Console before then. Verification checks who the developer is; it does not
review the app or its permissions.

## How it works

```
SMS arrives → SmsReceiver (allowlist) → SQLite queue → UploadWorker
  → POST {connector}/api/sms-bridge/messages   (token scope: sms.ingest)
  → data-connector parses → Ditto sms_transactions + bank_statement_lines
```

- **Pairing:** in Flipper go to Settings → SMS Bridge → Pair a phone. Scan the
  QR code (`flipper-sms-bridge://pair?url=…&code=…`) or type the code. The
  code works once and expires after 10 minutes. The phone gets its own
  credentials, limited to forwarding SMS for that one branch. Revoke it from
  the same settings page.
- **Offline-safe:** messages are queued the moment they arrive and uploaded by
  WorkManager when there is a network. Re-sending is harmless because the
  connector dedupes by the bank's own reference.
- **Credentials** are encrypted with an Android Keystore key, and the app opts
  out of all backups.
- **Parsing is on the server** (`data-connector/src/sms`). When a bank changes
  its wording, the connector is fixed and the app needs no update. The sender
  allowlist also comes from the server and refreshes every 6 hours.

## Installing on a phone

1. Download the APK from the latest `sms-bridge-v*` release.
2. Allow "Install unknown apps" for the browser or file manager when prompted.
3. Open the app and allow SMS access. **Android 13+ may grey out the SMS
   permission** for apps installed from a browser ("restricted setting"). If it
   does, go to App info → ⋮ → *Allow restricted settings*, then grant again.
   The app's "Open App info" button goes straight there.
4. Tap *Keep running in the background* and allow it. Without this, some phones
   (Tecno, Infinix, Xiaomi) stop background delivery.
5. Pair with Flipper. You can also send the last 7 or 30 days already in the
   inbox.

Use a phone that stays on and charged, ideally the one that receives the
business's bank and MoMo alerts.

## Building

```bash
# Core logic (sender allowlist, multipart join, QR parsing, upload policy),
# no Android SDK needed:
gradle -PcoreOnly :core:test

# The app (needs the Android SDK; ANDROID_HOME or local.properties sdk.dir):
gradle :app:assembleDebug
```

Gradle 8.14.3, JDK 17, AGP 8.12.1, Kotlin 2.2.20, the same toolchain as
`apps/flipper/android`. CI: `.github/workflows/sms_bridge.yml`.

Testing against a local connector from the emulator: pair with the URL
`http://10.0.2.2:8084/` (plain HTTP is allowed only for loopback/emulator
hosts), then inject a message:

```bash
adb emu sms send BK "TRANSFER - EKASH Beneficiary: Jane DOE Credited account: 0780000123 Debited account: 100000000042 Amount:RWF 2000.00 Transaction Charge:RWF 20 Event #:FTCMTEST0001 Status: COMPLETED Date: 2026-10-14 09:29:21.338"
```

(Use made-up values only. Real bank SMS contain personal data.)

## Releasing

Push a tag `sms-bridge-vX.Y.Z`. CI builds a release APK signed with the key in
the `SMS_BRIDGE_KEYSTORE_BASE64` / `_PASSWORD` / `SMS_BRIDGE_KEY_ALIAS` /
`SMS_BRIDGE_KEY_PASSWORD` secrets and attaches it to the tag's release.
**Never change or lose that key.** Android refuses an update signed with a
different key, and every installed phone would have to uninstall and pair
again.
