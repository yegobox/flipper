# Android E2E with Artemis

`.github/workflows/android_artemis_e2e.yml` runs after every merge to `main`
(and on demand from the Actions tab). An [Artemis](https://github.com/google/artemis)
AI agent drives Flipper on Android emulators and signs up a brand-new user.
It is a separate workflow: not a PR check and not a required status.

## What a run does

1. **build-apk** builds one `--profile` x86_64 APK (AOT, debug-signed, real
   backend from the `SECRETS` secret).
2. **signup** runs a device matrix in parallel, one emulator per job:

   | label | API | form factor |
   |---|---|---|
   | phone-api26-nexus5x | 26 (minSdk) | phone |
   | phone-api29-pixel3a | 29 | small phone |
   | phone-api31-pixel5 | 31 | phone |
   | phone-api34-pixel6 | 34 | phone |
   | phone-api36-pixel7 | 36 (targetSdk) | phone |
   | tablet-api30-pixelc | 30 | tablet |
   | tablet-api34-pixeltablet | 34 | tablet (split desktop login) |
   | foldable-api34-pixelfold | 34 | foldable |

   `workflow_dispatch` → `devices: smoke` runs only the Pixel 6 + Pixel Tablet rows.

3. On each device `signup_e2e.py`:
   - installs the APK on a clean device;
   - **Artemis phase 1**: Landing → Create account → username / full name →
     email → *Send Code*;
   - reads the OTP from Supabase `messages`. For email contacts flipper-turbo
     stores `Your OTP is: NNNNNN` there, and `verify-otp-signup` checks
     against that same row. No inbox or SMS is needed;
   - **Artemis phase 2**: types the OTP → Individual / Rwanda → *Create
     account* → opens the new business → home screen;
   - **verifies without the agent**: `GET {apihub}/v2/api/search?name=<username>`
     must return 200 (the business exists), and logcat must have no crash
     for `rw.flipper`.

   A device passes only if the agent reached the signed-in home screen *and*
   the backend check passes.

Each run and device uses a unique username (`ci` + 9 hex characters; usernames
are limited to 11) and email (`<local>+<username>@<domain>`).

## One-time setup

| Kind | Name | Value |
|---|---|---|
| secret | `GEMINI_API_KEY` | Google AI Studio key. Artemis's default config uses Gemini Flash plus `gemini-robotics-er-2-preview` for locating elements on screen |
| secret | `E2E_SUPABASE_URL` | Supabase project URL (same project flipper-turbo writes `messages` to) |
| secret | `E2E_SUPABASE_SERVICE_KEY` | service-role / `sb_secret_` key; it is used only to read `messages` |
| variable | `E2E_SIGNUP_TEST_EMAIL` | a mailbox you own, e.g. `flipper-ci@yegobox.com`. OTP emails are really sent to `flipper-ci+<username>@…` |
| variable (optional) | `E2E_APIHUB_URL` | defaults to `https://apihub.yegobox.com` |

The build job reuses the existing `SECRETS`, `CONFIGDART`, `FIREBASEOPTIONS`,
`AMPLIFY_*`, `GOOGLE_SERVICE_JSON`, `ACCESS_TOKEN` and `PAT_TOKEN` secrets.

## Things to know

- **Every run creates real accounts** (user, business, branch, pin) on the
  backend the `SECRETS` build points at, which is production today. That means
  8 accounts per merge with the full matrix. They are easy to find: username
  and business name start with `ci` and the email has `+ci…`. Point
  `SECRETS` for this workflow at a staging stack when one exists.
- **Cost and time**: the `pro` profile plans and verifies each step (~15–40 s
  per step), so allow roughly 10–25 minutes per device. `flash` is faster and
  cheaper but less careful.
- **Artifacts** (`artemis-<device>`): screenshots after each phase, Artemis
  traces, `report.json` (the agent's structured answers and the check results),
  `junit.xml`, and full and crash logcat.
- Artemis is pinned (`ARTEMIS_REF`). Bump it on purpose.

## Run locally

```bash
git clone https://github.com/google/artemis ~/artemis && (cd ~/artemis && uv sync)
# emulator or USB device connected, app APK built
export GEMINI_API_KEY=... SUPABASE_URL=... SUPABASE_SERVICE_KEY=... \
       SIGNUP_TEST_EMAIL=you@example.com APK_PATH=apps/flipper/build/app/outputs/flutter-apk/app-profile.apk \
       ANDROID_SERIAL=emulator-5554
uv run --project ~/artemis python e2e/artemis/signup_e2e.py
```

## Adding scenarios

Follow `signup_e2e.py`: write the goal as numbered steps using the exact
on-screen English labels, ask Artemis for a small pydantic result model, and
always add at least one check the agent cannot influence (backend state,
logcat, `adb shell dumpsys`).
