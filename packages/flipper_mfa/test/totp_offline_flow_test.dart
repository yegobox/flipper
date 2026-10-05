import 'dart:io';

import 'package:flipper_mfa/flipper_mfa.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Proves the authenticator check runs on device: the server is asked only
/// for a secret this device doesn't have (or a stale one), never to verify.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final cacheDir = Directory.systemTemp.createTempSync('mfa_cache_test');
  // LocalMfaSecretCache resolves its folder through path_provider.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (_) async => cacheDir.path,
      );

  const secret = 'JBSWY3DPEHPK3PXPJBSWY3DPEHPK3PXP';
  const rotated = 'KRSXG5CTMVRXEZLUKRSXG5CTMVRXEZLU';
  final totp = TOTPService();
  var userSeq = 0;

  late int remoteCalls;
  late String? remoteValue;
  late MfaService mfa;
  late String userId;

  setUp(() {
    remoteCalls = 0;
    remoteValue = secret;
    userId = 'user-${DateTime.now().microsecondsSinceEpoch}-${userSeq++}';
    mfa = MfaService(
      remoteSecret: (_) async {
        remoteCalls++;
        return remoteValue;
      },
    );
  });

  tearDownAll(() => cacheDir.deleteSync(recursive: true));

  test('cached secret + correct code: verified with no server call', () async {
    await mfa.cacheSecretLocally(userId: userId, secret: secret);
    final outcome = await mfa.verifyTotpForUser(
      userId: userId,
      code: totp.generateTOTPCode(secret),
    );
    expect(outcome, TotpVerifyOutcome.valid);
    expect(remoteCalls, 0);
  });

  test('cached secret works with the server unreachable', () async {
    await mfa.cacheSecretLocally(userId: userId, secret: secret);
    final offline = MfaService(
      remoteSecret: (_) async {
        remoteCalls++;
        throw const SocketException('offline');
      },
    );
    expect(
      await offline.verifyTotpForUser(
        userId: userId,
        code: totp.generateTOTPCode(secret),
      ),
      TotpVerifyOutcome.valid,
    );
    expect(
      await offline.verifyTotpForUser(userId: userId, code: '000000'),
      TotpVerifyOutcome.invalidCode,
    );
  });

  test(
    'first sign-in on a device fetches the secret once, then local',
    () async {
      final code = totp.generateTOTPCode(secret);
      expect(
        await mfa.verifyTotpForUser(userId: userId, code: code),
        TotpVerifyOutcome.valid,
      );
      expect(remoteCalls, 1);
      expect(
        await mfa.verifyTotpForUser(userId: userId, code: code),
        TotpVerifyOutcome.valid,
      );
      expect(remoteCalls, 1, reason: 'second check must use the cache');
    },
  );

  test('no cached secret and server unreachable: unavailable', () async {
    final offline = MfaService(
      remoteSecret: (_) async => throw const SocketException('offline'),
    );
    expect(
      await offline.verifyTotpForUser(userId: userId, code: '123456'),
      TotpVerifyOutcome.unavailable,
    );
  });

  test('server has no secret for the user: notEnrolled', () async {
    remoteValue = null;
    expect(
      await mfa.verifyTotpForUser(userId: userId, code: '123456'),
      TotpVerifyOutcome.notEnrolled,
    );
    expect(remoteCalls, 1);
  });

  test('a later sign-in uses the secret prefetched after SMS', () async {
    expect(await mfa.prefetchAndCacheSecret(userId: userId, pin: 4321), isTrue);
    expect(remoteCalls, 1);
    final offline = MfaService(
      remoteSecret: (_) async => throw const SocketException('offline'),
    );
    expect(
      await offline.verifyTotpForUser(
        userId: userId,
        code: totp.generateTOTPCode(secret),
        pin: 4321,
      ),
      TotpVerifyOutcome.valid,
    );
  });

  test(
    're-enrolled elsewhere: a failed code refreshes the stale secret',
    () async {
      await mfa.cacheSecretLocally(userId: userId, secret: secret);
      remoteValue = rotated;
      expect(
        await mfa.verifyTotpForUser(
          userId: userId,
          code: totp.generateTOTPCode(rotated),
        ),
        TotpVerifyOutcome.valid,
      );
      expect(remoteCalls, 1);
      expect(
        await mfa.verifyTotpForUser(
          userId: userId,
          code: totp.generateTOTPCode(rotated),
        ),
        TotpVerifyOutcome.valid,
      );
      expect(remoteCalls, 1, reason: 'refreshed secret is now cached');
    },
  );

  test('localOnly never contacts the server', () async {
    expect(
      await mfa.verifyTotpForUser(
        userId: userId,
        code: '123456',
        localOnly: true,
      ),
      TotpVerifyOutcome.unavailable,
    );
    await mfa.cacheSecretLocally(userId: userId, secret: secret);
    expect(
      await mfa.verifyTotpForUser(
        userId: userId,
        code: '000000',
        localOnly: true,
      ),
      TotpVerifyOutcome.invalidCode,
    );
    expect(remoteCalls, 0);
  });

  test('prefetch is a no-op once the secret is cached', () async {
    await mfa.cacheSecretLocally(userId: userId, secret: secret);
    expect(await mfa.prefetchAndCacheSecret(userId: userId), isTrue);
    expect(remoteCalls, 0);
  });
}
