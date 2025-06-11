import 'package:flipper_models/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';

/// Represents the state for phone authentication
class PhoneAuthState extends ChangeNotifier {
  // Controllers and keys
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Authentication state
  String _smsCode = '';
  String _selectedCountryCode = '';
  bool _isLoading = false;
  bool _showVerificationUI = false;
  String? _verificationId;
  int? _resendToken;

  // For OTP verification
  bool _otpExpired = false;
  int _timerSeconds = 60;
  bool _canResend = false;

  // Dialog management
  bool _isAuthDialogShowing = false;

  // View model
  late LoginViewModel loginViewModel;

  // Getters
  String get smsCode => _smsCode;
  String get selectedCountryCode => _selectedCountryCode;
  bool get isLoading => _isLoading;
  bool get showVerificationUI => _showVerificationUI;
  String? get verificationId => _verificationId;
  int? get resendToken => _resendToken;
  bool get otpExpired => _otpExpired;
  int get timerSeconds => _timerSeconds;
  bool get canResend => _canResend;
  bool get isAuthDialogShowing => _isAuthDialogShowing;

  // Setters with notification
  set smsCode(String value) {
    _smsCode = value;
    notifyListeners();
  }

  set selectedCountryCode(String value) {
    _selectedCountryCode = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set showVerificationUI(bool value) {
    _showVerificationUI = value;
    notifyListeners();
  }

  set verificationId(String? value) {
    _verificationId = value;
    notifyListeners();
  }

  set resendToken(int? value) {
    _resendToken = value;
    notifyListeners();
  }

  set otpExpired(bool value) {
    _otpExpired = value;
    notifyListeners();
  }

  set timerSeconds(int value) {
    _timerSeconds = value;
    notifyListeners();
  }

  set canResend(bool value) {
    _canResend = value;
    notifyListeners();
  }

  set isAuthDialogShowing(bool value) {
    _isAuthDialogShowing = value;
    notifyListeners();
  }

  // Initialize with default country code
  PhoneAuthState(String countryCode) {
    _selectedCountryCode = countryCode;
    loginViewModel = LoginViewModel();
  }

  // Clean up resources
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
