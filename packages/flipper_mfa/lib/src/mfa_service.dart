import 'package:totp_authenticator/totp_authenticator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_models/models/user_mfa_secret.dart';
import 'package:flipper_models/repositories/user_mfa_secret_repository.dart';
import 'package:flipper_mfa/src/local_mfa_secret_cache.dart';

/// Result of verifying a user TOTP against remote and/or local MFA secret.
enum TotpVerifyOutcome {
  /// Code matched the stored secret.
  valid,

  /// Secret was available; code did not match (or no secret anywhere).
  invalidCode,

  /// Could not fetch remote secret and no local cache to verify against.
  unavailable,
}

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
      final cleanSecret =
          secret.toUpperCase().replaceAll(RegExp(r'[^A-Z2-7]'), '');
      final cleanCode = code.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanSecret.isEmpty || cleanCode.length != 6) {
        return false;
      }
      // Library already allows ±1 time step (discrepancy); widen to ±2 for
      // desktop clock skew.
      return totp.verifyCode(cleanSecret, cleanCode, discrepancy: 2);
    } catch (e) {
      return false;
    }
  }

  TotpVerifyOutcome _verifyAgainstSecret(String secret, String code) {
    return verifyCode(secret: secret, code: code)
        ? TotpVerifyOutcome.valid
        : TotpVerifyOutcome.invalidCode;
  }

  Future<TotpVerifyOutcome> _verifyAgainstLocalCache(
    String userId,
    String code, {
    int? pin,
  }) async {
    final local = await LocalMfaSecretCache.read(userId, pin: pin);
    if (local == null || local.isEmpty) {
      return TotpVerifyOutcome.unavailable;
    }
    return _verifyAgainstSecret(local, code);
  }

  /// Verify a TOTP code for [userId].
  ///
  /// Online: loads secret from Supabase, caches it locally, then verifies.
  /// Offline / network error: verifies against [LocalMfaSecretCache] when present.
  ///
  /// When [localOnly] is true, skips Supabase and uses the local cache only.
  /// Optional [pin] is used as a secondary local-cache key.
  Future<TotpVerifyOutcome> verifyTotpForUser({
    required String userId,
    required String code,
    bool localOnly = false,
    int? pin,
  }) async {
    if (localOnly) {
      return _verifyAgainstLocalCache(userId, code, pin: pin);
    }

    try {
      final repo = UserMfaSecretRepository(Supabase.instance.client);
      final UserMfaSecret? record = await repo.getSecretByUserId(userId);
      if (record == null || record.secret.isEmpty) {
        final localOutcome =
            await _verifyAgainstLocalCache(userId, code, pin: pin);
        if (localOutcome != TotpVerifyOutcome.unavailable) {
          return localOutcome;
        }
        return TotpVerifyOutcome.unavailable;
      }
      await LocalMfaSecretCache.save(
        userId: userId,
        secret: record.secret,
        pin: pin,
      );
      return _verifyAgainstSecret(record.secret, code);
    } catch (_) {
      return _verifyAgainstLocalCache(userId, code, pin: pin);
    }
  }

  /// Fetch MFA secret from Supabase (if reachable) and persist locally.
  /// Call after PIN validation so offline TOTP works on the next attempt.
  Future<bool> prefetchAndCacheSecret({
    required String userId,
    int? pin,
  }) async {
    try {
      final repo = UserMfaSecretRepository(Supabase.instance.client);
      final record =
          await repo.getSecretByUserId(userId).timeout(const Duration(seconds: 5));
      if (record == null || record.secret.isEmpty) return false;
      await LocalMfaSecretCache.save(
        userId: userId,
        secret: record.secret,
        pin: pin,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Persist [secret] for [userId] on this device (call after MFA setup).
  Future<void> cacheSecretLocally({
    required String userId,
    required String secret,
    int? pin,
  }) {
    return LocalMfaSecretCache.save(userId: userId, secret: secret, pin: pin);
  }

  /// Probe Supabase MFA store (connectivity checkers often lie on web).
  Future<bool> canReachMfaStore(
    String userId, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final repo = UserMfaSecretRepository(Supabase.instance.client);
      await repo.getSecretByUserId(userId).timeout(timeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Generates a TOTP code for testing purposes
  String generateCode(String secret) {
    try {
      final totp = TOTP();
      final cleanSecret =
          secret.toUpperCase().replaceAll(RegExp(r'[^A-Z2-7]'), '');
      return totp.generateTOTPCode(cleanSecret);
    } catch (e) {
      return '';
    }
  }
}
