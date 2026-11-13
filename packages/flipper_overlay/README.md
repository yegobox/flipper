# flipper_overlay

Toasts (`toast`) and in-app notifications (`showSimpleNotification`,
`showOverlayNotification`, `showOverlay`), mounted once at the root with
`OverlaySupport.global`.

This is [overlay_support](https://pub.dev/packages/overlay_support) **2.1.0**
(Apache-2.0, see `LICENSE`), copied in on 2026-11-13 because upstream has not
released since November 2022. Only the import paths were changed
(`package:overlay_support/...` → `package:flipper_overlay/...`), so behaviour is
identical to the pub package we used before.

Owning the code lets us move it to `material_ui` ourselves when the app switches
(see `docs/flutter_version.md`).
