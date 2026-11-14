# flipper_overlay

Toasts (`toast`) and in-app notifications (`showSimpleNotification`,
`showOverlayNotification`, `showOverlay`), mounted once at the root with
`OverlaySupport.global`.

This is [overlay_support](https://pub.dev/packages/overlay_support) **2.1.0**
(Apache-2.0, see `LICENSE`), copied in on 2026-11-13 because upstream has not
released since November 2022. Apart from the import paths
(`package:overlay_support/...` → `package:flipper_overlay/...`) and the two
fixes under **Local changes**, the code is upstream's, so behaviour matches the
pub package we used before.

## Local changes

Changes from upstream 2.1.0, each covered by `test/`:

- `SlideDismissible` requires a `key`. Its `Dismissible` needs one, and a
  key-less construction used to throw on `key!`. Every caller already passed
  one.
- `OverlaySupportEntry.dismiss`: a `dismiss()` before the entry mounted,
  followed by `dismiss(animate: false)`, left a frame callback re-scheduling
  itself forever. It now stops once the entry is removed.

Owning the code lets us move it to `material_ui` ourselves when the app switches
(see `docs/flutter_version.md`).
