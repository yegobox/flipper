import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';

/// Represents the state for phone authentication
class PhoneAuthState {
  // Controllers and keys
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Authentication state
  String smsCode = '';
  String selectedCountryCode = '';
  bool isLoading = false;
  bool showVerificationUI = false;
  String? verificationId;
  int? resendToken;
  
  // For OTP verification
  bool otpExpired = false;
  int timerSeconds = 60;
  bool canResend = false;
  
  // Dialog management
  bool isAuthDialogShowing = false;
  
  // View model
  late LoginViewModel loginViewModel;
  
  // Initialize with default country code
  PhoneAuthState(String countryCode) {
    selectedCountryCode = countryCode;
    loginViewModel = LoginViewModel();
  }
  
  // Clean up resources
  void dispose() {
    phoneController.dispose();
  }
}
