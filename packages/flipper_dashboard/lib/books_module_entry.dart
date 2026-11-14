import 'package:flipper_dashboard/app_choice_dialog.dart';
import 'package:flipper_dashboard/books_module_navigation.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_access_gate.dart';
import 'package:flipper_dashboard/features/service_mode_hotkey.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_dashboard/native_books_context_bridge.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_sheet.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flipper_web/features/module_launcher/app_launcher_host.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

/// Native host for Flipper Books — wraps [AccountingModuleScreen] and wires the
/// topbar apps button to the dashboard's launcher: the All apps sheet on a
/// phone, the POS app chooser on a computer.
class BooksModuleEntry extends ConsumerStatefulWidget {
  const BooksModuleEntry({super.key});

  static const routeName = 'BooksModule';

  @override
  ConsumerState<BooksModuleEntry> createState() => _BooksModuleEntryState();
}

class _BooksModuleEntryState extends ConsumerState<BooksModuleEntry> {
  late final Future<void> _nativeContextReady;

  @override
  void initState() {
    super.initState();
    // Provider writes must not run during initState/build — defer to next event loop.
    _nativeContextReady = Future<void>(() => restoreNativeBooksContext(ref));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _nativeContextReady,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // A phone gets Flipper's own header — round back button, the
        // module's name — like every other Flipper screen. Wider windows keep
        // Books' desktop shell, which has its own chrome and app launcher.
        final mobile =
            MediaQuery.sizeOf(context).width < SITokens.desktopBreakpoint;
        final books = ModuleAccessGate(
          feature: AppFeature.Books,
          label: (context) => context.flipperL10n.dashboardAppBooks,
          child: BooksModeDesk(
            child: AppLauncherHost(
              // A phone gets the More tab's All apps sheet; a computer the
              // same app chooser POS opens from its rail (POS, Books, HR, Flo).
              onOpenLauncher: mobile
                  ? () => DashboardAllAppsSheet.show(context, ref)
                  : () => showAppChoiceDialog(
                      dialogService: locator<DialogService>(),
                      variant: DialogType.appChoice,
                      title: context.flipperL10n.chooseYourDefaultApp,
                    ),
              hostProvidesHeader: mobile,
              child: const AccountingModuleScreen(),
            ),
          ),
        );
        if (!mobile) return books;

        // One header, following where you are: a report's name and "back to
        // the list" inside a report, "Books" and "back to Flipper" elsewhere.
        final tab = ref.watch(accountingMobileTabProvider);
        final report = tab == AccountingMobileTab.reports
            ? ref.watch(mobileReportProvider)
            : null;
        void closeReport() =>
            ref.read(mobileReportProvider.notifier).state = null;

        return PopScope(
          // System back mirrors the header: out of a report first.
          canPop: report == null,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && report != null) closeReport();
          },
          child: Scaffold(
            appBar: CustomAppBar(
              key: const Key('books-app-bar'),
              title: report == null
                  ? context.flipperL10n.dashboardAppBooks
                  : mobileReportTitle(report),
              icon: Icons.arrow_back,
              onPop: report == null
                  ? () => Navigator.of(context).maybePop()
                  : closeReport,
            ),
            body: books,
          ),
        );
      },
    );
  }
}

/// Lets the mode hotkey (`Ctrl/Cmd + Shift + M`) leave Books for POS, Bar or
/// Hotel, cycling like it does on a desk but judged on the user signed in to
/// Books: only modes they hold, and a mode the branch does not offer yet only
/// for an admin ([pickPermittedServiceMode]). Books closes itself first, so
/// the mode does not open underneath it.
///
/// Books has its own hotkey scope: opened straight after sign-in, it has no
/// dashboard below it to listen for the key.
class BooksModeDesk extends ConsumerWidget {
  const BooksModeDesk({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keeps what the pick reads loaded. Only this desk rebuilds; Books
    // itself is [child].
    ref.watch(serviceModeGrantsProvider);
    // The id [dashboardCanOpenPos] reads.
    final userId = currentDashboardUserId();
    for (final feature in posViewFeatures) {
      ref.watch(
        featureViewAccessProvider(userId: userId, featureName: feature),
      );
    }
    final navigator = Navigator.of(context, rootNavigator: true);

    bool mayRun(ServiceMode mode) => mode == ServiceMode.pos
        ? dashboardCanOpenPos(ref, listen: false)
        : signedInUserMayRun(ref, mode, listen: false);
    bool offered(ServiceMode mode) =>
        ref.read(serviceModeOfferedProvider(mode));

    Future<ServiceMode?> target() async {
      // POS reads the user's access rows, which say "no" while they load:
      // wait for them as for the grants. Held while they load, though the
      // build's watch above keeps them too.
      final uid = currentDashboardUserId();
      final rows = [
        for (final feature in posViewFeatures)
          userAccessesProvider(uid, featureName: feature),
      ];
      final held = [for (final p in rows) ref.listenManual(p, (_, _) {})];
      try {
        await Future.wait<void>([
          serviceModeGrantsSettled(ref),
          for (final p in rows)
            ref.read(p.future).then<void>((_) {}, onError: (Object _) {}),
        ]);
        if (!context.mounted) return null;
        return await pickPermittedServiceMode(
          current: activeServiceMode,
          mayRun: mayRun,
          offered: offered,
          isAdmin: posDeskAdmin,
        );
      } finally {
        for (final subscription in held) {
          subscription.close();
        }
      }
    }

    return ServiceModeHotkeyScope(
      child: ServiceModeDesk(
        target: target,
        grantedModeOff: () => context.mounted
            ? grantedServiceModeOff(mayRun: mayRun, offered: offered)
            : null,
        onLeave: () => popBooksModuleIfOpen(navigator),
        child: child,
      ),
    );
  }
}
