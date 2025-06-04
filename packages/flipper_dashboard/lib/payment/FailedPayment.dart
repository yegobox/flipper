import 'dart:async';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/PaymentHandler.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:stacked_services/stacked_services.dart';

class FailedPayment extends StatefulWidget {
  const FailedPayment({Key? key}) : super(key: key);

  @override
  _FailedPaymentState createState() => _FailedPaymentState();
}

class _FailedPaymentState extends State<FailedPayment> with PaymentHandler {
  late final TextEditingController _phoneNumberController;
  bool _isLoading = true;
  String? _errorMessage;
  models.Plan? _plan;
  bool _usePhoneNumber = false;
  bool _mounted = true;
  StreamSubscription<List<models.Plan>>? _subscription;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _setupPlanSubscription();
  }

  @override
  void dispose() {
    _mounted = false;
    _subscription?.cancel();
    _phoneNumberController.dispose();
    super.dispose();
  }

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

  Future<void> _setupPlanSubscription() async {
    try {
      final businessId = (await ProxyService.strategy.activeBusiness())?.id;
      if (businessId == null) throw Exception('No active business');

      final fetchedPlan = await ProxyService.strategy.getPaymentPlan(
        businessId: businessId,
      );

      if (!_mounted) return;

      setState(() {
        _plan = fetchedPlan;
        _isLoading = false;
      });

      // Set up real-time subscription
      _subscription = Repository()
          .subscribeToRealtime<models.Plan>(
        query: Query(
          where: [const Where('businessId').isExactly(businessId)],
        ),
      )
          .listen((updatedPlans) {
        if (updatedPlans.isNotEmpty) {
          final updatedPlan = updatedPlans.first;
          if (!_mounted) return;

          setState(() {
            _plan = updatedPlan;
          });

          // Check if payment was completed
          if (updatedPlan.paymentCompletedByUser == true) {
            locator<RouterService>().navigateTo(FlipperAppRoute());
          }
        }
      });
    } catch (e) {
      if (!_mounted || !context.mounted) return;

      setState(() {
        _errorMessage = 'Error loading plan details: $e';
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Payment Failed'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_plan != null) _buildPlanDetails(_plan!),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 24),
                  _buildRetryButton(context),
                ],
              ),
            ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading || _plan == null
          ? null
          : () async {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });

              try {
                await _retryPayment(
                  context,
                  plan: _plan!,
                  isLoading: _isLoading,
                  phoneNumber:
                      _usePhoneNumber ? _phoneNumberController.text : null,
                );
              } catch (e) {
                if (!_mounted) return;
                setState(() {
                  _errorMessage = 'Payment failed: $e';
                });
              } finally {
                if (_mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Retry Payment'),
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
            _buildDetailRow(
                'Price',
                plan.totalPrice?.toCurrencyFormatted(
                        symbol: ProxyService.box.defaultCurrency()) ??
                    'N/A'),
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

  Future<void> _retryPayment(
    BuildContext context, {
    required models.Plan plan,
    required bool isLoading,
    String? phoneNumber,
  }) async {
    try {
      isLoading = true;

      // Validate phone number if it's a mobile payment
      if ((plan.paymentMethod?.toLowerCase() != 'card') && _usePhoneNumber) {
        final phoneError = _getPhoneNumberError(phoneNumber ?? '');
        if (phoneError != null) {
          throw Exception(phoneError);
        }

        // Store the validated phone number for payment
        if (phoneNumber != null) {
          await ProxyService.box.writeString(
            key: "customPhoneNumberForPayment",
            value: phoneNumber.replaceAll(' ', ''),
          );
        }
      }

      if (plan.paymentMethod?.toLowerCase() == 'card') {
        await cardPayment(
          plan.totalPrice!.toInt(),
          plan,
          plan.paymentMethod!,
          plan: plan,
        );
      } else {
        // Handle mobile payment
        await handleMomoPayment(plan.totalPrice!.toInt());
      }
    } catch (e) {
      // Show error to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${e.toString()}')),
        );
      }
    } finally {
      isLoading = false;
    }
  }
}
