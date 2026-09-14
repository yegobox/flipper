import 'dart:async';
import 'dart:io';
import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:logging/logging.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_rw/state_observer.dart';
import 'package:flipper_models/amplify_config_helper.dart';
import 'package:flipper_models/providers/provider_perf_observer.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/dashboard_quick_apps_navigation.dart';
import 'package:flipper_dashboard/providers/locale_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flipper_ai_feature/flipper_ai_feature.dart' show initLocalAi;
import 'package:flipper_dashboard/features/delegations/delegation_notification_listener.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goal_remote_contribution_listener.dart';
import 'package:flipper_models/services/personal_goal_notification_service.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_services/app_shortcuts_platform.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/payments_host.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/analytics/repository_analytics_event_store.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview_plus/device_preview_plus.dart';
import 'firebase_options.dart';
import 'package:flipper_models/power_sync/supabase.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
// Flag to control dependency initialization in tests
// import 'package:flipper_web/core/utils/initialization.dart';
//
import 'package:supabase_models/sync/ditto_sync_registry.dart';

import 'package:ditto_live/ditto_live.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

// Function to initialize Firebase
Future<void> _initializeFirebase() async {
  try {
    final platform = Ditto.currentPlatform;

    if (platform case SupportedPlatform.android || SupportedPlatform.ios) {
      debugPrint('📱 [Firebase] Requesting permissions (non-blocking)...');
      // Fire and forget permission requests so they don't block the startup sequence
      unawaited([
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.nearbyWifiDevices,
        Permission.notification,
      ].request().timeout(const Duration(seconds: 15), onTimeout: () {
        debugPrint('⚠️ [Firebase] Background permission request timed out');
        return {};
      }));
    }
    // Don't use microtask for Firebase as critical services depend on it
    debugPrint('📱 [Firebase] Calling Firebase.initializeApp...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 20), onTimeout: () {
      debugPrint('⚠️ [Firebase] Firebase.initializeApp timed out');
      throw TimeoutException('Firebase.initializeApp timed out');
    });
    // talker.info('Firebase initialized successfully');
  } catch (e, stackTrace) {
    GlobalErrorHandler.report(e, stackTrace, type: 'firebase_init_error');
  }
}

// Function to initialize Supabase.
Future<void> _initializeSupabase() async {
  try {
    await loadSupabase();

    // await initializeDitto(); // Initialization moved to AppService
  } catch (e, stackTrace) {
    GlobalErrorHandler.report(e, stackTrace, type: 'supabase_init_error');
    rethrow;
  }
}

// Function to initialize Print Delegation (Real-time Ditto-based)

/// Writes a startup failure to `init_error.log` in the app-support directory.
/// In MSIX this lands under the package's virtualized LocalCache, which is
/// writable inside the sandbox — unlike stdout, which has no console attached.
Future<void> _dumpInitErrorToFile(String errorText) async {
  try {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/init_error.log');
    await file.writeAsString(
      '=== init failure ===\n$errorText\n',
      flush: true,
    );
    debugPrint('📝 [main] Wrote init error to ${file.path}');
  } catch (e) {
    debugPrint('Failed to write init error log: $e');
  }
}

/// Renders a startup failure for the failure screen, the clipboard and
/// `init_error.log` from one place, so what a user photographs is exactly what
/// support reads back.
String _formatInitError(Object error, StackTrace stackTrace) {
  if (error is AppInitException) {
    return '[${error.stepLabel}] ${error.stepId}\n'
        '${error.cause}\n\n${error.stackTrace}';
  }
  return '$error\n\n$stackTrace';
}

bool skipDependencyInitialization = false;

String _analyticsPlatformName() {
  if (kIsWeb) return 'web';
  if (UniversalPlatform.isAndroid) return 'android';
  if (UniversalPlatform.isIOS) return 'ios';
  if (UniversalPlatform.isMacOS) return 'macos';
  if (UniversalPlatform.isWindows) return 'windows';
  if (UniversalPlatform.isLinux) return 'linux';
  return 'unknown';
}

/// One unit of application startup.
///
/// Startup used to be a single straight-line `await` chain under one 60s
/// budget: any step that threw — or the whole chain overrunning — killed the
/// app into a dead-end "Initialization Failed" screen with no way back except
/// force-quitting. Most of those steps are not needed to open a till.
///
/// Each step now carries its own budget and says whether the app can run
/// without it. Only an [isCritical] step can stop startup; everything else is
/// reported and skipped, so a flaky network or a wedged optional SDK degrades
/// a feature instead of bricking the app.
class _InitStep {
  const _InitStep({
    required this.id,
    required this.label,
    required this.run,
    this.isCritical = false,
    this.budget = const Duration(seconds: 20),
  });

  /// Stable identifier used in telemetry and on the failure screen.
  final String id;

  /// Human-readable name shown while the step runs.
  final String label;

  /// Whether a failure here must stop startup.
  final bool isCritical;

  /// Hard ceiling for this step. A hang costs this much, not the whole app.
  final Duration budget;

  final Future<void> Function() run;
}

/// Thrown when a critical startup step fails, carrying the step that broke so
/// the failure screen can name it instead of showing an anonymous error.
class AppInitException implements Exception {
  AppInitException({
    required this.stepId,
    required this.stepLabel,
    required this.cause,
    required this.stackTrace,
  });

  final String stepId;
  final String stepLabel;
  final Object cause;
  final StackTrace stackTrace;

  @override
  String toString() => 'Startup failed at "$stepLabel" [$stepId]: $cause';
}

/// Steps that will not be run again by a retry pass.
///
/// A critical step lands here only on success, so retrying resumes exactly at
/// the step that broke. An optional step lands here whether it succeeded or
/// failed — retrying startup because the database was locked should not spend
/// another 20s waiting on the SDK that already timed out.
final Set<String> _finishedInitSteps = <String>{};

/// Drives the label under the startup spinner so a slow boot shows progress
/// rather than an indefinite blank wait.
final ValueNotifier<String> initProgressLabel = ValueNotifier<String>('');

void _reportInitFailure(
  _InitStep step,
  Object error,
  StackTrace stackTrace,
) {
  try {
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: Hint.withMap({
        'context': 'App initialization step failed',
        'step': step.id,
        'critical': step.isCritical.toString(),
        'error_type': error.runtimeType.toString(),
      }),
    );
  } catch (e) {
    debugPrint('Failed to report init step failure to Sentry: $e');
  }

  // `Crash` is only registered once the dependency graph step has run, and a
  // step before it can fail first.
  try {
    if (getIt.isRegistered<Crash>()) {
      GlobalErrorHandler.logError(
        error,
        stackTrace: stackTrace,
        type: 'initialization_error',
        context: {
          'step': step.id,
          'critical': step.isCritical,
          'error_type': error.runtimeType.toString(),
        },
      );
    }
  } catch (e) {
    debugPrint('Failed to report init step failure to Crashlytics: $e');
  }
}

Future<void> _runInitStep(_InitStep step) async {
  if (_finishedInitSteps.contains(step.id)) {
    debugPrint('⏭️  [init] ${step.id} already done, skipping');
    return;
  }

  initProgressLabel.value = step.label;
  final watch = Stopwatch()..start();
  try {
    await step.run().timeout(
      step.budget,
      onTimeout: () => throw TimeoutException(
        '${step.label} timed out after ${step.budget.inSeconds}s',
        step.budget,
      ),
    );
    _finishedInitSteps.add(step.id);
    debugPrint('✅ [init] ${step.id} in ${watch.elapsedMilliseconds}ms');
  } catch (error, stackTrace) {
    debugPrint(
        '❌ [init] ${step.id} failed after ${watch.elapsedMilliseconds}ms: $error');
    _reportInitFailure(step, error, stackTrace);

    if (step.isCritical) {
      throw AppInitException(
        stepId: step.id,
        stepLabel: step.label,
        cause: error,
        stackTrace: stackTrace,
      );
    }

    // Optional: the app runs without it. Don't pay for it again on a retry.
    _finishedInitSteps.add(step.id);
    debugPrint('⚠️  [init] continuing without ${step.id}');
  }
}

/// Analytics must never be able to stop a till from opening, so it is a step
/// like any other rather than an unguarded `await` in the middle of startup.
Future<void> _initializeAnalytics() async {
  await FlipperAnalytics.initialize(
    appName: 'flipper',
    platformName: _analyticsPlatformName(),
    projectToken: AppSecrets.postHogProjectToken,
    store: RepositoryAnalyticsEventStore(),
    contextProvider: CallbackAnalyticsContextProvider(
      appName: 'flipper',
      platformName: _analyticsPlatformName(),
      buildMode: kDebugMode ? 'debug' : 'release',
      userIdGetter: () => ProxyService.box.getUserId()?.toString(),
      businessIdGetter: () => ProxyService.box.getBusinessId(),
      branchIdGetter: () => ProxyService.box.getBranchId(),
    ),
  );
}

List<_InitStep> _buildInitSteps() => <_InitStep>[
      // Firebase already swallows its own errors; the budget only bounds a hang.
      const _InitStep(
        id: 'firebase',
        label: 'Connecting services',
        budget: Duration(seconds: 25),
        run: _initializeFirebase,
      ),
      // Nothing can resolve a service without this.
      _InitStep(
        id: 'locator',
        label: 'Preparing app',
        isCritical: true,
        budget: const Duration(seconds: 15),
        run: () async {
          loc.setupLocator(stackedRouter: stackedRouter);
          setupDialogUi();
          setupBottomSheetUi();
        },
      ),
      const _InitStep(
        id: 'platform',
        label: 'Setting up device',
        budget: Duration(seconds: 30),
        run: initializeDependencies,
      ),
      _InitStep(
        id: 'error-handler',
        label: 'Setting up diagnostics',
        budget: const Duration(seconds: 5),
        run: () async => GlobalErrorHandler.initialize(),
      ),
      // The local Brick/SQLite store. Without it there is nothing to read or
      // sell from, so this one genuinely blocks startup — but a locked or busy
      // database is transient, which is what the automatic retry is for.
      const _InitStep(
        id: 'database',
        label: 'Opening local database',
        isCritical: true,
        budget: Duration(seconds: 45),
        run: _initializeSupabase,
      ),
      // ProxyService.box and every sync strategy come from here.
      _InitStep(
        id: 'dependencies',
        label: 'Loading services',
        isCritical: true,
        budget: const Duration(seconds: 30),
        run: () async {
          await initDependencies();
          // Hands flipper_payments this app's HTTP client, connector URL
          // resolver and talker. Needs ProxyService.http, so it must run
          // after the locator above is populated — calling it earlier (from
          // the 'platform' step) threw and silently skipped the rest of that
          // step on every platform.
          registerFlipperPaymentsHost();
        },
      ),
      const _InitStep(
        id: 'analytics',
        label: 'Starting analytics',
        budget: Duration(seconds: 12),
        run: _initializeAnalytics,
      ),
      // Cognito/S3. Product images and remote auth degrade without it; the POS
      // does not. AmplifyConfigHelper keeps retrying in the background.
      _InitStep(
        id: 'amplify',
        label: 'Connecting cloud storage',
        budget: const Duration(seconds: 20),
        run: () => AmplifyConfigHelper.configureAmplify(),
      ),
      const _InitStep(
        id: 'ditto-registry',
        label: 'Preparing sync',
        budget: Duration(seconds: 20),
        run: DittoSyncRegistry.registerDefaults,
      ),
      _InitStep(
        id: 'background',
        label: 'Finishing up',
        budget: const Duration(seconds: 5),
        run: () async {
          unawaited(PersonalGoalNotificationService.instance.initialize());
          // Register the on-device AI engine (no-op on Android/web → cloud only).
          initLocalAi();
        },
      ),
    ];

/// Runs every startup step in order, resuming from wherever a previous attempt
/// stopped. Throws [AppInitException] only when a critical step fails.
Future<void> initializeApp() async {
  if (skipDependencyInitialization) return;

  debugPrint('🚀 [init] starting (${_finishedInitSteps.length} steps done)');
  for (final step in _buildInitSteps()) {
    await _runInitStep(step);
  }
  initProgressLabel.value = '';
  debugPrint('🎉 [init] completed');
}

// net info: billers
//1.1.14
Future<void> main() async {
  // Initialize GlobalErrorHandler first to capture early errors

  // Initialize WidgetsBinding
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Configure logging
  Logger.root.level = Level.OFF;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const AppBootstrap());
}

/// Owns the startup attempt so it can be run again in place.
///
/// A failed start is recoverable here: the user taps "Try again" and the
/// pipeline resumes at the step that broke, without force-quitting the app.
/// One retry happens automatically and silently first, because the common
/// critical failures — a busy SQLite file, a half-open database — clear on a
/// second attempt a second later.
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late Future<void> _initialization;
  bool _autoRetryUsed = false;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeWithAutoRetry();
  }

  Future<void> _initializeWithAutoRetry() async {
    try {
      try {
        await initializeApp();
      } on AppInitException catch (e) {
        if (_autoRetryUsed) rethrow;
        _autoRetryUsed = true;
        debugPrint('🔁 [init] auto-retrying after failure at ${e.stepId}');
        await Future<void>.delayed(const Duration(milliseconds: 1200));
        await initializeApp();
      }
    } catch (error, stackTrace) {
      // Persist the full error so packaged builds with no attached console
      // (MSIX, a release APK in a shop) can still surface the cause.
      await _dumpInitErrorToFile(_formatInitError(error, stackTrace));
      rethrow;
    }
  }

  void _retry() {
    setState(() {
      _initialization = _initializeWithAutoRetry();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _StartupProgress();
        }

        if (snapshot.hasError) {
          FlutterNativeSplash.remove();
          final error = snapshot.error!;
          final stackTrace = snapshot.stackTrace ?? StackTrace.current;
          debugPrint('❌ App initialization error: $error');
          debugPrint('Stack trace: $stackTrace');

          final stepLabel =
              error is AppInitException ? error.stepLabel : 'Startup';

          return _StartupFailure(
            stepLabel: stepLabel,
            details: _formatInitError(error, stackTrace),
            onRetry: _retry,
          );
        }

        FlutterNativeSplash.remove();
        debugPrint('🎬 [main] Splash removed, returning FlipperApp');
        return const FlipperApp();
      },
    );
  }
}

/// Loading screen that names the step in flight, so a slow start reads as
/// progress instead of a frozen app.
class _StartupProgress extends StatelessWidget {
  const _StartupProgress();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: initProgressLabel,
                builder: (context, label, _) => Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Recoverable failure screen: names the failing step, offers a retry that
/// resumes the pipeline, and lets the user copy the full error for support.
class _StartupFailure extends StatelessWidget {
  const _StartupFailure({
    required this.stepLabel,
    required this.details,
    required this.onRetry,
  });

  final String stepLabel;
  final String details;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Initialization Failed',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The app could not finish starting at "$stepLabel". '
                    'Tap Try again — it will resume from that step.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: '[$stepLabel]\n$details'),
                      );
                    },
                    icon: const Icon(Icons.copy_all, size: 18),
                    label: const Text('Copy error details'),
                  ),
                  const SizedBox(height: 16),
                  // Shown in every build: without it a field failure is a
                  // photograph of a screen that says nothing actionable.
                  Theme(
                    data: ThemeData(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: const Text(
                        'Technical details',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      childrenPadding: EdgeInsets.zero,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 260),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              details,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Keep in sync with [DevicePreview.enabled] on [FlipperApp].
///
/// Enabled in debug on all platforms, including desktop.
///
/// This is only safe because `device_preview_plus` is forked in
/// `third_party/device_preview_plus` to host the app under a [Builder] instead
/// of a [LayoutBuilder]. Upstream, that [LayoutBuilder] owns a [BuildScope] for
/// the whole app, so every rebuild ran during `performLayout` and mounting or
/// re-activating any [OverlayPortal] (a [Tooltip], a typeahead, a route push
/// re-parenting stacked's GlobalKey'd `Navigator`) threw — then asserted every
/// frame thereafter, because Flutter's guard flags latch. See that package's
/// PATCHES.md.
///
/// [_DevicePreviewOverlaySafeHost] is still worth keeping: it defers the first
/// [MaterialApp] mount out of DevicePreview's own first layout pass.
///
/// Debug builds only, and even then opt-out-able with
/// `--dart-define=FLIPPER_DEVICE_PREVIEW=false` — the README screenshot job
/// runs a debug build and must capture the bare app, not the preview frame.
bool get kFlipperDevicePreviewEnabled =>
    kDebugMode &&
    const bool.fromEnvironment('FLIPPER_DEVICE_PREVIEW', defaultValue: true);

class FlipperApp extends StatefulWidget {
  const FlipperApp({super.key});

  @override
  State<FlipperApp> createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  late final ThemeData _theme;

  /// Must be created once per app lifetime. Calling [stackedRouter.delegate] on every
  /// [build] recreates the navigator delegate and can attach [RenderObject]s while an
  /// ancestor [LayoutBuilder] is still in [performLayout], triggering Flutter's
  /// "mutated in performLayout" assertion (often surfaced via DevicePreview).
  late final RouterDelegate<Object> _routerDelegate;
  late final RouteInformationParser<Object> _routeInformationParser;

  @override
  void initState() {
    debugPrint('🎬 [FlipperApp] initState called');
    super.initState();
    _theme = _buildTheme();
    _routerDelegate = stackedRouter.delegate() as RouterDelegate<Object>;
    _routeInformationParser =
        stackedRouter.defaultRouteParser() as RouteInformationParser<Object>;
    // Remove splash screen after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          '🎬 [FlipperApp] First frame rendered, removing splash screen...');
      FlutterNativeSplash.remove();
    });
  }

  ThemeData _buildTheme() {
    // Bundled `.ttf` files live under `google_fonts/` (see pubspec assets).
    return FlipperTheme.light(allowRuntimeFontFetching: false);
  }

  Widget _buildMaterialApp(BuildContext context, Locale? devicePreviewLocale) {
    // [Consumer] keeps the locale reactive even though the enclosing
    // [_DevicePreviewOverlaySafeHost] caches this widget across frames — only
    // the MaterialApp subtree rebuilds when the admin switches language.
    return Consumer(
      builder: (context, ref, _) {
        final chosenLocale = ref.watch(appLocaleProvider);
        return MaterialApp.router(
          key: const ValueKey('flipper_material_app'),
          debugShowCheckedModeBanner: false,
          title: 'flipper',
          theme: _theme,
          localizationsDelegates: const [
            // Includes fallbacks for locales flutter_localizations has no
            // bundle for (Kinyarwanda), so MaterialLocalizations is never null.
            ...FlipperLocalizationDelegates.delegates,
            FlipperCountryLocalizationsDelegate(),
          ],
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          // The language picked in Admin Control wins; with no explicit choice
          // fall through to DevicePreview (debug) and then the device language.
          // DevicePreview's locale must be captured during [build], not inside a
          // post-frame setState (DevicePreview.locale uses Provider.of listen:true).
          locale: chosenLocale ??
              devicePreviewLocale ??
              Locale(resolveDeviceLanguageCode()),
          themeMode: ThemeMode.system,
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeInformationParser,
          builder: (context, child) {
            final app = DevicePreview.appBuilder(context, child);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: app,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎬 [FlipperApp] build start');

    return ProviderScope(
      observers: [StateObserver()],
      overrides: kDebugMode
          ? [
              providerPerfTracingEnabledProvider.overrideWith((ref) => true),
            ]
          : const [],
      // OverlaySupport must stay outside DevicePreview (layout-safe toasts).
      child: OverlaySupport.global(
        child: PersonalGoalRemoteContributionListener(
          child: DelegationNotificationListener(
            child: LauncherShortcutRouterHost(
              child: DevicePreview(
                enabled: kFlipperDevicePreviewEnabled,
                tools: const [
                  ...DevicePreview.defaultTools,
                ],
                builder: (context) => _DevicePreviewOverlaySafeHost(
                  locale: DevicePreview.locale(context),
                  builder: _buildMaterialApp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mounts [builder] after the current frame so DevicePreview's [LayoutBuilder]
/// never inserts OverlayPortal/Tooltip subtrees during [performLayout].
class _DevicePreviewOverlaySafeHost extends StatefulWidget {
  const _DevicePreviewOverlaySafeHost({
    required this.builder,
    required this.locale,
  });

  final Widget Function(BuildContext context, Locale? locale) builder;
  final Locale? locale;

  @override
  State<_DevicePreviewOverlaySafeHost> createState() =>
      _DevicePreviewOverlaySafeHostState();
}

class _DevicePreviewOverlaySafeHostState
    extends State<_DevicePreviewOverlaySafeHost> {
  Widget? _app;
  Locale? _mountedLocale;
  bool _frameScheduled = false;

  void _scheduleAppMount() {
    if (_frameScheduled) return;
    _frameScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _frameScheduled = false;
      if (!mounted) return;
      if (_app != null && _mountedLocale == widget.locale) return;
      // Use [widget.locale] captured during build — do not call
      // DevicePreview.locale here (Provider listen outside build asserts).
      setState(() {
        _mountedLocale = widget.locale;
        _app = widget.builder(context, widget.locale);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_app == null || _mountedLocale != widget.locale) {
      _scheduleAppMount();
    }
    // During DevicePreview LayoutBuilder layout, return the already-mounted app
    // (or an empty placeholder) — never construct a new MaterialApp here.
    return _app ?? const ColoredBox(color: Colors.white);
  }
}

class FlipperCountryLocalizationsDelegate
    extends LocalizationsDelegate<CountryLocalizations> {
  const FlipperCountryLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return FlipperLocalizationDelegates.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<CountryLocalizations> load(Locale locale) async {
    // country_code_picker has no `rw`/`sw` bundle, so keep Flipper's locale
    // active while falling country names back to English.
    final effectiveLocale =
        locale.languageCode == 'fr' ? const Locale('fr') : const Locale('en');
    final localizations = CountryLocalizations(effectiveLocale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(FlipperCountryLocalizationsDelegate old) => false;
}

/// Registers Android launcher shortcut callbacks after init ([MaterialApp.router] is mounted).
///
/// Warm shortcuts persist [kPendingLauncherShortcutPageKey] until the dashboard applies them;
/// when already on [FlipperAppRoute], navigates immediately.
class LauncherShortcutRouterHost extends StatefulWidget {
  const LauncherShortcutRouterHost({required this.child, super.key});

  final Widget child;

  @override
  State<LauncherShortcutRouterHost> createState() =>
      _LauncherShortcutRouterHostState();
}

class _LauncherShortcutRouterHostState
    extends State<LauncherShortcutRouterHost> {
  @override
  void initState() {
    super.initState();
    AppShortcutsPlatform.setShortcutLaunchListener((page) {
      unawaited(_handleWarmLauncherShortcut(page));
    });
  }

  @override
  void dispose() {
    AppShortcutsPlatform.setShortcutLaunchListener(null);
    super.dispose();
  }

  Future<void> _handleWarmLauncherShortcut(String page) async {
    if (!mounted || page.isEmpty) return;
    await ProxyService.box.writeString(
      key: kPendingLauncherShortcutPageKey,
      value: page,
    );
    if (!mounted) return;

    final ctx = StackedService.navigatorKey?.currentContext;
    if (ctx == null || !ctx.mounted) return;
    if (!_isFlipperBusinessShellRoute()) return;

    // POS/checkout layout is chosen inside [CheckOut] via [LayoutBuilder]; avoid
    // routing with isBigScreen: true on phones — that hits the desktop pending-
    // cart stream error UI when branchId is not ready yet.
    try {
      await navigateToDashboardAppPage(
        context: ctx,
        isBigScreen: false,
        page: page,
      );
      if (!mounted) return;
      ProxyService.box.remove(key: kPendingLauncherShortcutPageKey);
    } catch (_) {
      // Keep persisted key for dashboard shell to retry.
    }
  }

  bool _isFlipperBusinessShellRoute() {
    try {
      final name = loc.locator<RouterService>().router.current.name;
      return name == FlipperAppRoute.name;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
