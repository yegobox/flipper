// Boot smoke test for a built Flutter web app.
//
// `flutter build web --release` only proves the app COMPILES. It says nothing
// about whether it boots in a real browser — exactly the class of failure
// release.yml already documents for dart2wasm + Ditto cold-start bootstrap,
// where the artifact built fine and then served a blank page to Chrome.
//
// This loads the built bundle in headless Chrome and fails if the Flutter view
// never renders or if the page raises errors while booting.
//
// Usage: node scripts/ci/web_boot_smoke.mjs <url> [--screenshot out.png]

import puppeteer from "puppeteer";

const url = process.argv[2] ?? "http://127.0.0.1:8080";
const shotIdx = process.argv.indexOf("--screenshot");
const screenshot = shotIdx > -1 ? process.argv[shotIdx + 1] : null;

const BOOT_TIMEOUT_MS = Number(process.env.SMOKE_BOOT_TIMEOUT_MS ?? 120_000);
// Time to keep watching for errors AFTER first paint, so async bootstrap
// failures (Supabase, Ditto, service worker) still get caught.
const SETTLE_MS = Number(process.env.SMOKE_SETTLE_MS ?? 15_000);

// Errors that are environmental in CI rather than app defects. Keep this list
// short and specific — a broad pattern here silently disables the smoke test.
const IGNORE = [
  /favicon\.ico/i,
  /net::ERR_INTERNET_DISCONNECTED/i,
  /Failed to load resource.*\/assets\/AssetManifest/i,
];

const ignored = (text) => IGNORE.some((re) => re.test(text));

const problems = [];
const note = (kind, text) => {
  if (!ignored(text)) problems.push(`[${kind}] ${text}`);
};

const browser = await puppeteer.launch({
  headless: "new",
  args: ["--no-sandbox", "--disable-dev-shm-usage", "--window-size=1440,900"],
});

let exitCode = 0;
try {
  const page = await browser.newPage();
  await page.setViewport({ width: 1440, height: 900 });

  page.on("console", (m) => {
    if (m.type() === "error") note("console", m.text());
  });
  page.on("pageerror", (e) => note("pageerror", e.message));
  page.on("requestfailed", (r) =>
    note("requestfailed", `${r.url()} ${r.failure()?.errorText ?? ""}`),
  );

  console.log(`loading ${url}`);
  await page.goto(url, { waitUntil: "domcontentloaded", timeout: BOOT_TIMEOUT_MS });

  // Flutter web mounts into <flutter-view>/<flt-glass-pane> depending on
  // version and renderer; accept any of them as "the framework came up".
  await page.waitForFunction(
    () =>
      !!document.querySelector("flutter-view") ||
      !!document.querySelector("flt-glass-pane") ||
      !!document.querySelector("flt-scene-host"),
    { timeout: BOOT_TIMEOUT_MS, polling: 500 },
  );
  console.log("flutter view mounted");

  await new Promise((r) => setTimeout(r, SETTLE_MS));

  // A mounted view that painted nothing is still a failed boot. Measure
  // <flutter-view> — <flt-glass-pane> is a shadow host whose own rect is 0x0
  // even on a healthy app, so testing it first reports a false failure.
  const painted = await page.evaluate(() => {
    const hosts = ["flutter-view", "flt-scene-host", "flt-glass-pane"];
    return hosts.some((sel) => {
      const el = document.querySelector(sel);
      if (!el) return false;
      const r = el.getBoundingClientRect();
      return r.width > 0 && r.height > 0;
    });
  });
  if (!painted) problems.push("[render] flutter view mounted but has zero size");

  if (screenshot) {
    await page.screenshot({ path: screenshot, fullPage: false });
    console.log(`screenshot: ${screenshot}`);
  }

  if (problems.length) {
    console.error(`\nboot smoke FAILED with ${problems.length} problem(s):`);
    for (const p of problems) console.error(`  ${p}`);
    exitCode = 1;
  } else {
    console.log("\nboot smoke PASSED");
  }
} catch (err) {
  console.error(`\nboot smoke FAILED: ${err.message}`);
  for (const p of problems) console.error(`  ${p}`);
  exitCode = 1;
} finally {
  await browser.close();
}

process.exit(exitCode);
