// lib/core/services/totp_service.dart
import 'dart:math';
import 'dart:typed_data';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';

class TOTPService {
  static const int _defaultInterval = 30;
  static const int _defaultLength = 6;
  static const int _defaultDriftWindows = 2;
  static const Algorithm _defaultAlgorithm = Algorithm.SHA1;

  /// Generate a TOTP code for a given Base32 secret
  String generateTOTPCode(
    String secret, {
    DateTime? time,
    int intervalSeconds = _defaultInterval,
    int length = _defaultLength,
    Algorithm algorithm = _defaultAlgorithm,
    String? provider,
    int timeAdjustmentSeconds = 0,
    bool debug = false,
  }) {
    if (secret.isEmpty) throw ArgumentError('Secret cannot be empty');

    final processedSecret = _processSecret(secret, provider, debug: debug);

    final timestamp = (time ?? DateTime.now().toUtc())
        .add(Duration(seconds: timeAdjustmentSeconds));

    if (debug) {
      _debugLog(processedSecret, timestamp, intervalSeconds, algorithm, length);
    }

    try {
      final code = OTP.generateTOTPCodeString(
        secret,
        timestamp.millisecondsSinceEpoch,
        interval: intervalSeconds,
        algorithm: algorithm,
        length: length,
        isGoogle: false, // standard TOTP for GitHub
      );

      if (debug) print('Generated TOTP code: $code');
      return code;
    } catch (e) {
      throw Exception('Failed to generate TOTP code: $e');
    }
  }

  /// Validate a TOTP code with drift window support
  bool validateTOTP(
    String secret,
    String code, {
    int intervalSeconds = _defaultInterval,
    int length = _defaultLength,
    Algorithm algorithm = _defaultAlgorithm,
    int allowedDriftWindows = _defaultDriftWindows,
    String? provider,
    int timeAdjustmentSeconds = 0,
    bool debug = false,
  }) {
    if (secret.isEmpty || code.isEmpty) return false;
    allowedDriftWindows = max(allowedDriftWindows, 0);

    final now =
        DateTime.now().toUtc().add(Duration(seconds: timeAdjustmentSeconds));

    for (int i = -allowedDriftWindows; i <= allowedDriftWindows; i++) {
      final windowTime = now.add(Duration(seconds: i * intervalSeconds));
      final expected = generateTOTPCode(
        secret,
        time: windowTime,
        intervalSeconds: intervalSeconds,
        length: length,
        algorithm: algorithm,
        provider: provider,
        debug: debug && i == 0,
      );

      if (_constantTimeEquals(expected, code)) return true;
    }

    return false;
  }

  /// Process secret to ensure valid Base32
  String _processSecret(String secret, String? provider, {bool debug = false}) {
    String cleanSecret = secret.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    // Only remove invalid Base32 chars for GitHub
    if (provider?.toLowerCase() == 'github') {
      cleanSecret = cleanSecret.replaceAll(RegExp(r'[^A-Z2-7]'), '');
    }

    // Validate
    try {
      base32.decode(cleanSecret);
      if (debug)
        print('Secret is valid Base32 with length: ${cleanSecret.length}');
    } catch (e) {
      throw ArgumentError('Invalid Base32 secret: $e');
    }

    return cleanSecret;
  }

  /// Constant-time string comparison to prevent timing attacks
  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++)
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    return result == 0;
  }

  /// Generate a cryptographically secure Base32 secret
  String generateSecret({int length = 32}) {
    if (length <= 0) throw ArgumentError('Length must be positive');

    final random = Random.secure();
    final bytesNeeded = (length * 5 / 8).ceil();
    final bytes = Uint8List(bytesNeeded);
    for (int i = 0; i < bytesNeeded; i++) bytes[i] = random.nextInt(256);

    final encoded = base32.encode(bytes).replaceAll('=', '');
    return encoded.substring(0, min(length, encoded.length));
  }

  /// Debug helper
  void _debugLog(String secret, DateTime timestamp, int interval,
      Algorithm algorithm, int length) {
    print('=== TOTP Debug Info ===');
    print('Secret: ${_truncateSecret(secret)} (${secret.length} chars)');
    print('Timestamp: ${timestamp.toIso8601String()}');
    print('Unix ms: ${timestamp.millisecondsSinceEpoch}');
    print('Interval: $interval s');
    print('Algorithm: $algorithm');
    print('Length: $length');
    print('=======================');
  }

  String _truncateSecret(String secret) {
    if (secret.length <= 8) return secret;
    return '${secret.substring(0, 4)}...${secret.substring(secret.length - 4)}';
  }

  /// Get remaining seconds until next TOTP code
  int getSecondsUntilNextCode({int intervalSeconds = _defaultInterval}) {
    final now = DateTime.now().toUtc();
    final currentWindow =
        now.millisecondsSinceEpoch ~/ (intervalSeconds * 1000);
    final nextWindowStart = (currentWindow + 1) * intervalSeconds * 1000;
    return ((nextWindowStart - now.millisecondsSinceEpoch) / 1000).floor();
  }
}
