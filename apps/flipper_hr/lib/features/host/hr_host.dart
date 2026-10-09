import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Who is running HR: the standalone web app, or the Flipper mobile app that
/// opened it from More → Apps.
///
/// The two differ only at the edges. On web HR owns sign-in, the business
/// picker and its own paywall. Embedded, the host has already signed the user
/// in and picked the branch, and sells its own plan — so every one of those
/// exits is handed back to the host instead of routed to a screen that does
/// not exist in the embedded router.
///
/// Pages ask the host rather than calling `context.go('/login')` and friends,
/// so the same widget works in both.
class HrHost {
  const HrHost.web() : _onExit = null, _onUpgrade = null;

  const HrHost.embedded({
    required VoidCallback onExit,
    required VoidCallback onUpgrade,
  }) : _onExit = onExit,
       _onUpgrade = onUpgrade;

  final VoidCallback? _onExit;
  final VoidCallback? _onUpgrade;

  bool get isEmbedded => _onExit != null;

  /// Sign-out and business switching belong to the host when embedded: signing
  /// out of HR would sign the whole app out of Supabase.
  bool get ownsAccount => !isEmbedded;

  /// Leaves HR. Embedded only — the web app has nowhere to go back to.
  void exit() => _onExit?.call();

  /// The way back to a valid session.
  void toSignIn(BuildContext context) =>
      isEmbedded ? _onExit!() : context.go('/login');

  /// The plan that unlocks HR: HR's own subscribe page on web, the host's
  /// plan screen when embedded (HR is included in the mobile plan).
  void toSubscribe(BuildContext context) =>
      isEmbedded ? _onUpgrade!() : context.go('/subscribe');

  /// Embedded, the branch is chosen in Flipper itself, so this leaves HR.
  void toBusinessSelection(BuildContext context) =>
      isEmbedded ? _onExit!() : context.go('/business-selection');
}

/// Overridden by [HrEmbeddedApp]'s scope; the web app keeps the default.
///
/// Read by widgets only. A provider that read this would also have to declare
/// it in `dependencies` to see the scoped override.
final hrHostProvider = Provider<HrHost>(
  (ref) => const HrHost.web(),
  dependencies: const [],
);
