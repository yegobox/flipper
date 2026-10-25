/// Routes that need a signed-in user. The redirect is a blocklist: anything
/// not listed here (the shop, `/apps`, `/signup`) is public.
const Set<String> kProtectedPaths = {
  '/business-selection',
  '/dashboard',
  '/accounting',
  '/pos',
  '/subscribe',
  '/custom-payment',
};

/// The public online shop: `/shop/<slug>` and everything under it.
bool isShopPath(String path) => path.startsWith('/shop/');

/// The app-wide redirect, kept free of Flutter so it can be tested alone.
///
/// [authenticated] is null while the auth state is still loading.
String? appRedirect({
  required String path,
  required bool? authenticated,
  required bool opensOnLoginScreen,
}) {
  if (authenticated == null) return null;
  // A customer on a shop link stays there, signed in or not.
  if (isShopPath(path)) return null;
  if (authenticated) {
    // After login, business selection comes first.
    if (path == '/login') return '/business-selection';
    return null;
  }
  // Native iOS/macOS skip the marketing home and land on PIN login.
  if (path == '/' && opensOnLoginScreen) return '/login';
  if (kProtectedPaths.contains(path)) return '/login';
  return null;
}

/// The first location for a shop link opened as a plain path.
///
/// flipper_web routes on the URL hash (`/#/accounting`), but shop links are
/// shared as `https://useflipper.com/shop/<slug>`. Hosting serves index.html
/// for every path, so the app boots with an empty hash; this turns the path
/// (and its query, e.g. the order token) into the router's first location.
String? shopDeepLinkLocation(Uri base) {
  if (base.fragment.isNotEmpty) return null;
  if (!isShopPath(base.path)) return null;
  return base.hasQuery ? '${base.path}?${base.query}' : base.path;
}
