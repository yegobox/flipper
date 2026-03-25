import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

mixin PaymentHandler {
  /// Initiates MTN Mobile Money payment. Returns the payment reference when
  /// successful, for use in polling payment status.
  Future<String?> handleMomoPayment(
    int finalPrice, {
    required Plan plan,
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
    final subscribed = await ProxyService.ht.subscribe(
      businessId: ProxyService.box.getBusinessId()!,
      phoneNumber: phone,
      amount: finalPrice,
      flipperHttpClient: ProxyService.http,
      timeInSeconds: timeInSeconds,
    );
    // delay for 20 seconds
    await Future.delayed(const Duration(seconds: 20));
    String? paymentReference;
    if (subscribed) {
      /// if subscribed, this means the user will not be prompted for PIN again,
      /// if he has not subscribed he will be prompted for PIN.
      final result = await ProxyService.ht.makePaymentWithReference(
        phoneNumber: phone,
        paymentType: "Subscription",
        payeemessage: "Flipper Subscription",
        branchId: "2f83b8b1-6d41-4d80-b0e7-de8ab36910af",
        businessId: (await ProxyService.strategy.getBusiness(
          businessId: ProxyService.box.getBusinessId()!,
        ))!.id,
        planId: plan.id,
        amount: finalPrice,
        flipperHttpClient: ProxyService.http,
      );
      paymentReference = result.paymentReference;
    }
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
          onError: (error) {
            talker.warning(error);
          },
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
