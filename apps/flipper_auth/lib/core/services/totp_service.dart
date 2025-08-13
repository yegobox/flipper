// lib/core/services/totp_service.dart
import 'package:otp/otp.dart';

class TOTPService {
  String generateTOTPCode(String secret, {DateTime? time}) {
    final timestamp = time ?? DateTime.now();
    return OTP.generateTOTPCodeString(
      secret,
      timestamp.millisecondsSinceEpoch ~/ 1000,
      interval: 30,
      algorithm: Algorithm.SHA1,
      length: 6,
    );
  }

  bool validateTOTP(String secret, String code,
      {int intervalSeconds = 30, int allowedDriftWindows = 1}) {
    final now = DateTime.now();
    for (int i = -allowedDriftWindows; i <= allowedDriftWindows; i++) {
      final windowTime = now.add(Duration(seconds: i * intervalSeconds));
      final expected = generateTOTPCode(secret, time: windowTime);
      if (expected == code) return true;
    }
    return false;
  }

  String generateSecret({int length = 32}) {
    return OTP.randomSecret();
  }
}
