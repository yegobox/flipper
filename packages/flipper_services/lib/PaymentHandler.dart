import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

mixin PaymentHandler {
  void handleMomoPayment(int finalPrice, {Plan? plan}) {
    ProxyService.ht.makePayment(
      businessId: ProxyService.box.getBusinessId()!,
      amount: finalPrice,
      flipperHttpClient: ProxyService.http,
    );
    // upsert plan with new payment method

    ProxyService.strategy.saveOrUpdatePaymentPlan(
      additionalDevices: plan!.additionalDevices!,
      businessId: ProxyService.box.getBusinessId()!,
      payStackUserId: plan.payStackCustomerId!,
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
      business: (await ProxyService.strategy.getBusiness())!,
      agentCode: 1,
      flipperHttpClient: ProxyService.http,
      amount: finalPrice,
    );

    ProxyService.strategy.saveOrUpdatePaymentPlan(
      additionalDevices: plan.additionalDevices!,
      businessId: ProxyService.box.getBusinessId()!,
      payStackUserId: plan.payStackCustomerId!,
      flipperHttpClient: ProxyService.http,
      isYearlyPlan: plan.isYearlyPlan!,
      paymentMethod: "CARD",
      plan: plan,
      selectedPlan: plan.selectedPlan!,
      totalPrice: finalPrice.toDouble(),
    );

    await ProxyService.strategy.saveOrUpdatePaymentPlan(
        businessId: paymentPlan.businessId!,
        selectedPlan: paymentPlan.selectedPlan!,
        paymentMethod: selectedPaymentMethod,
        customerCode: customerCode,
        additionalDevices: paymentPlan.additionalDevices!,
        isYearlyPlan: paymentPlan.isYearlyPlan!,
        totalPrice: paymentPlan.totalPrice!.toDouble(),
        flipperHttpClient: ProxyService.http,
        payStackUserId: userId.toString());
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
