import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/native_books_context_bridge.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/supabase_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

/// Builds Flipper HR for [HrModuleEntry].
typedef HrAppBuilder =
    Widget Function({
      required VoidCallback onExit,
      required VoidCallback onUpgrade,
    });

/// The HR app, registered by the host app (apps/flipper overrides this with
/// flipper_hr's `HrEmbeddedApp`). flipper_hr is an app package, which packages
/// may not import (scripts/ci/architecture_ratchet.sh), hence the hook.
///
/// Null when the running app does not ship HR; the More → Apps tile is then
/// hidden.
final hrAppBuilderProvider = Provider<HrAppBuilder?>((ref) => null);

/// Signs the app into Supabase if it is not already, returning the access
/// token or null when that is impossible (offline, no phone in the box).
///
/// A provider so tests can stand in for the network.
final hrEnsureSupabaseSessionProvider = Provider<Future<String?> Function()>(
  (ref) => SupabaseSessionService.ensureAccessToken,
);

/// Native host for Flipper HR (More → Apps → HR & Payroll).
///
/// Does for HR what its web shell does at sign-in, from the session the app
/// already has, so there is no second login: seeds the business and branch
/// from the native session (the same bridge Books uses) and makes sure there
/// is a Supabase session, which HR needs for every read.
class HrModuleEntry extends ConsumerStatefulWidget {
  const HrModuleEntry({super.key});

  static const routeName = 'HrModule';

  @override
  ConsumerState<HrModuleEntry> createState() => _HrModuleEntryState();
}

class _HrModuleEntryState extends ConsumerState<HrModuleEntry> {
  late Future<bool> _ready;

  @override
  void initState() {
    super.initState();
    // Provider writes must not run during initState/build — defer to next event loop.
    _ready = Future<bool>(_prepare);
  }

  Future<bool> _prepare() async {
    try {
      await restoreNativeBooksContext(ref);
    } catch (e) {
      // Not fatal: without a seeded branch HR's own gate says "pick a branch",
      // which explains itself. Only the missing session blocks HR.
      debugPrint('[HR] native context restore failed: $e');
    }
    final token = await ref.read(hrEnsureSupabaseSessionProvider)();
    return token != null && token.isNotEmpty;
  }

  void _retry() {
    final next = Future<bool>(_prepare);
    setState(() {
      _ready = next;
    });
  }

  void _exit() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data != true) {
          return _HrOffline(onRetry: _retry, onBack: _exit);
        }
        final buildHr = ref.watch(hrAppBuilderProvider);
        if (buildHr == null) return _HrOffline(onRetry: _retry, onBack: _exit);
        return buildHr(
          onExit: _exit,
          // HR is included in the mobile plan, so an unpaid business is sent
          // to that plan, not to HR's own subscription.
          onUpgrade: () =>
              locator<RouterService>().navigateTo(PaymentPlanUIRoute()),
        );
      },
    );
  }
}

class _HrOffline extends StatelessWidget {
  const _HrOffline({required this.onRetry, required this.onBack});

  final VoidCallback onRetry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.hrAndPayroll,
        icon: Icons.arrow_back,
        onPop: onBack,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 40),
              const SizedBox(height: 16),
              Text(l10n.hrNeedsInternet, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: onBack,
                    child: Text(l10n.hrBackToFlipper),
                  ),
                  FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
