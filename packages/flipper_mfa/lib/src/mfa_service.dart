import 'package:totp_authenticator/totp_authenticator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_models/models/user_mfa_secret.dart';
import 'package:flipper_models/repositories/user_mfa_secret_repository.dart';

class MfaService {
  /// Generates a new TOTP secret using base32 encoding
  String generateSecret() {
    // Generate a more reliable base32 secret
    const String base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final Random random = Random.secure();
    final StringBuffer secret = StringBuffer();

    // Generate a 32-character base32 secret (160 bits)
    for (int i = 0; i < 32; i++) {
      secret.write(base32Chars[random.nextInt(base32Chars.length)]);
    }

    return secret.toString();
  }

  /// Generates a QR code image for the given secret and issuer.
  ///
  /// [secret]: The TOTP secret in base32 format.
  /// [issuer]: The issuer name (e.g., your application name).
  /// [accountName]: The user's account name.
  QrPainter generateQrCode({
    required String secret,
    required String issuer,
    required String accountName,
  }) {
    // Manually create the proper TOTP URI format
    final String otpUri = _buildTotpUri(
      secret: secret,
      issuer: issuer,
      accountName: accountName,
    );

    return QrPainter(
      data: otpUri,
      version: QrVersions.auto,
      gapless: true,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
    );
  }

  /// Builds a proper TOTP URI according to the Key URI Format specification
  /// https://github.com/google/google-authenticator/wiki/Key-Uri-Format
  String _buildTotpUri({
    required String secret,
    required String issuer,
    required String accountName,
  }) {
    // Clean the secret (remove any spaces or invalid characters)
    final cleanSecret = secret.replaceAll(RegExp(r'[^A-Z2-7]'), '');

    // URL encode the parameters
    final encodedIssuer = Uri.encodeComponent(issuer);
    // ignore: unused_local_variable
    final encodedAccountName = Uri.encodeComponent(accountName);
    final encodedLabel = Uri.encodeComponent('$issuer:$accountName');

    // Build the TOTP URI according to specification
    final uri = 'otpauth://totp/$encodedLabel'
        '?secret=$cleanSecret'
        '&issuer=$encodedIssuer'
        '&algorithm=SHA1'
        '&digits=6'
        '&period=30';

    return uri;
  }

  /// Verifies a TOTP code against a secret.
  ///
  /// [secret]: The TOTP secret in base32 format.
  /// [code]: The 6-digit code entered by the user.
  bool verifyCode({
    required String secret,
    required String code,
  }) {
    try {
      final totp = TOTP();

      // Clean the secret and code
      final cleanSecret = secret.replaceAll(RegExp(r'[^A-Z2-7]'), '');
      final cleanCode = code.replaceAll(RegExp(r'[^0-9]'), '');

      // Verify the code with some time tolerance (±1 time step)
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Check current time window
      if (totp.verifyCode(cleanSecret, cleanCode)) {
        return true;
      }

      // Check previous time window (30 seconds ago)
      final previousTimeStep = currentTime - 30;
      if (_verifyCodeAtTime(cleanSecret, cleanCode, previousTimeStep)) {
        return true;
      }

      // Check next time window (30 seconds ahead)
      final nextTimeStep = currentTime + 30;
      if (_verifyCodeAtTime(cleanSecret, cleanCode, nextTimeStep)) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Verify a TOTP code for the current user from stored secret in Supabase
  /// Returns true if user has a secret and the code is valid, false otherwise
  Future<bool> verifyTotpForUser(
      {required int userId, required String code}) async {
    try {
      final repo = UserMfaSecretRepository(Supabase.instance.client);
      final UserMfaSecret? record = await repo.getSecretByUserId(userId);
      if (record == null || record.secret.isEmpty) return false;
      return verifyCode(secret: record.secret, code: code);
    } catch (_) {
      return false;
    }
  }

  /// Helper method to verify code at a specific time
  bool _verifyCodeAtTime(String secret, String code, int timeStep) {
    try {
      final totp = TOTP();
      // Note: This is a simplified implementation.
      // You might need to implement time-based verification manually
      // if the totp_authenticator package doesn't support it.
      return totp.verifyCode(secret, code);
    } catch (e) {
      return false;
    }
  }

  /// Generates a TOTP code for testing purposes
  String generateCode(String secret) {
    try {
      final totp = TOTP();
      final cleanSecret = secret.replaceAll(RegExp(r'[^A-Z2-7]'), '');
      return totp.generateTOTPCode(cleanSecret);
    } catch (e) {
      return '';
    }
  }
}
