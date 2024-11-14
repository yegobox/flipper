import 'package:flipper_models/helperModels/talker.dart';
import 'package:firestore_models/firestore_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

mixin PaymentHandler {
  void handleMomoPayment(int finalPrice) {
    ProxyService.ht.makePayment(
      businessId: ProxyService.box.getBusinessId()!,
      amount: finalPrice,
      flipperHttpClient: ProxyService.http,
    );

    final query = Query(where: [
      Where('businessId').isExactly(ProxyService.box.getBusinessId()!),
      Where('paymentCompletedByUser').isExactly(true),
    ]);
    final plan = Repository().subscribeToRealtime<Plan>(query: query);
    plan.listen(
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

  Future<void> cardPayment(int finalPrice, PaymentPlan paymentPlan,
      String selectedPaymentMethod) async {
    final (:url, :userId, :customerCode) = await ProxyService.local.subscribe(
      businessId: ProxyService.box.getBusinessId()!,
      business: ProxyService.local.getBusiness(),
      agentCode: 1,
      flipperHttpClient: ProxyService.http,
      amount: finalPrice,
    );

    await ProxyService.local.saveOrUpdatePaymentPlan(
        businessId: paymentPlan.businessId!,
        selectedPlan: paymentPlan.selectedPlan!,
        paymentMethod: selectedPaymentMethod,
        customerCode: customerCode,
        additionalDevices: paymentPlan.additionalDevices!,
        isYearlyPlan: paymentPlan.isYearlyPlan!,
        totalPrice: paymentPlan.totalPrice!,
        flipperHttpClient: ProxyService.http,
        payStackUserId: userId);
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
    bool keepLoop = true;
    do {
      /// force instant update from remote db

      PaymentPlan? plan = await ProxyService.backUp
          .getPaymentPlan(businessId: paymentPlan.businessId!);
      if (plan != null && plan.paymentCompletedByUser!) {
        talker.warning("A user has Completed payment");
        keepLoop = false;

        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    } while (keepLoop);
  }
}
