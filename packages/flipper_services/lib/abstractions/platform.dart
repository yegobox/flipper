import 'package:flutter/material.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

abstract class LoginStandard {
  Future<bool> createAccountWithPhone(
      {required String phone, required BuildContext context});
  signInWithGoogle();
  signInWithApple(
      {required String appleClientId, required String appleRedirectUri});
  confirmOtpForWeb({required String otp});
  Future<void> verifyWithOtp();
}
