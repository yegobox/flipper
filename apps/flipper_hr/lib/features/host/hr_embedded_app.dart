import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/features/host/hr_host.dart';
import 'package:flipper_hr/features/ui/hr_theme.dart';
import 'package:flipper_hr/router/hr_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Flipper HR as a screen of another app — the mobile app's More → Apps.
///
/// The host must have done what HR's own web shell would otherwise do before
/// pushing this: signed into Supabase (HR is Supabase-only) and seeded
/// flipper_web's `selectedBusinessProvider` / `selectedBranchProvider`, which
/// is where every branch-scoped HR page reads its scope.
///
/// Lives under the host's `MaterialApp`, so localizations come from there. It
/// has its own router, but no back-button dispatcher of its own: the system back
/// reaches the host's navigator, and the [PopScope] here turns it into "back
/// inside HR, else leave HR".
class HrEmbeddedApp extends StatefulWidget {
  const HrEmbeddedApp({
    super.key,
    required this.onExit,
    required this.onUpgrade,
  });

  /// Closes HR, e.g. pops the route that holds this widget.
  final VoidCallback onExit;

  /// Opens the host's plan screen: HR is included in the host's plan, so an
  /// unpaid business is sent there rather than to HR's own subscribe page.
  final VoidCallback onUpgrade;

  @override
  State<HrEmbeddedApp> createState() => _HrEmbeddedAppState();
}

class _HrEmbeddedAppState extends State<HrEmbeddedApp> {
  late final GoRouter _router = buildEmbeddedHrRouter();

  late final HrHost _host = HrHost.embedded(
    onExit: () => widget.onExit(),
    onUpgrade: () => widget.onUpgrade(),
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  /// System back, the same as the header's back button: up a level from a
  /// detail page, out to the host from a top-level one.
  void _onBack(bool didPop, Object? _) {
    if (didPop) return;
    if (_router.canPop()) {
      _router.pop();
      return;
    }
    final parent = hrParentPath(
      _router.routerDelegate.currentConfiguration.uri.path,
    );
    if (parent != null) {
      _router.go(parent);
    } else {
      widget.onExit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [hrHostProvider.overrideWithValue(_host)],
      child: Theme(
        data: hrTheme(FlipperTheme.light()),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: _onBack,
          child: Router<Object>(
            routerDelegate: _router.routerDelegate,
            routeInformationParser: _router.routeInformationParser,
            routeInformationProvider: _router.routeInformationProvider,
          ),
        ),
      ),
    );
  }
}
