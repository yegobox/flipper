"""Artemis-driven end-to-end signup test for Flipper on an Android device.

Artemis (https://github.com/google/artemis) is an LLM agent that drives a real
Android device from natural-language goals. This script wraps it into a
pass/fail CI check for the new-user signup flow:

  1. Install the APK on a clean device and launch it.
  2. Artemis phase 1: Landing -> Create account -> step 1 (username, full
     name) -> step 2 (email) -> "Send Code", then stop.
  3. Read the signup OTP from Supabase `messages` (flipper-turbo writes
     "Your OTP is: NNNNNN" there for email contacts and verify-otp-signup
     checks against the same row), so no inbox or SMS is needed.
  4. Artemis phase 2: type the OTP -> step 3 (Individual, Rwanda) -> create
     account -> pick the new business -> confirm the home screen.
  5. Deterministic checks the agent cannot fake: the business name is now
     taken on apihub (/v2/api/search -> 200), and logcat has no crash for
     the app.

Each device gets a unique username/email so parallel matrix jobs never
collide. Exit code 0 means signup works on this device.

Required env:
  GEMINI_API_KEY (or another Artemis LLM provider key)
  SUPABASE_URL, SUPABASE_SERVICE_KEY   read access to the `messages` table
  SIGNUP_TEST_EMAIL                    e.g. flipper-ci@yegobox.com; the run
                                       tag is added as +suffix
Optional env:
  ANDROID_SERIAL (default emulator-5554), APK_PATH, APP_ID (rw.flipper),
  APIHUB_URL (https://apihub.yegobox.com), ARTEMIS_PROFILE (pro|flash),
  ARTEMIS_MAX_STEPS, RUN_TAG, DEVICE_LABEL, ARTIFACTS_DIR
"""

from __future__ import annotations

import asyncio
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from xml.sax.saxutils import escape

from pydantic import BaseModel, Field

from artemis import Agent, Builders
from artemis.config import initialize_llm_config, settings
from artemis.sdk.types.task import AgentProfile

APP_ID = os.environ.get("APP_ID", "rw.flipper")
SERIAL = os.environ.get("ANDROID_SERIAL", "emulator-5554")
APK_PATH = os.environ.get("APK_PATH", "")
APIHUB_URL = os.environ.get("APIHUB_URL", "https://apihub.yegobox.com").rstrip("/")
PROFILE = os.environ.get("ARTEMIS_PROFILE", "pro")
MAX_STEPS = int(os.environ.get("ARTEMIS_MAX_STEPS", "60"))
DEVICE_LABEL = os.environ.get("DEVICE_LABEL", SERIAL)
RUN_TAG = os.environ.get("RUN_TAG") or str(int(time.time()))
ARTIFACTS = Path(os.environ.get("ARTIFACTS_DIR", "artemis-artifacts")).resolve()
OTP_WAIT_SECONDS = int(os.environ.get("OTP_WAIT_SECONDS", "180"))


class SendCodeResult(BaseModel):
    reached_signup_form: bool = Field(
        description="True if the 3-step signup form ('Who are you?') was reached."
    )
    code_sent: bool = Field(
        description=(
            "True if after tapping 'Send Code' the app confirmed the code was sent"
            " (snackbar 'OTP sent successfully!') or an 'OTP Code' field appeared."
        )
    )
    error_messages: list[str] = Field(
        default_factory=list,
        description="Every error text, snackbar or dialog shown by the app, verbatim.",
    )
    notes: str = Field(default="", description="Short description of where you stopped.")


class FinishSignupResult(BaseModel):
    otp_verified: bool = Field(
        description="True if the app confirmed the contact was verified (green check or 'verified successfully')."
    )
    account_created: bool = Field(
        description="True if 'Create account' was tapped and the app left the signup form without an error."
    )
    business_opened: bool = Field(
        description="True if the business named after the username was opened (from 'Choose a business' or directly)."
    )
    home_reached: bool = Field(
        description="True if a signed-in home/dashboard screen of the app is visible at the end."
    )
    final_screen: str = Field(description="What the final screen shows (title and key texts).")
    error_messages: list[str] = Field(
        default_factory=list,
        description="Every error text, snackbar or dialog shown by the app, verbatim.",
    )


def log(msg: str) -> None:
    print(f"[{DEVICE_LABEL}] {msg}", flush=True)


def adb(*args: str, check: bool = True, timeout: int = 120) -> str:
    proc = subprocess.run(
        ["adb", "-s", SERIAL, *args],
        capture_output=True,
        text=True,
        timeout=timeout,
    )
    if check and proc.returncode != 0:
        raise RuntimeError(f"adb {' '.join(args)} failed: {proc.stderr.strip()}")
    return proc.stdout


def screenshot(name: str) -> None:
    try:
        png = subprocess.run(
            ["adb", "-s", SERIAL, "exec-out", "screencap", "-p"],
            capture_output=True,
            timeout=30,
        ).stdout
        if png:
            (ARTIFACTS / f"{name}.png").write_bytes(png)
    except Exception as exc:  # screenshots are diagnostics only
        log(f"screenshot {name} failed: {exc}")


def identity() -> tuple[str, str]:
    """Unique signup identity for this run + device.

    Username rules (signup_form_bloc.dart): required, at most 11 characters,
    and must not already exist as a business on apihub.
    """
    digest = hashlib.sha256(f"{RUN_TAG}:{DEVICE_LABEL}".encode()).hexdigest()
    username = "ci" + digest[:9]
    base = os.environ["SIGNUP_TEST_EMAIL"].strip().lower()
    local, _, domain = base.partition("@")
    if not domain:
        raise SystemExit("SIGNUP_TEST_EMAIL must be an email address")
    return username, f"{local}+{username}@{domain}"


def prepare_device() -> None:
    adb("wait-for-device", timeout=300)
    if APK_PATH:
        log(f"installing {APK_PATH}")
        adb("install", "-r", "-g", APK_PATH, timeout=600)
    adb("shell", "pm", "clear", APP_ID, check=False)
    sdk = int(adb("shell", "getprop", "ro.build.version.sdk").strip() or 0)
    if sdk >= 33:
        adb("shell", "pm", "grant", APP_ID, "android.permission.POST_NOTIFICATIONS", check=False)
    adb("logcat", "-c", check=False)
    adb("shell", "monkey", "-p", APP_ID, "-c", "android.intent.category.LAUNCHER", "1")
    # First launch initialises Firebase/Ditto; give it a moment before the agent looks.
    time.sleep(20)


def fetch_otp(username: str, not_before: float) -> str:
    """Poll Supabase `messages` for the OTP flipper-turbo recorded for our email.

    Matching on the unique username tag keeps this robust even if the agent
    typed the email with different casing.
    """
    url = os.environ["SUPABASE_URL"].rstrip("/") + "/rest/v1/messages?" + urllib.parse.urlencode(
        {
            "select": "text,created_at,phone_number",
            "phone_number": f"ilike.*+{username}@*",
            "text": "like.Your OTP is:*",
            "order": "created_at.desc",
            "limit": "1",
        }
    )
    key = os.environ["SUPABASE_SERVICE_KEY"]
    request = urllib.request.Request(url, headers={"apikey": key, "Authorization": f"Bearer {key}"})
    deadline = time.time() + OTP_WAIT_SECONDS
    while time.time() < deadline:
        try:
            with urllib.request.urlopen(request, timeout=20) as resp:
                rows = json.load(resp)
        except urllib.error.URLError as exc:
            log(f"supabase poll failed: {exc}")
            rows = []
        for row in rows:
            match = re.search(r"Your OTP is:\s*(\d{6})", row.get("text", ""))
            if match:
                log(f"OTP row found for {row.get('phone_number')} at {row.get('created_at')}")
                return match.group(1)
        time.sleep(5)
    raise TimeoutError(
        f"No OTP recorded in Supabase messages for +{username}@ within {OTP_WAIT_SECONDS}s"
        f" (waited since {time.strftime('%H:%M:%S', time.gmtime(not_before))} UTC)"
    )


def business_exists(username: str) -> bool:
    url = f"{APIHUB_URL}/v2/api/search?" + urllib.parse.urlencode({"name": username})
    try:
        with urllib.request.urlopen(url, timeout=30) as resp:
            return resp.status == 200
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return False
        raise


def app_crashes() -> list[str]:
    crash_log = adb("logcat", "-d", "-b", "crash", check=False)
    (ARTIFACTS / "logcat-crash.txt").write_text(crash_log)
    (ARTIFACTS / "logcat.txt").write_text(adb("logcat", "-d", check=False, timeout=180))
    return [
        line
        for line in crash_log.splitlines()
        if APP_ID in line and ("FATAL EXCEPTION" in line or "Process:" in line)
    ]


PHASE1_GOAL = """\
You are testing the sign-up flow of the Flipper app (package {app_id}), which is
already open on this Android device. Only interact with the Flipper app. If an
Android permission dialog appears, tap "Allow". Never tap "Sign in" and never
use Google, Microsoft, Apple or phone-number login.

1. Start creating a NEW account:
   - On a phone you will see an intro carousel: tap "Skip intro - Create account"
     (or tap "Next" until "Create account" appears, then tap it).
   - On a tablet you may see a split sign-in screen instead: tap
     "New to Flipper? Create an account".
2. The screen "Who are you?" (Step 1 of 3) appears.
   - In "Username" type exactly: {username}
   - In "Full Name" type exactly: {full_name}
   - Wait until the username check finishes (no "already taken" error), then
     tap "Continue".
3. The screen "How do we reach you?" (Step 2 of 3) appears.
   - In the "Phone / Email" field type exactly: {email}
   - Tap "Send Code" once and wait up to 30 seconds.
4. STOP as soon as the app confirms the code was sent ("OTP sent successfully!")
   or an "OTP Code" field appears. Do NOT type any code. Do NOT tap Continue.

If any error appears (for example "Name Search not available", "already taken",
"already associated with an existing account", "Failed to send OTP"), stop and
report the exact text.
"""

PHASE2_GOAL = """\
You are continuing a sign-up in the Flipper app (package {app_id}) that is open
on the "How do we reach you?" screen (Step 2 of 3). A one-time code was sent.
Only interact with the Flipper app. If an Android permission dialog appears,
tap "Allow".

1. In the "OTP Code" field type exactly: {otp}
   Wait for the app to confirm verification (a green check or "verified
   successfully"). Then tap "Continue".
2. The screen "Tell us about your shop" (Step 3 of 3) appears.
   - Leave "Usage" as "Individual" (select "Individual" if something else is chosen).
   - Leave Country as "Rwanda" (select "Rwanda" if something else is chosen).
   - Tap the button "Create account · claim 500 pts".
3. Wait up to 90 seconds for the account to be created.
   - If a "Choose a business" screen appears, tap the business named
     "{username}".
   - If a subscription / payment plan screen appears, that still counts as a
     signed-in state: stop there and describe it.
4. Stop when a signed-in home screen of the app is visible (for an Individual
   account it greets the user, e.g. "Ready for adventure?"), and describe it.

Report every error text exactly as shown (for example "An error occurred during
signup" or "Invalid or expired OTP").
"""


async def run_signup(username: str, email: str) -> tuple[bool, dict]:
    report: dict = {"device": DEVICE_LABEL, "username": username, "email": email}
    config = Builders.AgentConfig.with_default_profile(
        profile=AgentProfile(name="default", llm_config=initialize_llm_config())
    )
    config.with_video_recording_tools(enabled=False)
    if settings.ADB_HOST:
        config.with_adb_server(host=settings.ADB_HOST, port=settings.ADB_PORT)
    config.for_device_serial(SERIAL)

    agent = Agent(config=config.build())
    try:
        await agent.init(retry_count=10, retry_wait_seconds=3)

        async def phase(name: str, goal: str, output: type[BaseModel]):
            request = (
                agent.new_task(goal)
                .with_output_format(output)
                .using_profile(PROFILE)
                .with_name(f"{DEVICE_LABEL}-{name}")
                .with_max_steps(MAX_STEPS)
                .with_trace_recording(path=str(ARTIFACTS / "traces"))
            )
            log(f"artemis {name} ({PROFILE}) starting")
            result = await agent.run_task(request=request.build())
            screenshot(name)
            log(f"artemis {name} result: {result!r}")
            return result

        sent_after = time.time()
        first = await phase(
            "send-code",
            PHASE1_GOAL.format(app_id=APP_ID, username=username, full_name="Artemis CI", email=email),
            SendCodeResult,
        )
        report["send_code"] = first.model_dump() if first else None

        try:
            otp = fetch_otp(username, sent_after)
        except TimeoutError as exc:
            report["failure"] = str(exc)
            return False, report
        report["otp_found"] = True

        second = await phase(
            "finish-signup",
            PHASE2_GOAL.format(app_id=APP_ID, username=username, otp=otp),
            FinishSignupResult,
        )
        report["finish_signup"] = second.model_dump() if second else None
    finally:
        await agent.clean()

    # Give the backend a moment, then check with sources the agent cannot influence.
    exists = False
    for _ in range(12):
        exists = business_exists(username)
        if exists:
            break
        time.sleep(5)
    report["business_created_on_apihub"] = exists
    crashes = app_crashes()
    report["crashes"] = crashes

    failures = []
    if not exists:
        failures.append(f"business '{username}' not found on {APIHUB_URL}/v2/api/search")
    if crashes:
        failures.append(f"app crashed: {crashes[0]}")
    if not second:
        failures.append("Artemis returned no structured result for finish-signup")
    elif not (second.account_created and second.home_reached):
        failures.append(
            f"agent did not reach the signed-in home screen: {second.final_screen}"
            f" errors={second.error_messages}"
        )
    report["failure"] = "; ".join(failures) or None
    return not failures, report


def write_reports(passed: bool, report: dict, seconds: float) -> None:
    (ARTIFACTS / "report.json").write_text(json.dumps(report, indent=2))
    message = escape(report.get("failure") or "failed", {'"': "&quot;"})
    failure = "" if passed else f'<failure message="{message}"/>'
    (ARTIFACTS / "junit.xml").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<testsuite name="artemis-android-signup" tests="1" failures="{0 if passed else 1}">\n'
        f'  <testcase classname="signup.{escape(DEVICE_LABEL)}" name="new user can sign up"'
        f' time="{seconds:.1f}">{failure}</testcase>\n'
        "</testsuite>\n"
    )
    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary:
        with open(summary, "a", encoding="utf-8") as fh:
            icon = "✅" if passed else "❌"
            fh.write(f"### {icon} Signup on `{DEVICE_LABEL}` ({seconds / 60:.1f} min)\n\n")
            fh.write(f"- username `{report.get('username')}`\n")
            fh.write(f"- business created on apihub: `{report.get('business_created_on_apihub')}`\n")
            if report.get("failure"):
                fh.write(f"- failure: {report['failure']}\n")
            fh.write("\n")


def main() -> int:
    ARTIFACTS.mkdir(parents=True, exist_ok=True)
    started = time.time()
    username, email = identity()
    log(f"signup identity: {username} / {email}")
    report: dict = {"device": DEVICE_LABEL, "username": username}
    passed = False
    try:
        prepare_device()
        screenshot("launch")
        passed, report = asyncio.run(run_signup(username, email))
    except Exception as exc:  # report infrastructure failures the same way
        report["failure"] = f"{type(exc).__name__}: {exc}"
        screenshot("error")
    write_reports(passed, report, time.time() - started)
    log("PASS" if passed else f"FAIL: {report.get('failure')}")
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
