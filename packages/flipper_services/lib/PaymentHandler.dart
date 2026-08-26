import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/dodo/dodo_client.dart';
import 'package:flipper_services/dodo/dodo_models.dart';
import 'package:flipper_services/dodo/dodo_subscription.dart';
import 'package:flipper_services/momo/momo_client.dart';
import 'package:flipper_services/momo/momo_models.dart';
import 'package:flipper_services/momo/momo_subscription.dart';
import 'package:flipper_services/payment_rail.dart';
import 'package:flipper_services/supabase_realtime_utils.dart';
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

/// Raised when the payer did not consent, so nothing was charged.
///
/// Distinct from a payment that failed: no money was moved and none will be.
/// The user has to approve the Mobile Money request on their handset and try
/// again.
class MomoPreapprovalDeclined implements Exception {
  MomoPreapprovalDeclined(this.message, {this.mandate});

  final String message;
  final MomoMandate? mandate;

  @override
  String toString() => message;
}

/// Raised when the card rail could not get the customer as far as a payment
/// page, so **nothing was charged and nothing will be**.
///
/// Kept apart from a payment that failed for the same reason
/// [MomoPreapprovalDeclined] is: the customer has not lost any money, and the
/// useful next step is usually a different device, the raw link, or Mobile
/// Money — not a retry that will fail identically.
class CardCheckoutUnavailable implements Exception {
  CardCheckoutUnavailable(this.message, {this.checkout});

  final String message;

  /// The link we had but could not open, when there was one. Worth offering:
  /// a customer can finish the payment on another device.
  final DodoCheckout? checkout;

  @override
  String toString() => message;
}

mixin PaymentHandler {
  /// Establishes Mobile Money consent, then charges the subscription. Returns
  /// the payment reference when a charge went out, for use in polling.
  ///
  /// Throws [MomoPreapprovalDeclined] when the payer refused the mandate — the
  /// one case where we deliberately walk away rather than reaching for their
  /// money a second way.
  Future<String?> handleMomoPayment(
    int finalPrice, {
    required Plan plan,
    /// Called as the mandate moves, so a screen can say "approve the request on
    /// your phone" instead of showing a silent spinner.
    void Function(MomoMandate mandate)? onMandate,
  }) async {
    /// Pre-approval validity time in seconds. Must exceed plan duration to give
    /// billing software enough time to charge the user before expiry.
    /// Debug mode uses 120s for quick testing.
    const int secondsPerDay = 86400;
    const int monthlyPlanDays = 30;
    const int yearlyPlanDays = 365;
    const int billingBufferDays = 15; // Buffer for billing to run before expiry

    int timeInSeconds;
    if (kDebugMode) {
      timeInSeconds = 120;
    } else {
      switch (plan.selectedPlan) {
        case "monthly":
          timeInSeconds = (monthlyPlanDays + billingBufferDays) * secondsPerDay;
          break;
        case "yearly":
          timeInSeconds = (yearlyPlanDays + billingBufferDays) * secondsPerDay;
          break;
        default:
          // Unknown plan: default to yearly + buffer to avoid premature expiry
          timeInSeconds = (yearlyPlanDays + billingBufferDays) * secondsPerDay;
      }
    }
    // Use phone from plan only (no local storage)
    final phone = plan.phoneNumber
        ?.replaceAll("+", "")
        .replaceAll(" ", "")
        .trim();
    if (phone == null || phone.isEmpty) {
      throw Exception(
        'Phone number is required for MTN Mobile Money payment. '
        'Please enter your MTN number in the payment screen.',
      );
    }

    // Save plan with discounted price BEFORE subscribe so the backend preApprove
    // uses the correct amount when it fetches the plan from the database.
    ProxyService.strategy.saveOrUpdatePaymentPlan(
      additionalDevices: plan.additionalDevices!,
      businessId: (await ProxyService.strategy.activeBusiness())!.id,
      flipperHttpClient: ProxyService.http,
      isYearlyPlan: plan.isYearlyPlan!,
      paymentMethod: "MTNMOMO",
      plan: plan,
      selectedPlan: plan.selectedPlan!,
      totalPrice: finalPrice.toDouble(),
    );
    /// Consent first, money second.
    ///
    /// [MomoSubscriptionCharger] requests (or reuses) the mandate, waits for
    /// the payer's PIN on it, and only then submits the debit. A payer who
    /// refuses the mandate is never charged — flipper-turbo read nothing but
    /// the HTTP status of `preApprove` and charged regardless, which is how a
    /// lapsed or under-authorised mandate turned into a debit that failed with
    /// no visible reason.
    // Charge the plan we were handed, never "the business's newest plan": the
    // server-side fallback is how the wrong plan used to get marked paid
    // (`PAYMENT_COMPLETED_WITHOUT_MONEY_ANALYSIS.md`).
    final planId = plan.id;
    if (planId == null || planId.isEmpty) {
      throw Exception(
        'This subscription has no plan id yet, so it cannot be charged safely. '
        'Reopen the plan screen and try again.',
      );
    }

    final charger = MomoSubscriptionCharger(MomoClient(ProxyService.http));
    final result = await charger.charge(
      phoneNumber: phone,
      amount: finalPrice,
      planId: planId,
      businessId: (await ProxyService.strategy.getBusiness(
        businessId: ProxyService.box.getBusinessId()!,
      ))!.id,
      validitySeconds: timeInSeconds,
      onMandate: onMandate,
    );

    switch (result.outcome) {
      case MomoSubscriptionOutcome.preapprovalRefused:
        talker.warning('Subscription not charged: ${result.message}');
        throw MomoPreapprovalDeclined(
          result.message ??
              'Mobile Money consent was declined, so nothing was charged.',
          mandate: result.mandate,
        );
      case MomoSubscriptionOutcome.chargeRejected:
        throw Exception(result.message ?? 'The payment could not be started.');
      case MomoSubscriptionOutcome.charged:
        if (result.chargedOnPinPrompt) {
          talker.info(
            'Charged without a covering mandate — MTN will ask for a PIN once',
          );
        }
    }
    final String? paymentReference = result.reference;
    // upsert plan with new payment method
    // refresh a plan as it might have updted remotely.

    ProxyService.strategy.saveOrUpdatePaymentPlan(
      additionalDevices: plan.additionalDevices!,
      businessId: (await ProxyService.strategy.activeBusiness())!.id,
      // payStackUserId: plan.payStackCustomerId!,
      flipperHttpClient: ProxyService.http,
      isYearlyPlan: plan.isYearlyPlan!,
      paymentMethod: "MTNMOMO",
      plan: plan,
      selectedPlan: plan.selectedPlan!,
      totalPrice: finalPrice.toDouble(),
    );

    final businessId = ProxyService.box.getBusinessId()!;
    // `.stream()` allows only one PostgREST filter; narrow by business_id and
    // check completion in the listener (matches prior Brick query intent).
    Supabase.instance.client
        .from('plans')
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
        .listen(
          (rows) {
            final completed = rows.any(
              (r) => r['payment_completed_by_user'] == true,
            );
            if (completed) {
              talker.warning(rows);
              locator<RouterService>().navigateTo(FlipperAppRoute());
            }
          },
          onError: (error, stackTrace) => logSupabaseRealtimeError(
            error,
            source: 'plans payment',
            stackTrace: stackTrace,
          ),
        );
    return paymentReference;
  }

  /// Sends the customer to Dodo's hosted checkout to pay this plan by card.
  ///
  /// The counterpart of [handleMomoPayment], and deliberately *not* a variation
  /// of it. With MoMo we take consent, push a debit, and poll MTN. With a card
  /// the customer pays on a page Dodo owns, so there is nothing to pre-approve
  /// and nothing to charge — the work is handing over the right link and then
  /// reading back what happened. Waiting for the outcome is the caller's job
  /// ([DodoCardCheckout.awaitEntitlement], or the `plans` realtime stream a
  /// payment screen already listens to), so the screen can show "finish on the
  /// payment page" rather than a silent spinner.
  ///
  /// [finalPrice] is accepted for symmetry and **is not sent**: Dodo bills the
  /// price fixed on its product, so a discounted figure would only make
  /// `plans.total_price` disagree with what the card is actually charged. A
  /// Flipper discount code therefore does not apply on this rail — say so in
  /// the UI rather than quietly charging full price against a shown discount.
  ///
  /// Throws [CardCheckoutUnavailable] when we cannot even get as far as a link.
  Future<DodoCheckoutResult> handleCardPayment({
    required Plan plan,
    int? finalPrice,
    String? email,
    DodoClient? client,
    DodoLinkOpener? openLink,
    bool openCheckout = true,
  }) async {
    final planId = plan.id;
    if (planId == null || planId.isEmpty) {
      // Same rule as the MoMo path: charge the plan we were handed, never "the
      // business's newest plan".
      throw CardCheckoutUnavailable(
        'This subscription has no plan id yet, so it cannot be paid safely. '
        'Reopen the plan screen and try again.',
      );
    }

    final business = await ProxyService.strategy.activeBusiness();
    if (business == null) {
      throw CardCheckoutUnavailable('No active business to bill.');
    }

    // Dodo needs an address to create the customer and send invoices to. The
    // connector falls back to `businesses.email` and fails if neither has one;
    // catching it here gives the user something they can act on instead of a
    // 400 from two hops away.
    final resolvedEmail = _firstNonEmpty([email, business.email?.toString()]);
    if (resolvedEmail == null) {
      throw CardCheckoutUnavailable(
        'Card payment needs an email address for the receipt. Add one on the '
        'payment screen, or in Business settings.',
      );
    }

    // Row before request, as on the MoMo rail: if the start call or the browser
    // hand-off dies, the plan already records which rail was chosen, so support
    // can see what the customer was doing. The price is untouched on purpose —
    // this writes the rail, not a new amount.
    await ProxyService.strategy.saveOrUpdatePaymentPlan(
      businessId: business.id,
      selectedPlan: plan.selectedPlan!,
      planTemplateId: plan.planTemplateId,
      additionalDevices: plan.additionalDevices ?? 0,
      isYearlyPlan: plan.isYearlyPlan ?? false,
      totalPrice: (plan.totalPrice ?? finalPrice ?? 0).toDouble(),
      paymentMethod: PaymentRail.card.wireValue,
      plan: plan,
      numberOfPayments: plan.numberOfPayments ?? 1,
      flipperHttpClient: ProxyService.http,
    );

    final checkout = DodoCardCheckout(
      client ?? DodoClient(ProxyService.http),
      openLink: openLink,
    );

    final result = await checkout.start(
      businessId: business.id,
      planId: planId,
      branchId: plan.branchId ?? ProxyService.box.getBranchId(),
      planTemplateId: plan.planTemplateId,
      selectedPlan: plan.selectedPlan,
      addons: plan.addons
              ?.map((addon) => addon.addonName)
              .whereType<String>()
              .toList() ??
          const [],
      isYearlyPlan: plan.isYearlyPlan ?? false,
      email: resolvedEmail,
      customerName: business.name,
      phoneNumber: plan.phoneNumber ?? business.phoneNumber,
      country: business.country,
      additionalDevices: plan.additionalDevices,
      openCheckout: openCheckout,
    );

    talker.info('Card subscription: $result');

    if (result.outcome == DodoCheckoutOutcome.couldNotOpenLink) {
      // Nothing was charged. Surfaced as its own failure so the screen can
      // offer the link — or Mobile Money — instead of saying "payment failed".
      throw CardCheckoutUnavailable(
        result.message ??
            'Could not open the card payment page on this device.',
        checkout: result.checkout,
      );
    }

    return result;
  }

  static String? _firstNonEmpty(List<String?> candidates) {
    for (final candidate in candidates) {
      final trimmed = candidate?.trim();
      if (trimmed != null && trimmed.isNotEmpty && trimmed != 'null') {
        return trimmed;
      }
    }
    return null;
  }

  Future<void> cardPayment(
    int finalPrice,
    Plan paymentPlan,
    String selectedPaymentMethod, {
    required Plan plan,
  }) async {
    final (:url, :userId, :customerCode) = await ProxyService.strategy
        .subscribe(
          businessId: ProxyService.box.getBusinessId()!,
          business: (await ProxyService.strategy.getBusiness(
            businessId: ProxyService.box.getBusinessId()!,
          ))!,
          agentCode: 1,
          flipperHttpClient: ProxyService.http,
          amount: finalPrice,
        );

    ProxyService.strategy.saveOrUpdatePaymentPlan(
      additionalDevices: plan.additionalDevices!,
      businessId: (await ProxyService.strategy.activeBusiness())!.id,
      // payStackUserId: plan.payStackCustomerId!,
      flipperHttpClient: ProxyService.http,
      isYearlyPlan: plan.isYearlyPlan!,
      paymentMethod: "CARD",
      plan: plan,
      selectedPlan: plan.selectedPlan!,
      totalPrice: finalPrice.toDouble(),
    );

    await ProxyService.strategy.saveOrUpdatePaymentPlan(
      businessId: (await ProxyService.strategy.activeBusiness())!.id,
      selectedPlan: paymentPlan.selectedPlan!,
      paymentMethod: selectedPaymentMethod,
      customerCode: customerCode,
      additionalDevices: paymentPlan.additionalDevices!,
      isYearlyPlan: paymentPlan.isYearlyPlan!,
      totalPrice: paymentPlan.totalPrice!.toDouble(),
      flipperHttpClient: ProxyService.http,
      // payStackUserId: userId.toString(),
    );
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
    bool keepLoop = true;
    do {
      /// force instant update from remote db

      Plan? plan = await ProxyService.strategy.getPaymentPlan(
        businessId: paymentPlan.businessId!,
      );
      if (plan != null && plan.paymentCompletedByUser!) {
        talker.warning("A user has Completed payment");
        keepLoop = false;

        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } while (keepLoop);
  }
}
