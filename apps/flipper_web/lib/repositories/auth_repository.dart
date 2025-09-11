
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  Future<bool> verifyPin(String pin) async {
    // API call to verify PIN will be added here
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency
    return pin == '1234'; // Simulate a successful PIN verification
  }

  Future<void> sendOtp() async {
    // API call to send OTP will be added here
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency
  }

  Future<bool> verifyOtp(String otp) async {
    // API call to verify OTP will be added here
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency
    return otp == '123456'; // Simulate a successful OTP verification
  }

  Future<bool> verifyTotp(String totp) async {
    // API call to verify TOTP will be added here
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency
    return totp == '654321'; // Simulate a successful TOTP verification
  }
}
