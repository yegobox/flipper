import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'internal/responsive_page.dart' as b;

// Import refactored components
import 'phone_auth/phone_auth_state.dart';
import 'phone_auth/phone_verification_service.dart';
import 'phone_auth/phone_input_ui.dart';
import 'phone_auth/verification_ui.dart';
import 'phone_auth/timer_service.dart';

class PhoneInputScreen extends StatefulWidget {
  final AuthAction? action;
  final WidgetBuilder? subtitleBuilder;
  final WidgetBuilder? footerBuilder;

  const PhoneInputScreen({
    Key? key,
    this.action,
    this.subtitleBuilder,
    this.footerBuilder,
  }) : super(key: key);

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen>
    with TickerProviderStateMixin {
  // State management
  late PhoneAuthState _state;
  late PhoneVerificationService _verificationService;
  late TimerService _timerService;

  // Animation controller for transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Initialize state with default country code
    _state = PhoneAuthState('+250');

    // Initialize services
    _verificationService = PhoneVerificationService(
      state: _state,
      context: context,
      showErrorSnackBar: _showErrorSnackBar,
      startResendTimer: _startResendTimer,
      animationController: _animationController,
    );

    _timerService = TimerService(
      state: _state,
      setState: setState,
    );
  }

  // Helper methods
  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _startResendTimer() {
    _timerService.startResendTimer();
  }

  void _verifyPhoneNumber(BuildContext context, String phoneNumber) {
    _verificationService.verifyPhoneNumber(phoneNumber);
  }

  void _resendCode() {
    _verificationService.resendCode();
  }

  void _verifyCode() {
    _verificationService.verifyCode();
  }

  void _changePhoneNumber() {
    setState(() {
      _state.showVerificationUI = false;
      _state.smsCode = '';
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FirebaseUILocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        body: b.ResponsivePage(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _state.showVerificationUI
                ? VerificationUI(
                    state: _state,
                    colorScheme: colorScheme,
                    fadeAnimation: _fadeAnimation,
                    onVerifyCode: _verifyCode,
                    onResendCode: _resendCode,
                    onChangePhoneNumber: _changePhoneNumber,
                  )
                : PhoneInputUI(
                    state: _state,
                    colorScheme: colorScheme,
                    l: localizations,
                    onVerifyPhone: _verifyPhoneNumber,
                    subtitleBuilder: widget.subtitleBuilder,
                    footerBuilder: widget.footerBuilder,
                  ),
          ),
        ),
      ),
    ));
  }
}
