// lib/core/services/totp_service.dart
import 'package:otp/otp.dart';

class TOTPService {
  String generateTOTPCode(String secret) {
    return OTP.generateTOTPCodeString(
      'secret',
      Duration(seconds: 30).inSeconds,
      interval: 30,
      algorithm: Algorithm.SHA1,
      length: 6,
    );
  }

  bool validateTOTP(String secret, String code) {
    final now = DateTime.now();
    final validCode = generateTOTPCode(secret);
    return code == validCode;
  }

  String generateSecret() {
    return OTP.generateTOTPCodeString(
      'secret',
      Duration(seconds: 30).inSeconds,
      interval: 30,
      algorithm: Algorithm.SHA1,
      length: 32,
    );
  }
}
