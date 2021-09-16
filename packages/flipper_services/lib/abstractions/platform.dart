import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStandard {
  Future<bool> createAccountWithPhone(
      {required String phone, required BuildContext context});
  signInWithGoogle();
  signInWithApple(
      {required String appleClientId, required String appleRedirectUri});
  confirmOtpForWeb({required String otp});
  Future<void> verifyWithOtp();
  Future<User?> getCurrentUserId();
}
