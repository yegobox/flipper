# flipper_hr

Flipper HR — web app intended to serve https://hr.useflipper.com.

Authentication is shared with Books: HR reuses `flipper_web`'s PIN login, signup
and business/branch selection, so one Flipper account signs in to both apps. HR
modules get built on top of `HrHomeShell` from here.

## Auth wiring

HR depends on `flipper_web` as a package and mounts its screens in HR's own
router — nothing about the login flow is duplicated:

| Route                | Screen                                        |
| -------------------- | --------------------------------------------- |
| `/login`             | `PinScreen` (flipper_web) — PIN → OTP/TOTP     |
| `/signup`            | `SignupView` (flipper_web)                     |
| `/business-selection`| `BusinessSelectionWrapper` (flipper_web)       |
| `/people`            | `HrHomeShell` (this app)                       |
| `/`                  | `HrAuthGate` — routes by session + selection   |

Three host-app settings are applied in `main()` before the router is built:

- `flipperWebIsHostApp = true` — makes the shared stack persist login identity
  and the sale device id in `SharedPreferences` instead of Flipper POS's
  GetIt-registered box, which HR never registers.
- `postSelectionRouteName = HrRoute.home` — the shared business/branch selector
  lands on HR (`/people`) instead of Books (`/accounting`).
- `brandPanelBuilder = (_) => const HrBrandPanel()` — the right half of the
  sign-in / sign-up screens (desktop widths only) renders HR's panel instead of
  Books'. Unset, it falls back to flipper_web's `WebBrandPanel`.

`HrBrandPanel` keeps the shared panel geometry — gradient, glow, rings, three
floating cards — with HR's own content: payroll totals, a new-hire card and an
attendance streak, over the headline "Your team, your time, your people". It
implements `Flipper HR Right Panel.html` from the `personal` design project.

Same Supabase project and same `apihub` endpoints as flipper_web, so PINs, OTP
and TOTP behave identically. Sessions are per-origin browser storage: signing in
on `hr.useflipper.com` does not carry a session over from `useflipper.com`, it is
the *account* that is shared, not the browser session.

## Local

```bash
melos bootstrap --scope="flipper_hr"
flutter run -d chrome        # from apps/flipper_hr
flutter test
```

## Hosting layout

Firebase project: `yegobox-2ee43` (same project as flipper_web production).

| App          | Hosting site   | Domains                                     |
| ------------ | -------------- | ------------------------------------------- |
| flipper_web  | `yegobox-2ee43`| flipper.yegobox.com, useflipper.com         |
| flipper_web  | `flipper-uat`  | preview/UAT channel                         |
| flipper_hr   | `flipper-hr`   | hr.useflipper.com (to be connected)         |

`hr.useflipper.com` must be attached to its **own** hosting site — the default
`yegobox-2ee43` site already owns `useflipper.com`, and a subdomain attached
there would serve flipper_web.

## Deploy

```bash
cd apps/flipper_hr
flutter build web --release

# one time, creates https://flipper-hr.web.app
firebase hosting:sites:create flipper-hr --project yegobox-2ee43

firebase deploy --only hosting --project yegobox-2ee43
```

`firebase.json` pins `hosting.site: "flipper-hr"`, so deploys never touch the
flipper_web sites.

## Connecting hr.useflipper.com

1. Firebase Console → Hosting → site `flipper-hr` → **Add custom domain** →
   `hr.useflipper.com`.
2. Add the records Firebase shows at Namecheap (`useflipper.com` nameservers are
   `dns1/dns2.registrar-servers.com`): a TXT record to verify ownership, then the
   A records for the `hr` host.
3. Wait for the certificate to provision, then sign in with a Flipper PIN and
   confirm HR opens on `/people` with the picked business and branch.
