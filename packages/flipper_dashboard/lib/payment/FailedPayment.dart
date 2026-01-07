import 'dart:async';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';
import 'package:flipper_models/helperModels/talker.dart';
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
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_ui/flipper_ui.dart';

class FailedPayment extends StatefulWidget {
  const FailedPayment({Key? key}) : super(key: key);

  @override
  _FailedPaymentState createState() => _FailedPaymentState();
}

class _FailedPaymentState extends State<FailedPayment>
    with PaymentHandler, TickerProviderStateMixin {
  late final TextEditingController _phoneNumberController;
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move error handling here if needed, or ensure _setupPlanSubscription defers SnackBar
  }

  bool _isLoading = true;
  String? _errorMessage;
  models.Plan? _plan;
  bool _usePhoneNumber = false;
  bool _mounted = true;
  bool _waitingForPaymentCompletion = false;
  Timer? _paymentTimeoutTimer;
  StreamSubscription<List<models.Plan>>? _subscription;

  // Discount code state
  String? _discountCode;
  double _discountAmount = 0;
  double _originalPrice = 0;
  bool _isValidatingCode = false;
  String? _discountError;

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();

    // Initialize animations for UI enhancement
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Keep original setup logic intact
    _setupPlanSubscription();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _mounted = false;
    _subscription?.cancel();
    _phoneNumberController.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    _paymentTimeoutTimer?.cancel();
    super.dispose();
  }

  // Keep original validation logic exactly as is
  String? _getPhoneNumberError(String value) {
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

    String prefix = digitsOnly.substring(3, 5);
    if (!['78', '79'].contains(prefix)) {
      return 'Invalid MTN number prefix (must start with 78 or 79)';
    }

    return null;
  }

  // Keep original setup logic exactly as is
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
            policy: OfflineFirstGetPolicy.alwaysHydrate,
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

              if (updatedPlan.paymentCompletedByUser == true) {
                _paymentTimeoutTimer?.cancel();
                if (_mounted) {
                  setState(() {
                    _waitingForPaymentCompletion = false;
                  });
                }
                showCustomSnackBarUtil(
                  context,
                  'Payment Successful',
                  backgroundColor: Colors.green,
                  showCloseButton: true,
                );
              }
            }
          });
    } catch (e) {
      if (!_mounted || !context.mounted) return;

      setState(() {
        _errorMessage = 'Error loading plan details: $e';
        _isLoading = false;
      });

      // Defer SnackBar to ensure context is valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showCustomSnackBarUtil(
            context,
            'Payment Failed try again',
            backgroundColor: Colors.red,
            showCloseButton: true,
          );
        }
      });
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
      // Initialize _originalPrice to planPrice if it's unset (<= 0) before validation
      final effectiveOriginalPrice = _originalPrice <= 0 ? planPrice : _originalPrice;

      final result = await ProxyService.strategy.validateDiscountCode(
        code: code.trim().toUpperCase(),
        planName: _plan?.selectedPlan ?? '',
        amount: effectiveOriginalPrice,
      );

      if (mounted) {
        if (result['is_valid'] == true) {
          final discountType = result['discount_type'] as String;
          final discountValue = (result['discount_value'] as num).toDouble();

          final calculatedDiscount = ProxyService.strategy.calculateDiscount(
            originalPrice: effectiveOriginalPrice,
            discountType: discountType,
            discountValue: discountValue,
          );

          setState(() {
            _discountCode = code.trim().toUpperCase();
            _discountAmount = calculatedDiscount;
            _discountError = null;
            _isValidatingCode = false;
            // Only update _originalPrice if it was previously unset or different
            if (_originalPrice <= 0) {
              _originalPrice = planPrice;
            }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Payment Issue',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _waitingForPaymentCompletion
          ? _buildPaymentWaitingState()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 32),
                    if (_plan != null) _buildPlanDetails(_plan!),
                    if (_errorMessage != null) _buildErrorMessage(),
                    const SizedBox(height: 16),
                    if (_plan != null)
                      CouponToggle(
                        onCodeChanged: _validateDiscountCode,
                        errorMessage: _discountError,
                        isValidating: _isValidatingCode,
                      ),
                    const SizedBox(height: 24),
                    if (_plan != null) _buildPhoneNumberSection(),
                    const SizedBox(height: 32),
                    _buildRetryButton(context),
                    const SizedBox(height: 24),
                    _buildHelpSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading payment details...',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentWaitingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.blue.shade200, width: 2),
            ),
            child: const Icon(
              Icons.hourglass_top,
              size: 40,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Waiting for Payment Completion',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Please complete the payment in your\npayment app or browser.',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'This may take a few moments...',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            _shakeAnimation.value *
                10 *
                (0.5 - (0.5 * _shakeAnimation.value)) *
                2,
            0,
          ),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: const Color(0xFFE53E3E).withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.payment_outlined,
                  size: 40,
                  color: Color(0xFFE53E3E),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Needs Attention',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Don\'t worry, this happens sometimes.\nLet\'s get you sorted out quickly.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneNumberSection() {
    // Mobile money payment section
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone_android,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Mobile Money Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Payment will be processed using MTN Mobile Money',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Use different phone number',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              'Try with another MTN number if the current one failed',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            value: _usePhoneNumber,
            onChanged: (value) {
              setState(() {
                _usePhoneNumber = value;
                if (!value) {
                  _phoneNumberController.clear();
                }
              });
            },
            activeThumbColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
          if (_usePhoneNumber) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'MTN Phone Number',
                hintText: '250 78 123 4567',
                prefixIcon: const Icon(Icons.phone_android),
                suffixIcon: _phoneNumberController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _phoneNumberController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorText: _getPhoneNumberError(_phoneNumberController.text),
                helperText: 'Must start with 250 78 or 250 79',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              onChanged: (value) {
                // Keep original formatting logic exactly as is
                if (value.length <= 3) {
                  _phoneNumberController.text = value;
                } else if (value.length <= 5) {
                  _phoneNumberController.text =
                      '${value.substring(0, 3)} ${value.substring(3)}';
                } else if (value.length <= 8) {
                  _phoneNumberController.text =
                      '${value.substring(0, 3)} ${value.substring(3, 5)} ${value.substring(5)}';
                } else {
                  _phoneNumberController.text =
                      '${value.substring(0, 3)} ${value.substring(3, 5)} ${value.substring(5, 8)} ${value.substring(8)}';
                }
                _phoneNumberController.selection = TextSelection.collapsed(
                  offset: _phoneNumberController.text.length,
                );
                setState(() {});
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed:
                _isLoading || _plan == null || _waitingForPaymentCompletion
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
                        phoneNumber: _usePhoneNumber
                            ? _phoneNumberController.text
                            : null,
                      );
                      // If payment initiation succeeds, show waiting state
                      if (_mounted) {
                        setState(() {
                          _waitingForPaymentCompletion = true;
                          _isLoading = false;
                        });
                        // Start timeout timer (5 minutes)
                        _paymentTimeoutTimer?.cancel();
                        _paymentTimeoutTimer = Timer(
                          const Duration(minutes: 5),
                          () {
                            if (_mounted) {
                              setState(() {
                                _waitingForPaymentCompletion = false;
                                _errorMessage =
                                    'Payment timeout. Please try again.';
                              });
                              showCustomSnackBarUtil(
                                context,
                                'Payment timeout. Please try again.',
                                backgroundColor: Colors.red,
                                showCloseButton: true,
                              );
                            }
                          },
                        );
                      }
                    } catch (e) {
                      _paymentTimeoutTimer?.cancel();
                      if (!_mounted) return;
                      setState(() {
                        _errorMessage = 'Payment failed: $e';
                        _waitingForPaymentCompletion = false;
                      });

                      // Add shake animation on error
                      _shakeController.forward().then((_) {
                        _shakeController.reset();
                      });

                      showCustomSnackBarUtil(
                        context,
                        'Payment failed try again',
                        backgroundColor: Colors.red,
                        showCloseButton: true,
                      );
                    } finally {
                      if (_mounted && !_waitingForPaymentCompletion) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Processing...'),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () =>
                locator<RouterService>().navigateTo(FlipperAppRoute()),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Skip for Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanDetails(models.Plan plan) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Payment Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Plan', plan.selectedPlan ?? 'N/A'),
          if (_discountAmount > 0) ...[
            _buildDetailRow(
              'Subtotal',
              _originalPrice.toCurrencyFormatted(
                symbol: ProxyService.box.defaultCurrency(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Discount',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
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
                      fontSize: 16.0,
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
                        ? (_originalPrice - _discountAmount)
                        : plan.totalPrice)
                    ?.toCurrencyFormatted(
                      symbol: ProxyService.box.defaultCurrency(),
                    ) ??
                'N/A',
            isTotal: _discountAmount > 0,
          ),
          _buildDetailRow(
            'Billing',
            plan.isYearlyPlan == true ? 'Yearly' : 'Monthly',
          ),
          if (plan.additionalDevices != null && plan.additionalDevices! > 0)
            _buildDetailRow(
              'Additional Devices',
              plan.additionalDevices.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
              fontSize: isTotal ? 18.0 : 16.0,
              color: isTotal ? Colors.green : Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18.0 : 16.0,
              color: isTotal ? Colors.green : Colors.black87,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Common issues:\n• Insufficient funds\n• Network connectivity\n• Incorrect phone number\n• Payment method restrictions',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // Handle contact support
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.support_agent, size: 16),
                const SizedBox(width: 4),
                const Text('Contact Support'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Retry payment with mobile money
  Future<void> _retryPayment(
    BuildContext context, {
    required models.Plan plan,
    required bool isLoading,
    String? phoneNumber,
  }) async {
    // Validate phone number if using custom number
    if (_usePhoneNumber) {
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

    // Calculate the discounted price for payment
    final planPrice = plan.totalPrice?.toDouble() ?? 0.0;
    final finalPrice = planPrice - _discountAmount;
    final finalPriceInt = finalPrice > 0 ? finalPrice.toInt() : 0;

    // Handle mobile money payment with the discounted price
    await handleMomoPayment(finalPriceInt, plan: plan);
  }
}
