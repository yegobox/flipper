import 'dart:async';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_services/PaymentHandler.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_models/helperModels/extensions.dart';

class PaymentFinalize extends StatefulWidget {
  @override
  _PaymentFinalizeState createState() => _PaymentFinalizeState();
}

class _PaymentFinalizeState extends State<PaymentFinalize> with PaymentHandler {
  bool isLoading = false;
  bool useCustomPhoneNumber = false;
  TextEditingController phoneNumberController = TextEditingController();

  StreamSubscription<List<models.Plan>>? _subscription;
  bool _mounted = true;

  // Discount code state
  String? _discountCode;
  double _discountAmount = 0;
  double _originalPrice = 0;
  bool _isValidatingCode = false;
  String? _discountError;
  models.Plan? _plan;

  @override
  void initState() {
    super.initState();
    _setupPlanSubscription();
  }

  @override
  void dispose() {
    _mounted = false;
    _subscription?.cancel();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _setupPlanSubscription() async {
    try {
      final businessId = (await ProxyService.strategy.activeBusiness())?.id;
      if (businessId == null) throw Exception('No active business');

      // Fetch initial plan
      final fetchedPlan = await ProxyService.strategy.getPaymentPlan(
        businessId: businessId,
      );

      if (_mounted) {
        setState(() {
          _plan = fetchedPlan;
        });
      }

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error setting up listener: $e')));
    }
  }

  /// Validates and applies a discount code
  Future<void> _validateDiscountCode(String code) async {
    if (code.trim().isEmpty) {
      setState(() {
        _discountError = null;
        _discountAmount = 0;
        _discountCode = null;
      });
      return;
    }

    setState(() {
      _isValidatingCode = true;
      _discountError = null;
    });

    try {
      final planPrice = _plan?.totalPrice?.toDouble() ?? 0;
      final result = await ProxyService.strategy.validateDiscountCode(
        code: code.trim().toUpperCase(),
        planName: _plan?.selectedPlan ?? '',
        amount: _originalPrice > 0 ? _originalPrice : planPrice,
      );

      if (mounted) {
        if (result['is_valid'] == true) {
          final discountType = result['discount_type'] as String;
          final discountValue = (result['discount_value'] as num).toDouble();

          final calculatedDiscount = ProxyService.strategy.calculateDiscount(
            originalPrice: _originalPrice > 0 ? _originalPrice : planPrice,
            discountType: discountType,
            discountValue: discountValue,
          );

          setState(() {
            _discountCode = code.trim().toUpperCase();
            _discountAmount = calculatedDiscount;
            _discountError = null;
            _isValidatingCode = false;
            _originalPrice = planPrice;
          });

          talker.info(
            'Discount code applied: $code - ${discountType == 'percentage' ? '${discountValue}%' : 'RWF $discountValue'}',
          );
        } else {
          setState(() {
            _discountError = result['error_message'] as String?;
            _discountAmount = 0;
            _discountCode = null;
            _isValidatingCode = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _discountError = 'Failed to validate code';
          _discountAmount = 0;
          _discountCode = null;
          _isValidatingCode = false;
        });
      }
      talker.error('Error validating discount code: $e');
    }
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16.0 : 14.0,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16.0 : 14.0,
              color: isTotal ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String? _getPhoneNumberError(String value) {
    String digitsOnly = value.replaceAll(' ', '');
    if (digitsOnly.isEmpty) return null;
    if (!digitsOnly.startsWith('250'))
      return 'Phone number must start with 250';
    if (digitsOnly.length < 12) return 'Phone number must be 12 digits';
    if (digitsOnly.length > 12) return 'Phone number cannot exceed 12 digits';
    String prefix = digitsOnly.substring(3, 5);
    if (!['78', '79'].contains(prefix)) {
      return 'Invalid MTN number prefix (must start with 78 or 79)';
    }
    return null;
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Complete Payment',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? 200 : 20,
                  vertical: 24,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionTitle(context, 'MTN Mobile Money Payment'),
                        const SizedBox(height: 8),
                        Text(
                          'Payment will be processed using MTN Mobile Money',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_plan != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Plan Summary',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                  'Plan',
                                  _plan!.selectedPlan ?? 'N/A',
                                ),
                                if (_discountAmount > 0) ...[
                                  _buildDetailRow(
                                    'Subtotal',
                                    _originalPrice.toCurrencyFormatted(
                                      symbol: ProxyService.box
                                          .defaultCurrency(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Discount',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                                color: Colors.green,
                                              ),
                                            ),
                                            if (_discountCode != null) ...[
                                              const SizedBox(width: 4),
                                              Text(
                                                '($_discountCode)',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          '-${_discountAmount.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                _buildDetailRow(
                                  _discountAmount > 0 ? 'Total' : 'Price',
                                  (_discountAmount > 0
                                              ? (_originalPrice -
                                                    _discountAmount)
                                              : _plan!.totalPrice)
                                          ?.toCurrencyFormatted(
                                            symbol: ProxyService.box
                                                .defaultCurrency(),
                                          ) ??
                                      'N/A',
                                  isTotal: _discountAmount > 0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          CouponToggle(
                            onCodeChanged: _validateDiscountCode,
                            errorMessage: _discountError,
                            isValidating: _isValidatingCode,
                          ),
                        ],
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SwitchListTile(
                            title: const Text(
                              'Use different phone number',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Specify a different number for payment',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            value: useCustomPhoneNumber,
                            onChanged: (bool value) {
                              setState(() {
                                useCustomPhoneNumber = value;
                                if (!value) {
                                  phoneNumberController.clear();
                                  ProxyService.box.writeString(
                                    key: "customPhoneNumberForPayment",
                                    value: '',
                                  );
                                }
                              });
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        if (useCustomPhoneNumber) ...[
                          const SizedBox(height: 20),
                          TextField(
                            onChanged: (value) {
                              String digitsOnly = value.replaceAll(
                                RegExp(r'\\D'),
                                '',
                              );
                              if (digitsOnly.length >= 1 &&
                                  !digitsOnly.startsWith('250')) {
                                if (digitsOnly.startsWith('0')) {
                                  digitsOnly = '25$digitsOnly';
                                } else {
                                  digitsOnly = '250$digitsOnly';
                                }
                              }

                              String formattedNumber = '';
                              for (int i = 0; i < digitsOnly.length; i++) {
                                if (i == 3 || i == 6 || i == 9) {
                                  formattedNumber += ' ';
                                }
                                formattedNumber += digitsOnly[i];
                              }

                              phoneNumberController.value = TextEditingValue(
                                text: formattedNumber,
                                selection: TextSelection.collapsed(
                                  offset: formattedNumber.length,
                                ),
                              );

                              ProxyService.box.writeString(
                                key: "customPhoneNumberForPayment",
                                value: digitsOnly,
                              );
                            },
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              labelText: 'MTN Phone Number',
                              hintText: '250 78 123 4567',
                              prefixIcon: const Icon(Icons.phone_android),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              errorText: _getPhoneNumberError(
                                phoneNumberController.text,
                              ),
                              helperText: 'Must start with 250 78 or 250 79',
                              suffixIcon: phoneNumberController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        phoneNumberController.clear();
                                        ProxyService.box.writeString(
                                          key: "customPhoneNumberForPayment",
                                          value: '',
                                        );
                                        setState(() {});
                                      },
                                    )
                                  : null,
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 15,
                            buildCounter:
                                (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) {
                                  return null;
                                },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\\d ]'),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : const Text(
                                    'Complete Payment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handlePayment() async {
    setState(() {
      isLoading = true;
    });
    try {
      models.Plan? paymentPlan = await ProxyService.strategy.getPaymentPlan(
        businessId: (await ProxyService.strategy.activeBusiness())!.id,
      );

      talker.warning("CurrentPaymentPlan: $paymentPlan");

      int finalPrice = 0;
      if (_discountAmount > 0) {
        finalPrice = (_originalPrice - _discountAmount).toInt();
      } else if (ProxyService.box.couponCode() != null) {
        // Fallback to legacy check if legacy coupon is present
        finalPrice =
            (paymentPlan!.totalPrice! -
                    ((paymentPlan.totalPrice! *
                            ProxyService.box.discountRate()!) /
                        100))
                .toInt();
      } else {
        finalPrice = paymentPlan!.totalPrice?.toInt() ?? 0;
      }

      // Handle mobile money payment only
      await handleMomoPayment(finalPrice, plan: paymentPlan!);
    } catch (e, s) {
      talker.warning(e.toString());
      talker.error(s.toString());
      if (_mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initiate payment: $e')),
        );
      }
    }
  }
}
