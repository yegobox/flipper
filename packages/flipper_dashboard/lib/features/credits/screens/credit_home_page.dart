import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'dart:async';

import '../models/credit_data.dart';
import '../widgets/credit_display.dart';
import '../widgets/credit_icon_widget.dart';

class CreditHomePage extends StatefulWidget {
  const CreditHomePage({Key? key}) : super(key: key);

  @override
  State<CreditHomePage> createState() => _CreditHomePageState();
}

class _CreditHomePageState extends State<CreditHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _buyCreditController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _buyCreditController.dispose();
    _phoneNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightMode
          ? const Color(0xFFF5F5F7) // Apple light background
          : const Color(0xFF121212), // Dark mode background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Credit Hub',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Consumer<CreditData>(
            builder: (context, creditData, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CreditIconWidget(
                  credits: creditData.availableCredits,
                  maxCredits: creditData.maxCredits,
                  size: 40,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Consumer<CreditData>(
                      builder: (context, creditData, child) {
                        return CreditDisplay(
                          credits: creditData.availableCredits,
                          maxCredits: creditData.maxCredits,
                          colorScheme: colorScheme,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Add Credits',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAddCreditsSection(
                        context, isLightMode, colorScheme, textTheme),
                    const SizedBox(height: 30),
                    // TODO: resume this and implement this in future.
                    // QuickAmountsSelector(
                    //   onAmountSelected: (amount) {
                    //     Provider.of<CreditData>(context, listen: false)
                    //         .buyCredits(amount);
                    //     _showSuccessSnackBar(context, amount);
                    //   },
                    // ),
                    // const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCreditsSection(BuildContext context, bool isLightMode,
      ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isLightMode ? Colors.white : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _buyCreditController,
            keyboardType: TextInputType.number,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Enter amount',
              labelStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              prefixText: ProxyService.box.defaultCurrency(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isLightMode
                  ? Colors.grey.withOpacity(0.05)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '07xxxxxxxx',
              labelStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isLightMode
                  ? Colors.grey.withOpacity(0.05)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _processPayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: colorScheme.primary.withOpacity(0.6),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    final amount = int.tryParse(_buyCreditController.text);
    final phoneNumber = _phoneNumberController.text.trim();

    // Validate input
    if (amount == null || amount <= 0) {
      _showErrorSnackBar(context, 'Please enter a valid amount');
      return;
    }

    if (phoneNumber.isEmpty || !_isValidPhoneNumber(phoneNumber)) {
      _showErrorSnackBar(context, 'Please enter a valid phone number');
      return;
    }

    // Format phone number if needed (ensure it starts with 250)
    final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare payment data
      final paymentData = {
        'amount': amount,
        'phoneNumber': formattedPhoneNumber,
        'currency': ProxyService.box.defaultCurrency(),
        'description': 'Credit purchase'
      };

      // Call the payment API
      final result = await ProxyService.httpApi.payNow(
          flipperHttpClient: ProxyService.http, paymentData: paymentData);

      // Handle successful API call
      if (result.containsKey('paymentReference')) {
        final paymentReference = result['paymentReference'];
        _showPaymentInitiatedDialog(
            context, formattedPhoneNumber, paymentReference);

        // Clear input fields
        _buyCreditController.clear();
        _phoneNumberController.clear();
      } else {
        _showErrorSnackBar(
            context, 'Payment request failed. Please try again.');
      }
    } catch (e, stackTrace) {
      talker.error('Payment error', e, stackTrace);
      _showErrorSnackBar(context, 'An error occurred: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(BuildContext context,
      [String message = 'Please enter a valid amount']) {
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(message, Icons.error_outline, Colors.red.shade600),
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Basic validation - can be enhanced based on requirements
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    return cleanNumber.length >= 9 && cleanNumber.length <= 12;
  }

  String _formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // If it starts with 0, replace with 25
    if (digitsOnly.startsWith('0')) {
      return '250${digitsOnly.substring(1)}';
    }

    // If it doesn't have country code, add 250
    if (digitsOnly.length == 9) {
      return '250$digitsOnly';
    }

    return digitsOnly;
  }

  void _showPaymentInitiatedDialog(
      BuildContext context, String phoneNumber, String paymentReference) {
    // Create a stateful builder to update the dialog content
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _PaymentStatusDialog(
            phoneNumber: phoneNumber, paymentReference: paymentReference);
      },
    );
  }
}

class _PaymentStatusDialog extends StatefulWidget {
  final String phoneNumber;
  final String paymentReference;

  const _PaymentStatusDialog({
    required this.phoneNumber,
    required this.paymentReference,
  });

  @override
  _PaymentStatusDialogState createState() => _PaymentStatusDialogState();
}

class _PaymentStatusDialogState extends State<_PaymentStatusDialog> {
  bool isCheckingPayment = true;
  bool paymentSuccessful = false;
  int checkCount = 0;
  static const int maxChecks = 30; // Check for up to 30 times (5 minutes)
  Timer? statusCheckTimer;

  @override
  void initState() {
    super.initState();
    // Start checking payment status after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _checkPaymentStatus();
      }
    });
  }

  @override
  void dispose() {
    statusCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkPaymentStatus() async {
    try {
      bool isSuccessful = await ProxyService.httpApi.checkPaymentStatus(
        flipperHttpClient: ProxyService.http,
        paymentReference: widget.paymentReference,
      );

      if (mounted) {
        setState(() {
          if (isSuccessful) {
            // Payment successful
            paymentSuccessful = true;
            isCheckingPayment = false;
            statusCheckTimer?.cancel();
          } else {
            // Payment not yet successful, increment check count
            checkCount++;

            // If we haven't reached max checks, schedule another check after 10 seconds
            if (checkCount < maxChecks) {
              statusCheckTimer = Timer(const Duration(seconds: 10), () {
                if (mounted && isCheckingPayment) {
                  _checkPaymentStatus();
                }
              });
            } else {
              // Max checks reached, stop checking
              isCheckingPayment = false;
            }
          }
        });
      }
    } catch (e) {
      talker.error('Error checking payment status', e);
      if (mounted) {
        setState(() {
          checkCount++;
          if (checkCount < maxChecks) {
            statusCheckTimer = Timer(const Duration(seconds: 10), () {
              if (mounted && isCheckingPayment) {
                _checkPaymentStatus();
              }
            });
          } else {
            isCheckingPayment = false;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            paymentSuccessful ? Icons.check_circle : Icons.phone_android,
            color: paymentSuccessful
                ? Colors.green
                : Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              paymentSuccessful ? 'Payment Successful' : 'Payment Initiated',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!paymentSuccessful) ...[
            Text(
              'A payment request has been sent to ${widget.phoneNumber}.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please check your phone and approve the payment.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Center(
              child: isCheckingPayment
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Checking payment status...',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    )
                  : checkCount >= maxChecks
                      ? const Text(
                          'Payment verification timed out. Please check your credits later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        )
                      : const SizedBox(),
            ),
          ] else ...[
            const Text(
              'Your payment has been successfully processed!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your credits have been added to your account.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              isCheckingPayment = false;
            });
            statusCheckTimer?.cancel();
            Navigator.of(context).pop();
          },
          child: Text(paymentSuccessful ? 'Done' : 'Close'),
        ),
      ],
    );
  }
}

// Helper widget to display snackbar messages
SnackBar _buildSnackBar(String message, IconData icon, Color color) {
  return SnackBar(
    content: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 16),
        Text(message),
      ],
    ),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.all(12),
    duration: const Duration(seconds: 2),
  );
}
