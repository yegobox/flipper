import 'package:firestore_models/firestore_models.dart';
import 'package:flipper_services/PaymentHandler.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FailedPayment extends HookConsumerWidget with PaymentHandler {
  const FailedPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final plan = useState<PaymentPlan?>(null);

    useEffect(() {
      Future<void> fetchPlan() async {
        try {
          final fetchedPlan = await ProxyService.backUp
              .getPaymentPlan(businessId: ProxyService.box.getBusinessId()!);
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
        title: const Text(
          'Payment Failed',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 72.0,
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              'We couldn\'t process your payment for the following plan:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            if (plan.value != null) _buildPlanDetails(plan.value!),
            if (error.value != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  error.value!,
                  style: const TextStyle(color: Colors.red, fontSize: 16.0),
                ),
              ),
            const SizedBox(height: 32.0),
            Center(
              child: isLoading.value
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.redAccent.withOpacity(0.8),
                      ),
                      strokeWidth: 4,
                      backgroundColor: Colors.grey.shade300,
                    )
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry Payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36.0, vertical: 16.0),
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
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
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
      await cardPayment(finalPrice, plan, plan.paymentMethod!);
    } else {
      isLoading.value = true;
      int finalPrice = plan.totalPrice!.toInt();
      handleMomoPayment(finalPrice);
    }
  }
}
