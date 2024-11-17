import 'package:flipper_services/PaymentHandler.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;

class FailedPayment extends HookConsumerWidget with PaymentHandler {
  const FailedPayment({Key? key}) : super(key: key);
  String? _getPhoneNumberError(String value) {
    // Remove spaces for validation
    String digitsOnly = value.replaceAll(' ', '');

    if (digitsOnly.isEmpty) {
      return null;
    }

    if (!digitsOnly.startsWith('250')) {
      return 'Phone number must start with 250';
    }

    if (digitsOnly.length < 12) {
      return 'Phone number must be 12 digits';
    }

    if (digitsOnly.length > 12) {
      return 'Phone number cannot exceed 12 digits';
    }

    // Validate MTN prefixes (78, 79)
    String prefix = digitsOnly.substring(3, 5);
    if (!['78', '79'].contains(prefix)) {
      return 'Invalid MTN number prefix (must start with 78 or 79)';
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final plan = useState<models.Plan?>(null);
    final usePhoneNumber = useState(false); // Toggle state
    final phoneNumber = useState<String?>(""); // Phone number input
    TextEditingController phoneNumberController = TextEditingController();

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

            // Toggle for phone number input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Change Phone number for payment',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: usePhoneNumber.value,
                  onChanged: (bool value) {
                    usePhoneNumber.value = value;
                  },
                ),
              ],
            ),

            // Phone number input field (shown when toggle is enabled)
            // Inside your HookConsumerWidget
            if (usePhoneNumber.value)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  maxLength: 15, // Including spaces: "250 781 468 740"
                  buildCounter: (context,
                      {required currentLength, required isFocused, maxLength}) {
                    return null; // Removes the built-in counter
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '250 781 468 740',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    errorText: _getPhoneNumberError(phoneNumberController.text),
                    helperText: 'Rwanda phone number (12 digits)',
                    suffixIcon: phoneNumberController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              phoneNumberController.clear();
                              ProxyService.box.writeString(
                                key: "customPhoneNumberForPayment",
                                value: '',
                              );
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');

                    // Ensure the number starts with 250 if not already present
                    if (digitsOnly.length >= 1 &&
                        !digitsOnly.startsWith('250')) {
                      if (digitsOnly.startsWith('0')) {
                        // If starts with 0, replace it with 250
                        digitsOnly = '25${digitsOnly}';
                      } else {
                        // Add 250 prefix
                        digitsOnly = '250$digitsOnly';
                      }
                    }

                    // Format the number with spaces for readability: 250 781 468 740
                    String formattedNumber = '';
                    for (int i = 0; i < digitsOnly.length; i++) {
                      if (i == 3 || i == 6 || i == 9) {
                        formattedNumber += ' ';
                      }
                      formattedNumber += digitsOnly[i];
                    }

                    // Update the controller with the formatted number
                    phoneNumberController.value = TextEditingValue(
                      text: formattedNumber,
                      selection: TextSelection.collapsed(
                          offset: formattedNumber.length),
                    );

                    // Store the validated number
                    ProxyService.box.writeString(
                      key: "customPhoneNumberForPayment",
                      value: digitsOnly, // Store without formatting
                    );
                  },
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
                              plan: plan.value!,
                              isLoading: isLoading,
                              phoneNumber: usePhoneNumber.value
                                  ? phoneNumber.value
                                  : null)
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetails(models.Plan plan) {
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
      {required models.Plan plan,
      required ValueNotifier<bool> isLoading,
      String? phoneNumber}) async {
    if (plan.paymentMethod == "Card" || plan.paymentMethod == "CARD") {
      int finalPrice = plan.totalPrice!.toInt();
      isLoading.value = true;
      await cardPayment(finalPrice, plan, plan.paymentMethod!, plan: plan);
    } else {
      isLoading.value = true;
      int finalPrice = plan.totalPrice!.toInt();

      // Handle mobile payment with phone number if provided
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        handleMomoPayment(finalPrice);
      } else {
        handleMomoPayment(finalPrice);
      }
    }
  }
}
