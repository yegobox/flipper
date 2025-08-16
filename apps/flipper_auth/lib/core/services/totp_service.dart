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

    try {
      // Use the processed secret, not the original
      final code = OTP.generateTOTPCodeString(
        processedSecret,
        timestamp.millisecondsSinceEpoch,
        interval: intervalSeconds,
        algorithm: algorithm,
        length: length,
        isGoogle: provider?.toLowerCase() == 'github',
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
    // Remove whitespace and convert to uppercase
    String cleanSecret = secret.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    if (debug) {
      print('Original secret: $secret');
      print('After cleanup: $cleanSecret');
      print('Secret length: ${cleanSecret.length}');
    }

    // GitHub secrets should only contain valid Base32 characters (A-Z, 2-7)
    if (provider?.toLowerCase() == 'github') {
      final beforeFilter = cleanSecret;
      cleanSecret = cleanSecret.replaceAll(RegExp(r'[^A-Z2-7]'), '');

      if (debug && beforeFilter != cleanSecret) {
        print('Filtered out invalid chars: $beforeFilter -> $cleanSecret');
      }

      // Ensure the secret length is appropriate (GitHub typically uses 16 or 32 chars)
      if (cleanSecret.length < 10) {
        throw ArgumentError(
            'GitHub secret too short after cleaning: ${cleanSecret.length} chars');
      }
    }

    if (debug) {
      print('Final clean secret: $cleanSecret (${cleanSecret.length} chars)');
    }

    // Validate that it's proper Base32 without adding padding first
    try {
      // Test decode without padding first
      base32.decode(cleanSecret);
      if (debug) {
        print('Secret decoded successfully without padding');
      }
    } catch (e) {
      if (debug) {
        print('Decode without padding failed: $e');
        print('Trying with padding...');
      }

      // Add padding if needed for proper Base32 decoding
      String paddedSecret = cleanSecret;
      while (paddedSecret.length % 8 != 0) {
        paddedSecret += '=';
      }

      try {
        final decoded = base32.decode(paddedSecret);
        if (debug) {
          print('Secret decoded successfully with padding: $paddedSecret');
          print('Decoded bytes length: ${decoded.length}');
        }
      } catch (e2) {
        throw ArgumentError('Invalid Base32 secret: $e2');
      }
    }

    // Return clean secret without padding (OTP library handles padding)
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

  /// Get remaining seconds until next TOTP code
  int getSecondsUntilNextCode({int intervalSeconds = _defaultInterval}) {
    final now = DateTime.now().toUtc();
    final currentWindow =
        now.millisecondsSinceEpoch ~/ (intervalSeconds * 1000);
    final nextWindowStart = (currentWindow + 1) * intervalSeconds * 1000;
    return ((nextWindowStart - now.millisecondsSinceEpoch) / 1000).floor();
  }
}
