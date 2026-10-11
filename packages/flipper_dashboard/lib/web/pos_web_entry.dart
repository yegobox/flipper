import 'dart:async';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/power_sync/supabase.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show DatabaseFactory, databaseFactoryOrNull;

/// The Flipper POS, hosted by flipper_web (Books on the web).
///
/// flipper_web boots Supabase and, after login, Ditto — nothing else. The POS
/// also needs the service locator, `ProxyService` and the Brick repository,
/// which the native app sets up in `main()`. [bootstrapPosForWeb] does that on
/// first open, and [seedPosContextFromWeb] hands the POS the session Books
/// already has: the reverse of `restoreNativeBooksContext`.
///
/// flipper_web loads this library deferred, so Books never pays for it.

Future<void>? _bootstrap;

/// Sets up what the POS needs, once per page load. A failed attempt is
/// forgotten so the retry button can run it again.
///
/// [databaseFactory] backs the offline HTTP queue and the in-memory Brick DB
/// (repository.dart takes the in-memory path on web); the host passes
/// `databaseFactoryFfiWeb`, whose wasm/worker files ship in its web/ folder.
Future<void> bootstrapPosForWeb({required DatabaseFactory databaseFactory}) {
  return _bootstrap ??= _runBootstrap(databaseFactory).catchError((
    Object e,
    StackTrace st,
  ) {
    _bootstrap = null;
    Error.throwWithStackTrace(e, st);
  });
}

Future<void> _runBootstrap(DatabaseFactory databaseFactory) async {
  databaseFactoryOrNull = databaseFactory;

  // flipper_web already initialized Supabase with the signed-in session; the
  // Repository's own `Supabase.initialize` returns that instance unchanged.
  await loadSupabase();

  await loc.setupLocator(stackedRouter: stackedRouter);
  setupDialogUi();
  setupBottomSheetUi();
  await initDependencies();

  // Not calling registerFlipperPaymentsHost / registerDataConnectorAuthHost:
  // flipper_web registered its Supabase-backed connector auth and payments
  // client at startup, and the native ones would replace them with a token
  // source that has no session in a browser.
}

/// Writes Books' selected business, branch and user into the POS preference
/// box, so the POS opens on the branch the user picked in Books.
///
/// Returns false when there is no selection to hand over.
Future<bool> seedPosContextFromWeb(WidgetRef ref) async {
  final business = ref.read(selectedBusinessProvider);
  final branch = ref.read(selectedBranchProvider);
  if (business == null || branch == null) {
    debugPrint('[POS web] no business/branch selected in Books');
    return false;
  }

  final profile = ref.read(userProfileCacheProvider);
  final userId = ref.read(sessionApiUserIdProvider)?.trim() ?? profile?.id;
  final box = ref.read(branchServicesProvider).box;

  if (userId != null && userId.isNotEmpty) {
    await box.writeString(key: 'userId', value: userId);
  }
  final phone = profile?.phoneNumber ?? '';
  if (phone.isNotEmpty) {
    await box.writeString(key: 'userPhone', value: phone);
  }
  await box.writeString(key: 'businessId', value: business.id);
  await box.writeString(key: 'branchId', value: branch.id);
  await box.writeString(key: 'branchIdString', value: branch.id);
  return true;
}

/// Full-page POS for flipper_web's `/pos` route.
///
/// Runs on the native app's Stacked router in a nested [MaterialApp] (as
/// flipper_hr's embedded app runs its own router), with no route information
/// provider, so it never fights GoRouter for the browser URL.
class PosWebEntry extends ConsumerStatefulWidget {
  const PosWebEntry({
    super.key,
    required this.databaseFactory,
    required this.onExit,
  });

  /// See [bootstrapPosForWeb].
  final DatabaseFactory databaseFactory;

  /// Leaves the POS (back to Books).
  final VoidCallback onExit;

  @override
  ConsumerState<PosWebEntry> createState() => _PosWebEntryState();
}

class _PosWebEntryState extends ConsumerState<PosWebEntry> {
  late Future<bool> _ready;

  @override
  void initState() {
    super.initState();
    // Provider reads must not run during initState — defer to the next event.
    _ready = Future<bool>(_prepare);
  }

  Future<bool> _prepare() async {
    await bootstrapPosForWeb(databaseFactory: widget.databaseFactory);
    if (!mounted) return false;
    return seedPosContextFromWeb(ref);
  }

  void _retry() => setState(() => _ready = Future<bool>(_prepare));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosTokens.posBg,
      child: Column(
        children: [
          _PosWebTopBar(onExit: widget.onExit),
          Expanded(
            child: FutureBuilder<bool>(
              future: _ready,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('[POS web] bootstrap failed: ${snapshot.error}');
                  return _PosWebMessage(
                    message: snapshot.error.toString(),
                    onRetry: _retry,
                  );
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data != true) {
                  return _PosWebMessage(
                    message: context.flipperL10n.checkoutRecoverySelectBranch,
                    onRetry: widget.onExit,
                  );
                }
                // Capella reads go through the same Ditto Books started.
                if (!ref.watch(dittoReadyProvider)) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const PosWebApp();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The POS itself: [CheckOut] on the native app's Stacked router.
///
/// Public so a web boot probe can mount it without Books' session gates.
class PosWebApp extends ConsumerStatefulWidget {
  const PosWebApp({super.key});

  @override
  ConsumerState<PosWebApp> createState() => _PosWebAppState();
}

class _PosWebAppState extends ConsumerState<PosWebApp> {
  // The Stacked delegate pushes its initial routes only from
  // setInitialRoutePath, which the Router calls only when it has a route
  // information provider. Without one the POS navigator stays empty.
  final _routeInformation = _SilentRouteInformationProvider(
    RouteInformation(uri: Uri.parse('/check-out')),
  );

  @override
  void initState() {
    super.initState();
    // Catalog, counters and SAR rows for this branch: the same pull the native
    // app registers after login.
    ref
        .read(branchServicesProvider)
        .app
        .ensureBranchDittoSubscriptionsForCurrentBranch();
  }

  @override
  void dispose() {
    _routeInformation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bigScreen =
        MediaQuery.sizeOf(context).width >=
        PosLayoutBreakpoints.mobileLayoutMaxWidth;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flipper POS',
      theme: FlipperTheme.light(),
      locale: Localizations.maybeLocaleOf(context),
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      routeInformationProvider: _routeInformation,
      routeInformationParser: stackedRouter.defaultRouteParser(),
      // Built once per page load (RootStackRouter caches it), so leaving and
      // reopening the POS keeps the cart screen where it was.
      routerDelegate: stackedRouter.delegate(
        initialRoutes: [CheckOutRoute(isBigScreen: bigScreen)],
      ),
    );
  }
}

/// Gives the nested POS router its first location and never reports
/// navigation back: the browser URL belongs to flipper_web's GoRouter.
class _SilentRouteInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  _SilentRouteInformationProvider(this.value);

  @override
  final RouteInformation value;

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {}
}

class _PosWebTopBar extends StatelessWidget {
  const _PosWebTopBar({required this.onExit});

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: PosTokens.surface,
        border: Border(bottom: BorderSide(color: PosTokens.line)),
      ),
      child: Row(
        children: [
          TextButton.icon(
            key: const Key('pos-web-back-to-books'),
            onPressed: onExit,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: Text(l10n.dashboardAppBooks),
            style: TextButton.styleFrom(foregroundColor: PosTokens.ink2),
          ),
          const SizedBox(width: 8),
          const Text(
            'POS',
            style: const TextStyle(
              color: PosTokens.ink1,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosWebMessage extends StatelessWidget {
  const _PosWebMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.flipperL10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
