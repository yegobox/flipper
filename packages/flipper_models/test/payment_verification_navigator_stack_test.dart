import 'package:stacked/stacked.dart' show RootStackRouter, RouteData;
import 'package:flipper_models/account_mode/account_mode_client.dart';
import 'package:flipper_models/account_mode/account_mode_store.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_models/services/payment_verification_navigator.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_routing/app.locator.dart' as routing_locator;
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart' as services_locator;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MockRouterService extends Mock implements RouterService {}

class _MockRootRouter extends Mock implements RootStackRouter {}

class _MockRouteData extends Mock implements RouteData {}

class _MockBox extends Mock implements LocalStorage {}

/// Pins how the paywall opens, now that startup's fast path shows the home
/// before the plan check.
///
/// The regression this guards: behind a home that is already showing, the
/// paywall was pushed on top of it, and neither lockout screen blocks back,
/// so one Android back put a lapsed business in the full POS.
void main() {
  // The navigator caches its RouterService on first use: one for the file.
  final router = _MockRouterService();
  final rootRouter = _MockRootRouter();
  final current = _MockRouteData();
  final box = _MockBox();
  var commissionOnly = false;

  setUpAll(() async {
    registerFallbackValue(FlipperAppRoute());
    await services_locator.getIt.reset();
    await routing_locator.locator.reset();
    services_locator.getIt.registerSingleton<LocalStorage>(box);
    routing_locator.locator.registerSingleton<RouterService>(router);
  });

  tearDownAll(() async {
    PaymentVerificationNavigator.refreshCommissionOnly =
        refreshCommissionOnlySession;
    AccountModeStore.instance = null;
    await services_locator.getIt.reset();
    await routing_locator.locator.reset();
  });

  setUp(() {
    reset(router);
    reset(rootRouter);
    reset(current);
    reset(box);
    when(() => router.router).thenReturn(rootRouter);
    when(() => rootRouter.current).thenReturn(current);
    when(() => current.name).thenReturn(FlipperAppRoute.name);
    when(() => router.navigateTo(any())).thenAnswer((_) async => null);
    when(() => router.clearStackAndShow(any())).thenAnswer((_) async {});
    when(() => box.getUserId()).thenReturn('user-1');
    when(() => box.getBusinessId()).thenReturn(null);
    when(
      () => box.readBool(key: any(named: 'key')),
    ).thenAnswer((_) => commissionOnly);

    commissionOnly = false;
    PaymentVerificationNavigator.refreshCommissionOnly = () async =>
        commissionOnly;
    // No business selected: never personal, and no network.
    AccountModeStore.instance = AccountModeStore(
      box: () => box,
      readDittoDoc: (_) async => null,
      client: AccountModeClient(
        baseUrl: () async => 'https://connector.test',
        httpClient: MockClient((_) async => http.Response('{}', 500)),
      ),
    );
  });

  Future<void> handle(
    PaymentVerificationResult result, {
    Exception? exception,
    bool alreadyHome = false,
  }) => PaymentVerificationNavigator.handle(
    PaymentVerificationResponse(result: result, exception: exception),
    // What each startup path passes (see StartupViewModel).
    userInitiated: alreadyHome,
    isInitialStartup: true,
    alreadyHome: alreadyHome,
  );

  group('behind a home that is already showing', () {
    test('no plan replaces the stack with the plan screen', () async {
      await handle(PaymentVerificationResult.noPlan, alreadyHome: true);
      verify(
        () => router.clearStackAndShow(any(that: isA<PaymentPlanUIRoute>())),
      ).called(1);
      verifyNever(() => router.navigateTo(any()));
    });

    test('a lapsed plan replaces the stack with the failed screen', () async {
      await handle(
        PaymentVerificationResult.planExistsButInactive,
        alreadyHome: true,
      );
      verify(
        () => router.clearStackAndShow(any(that: isA<FailedPaymentRoute>())),
      ).called(1);
      verifyNever(() => router.navigateTo(any()));
    });

    test('a payment error replaces the stack too', () async {
      await handle(
        PaymentVerificationResult.error,
        exception: PaymentIncompleteException('unpaid'),
        alreadyHome: true,
      );
      verify(
        () => router.clearStackAndShow(any(that: isA<FailedPaymentRoute>())),
      ).called(1);
      verifyNever(() => router.navigateTo(any()));
    });

    test('never opens a paywall once the user signed out', () async {
      // Logout cleared the session while the check behind the home ran.
      when(() => box.getUserId()).thenReturn(null);
      await handle(PaymentVerificationResult.noPlan, alreadyHome: true);
      await handle(
        PaymentVerificationResult.planExistsButInactive,
        alreadyHome: true,
      );
      verifyNever(() => router.clearStackAndShow(any()));
      verifyNever(() => router.navigateTo(any()));
    });

    test('a commission-only session replaces it with commissions', () async {
      commissionOnly = true;
      await handle(PaymentVerificationResult.noPlan, alreadyHome: true);
      verify(
        () => router.clearStackAndShow(
          any(that: isA<AgentCommissionScreenRoute>()),
        ),
      ).called(1);
      verifyNever(() => router.navigateTo(any()));
    });
  });

  test('the blocking startup still pushes the paywall, as before', () async {
    await handle(PaymentVerificationResult.noPlan);
    verify(
      () => router.navigateTo(any(that: isA<PaymentPlanUIRoute>())),
    ).called(1);
    verifyNever(() => router.clearStackAndShow(any()));
  });

  group('reconcileCommissionOnlyHome', () {
    test('a session that became commission-only swaps the home', () async {
      // Cached flag (what the home was opened from) says no...
      when(() => box.readBool(key: any(named: 'key'))).thenReturn(false);
      // ...the server now says yes.
      PaymentVerificationNavigator.refreshCommissionOnly = () async => true;
      await PaymentVerificationNavigator.reconcileCommissionOnlyHome();
      verify(
        () => router.clearStackAndShow(
          any(that: isA<AgentCommissionScreenRoute>()),
        ),
      ).called(1);
    });

    test('an unchanged answer leaves the home alone', () async {
      commissionOnly = true;
      await PaymentVerificationNavigator.reconcileCommissionOnlyHome();
      verifyNever(() => router.clearStackAndShow(any()));
      verifyNever(() => router.navigateTo(any()));
    });

    test('never opens commissions for a signed-out device', () async {
      when(() => box.readBool(key: any(named: 'key'))).thenReturn(false);
      when(() => box.getUserId()).thenReturn(null);
      PaymentVerificationNavigator.refreshCommissionOnly = () async => true;
      await PaymentVerificationNavigator.reconcileCommissionOnlyHome();
      verifyNever(() => router.clearStackAndShow(any()));
    });
  });
}
