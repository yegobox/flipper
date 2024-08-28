import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

class FailedPayment extends HookConsumerWidget {
  const FailedPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final plan = useState<PaymentPlan?>(null);

    useEffect(() {
      Future<void> fetchPlan() async {
        try {
          final fetchedPlan =
              await ProxyService.realm.getPaymentPlan(businessId: 1);
          plan.value = fetchedPlan;
        } catch (e) {
          error.value = 'Failed to fetch plan details: ${e.toString()}';
        } finally {
          isLoading.value = false;
        }
      }

      fetchPlan();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Payment Failed'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'We couldn\'t process your payment for the following plan:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 24.0),
            if (plan.value != null) _buildPlanDetails(plan.value!),
            if (error.value != null)
              Text(
                error.value!,
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 24.0),
            Center(
              child: isLoading.value
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black.withOpacity(0.7)),
                      strokeWidth: 3,
                      backgroundColor: Colors.grey.shade300,
                    )
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry Payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: plan.value != null
                          ? () => _retryPayment(context,
                              plan: plan.value!, isLoading: isLoading)
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetails(PaymentPlan plan) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Plan', plan.selectedPlan ?? 'N/A'),
            _buildDetailRow('Price', plan.totalPrice?.toRwf() ?? 'N/A'),
            _buildDetailRow(
                'Billing', plan.isYearlyPlan == true ? 'Yearly' : 'Monthly'),
            if (plan.additionalDevices != null && plan.additionalDevices! > 0)
              _buildDetailRow(
                  'Additional Devices', plan.additionalDevices.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Future<void> _retryPayment(BuildContext context,
      {required PaymentPlan plan,
      required ValueNotifier<bool> isLoading}) async {
    if (plan.paymentMethod == "Card") {
      int finalPrice = plan.totalPrice!.toInt();
      isLoading.value = true;
      FlipperSaleCompaign? compaign = ProxyService.realm.getLatestCompaign();
      try {
        if (kDebugMode) {
          if (compaign != null) {
            finalPrice = (plan.totalPrice! -
                    ((plan.totalPrice! * compaign.discountRate!) / 100))
                .toInt();
          } else {
            finalPrice = plan.totalPrice!.toInt();
          }
        }

        final (:url, :userId, :customerCode) =
            await ProxyService.realm.subscribe(
          businessId: ProxyService.box.getBusinessId() ?? 0,
          agentCode: 1,
          flipperHttpClient: ProxyService.http,
          amount: finalPrice,
        );
        if (!await launchUrl(Uri.parse(url))) {
          throw Exception('Could not launch $url');
        }
        await _waitForPaymentCompletion(plan);
        isLoading.value = false;
        locator<RouterService>().navigateTo(FlipperAppRoute());
      } catch (e) {
        isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Mobile Money payment coming soon, choose card payment')),
      );
    }
  }

  Future<void> _waitForPaymentCompletion(PaymentPlan plan) async {
    const delayBetweenAttempts = Duration(seconds: 5);

    while (true) {
      await ProxyService.realm.realm?.subscriptions.waitForSynchronization();
      PaymentPlan? planUpdated =
          ProxyService.realm.getPaymentPlan(businessId: plan.businessId ?? 0);

      if (planUpdated != null && planUpdated.paymentCompletedByUser == true) {
        return; // Exit the loop and complete the function once payment is completed
      }

      await Future.delayed(delayBetweenAttempts); // Wait before checking again
    }
  }
}
