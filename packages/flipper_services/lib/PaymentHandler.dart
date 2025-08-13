import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

mixin PaymentHandler {
  Future<void> handleMomoPayment(int finalPrice, {required Plan plan}) async {
    /// given  plan.selectedPlan compute time in seconds
    int timeInSeconds = 120;
    if (plan.selectedPlan == "monthly") {
      timeInSeconds = kDebugMode ? 120 : 2628000;
    }
    if (plan.selectedPlan == "yearly") {
      timeInSeconds = kDebugMode ? 120 : 31536000;
    }
    final subscribed = await ProxyService.ht.subscribe(
      businessId: ProxyService.box.getBusinessId()!,
      amount: finalPrice,
      flipperHttpClient: ProxyService.http,
      timeInSeconds: timeInSeconds,
    );
    // delay for 20 seconds
    await Future.delayed(const Duration(seconds: 20));
    if (subscribed) {
      final phone =
          ProxyService.box.customPhoneNumberForPayment()?.replaceAll("+", "") ??
              ProxyService.box.getUserPhone()!.replaceAll("+", "");

      /// if subscribed, this means the user will not be prompted for PIN again,
      /// if he has not subscribed he will be prompted for PIN.
      ProxyService.ht.makePayment(
        phoneNumber: phone,
        paymentType: "Subscription",
        payeemessage: "Flipper Subscription",
        branchId: "2f83b8b1-6d41-4d80-b0e7-de8ab36910af",
        businessId: ProxyService.box.getBusinessId()!,
        amount: finalPrice,
        flipperHttpClient: ProxyService.http,
      );
    }
    // upsert plan with new payment method

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

    final query = Query(where: [
      Where('businessId').isExactly(ProxyService.box.getBusinessId()!),
      Where('paymentCompletedByUser').isExactly(true),
    ]);
    final paymentPlan = Repository().subscribeToRealtime<Plan>(query: query);
    paymentPlan.listen(
      (data) {
        if (data.isNotEmpty) {
          talker.warning(data);
          locator<RouterService>().navigateTo(FlipperAppRoute());
        }
      },
      onError: (error) {
        talker.warning(error);
      },
    );
  }

  Future<void> cardPayment(
      int finalPrice, Plan paymentPlan, String selectedPaymentMethod,
      {required Plan plan}) async {
    final (:url, :userId, :customerCode) =
        await ProxyService.strategy.subscribe(
      businessId: ProxyService.box.getBusinessId()!,
      business: (await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!))!,
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

      Plan? plan = await ProxyService.strategy
          .getPaymentPlan(businessId: paymentPlan.businessId!);
      if (plan != null && plan.paymentCompletedByUser!) {
        talker.warning("A user has Completed payment");
        keepLoop = false;

        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } while (keepLoop);
  }
}
