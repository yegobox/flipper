import 'package:flutter/material.dart';
import 'phone_auth_state.dart';

/// Service to handle timer functionality for OTP resend
class TimerService {
  final PhoneAuthState state;
  final Function(VoidCallback) setState;

  TimerService({
    required this.state,
    required this.setState,
  });

  /// Start the timer for OTP resend
  void startResendTimer() {
    // Initialize timer values
    setState(() {
      state.timerSeconds = 60;
      state.canResend = false;
      state.otpExpired = false;
    });

    // Create a recurring timer function that doesn't rely on recursion
    void decrementTimer() {
      setState(() {
        if (state.timerSeconds > 0) {
          state.timerSeconds--;
          
          // Schedule the next decrement
          Future.delayed(const Duration(seconds: 1), decrementTimer);
        } else {
          // Timer reached zero
          state.canResend = true;
          state.otpExpired = true; // Mark OTP as expired after timer ends
        }
      });
    }

    // Start the timer by scheduling the first decrement
    Future.delayed(const Duration(seconds: 1), decrementTimer);
  }
}
