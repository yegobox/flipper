import 'dart:async';
import 'dart:developer';

import 'package:flipper_services/ebm_sync_service.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/AppInitializer.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/payment_verification_navigator.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_models/services/internet_connection_service.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/asset_sync_service.dart';
import 'package:flipper_services/receipt_sync_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends FlipperBaseModel with CoreMiscellaneous {
  StartupViewModel() {
    debugPrint('🚀 [StartupViewModel] constructor called');
  }
  final appService = loc.getIt<AppService>();
  bool isBusinessSet = false;
  final _routerService = locator<RouterService>();

  Future<void> listenToAuthChange() async {}

  // Payment verification service instance
  final _paymentVerificationService = PaymentVerificationService();

  // Internet connection service instance
  final _internetConnectionService = InternetConnectionService();

  // Track last user activity to avoid interrupting active users
  DateTime? _lastUserActivity;

  /// How recently the user must have interacted for a *background* payment
  /// verification to hold off on navigating (see `PaymentVerificationNavigator`).
  ///
  /// In debug this is deliberately shorter than the verification interval.
  /// `updateUserActivity()` fires on every tap anywhere in the app, so with the
  /// production 5-minute threshold and the 2-minute debug interval, every
  /// periodic check lands inside the window and the paywall can never appear
  /// while a developer is using the app — 2 < 5, so it is not a timing race but
  /// a structural impossibility. 30s < 2min makes the paywall reachable again.
  ///
  /// Release behaviour is unchanged: mid-sale interruption is still prevented,
  /// and `_criticalRoutes` guards the checkout screens independently.
  static const Duration _userActivityThreshold = kDebugMode
      ? Duration(seconds: 30)
      : Duration(minutes: 5);

  /// How often background payment verification runs.
  ///
  /// Must stay **longer** than [_userActivityThreshold] — see the assert in
  /// [runStartupLogic]. Debug polls often so a lapse is visible while working;
  /// release polls rarely because the realtime plan watch is the real mechanism.
  static const int _verificationIntervalMinutes = kDebugMode ? 2 : 240;
  bool _isInitialStartup = true;
  bool _hasRetriedAfterTimeout = false;
  double _progress = 0.0;
  double get progress => _progress;

  Future<void> runStartupLogic() async {
    // await logOut();
    try {
      debugPrint('🚀 [StartupViewModel] Starting runStartupLogic...');
      _progress = 0.0;
      notifyListeners();
      final startTime = DateTime.now();

      final forceLogout = ProxyService.box.getForceLogout();
      if (forceLogout) {
        talker.warning('Force logout detected - logging out user');
        // Reset the force logout flag to prevent repeated logouts
        await ProxyService.box.setForceLogout(false);
        await logOut();
        _routerService.navigateTo(LoginRoute());
        return;
      }
      talker.warning("StartupViewModel runStartupLogic");
      // ------------------------------------------------------

      // Initialize Ditto early if user is logged in
      // This ensures Ditto is available for LoginChoices screen to fetch businesses
      final userId = ProxyService.box.getUserId();
      if (userId == null) {
        debugPrint(
          '🚀 [StartupViewModel] No user in local storage; showing login',
        );
        _routerService.clearStackAndShow(LoginRoute());
        return;
      }

      // A signed-in device with its business and branch cached opens the
      // home from that cache and checks the plan behind it, instead of
      // waiting on the network first. See [fastStartupFor].
      final fastPath = fastStartupFor(
        hasCachedSession: _hasCachedSession(),
        freshSignup: _freshSignupPending(),
      );
      final trace = Stopwatch()..start();
      final marks = <String>[];
      void mark(String step) =>
          marks.add('$step=${trace.elapsedMilliseconds}ms');

      try {
        debugPrint(
          '🚀 [StartupViewModel] Initializing Ditto early for userId: $userId',
        );
        final earlyInit = userId.startsWith('login-')
            ? appService.initDittoForLogin(userId)
            // The fast path only opens the store; replication (started by
            // appInit) does the cloud auth without holding up the home.
            : appService.initDittoEarlyForSession(
                userId,
                authenticate: !fastPath,
              );
        await earlyInit.timeout(const Duration(seconds: 10));
        debugPrint('🚀 [StartupViewModel] Ditto initialized early');
      } catch (e) {
        debugPrint(
          '⚠️ [StartupViewModel] Failed to initialize Ditto early (will continue): $e',
        );
      }
      mark('ditto');
      _progress = 0.2;
      notifyListeners();

      debugPrint('🚀 [StartupViewModel] Checking requirements...');
      try {
        await _requirementsMeetsWithRetry();
        debugPrint('🚀 [StartupViewModel] Requirements met');
      } catch (e) {
        if (!await _keepsCachedSessionAfter(e)) rethrow;
        talker.warning(
          'Startup requirements could not be verified offline ($e); '
          'continuing with the cached session',
        );
      }
      mark('requirements');
      _progress = 0.4;
      notifyListeners();

      debugPrint('🚀 [StartupViewModel] Initializing app components...');
      AppInitializer.initialize();

      // Local mode: no EBM, and nothing uploads to S3. Pending assets and
      // receipts stay queued and go up after the user opts in to sync.
      if (!LocalMode.isOn) {
        final repository = Repository();
        EbmSyncService(repository);

        AssetSyncService().initialize();
        ReceiptSyncService().initialize();
      }

      ProxyService.strategy.cleanDuplicatePlans();
      debugPrint('🚀 [StartupViewModel] App components initialized');
      _progress = 0.6;
      notifyListeners();

      _paymentVerificationService.setPaymentStatusChangeCallback((response) {
        unawaited(_handlePaymentStatusChange(response));
      });
      // The interval is the floor, not the mechanism. On its own, a device
      // stays locked out for up to four hours after the owner pays on another
      // one — and keeps trading for up to four hours after a subscription
      // lapses. The realtime watch below reacts to the plan row itself, so the
      // timer only has to cover devices that were offline when it changed.
      // The paywall is only reachable if a verification can land OUTSIDE the
      // activity window. `updateUserActivity()` fires on every tap, so if the
      // threshold were >= the interval, every periodic check would be skipped
      // as "user recently active" and a lapsed subscription would trade
      // indefinitely. That inversion shipped once; this stops it silently
      // returning.
      assert(
        _userActivityThreshold <
            const Duration(minutes: _verificationIntervalMinutes),
        'payment verification interval ($_verificationIntervalMinutes min) must exceed '
        'the user-activity threshold ($_userActivityThreshold), or '
        'PaymentVerificationNavigator skips every periodic check and the paywall '
        'can never appear',
      );
      _paymentVerificationService.startPeriodicVerification(
        intervalMinutes: _verificationIntervalMinutes,
      );
      unawaited(_paymentVerificationService.startRealtimeVerification());

      _internetConnectionService.startPeriodicConnectionCheck();

      debugPrint('🚀 [StartupViewModel] Running appService.appInit()...');
      await appService.appInit().timeout(const Duration(seconds: 30));
      debugPrint('🚀 [StartupViewModel] appService.appInit() complete');
      mark('appInit');
      _progress = 0.8;
      notifyListeners();

      if (fastPath) {
        // The startup grace is spent by opening the home, not when the check
        // behind it lands: a `plans` realtime event in between would still
        // count as the initial startup and open a second home over this one.
        // The check behind it decides on its own ([_verifyBehindHome]).
        _isInitialStartup = false;
        await PaymentVerificationNavigator.enterHomeFromCache();
        mark('home');
        _progress = 1.0;
        notifyListeners();
        talker.info('[startup] fast ${marks.join(' ')}');
        unawaited(_verifyBehindHome());
        return;
      }

      debugPrint('🚀 [StartupViewModel] Verifying payment status...');
      await _handleInitialPaymentVerification().timeout(
        const Duration(seconds: 15),
      );
      mark('home');
      talker.info('[startup] blocking ${marks.join(' ')}');
      // Try the watch again now the business is definitely resolved: the call
      // above may have run before `appInit()` had one, and it is a no-op when
      // the channel is already open for this business.
      unawaited(_paymentVerificationService.startRealtimeVerification());
      debugPrint('🚀 [StartupViewModel] Payment verification complete');
      _progress = 1.0;
      notifyListeners();

      debugPrint(
        '🎉 [StartupViewModel] runStartupLogic completed in ${DateTime.now().difference(startTime).inMilliseconds}ms',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ [StartupViewModel] ERROR during runStartupLogic: $e');
      talker.error(e, stackTrace);
      await _handleStartupError(e, stackTrace);
    }
  }

  /// Whether startup may open the home from the cached session before the
  /// plan check. Only a real signed-in session with its business and branch
  /// on this device ([_hasCachedSession]: not QR login's `login-` identity);
  /// everything else (no session, LoginChoices after a fresh signup, which
  /// `appInit` still routes) keeps the blocking path. A fresh signup already
  /// has both ids cached (`CoreSync.signup` writes them before its
  /// `freshSignup` flag), so the flag is checked on its own.
  @visibleForTesting
  static bool fastStartupFor({
    required bool hasCachedSession,
    required bool freshSignup,
  }) => hasCachedSession && !freshSignup;

  /// The startup plan check, after [PaymentVerificationNavigator.enterHomeFromCache]
  /// opened the home. Never re-runs startup: a slow or failed check only
  /// means the periodic and realtime checks decide later.
  Future<void> _verifyBehindHome() async {
    PaymentVerificationResponse response;
    try {
      response = await _paymentVerificationService
          .verifyPaymentStatus()
          .timeout(const Duration(seconds: 30));
    } catch (e, stackTrace) {
      talker.error(e, stackTrace);
      response = PaymentVerificationResponse(
        result: PaymentVerificationResult.error,
        errorMessage: 'Payment verification failed: $e',
        exception: e is Exception ? e : Exception(e),
      );
    }
    try {
      await _handlePaymentStatusChange(
        response,
        alreadyHome: true,
        // Decides like the blocking check it replaces: a lapsed plan reaches
        // the paywall even if the user already tapped into the home or the
        // POS, which would otherwise skip it as "user active" or "critical
        // route" until the next periodic check, hours later.
        decisive: true,
      );
      // The home came from the cached commission-only flag. The blocking
      // path re-asked on every start; ask now, behind it.
      if (response.result == PaymentVerificationResult.active) {
        await PaymentVerificationNavigator.reconcileCommissionOnlyHome();
      }
    } catch (e, stackTrace) {
      talker.error(e, stackTrace);
    }
    unawaited(_paymentVerificationService.startRealtimeVerification());
  }

  /// Handle payment status changes from periodic verification
  Future<void> _handlePaymentStatusChange(
    PaymentVerificationResponse response, {
    bool alreadyHome = false,
    bool decisive = false,
  }) async {
    // The startup grace period is a ONE-SHOT: it exists so the very first
    // check may navigate off StartUpView, and it deliberately bypasses both
    // the pre-auth route guard and the recent-activity guard in
    // PaymentVerificationNavigator. Consume it on the first check whatever the
    // outcome.
    //
    // It used to clear only on `active`. A verification that errors — e.g.
    // "No active business found" right after logout — left the flag set for
    // the rest of the session, so every later *periodic* tick still claimed to
    // be the initial startup, skipped both guards, and pushed a user sitting
    // on the login/signup screen into the authenticated home once per
    // interval.
    final wasInitialStartup = _isInitialStartup;
    _isInitialStartup = false;

    await PaymentVerificationNavigator.handle(
      response,
      userInitiated: decisive,
      isInitialStartup: wasInitialStartup || decisive,
      alreadyHome: alreadyHome,
      lastUserActivity: _lastUserActivity,
      userActivityThreshold: _userActivityThreshold,
    );
  }

  /// Handle initial payment verification during startup
  Future<void> _handleInitialPaymentVerification() async {
    try {
      final response = await _paymentVerificationService.verifyPaymentStatus();
      await _handlePaymentStatusChange(response);
    } catch (e, stackTrace) {
      // If payment verification itself throws an exception, create a response and handle it
      talker.error(e, stackTrace);
      // Routed through _handlePaymentStatusChange so this path consumes the
      // one-shot startup flag too.
      await _handlePaymentStatusChange(
        PaymentVerificationResponse(
          result: PaymentVerificationResult.error,
          errorMessage: 'Payment verification failed: $e',
          exception: Exception(e),
        ),
      );
    }
  }

  /// Call this method whenever user interacts with the app
  void updateUserActivity() {
    _lastUserActivity = DateTime.now();
    _isInitialStartup = false;
  }

  /// Force payment verification with navigation (e.g. sales / support).
  Future<void> forcePaymentVerification() async {
    await PaymentVerificationNavigator.verifyAndNavigate(userInitiated: true);
  }

  /// Ensures the specified user has all required admin access for all features.
  static Future<void> ensureAdminAccessForUser({
    required String userId,
    required String branchId,
    required String businessId,
    required dynamic talker,
  }) async {
    try {
      // Use features from flipper_services/constants.dart
      final List<String> featureNames = features
          .map((f) => f.toString())
          .toList();
      for (String feature in featureNames) {
        talker.warning(
          "Checking permission for userId: $userId, feature: $feature",
        );
        List<Access> hasAccess = await ProxyService.strategy.access(
          userId: userId,
          featureName: feature,
          fetchRemote: true,
        );
        if (hasAccess.isEmpty) {
          await ProxyService.strategy.addAccess(
            branchId: branchId,
            businessId: businessId,
            userId: userId,
            featureName: feature,
            accessLevel: 'admin',
            status: 'active',
            userType: "Admin",
          );
          talker.info("Assigned admin access for $feature to user $userId");
        }
      }
    } catch (e, stack) {
      talker.error(e, stack);
    }
  }

  /// Handles different error scenarios during startup.
  Future<void> _handleStartupError(Object e, StackTrace stackTrace) async {
    if (e is LoginChoicesException) {
      _routerService.navigateTo(LoginChoicesRoute());
    } else if (e is SessionException || e is PinError) {
      log(stackTrace.toString(), name: 'runStartupLogic');
      await logOut();
      _routerService.clearStackAndShow(LoginRoute());
      return;
    } else if (e is BusinessNotFoundException || e == NeedSignUpException) {
      // Every platform onboards the same way: a signed-in user without a
      // business goes to signup and creates one. Windows used to be bounced
      // back to the login screen here, which left desktop with no way in.
      _routerService.navigateTo(SignUpViewRoute(countryNm: "Rwanda"));
      return;
    } else if ((e is SubscriptionError ||
            e is FailedPaymentException ||
            e is NoPaymentPlanFound) &&
        await PaymentVerificationNavigator.entryRefused()) {
      // A local-mode business whose data is on another device: the gate has
      // explained and signed out instead of showing a paywall.
      return;
    } else if (LocalMode.isOn &&
        (e is SubscriptionError ||
            e is FailedPaymentException ||
            e is NoPaymentPlanFound)) {
      // Local mode is free forever — never a paywall.
      await PaymentVerificationNavigator.navigateToAuthenticatedHome();
      return;
    } else if (e is SubscriptionError) {
      _routerService.navigateTo(PaymentPlanUIRoute());
      return;
    } else if (e is FailedPaymentException) {
      _routerService.navigateTo(FailedPaymentRoute());
    } else if (e is NoPaymentPlanFound) {
      _routerService.navigateTo(PaymentPlanUIRoute());
      return;
    } else if (e is TimeoutException) {
      if (!_hasRetriedAfterTimeout) {
        _hasRetriedAfterTimeout = true;
        talker.warning('Startup timed out, retrying once...');
        await runStartupLogic();
        return;
      }
      talker.error('Startup failed after timeout retry', e, stackTrace);
      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      if (businessId != null && branchId != null) {
        talker.warning(
          'Entering app with cached session despite startup timeout',
        );
        await _handleInitialPaymentVerification();
      }
      return;
    } else {
      if (await _keepsCachedSessionAfter(e)) {
        talker.warning(
          'Startup failed offline ($e); entering with the cached session',
        );
        await _handleInitialPaymentVerification();
        return;
      }
      try {
        logOut();
        _routerService.navigateTo(LoginRoute());
      } catch (e) {
        _routerService.navigateTo(LoginRoute());
      }
      // check if there is any view navigated to
      return;
    }
  }

  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  /// Whether startup may carry on with the session already on this device
  /// after [error], instead of logging out.
  ///
  /// The requirement checks look the business and branch up locally, then
  /// online. Ditto never replicates `branches` down, so on a device with no
  /// network the online step finds nothing and the check used to throw —
  /// which fell through to `logOut()` and the login screen, although the user
  /// never signed out. Being offline says nothing about whether the session is
  /// valid, so a device holding one keeps it. Errors that do say the session
  /// is bad still log out, and online behaviour is unchanged.
  @visibleForTesting
  static bool keepsCachedSessionAfter(
    Object error, {
    required bool hasCachedSession,
    required bool online,
  }) {
    if (!hasCachedSession || online) return false;
    return error is! SessionException &&
        error is! PinError &&
        error is! LoginChoicesException;
  }

  /// A signed-in user with a business and branch picked — everything the last
  /// login wrote and the app needs to open without a network. QR login's
  /// temporary `login-` identity is not a session.
  static bool _hasCachedSession() {
    bool present(String? value) => value != null && value.trim().isNotEmpty;
    final box = ProxyService.box;
    final userId = box.getUserId();
    return present(userId) &&
        !userId!.startsWith('login-') &&
        present(box.getBusinessId()) &&
        present(box.getBranchId());
  }

  /// Set by `CoreSync.signup`, cleared by `appInit` once it has routed the
  /// new account to LoginChoices.
  static bool _freshSignupPending() =>
      ProxyService.box.readBool(key: 'freshSignup') ?? false;

  Future<bool> _keepsCachedSessionAfter(Object error) async {
    if (!_hasCachedSession()) return false;
    return keepsCachedSessionAfter(
      error,
      hasCachedSession: true,
      online: await ProxyService.status.isInternetAvailable(),
    );
  }

  Future<void> _requirementsMeetsWithRetry() async {
    try {
      await _allRequirementsMeets().timeout(const Duration(seconds: 15));
    } on TimeoutException {
      talker.warning(
        'Requirements check timed out, retrying once (local only)...',
      );
      await _allRequirementsMeets().timeout(const Duration(seconds: 15));
    }
  }

  Future<void> _allRequirementsMeets() async {
    try {
      if (isTestEnvironment()) {
        return;
      }
      final userId = ProxyService.box.getUserId();
      if (userId == null) {
        throw SessionException(term: 'No user in local storage');
      }
      talker.warning("StartupViewModel _allRequirementsMeets");

      // Check if business ID is set
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        throw Exception("Business ID is not set in local storage");
      }

      // Check if branch ID is set
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        throw LoginChoicesException(term: "Branch ID not set");
      }

      // Local-only: avoid Turso pull / Supabase hydrate during startup checks.
      var business = await ProxyService.strategy.getBusinessById(
        businessId: businessId,
        fetchOnline: false,
      );
      if (business == null) {
        // Local copy missing — try an online fetch as a fallback. This can
        // happen when the app restarts before local syncing/hydration
        // completed (Ditto/Turso). Prefer a quick online fetch rather than
        // failing startup immediately.
        try {
          talker.warning(
            'Business not found locally; attempting online fetch...',
          );
          // Ensure we have a Future so `.timeout` is available even if the
          // underlying implementation returns `FutureOr<Business?>`.
          business = await Future.value(
            ProxyService.strategy.getBusinessById(
              businessId: businessId,
              fetchOnline: true,
            ),
          ).timeout(const Duration(seconds: 10));
          if (business == null) {
            throw BusinessNotFoundException(
              term: 'Business not found locally or online',
            );
          }
        } catch (e, st) {
          talker.error(e, st);
          throw BusinessNotFoundException(
            term: 'Business not found locally or online',
          );
        }
      }
      talker.warning("Business found: ${business.name}");

      // Check branches for the specific business
      List<Branch> branches = await ProxyService.strategy.branches(
        businessId: businessId,
        active: true,
        localOnly: true,
      );
      talker.warning("branches: ${branches.length}");

      // If no branches exist locally, attempt a non-local lookup (Brick/
      // online) as a fallback. This handles fresh devices or cases where
      // Ditto hasn't replicated down branches yet.
      if (branches.isEmpty) {
        try {
          talker.warning('No local branches; attempting non-local fetch...');
          branches = await ProxyService.strategy.branches(
            businessId: businessId,
            active: true,
            localOnly: false,
          );
          talker.warning('branches after non-local fetch: ${branches.length}');
        } catch (e, st) {
          talker.error('Non-local branches fetch failed', st);
        }
      }

      if (branches.isEmpty) {
        throw Exception(
          "requirements failed for having branches saved locally",
        );
      }
    } catch (e, stackTrace) {
      talker.error(e, stackTrace);
      rethrow;
    }
  }

  /// Clean up resources when the view model is disposed
  @override
  void dispose() {
    _internetConnectionService.stopPeriodicConnectionCheck();
    super.dispose();
  }
}
