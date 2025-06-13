import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:io';

import '../animated_loading_dialog.dart';
import 'phone_auth_state.dart';

/// Service class to handle phone verification logic
class PhoneVerificationService {
  final PhoneAuthState state;
  final BuildContext context;
  final Function(String) showErrorSnackBar;
  final Function() startResendTimer;
  final AnimationController animationController;

  // Reference to the animated dialog
  GlobalKey<AnimatedLoadingDialogState> _dialogKey =
      GlobalKey<AnimatedLoadingDialogState>();

  PhoneVerificationService({
    required this.state,
    required this.context,
    required this.showErrorSnackBar,
    required this.startResendTimer,
    required this.animationController,
  });

  /// Verify phone number with Firebase
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    print('PhoneVerificationService.verifyPhoneNumber called');
    print('Phone number: $phoneNumber');

    // Set loading state first so UI updates immediately
    state.isLoading = true;

    if (state.formKey.currentState?.validate() != true) {
      print('Form validation failed');
      state.isLoading = false;
      return;
    }

    print('Form validation passed');

    if (state.selectedCountryCode == 'RW') {
      state.selectedCountryCode = '+250';
    }

    final fullPhoneNumber = state.selectedCountryCode + phoneNumber;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) {
          state.isLoading = false;
          signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async {
          state.isLoading = false;
          await Sentry.captureException(e, stackTrace: e);
          showErrorSnackBar(
              'Verification failed: ${e.message ?? "An unknown error occurred"}');
        },
        codeSent: (String verificationId, int? resendToken) {
          state.isLoading = false;
          state.verificationId = verificationId;
          state.resendToken = resendToken;
          state.showVerificationUI = true;
          state.otpExpired = false;

          animationController.forward();
          startResendTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          state.verificationId = verificationId;
        },
        forceResendingToken: state.resendToken,
      );
    } catch (e) {
      state.isLoading = false;
      showErrorSnackBar('An error occurred: ${e.toString()}');
    }
  }

  /// Resend verification code
  Future<void> resendCode() async {
    if (!state.canResend) return;

    state.isLoading = true;
    state.smsCode = '';

    final fullPhoneNumber =
        state.selectedCountryCode + state.phoneController.text;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) {
          state.isLoading = false;
          signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async {
          state.isLoading = false;
          await Sentry.captureException(e, stackTrace: e);
          showErrorSnackBar(
              'Verification failed: ${e.message ?? "An unknown error occurred"}');
        },
        codeSent: (String verificationId, int? resendToken) {
          state.isLoading = false;
          state.verificationId = verificationId;
          state.resendToken = resendToken;
          state.otpExpired = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New verification code sent'),
              backgroundColor: Colors.green,
            ),
          );
          startResendTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          state.verificationId = verificationId;
        },
        forceResendingToken: state.resendToken,
      );
    } catch (e) {
      state.isLoading = false;
      showErrorSnackBar('An error occurred: ${e.toString()}');
    }
  }

//
  /// Verify OTP code
  Future<void> verifyCode() async {
    if (state.smsCode.length < 6) {
      showErrorSnackBar('Please enter a valid 6-digit code');
      return;
    }

    if (state.otpExpired) {
      showErrorSnackBar(
          'This verification code has expired. Please request a new one.');
      return;
    }

    state.isLoading = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: state.smsCode,
      );

      await signInWithCredential(credential);
    } catch (e) {
      state.isLoading = false;

      if (e is FirebaseAuthException &&
          (e.code == 'invalid-verification-code' ||
              e.code == 'session-expired')) {
        state.otpExpired = true;
        state.canResend = true;
        showErrorSnackBar(
            'Verification code has expired. Please request a new one.');
      } else {
        showErrorSnackBar('Failed to verify code: ${e.toString()}');
      }
    }
  }

  /// Sign in with phone credential
  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      state.isLoading = true;

      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (user.user != null) {
        print(
            '🚀 User authenticated successfully, about to call handleAuthStateChanges');
        handleAuthStateChanges();
        print('🚀 handleAuthStateChanges completed, about to show dialog');
        showAuthenticationDialog();

        final props = <String, Object>{
          'source': 'phone_input_screen',
          if (user.user?.uid != null) 'user_id': user.user!.uid,
          if (user.user?.phoneNumber != null)
            'phone': user.user!.phoneNumber ?? user.user!.email!,
        };
        PosthogService.instance.capture('login_success', properties: props);
      }

      state.isLoading = false;
    } catch (e) {
      hideAuthenticationDialog();
      state.isLoading = false;
      showErrorSnackBar('Authentication failed: ${e.toString()}');
    }
  }

  /// Show authentication loading dialog with fade animation
  void showAuthenticationDialog() {
    print(
        'Dialog state: _isAuthDialogShowing=${state.isAuthDialogShowing}, mounted=${context.mounted}, _showVerificationUI=${state.showVerificationUI}');

    if (state.isAuthDialogShowing || !context.mounted) return;

    state.isAuthDialogShowing = true;

    // Show the animated dialog with a global key for state access
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AnimatedLoadingDialog(
          key: _dialogKey,
          message: 'Finalizing authentication...',
          animationDuration: const Duration(milliseconds: 300),
        );
      },
    ).then((_) {
      state.isAuthDialogShowing = false;
    });
  }

  /// Hide authentication loading dialog with standard pop
  void hideAuthenticationDialog() {
    if (state.isAuthDialogShowing && context.mounted) {
      // If we have a reference to the animated dialog, use it for dismissal
      if (_dialogKey.currentState != null) {
        // This will trigger the fade-out animation before popping
        _dialogKey.currentState!.dismissWithAnimation();
      } else {
        // Fallback to standard pop if we don't have the dialog reference
        Navigator.of(context, rootNavigator: true).maybePop();
      }
      state.isAuthDialogShowing = false;
    }
  }

  /// Handles user authentication state changes and login flow
  Future<void> handleAuthStateChanges() async {
    print('⭐️ handleAuthStateChanges called');
    if (Platform.isWindows) {
      print('⭐️ Platform is Windows, returning early');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    print('⭐️ Current user: ${user?.uid ?? "null"}');
    if (user == null) {
      print('⭐️ User is null, returning early');
      return;
    }

    try {
      print('⭐️ About to call processUserLogin with user: ${user.uid}');
      final loginData = await state.loginViewModel.processUserLogin(user: user);
      print('⭐️ processUserLogin completed successfully');
      final Pin userPin = loginData['pin'];
      final IUser userData = loginData['user'];

      print('⭐️ About to call completeLoginProcess');
      await state.loginViewModel.completeLoginProcess(userPin, user: userData);
      print('⭐️ completeLoginProcess completed successfully');
    } catch (e, s) {
      print('⭐️ Error in handleAuthStateChanges: $e');
      // Handle the error with a smooth transition
      await handleErrorWithSmoothTransition(e, s);
    }
  }

  /// Handles errors with a smooth transition for dialog dismissal and navigation
  Future<void> handleErrorWithSmoothTransition(Object e, StackTrace s) async {
    // First determine if this error will lead to navigation
    final bool willNavigate = e is NeedSignUpException ||
        e is BusinessNotFoundException ||
        e is LoginChoicesException ||
        e is NoPaymentPlanFound;

    if (willNavigate) {
      // Use a fade transition for the dialog dismissal
      if (state.isAuthDialogShowing && context.mounted) {
        // For navigation cases, use a smoother dismissal
        await dismissDialogWithAnimation();
      }

      // Now handle the error which will trigger navigation
      state.loginViewModel.handleLoginError(e, s);
    } else {
      // For non-navigation errors, use standard dismissal
      hideAuthenticationDialog();
      state.loginViewModel.handleLoginError(e, s);
    }
  }

  /// Dismisses the dialog with a true fade animation for smoother transitions
  Future<void> dismissDialogWithAnimation() async {
    if (!state.isAuthDialogShowing || !context.mounted) return;

    // Set flag to prevent multiple dismissals
    state.isAuthDialogShowing = false;

    // If we have a reference to the animated dialog, use it for dismissal with animation
    if (_dialogKey.currentState != null) {
      // This will trigger the fade-out animation before popping
      await _dialogKey.currentState!.dismissWithAnimation();
    } else {
      // Fallback to standard pop with a delay if we don't have the dialog reference
      Navigator.of(context, rootNavigator: true).pop();

      // Wait for the animation to complete
      await Future.delayed(const Duration(milliseconds: 250));
    }
  }
}
