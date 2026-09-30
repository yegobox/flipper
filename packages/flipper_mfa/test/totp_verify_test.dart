import 'package:flipper_mfa/flipper_mfa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // RFC 6238 Appendix B, SHA1 seed "12345678901234567890" in Base32.
  const rfcSecret = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';
  // Shape of secrets MfaService.generateSecret() hands to authenticator apps.
  const appSecret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';

  group('TOTPService (shared with Flipper Auth)', () {
    final totp = TOTPService();

    test('matches RFC 6238 SHA1 vectors (last 6 digits)', () {
      String at(int seconds) => totp.generateTOTPCode(
        rfcSecret,
        time: DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true),
      );
      expect(at(59), '287082');
      expect(at(1111111109), '081804');
      expect(at(1111111111), '050471');
      expect(at(1234567890), '005924');
      expect(at(2000000000), '279037');
    });
  });

  group('MfaService.verifyCode (on-device)', () {
    final mfa = MfaService();
    final totp = TOTPService();

    test('accepts the code an authenticator shows right now', () {
      final code = totp.generateTOTPCode(appSecret);
      expect(mfa.verifyCode(secret: appSecret, code: code), isTrue);
    });

    test('tolerates up to two 30s steps of phone clock drift', () {
      final now = DateTime.now().toUtc();
      for (final steps in [-2, -1, 1, 2]) {
        final code = totp.generateTOTPCode(
          appSecret,
          time: now.add(Duration(seconds: 30 * steps)),
        );
        expect(
          mfa.verifyCode(secret: appSecret, code: code),
          isTrue,
          reason: 'drift $steps steps',
        );
      }
    });

    test('rejects codes outside the drift window', () {
      final code = totp.generateTOTPCode(
        appSecret,
        time: DateTime.now().toUtc().add(const Duration(minutes: 5)),
      );
      expect(mfa.verifyCode(secret: appSecret, code: code), isFalse);
    });

    test('rejects malformed input instead of throwing', () {
      expect(mfa.verifyCode(secret: appSecret, code: '12345'), isFalse);
      expect(mfa.verifyCode(secret: '', code: '123456'), isFalse);
      expect(mfa.verifyCode(secret: '!!!!', code: '123456'), isFalse);
    });

    test('accepts lowercase / spaced secrets as users may paste them', () {
      final code = totp.generateTOTPCode(appSecret);
      expect(
        mfa.verifyCode(
          secret: 'jbsw y3dp ehpk 3pxp jbsw y3dp ehpk 3pxp',
          code: code,
        ),
        isTrue,
      );
    });
  });
}
