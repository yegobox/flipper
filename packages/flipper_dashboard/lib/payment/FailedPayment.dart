import 'dart:async';
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

    // Initialize animations for UI enhancement
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

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

          // Check if payment was completed - enhanced with success animation
          if (updatedPlan.paymentCompletedByUser == true) {
            _showSuccessAndNavigate();
          }
        }
      });
    } catch (e) {
      if (!_mounted || !context.mounted) return;

      setState(() {
        _errorMessage = 'Error loading plan details: $e';
        _isLoading = false;
      });

      _showErrorSnackBar(_errorMessage!);
    }
  }

  // Enhanced success feedback
  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Payment successful! 🎉'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (_mounted) {
        locator<RouterService>().navigateTo(FlipperAppRoute());
      }
    });
  }

  // Enhanced error feedback
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 16,
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
                    color: const Color(0xFFE53E3E).withOpacity(0.2),
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
    // Show phone number section unless explicitly a card payment
    // If paymentMethod is null, empty, or anything other than 'card', show mobile money options
    final paymentMethod = _plan?.paymentMethod?.toLowerCase();
    final isCardPayment = paymentMethod == 'card' ||
        paymentMethod == 'credit_card' ||
        paymentMethod == 'debit_card';

    // Debug: Let's see what payment method we're getting
    print(
        'Payment method detected: $paymentMethod, isCardPayment: $isCardPayment');

    if (isCardPayment) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
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
            activeColor: Theme.of(context).colorScheme.primary,
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
                    offset: _phoneNumberController.text.length);
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
                        phoneNumber: _usePhoneNumber
                            ? _phoneNumberController.text
                            : null,
                      );
                    } catch (e) {
                      if (!_mounted) return;
                      setState(() {
                        _errorMessage = 'Payment failed: $e';
                      });

                      // Add shake animation on error
                      _shakeController.forward().then((_) {
                        _shakeController.reset();
                      });

                      _showErrorSnackBar('Payment failed: ${e.toString()}');
                    } finally {
                      if (_mounted) {
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
                              Theme.of(context).colorScheme.onPrimary),
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
          _buildDetailRow(
            'Price',
            plan.totalPrice?.toCurrencyFormatted(
                    symbol: ProxyService.box.defaultCurrency()) ??
                'N/A',
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

  // Keep original retry payment logic exactly as is
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
        await handleMomoPayment(plan.totalPrice!.toInt(), plan: plan);
      }
    } catch (e, s) {
      talker.error(e.toString());
      talker.error(s.toString());
      // Show error to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${e.toString()}')),
        );
      }
    }
  }
}
