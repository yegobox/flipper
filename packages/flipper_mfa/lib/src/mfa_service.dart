import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_models/repositories/user_mfa_secret_repository.dart';
import 'package:flipper_mfa/src/local_mfa_secret_cache.dart';
import 'package:flipper_mfa/src/totp_service.dart';

/// Result of verifying a user TOTP against remote and/or local MFA secret.
enum TotpVerifyOutcome {
  /// Code matched the stored secret.
  valid,

  /// Secret was available; code did not match.
  invalidCode,

  /// Could not fetch remote secret and no local cache to verify against.
  unavailable,

  /// The server answered but has no authenticator secret for this user.
  notEnrolled,
}

class MfaService {
  MfaService({Future<String?> Function(String userId)? remoteSecret})
    : _remoteSecret = remoteSecret ?? _supabaseSecret;

  /// Where a missing or stale secret comes from; tests pass a fake.
  final Future<String?> Function(String userId) _remoteSecret;

  static Future<String?> _supabaseSecret(String userId) async {
    final repo = UserMfaSecretRepository(Supabase.instance.client);
    final record = await repo.getSecretByUserId(userId);
    return record?.secret;
  }

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
    final uri =
        'otpauth://totp/$encodedLabel'
        '?secret=$cleanSecret'
        '&issuer=$encodedIssuer'
        '&algorithm=SHA1'
        '&digits=6'
        '&period=30';

    return uri;
  }

  static final TOTPService _totp = TOTPService();

  /// Verifies a TOTP code against a secret, entirely on device.
  ///
  /// Uses the same [TOTPService] Flipper Auth generates codes with (RFC 6238,
  /// SHA1, 30s, 6 digits), allowing ±2 steps of clock drift.
  bool verifyCode({required String secret, required String code}) {
    try {
      final cleanSecret = secret.toUpperCase().replaceAll(
        RegExp(r'[^A-Z2-7]'),
        '',
      );
      final cleanCode = code.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanSecret.isEmpty || cleanCode.length != 6) {
        return false;
      }
      return _totp.validateTOTP(cleanSecret, cleanCode);
    } catch (e) {
      return false;
    }
  }

  TotpVerifyOutcome _verifyAgainstSecret(String secret, String code) {
    return verifyCode(secret: secret, code: code)
        ? TotpVerifyOutcome.valid
        : TotpVerifyOutcome.invalidCode;
  }

  /// Verify a TOTP code for [userId] on device.
  ///
  /// The code is checked against the secret cached on this device
  /// ([LocalMfaSecretCache]); a normal sign-in makes no network call. The
  /// server is contacted only to obtain a secret, never to verify:
  /// - no secret cached yet (first authenticator sign-in on this device), or
  /// - the code fails against the cached secret, in case MFA was re-enrolled
  ///   elsewhere and the cached secret is stale.
  ///
  /// When [localOnly] is true the server is never contacted.
  /// Optional [pin] is used as a secondary local-cache key.
  Future<TotpVerifyOutcome> verifyTotpForUser({
    required String userId,
    required String code,
    bool localOnly = false,
    int? pin,
  }) async {
    final cached = await LocalMfaSecretCache.read(userId, pin: pin);
    if (cached != null && cached.isNotEmpty) {
      final outcome = _verifyAgainstSecret(cached, code);
      if (outcome == TotpVerifyOutcome.valid || localOnly) return outcome;
      final fetched = await _fetchSecret(userId: userId, pin: pin);
      final fresh = fetched.secret;
      if (fresh == null) {
        // The server dropped the secret (MFA removed): say so, rather than
        // blaming the code. Unreachable keeps the cached-secret verdict.
        return fetched.reached ? TotpVerifyOutcome.notEnrolled : outcome;
      }
      if (fresh == cached) return outcome;
      return _verifyAgainstSecret(fresh, code);
    }

    if (localOnly) return TotpVerifyOutcome.unavailable;
    final fetched = await _fetchSecret(userId: userId, pin: pin);
    final fresh = fetched.secret;
    if (fresh == null) {
      return fetched.reached
          ? TotpVerifyOutcome.notEnrolled
          : TotpVerifyOutcome.unavailable;
    }
    return _verifyAgainstSecret(fresh, code);
  }

  Future<String?> _fetchAndCacheSecret({
    required String userId,
    int? pin,
  }) async => (await _fetchSecret(userId: userId, pin: pin)).secret;

  /// [reached] is true when the server answered, so a null [secret] means
  /// the user has no authenticator enrolled rather than a network failure.
  Future<({String? secret, bool reached})> _fetchSecret({
    required String userId,
    int? pin,
  }) async {
    final String? secret;
    try {
      secret = await _remoteSecret(userId).timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('MFA secret fetch failed for $userId: $e');
      return (secret: null, reached: false);
    }
    if (secret == null || secret.isEmpty) {
      return (secret: null, reached: true);
    }
    try {
      await LocalMfaSecretCache.save(userId: userId, secret: secret, pin: pin);
    } catch (e) {
      // Still verify this sign-in; the next one fetches again.
      debugPrint('MFA secret cache write failed: $e');
    }
    return (secret: secret, reached: true);
  }

  /// Seed the on-device secret after PIN validation so the authenticator
  /// check that follows needs no network. No-op when already cached.
  ///
  /// Never throws: callers fire it in the background with `unawaited`, so a
  /// cache failure here must not surface as an unhandled async error.
  Future<bool> prefetchAndCacheSecret({
    required String userId,
    int? pin,
  }) async {
    try {
      final cached = await LocalMfaSecretCache.read(userId, pin: pin);
      if (cached != null && cached.isNotEmpty) return true;
      return await _fetchAndCacheSecret(userId: userId, pin: pin) != null;
    } catch (e) {
      debugPrint('MFA secret prefetch failed: $e');
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
      final cleanSecret = secret.toUpperCase().replaceAll(
        RegExp(r'[^A-Z2-7]'),
        '',
      );
      return _totp.generateTOTPCode(cleanSecret);
    } catch (e) {
      return '';
    }
  }
}
