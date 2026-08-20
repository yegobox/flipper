/// Locations reachable without a session.
const hrPublicPaths = {'/login', '/signup'};

/// Redirect policy for [hrRouterProvider], kept dependency-free so it can be
/// tested without Supabase or a live router.
///
/// Returns the location to redirect to, or `null` to stay put. `/` is always
/// allowed through for signed-in sessions because `HrAuthGate` — which knows
/// whether a business/branch is selected — decides where it goes.
String? hrRedirectLocation({
  required bool isAuthenticated,
  required String path,
}) {
  if (isAuthenticated) {
    // Login and signup are dead ends once signed in.
    return hrPublicPaths.contains(path) ? '/business-selection' : null;
  }
  // HR has no marketing page; anything else belongs on login.
  return hrPublicPaths.contains(path) ? null : '/login';
}
