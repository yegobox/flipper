/// Whether [flipper_web] is the running application (not embedded in Flipper POS).
///
/// Set to `true` in `apps/flipper_web/lib/main.dart` only.
bool flipperWebIsHostApp = false;

/// Bundle key for a flipper_web asset path such as `assets/fonts/x.ttf`.
///
/// Embedded in Flipper POS, flipper_web is a package and its assets are only
/// bundled under `packages/flipper_web/…` — a bare `assets/…` key fails there
/// with "Unable to load asset". `Image.asset` takes `package:` for this; raw
/// `rootBundle` loads must go through here.
String flipperWebAssetKey(String path) =>
    flipperWebIsHostApp ? path : 'packages/flipper_web/$path';
