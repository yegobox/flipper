import 'package:flipper_models/services/payment_verification_navigator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins the rule that a healthy payment check must not move a working user.
///
/// The regression this guards: `_handleActiveSubscription` used to navigate to
/// the authenticated home on *every* successful verification, so each periodic
/// tick and each `plans` realtime event popped whatever page the user was on —
/// Reports, Settings, Inventory — even though nothing was owed.
void main() {
  group('PaymentVerificationNavigator.mayEnterHomeFor', () {
    bool may(
      String route, {
      bool userInitiated = false,
      bool isInitialStartup = false,
    }) => PaymentVerificationNavigator.mayEnterHomeFor(
      currentRoute: route,
      userInitiated: userInitiated,
      isInitialStartup: isInitialStartup,
    );

    test('background check does not move a user who is working', () {
      for (final route in const [
        FlipperAppRoute.name,
        'Reports',
        'Settings',
        'Inventory',
        'Books',
        'Customers',
        BarModeHostRoute.name,
        HotelModeHostRoute.name,
      ]) {
        expect(may(route), isFalse, reason: '$route must not be popped');
      }
    });

    test('a lifted paywall lets the device back in', () {
      // The point of the background check: the owner pays on another device,
      // this one is sitting on the lockout screen and has to be released.
      expect(may(PaymentPlanUIRoute.name), isTrue);
      expect(may(FailedPaymentRoute.name), isTrue);
    });

    test('initial startup may leave the splash screen', () {
      expect(may('StartUpView', isInitialStartup: true), isTrue);
    });

    test('a user-initiated check may navigate from anywhere', () {
      expect(may('Reports', userInitiated: true), isTrue);
    });

    test('a failed background check does not lift the paywall', () {
      // Regression: the card checkout writes `plans` before calling the
      // connector; the verification that write triggered errored (dev turbo
      // unreachable) and "proceed despite the error" let an unpaid user into
      // the dashboard until the next check bounced them back.
      bool failOpen({
        bool userInitiated = false,
        bool isInitialStartup = false,
      }) => PaymentVerificationNavigator.mayFailOpenFor(
        userInitiated: userInitiated,
        isInitialStartup: isInitialStartup,
      );

      expect(failOpen(), isFalse);
      // Startup still fails open so an offline shop can trade…
      expect(failOpen(isInitialStartup: true), isTrue);
      // …and a check the user asked for may still navigate.
      expect(failOpen(userInitiated: true), isTrue);
    });

    test('paywall route set covers both lockout screens', () {
      expect(
        PaymentVerificationNavigator.paywallRoutes,
        containsAll(<String>[PaymentPlanUIRoute.name, FailedPaymentRoute.name]),
      );
    });
  });
}
