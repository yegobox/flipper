// lib/core/services/totp_service.dart
import 'dart:math';
import 'dart:typed_data';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';

class TOTPService {
  String generateTOTPCode(String secret, {DateTime? time, int intervalSeconds = 30}) {
    final timestamp = time ?? DateTime.now().toUtc();
    return OTP.generateTOTPCodeString(
      secret,
      timestamp.millisecondsSinceEpoch ~/ 1000,
      interval: intervalSeconds,
      algorithm: Algorithm.SHA1,
      length: 6,
    );
  }

  bool validateTOTP(String secret, String code,
      {int intervalSeconds = 30, int allowedDriftWindows = 1}) {
    // Sanitize parameters
    if (intervalSeconds <= 0) intervalSeconds = 30;
    if (allowedDriftWindows < 0) allowedDriftWindows = 1;
    
    final now = DateTime.now().toUtc();
    for (int i = -allowedDriftWindows; i <= allowedDriftWindows; i++) {
      final windowTime = now.add(Duration(seconds: i * intervalSeconds));
      final expected = generateTOTPCode(secret, time: windowTime, intervalSeconds: intervalSeconds);
      if (_constantTimeEquals(expected, code)) return true;
    }
    return false;
  }

  /// Constant-time string comparison to avoid timing attacks
  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  String generateSecret({int length = 32}) {
    final random = Random.secure();
    final bytesNeeded = (length * 5 / 8).ceil();
    final bytes = Uint8List(bytesNeeded);
    
    for (int i = 0; i < bytesNeeded; i++) {
      bytes[i] = random.nextInt(256);
    }
    
    final encoded = base32.encode(bytes);
    return encoded.replaceAll('=', '').substring(0, length);
  }
}
