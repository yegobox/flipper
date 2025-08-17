import 'package:totp_authenticator/totp_authenticator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MfaService {
  /// Generates a new TOTP secret.
  String generateSecret() {
    return TOTP.generateSecret();
  }

  /// Generates a QR code image for the given secret and issuer.
  ///
  /// [secret]: The TOTP secret.
  /// [issuer]: The issuer name (e.g., your application name).
  /// [accountName]: The user's account name.
  QrPainter generateQrCode({
    required String secret,
    required String issuer,
    required String accountName,
  }) {
    final totp = TOTP();
    final String otpUri = totp.generateQRCodeUrl(
      "Flipper",
      secret,
      issuer: issuer,
    );
    return QrPainter(
      data: otpUri,
      version: QrVersions.auto,
      gapless: true,
    );
  }

  /// Verifies a TOTP code against a secret.
  ///
  /// [secret]: The TOTP secret.
  /// [code]: The code entered by the user.
  bool verifyCode({
    required String secret,
    required String code,
  }) {
    final totp = TOTP();
    return totp.verifyCode(secret, code);
  }
}
