import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/momo/momo_client.dart';
import 'package:flipper_services/momo/momo_models.dart';
import 'package:flipper_services/momo/momo_subscription.dart';
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
