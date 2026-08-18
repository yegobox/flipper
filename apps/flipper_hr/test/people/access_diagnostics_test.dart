import 'dart:convert';

import 'package:flipper_hr/features/people/data/access_diagnostics.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds an unsigned JWT-shaped string. Not a real token — the decoder does not
/// verify, and the tests must never carry credentials.
String fakeJwt(Map<String, dynamic> claims) {
  String seg(Map<String, dynamic> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  return '${seg({'alg': 'HS256'})}.${seg(claims)}.signature';
}

void main() {
  group('decodeJwtClaims', () {
    test('reads the payload of a well-formed token', () {
      final claims = decodeJwtClaims(
        fakeJwt({'role': 'authenticated', 'sub': 'abc', 'phone': '250700000000'}),
      );

      expect(claims['role'], 'authenticated');
      expect(claims['sub'], 'abc');
      expect(claims['phone'], '250700000000');
    });

    test('handles payloads whose length needs base64 padding', () {
      // Vary the claim length so every remainder mod 4 is exercised.
      for (final pad in ['a', 'ab', 'abc', 'abcd']) {
        final claims = decodeJwtClaims(fakeJwt({'role': pad}));
        expect(claims['role'], pad, reason: 'padding for "$pad"');
      }
    });

    test('returns no claims for anything malformed', () {
      expect(decodeJwtClaims(''), isEmpty);
      expect(decodeJwtClaims('not-a-jwt'), isEmpty);
      expect(decodeJwtClaims('a.!!!!.c'), isEmpty);
      expect(decodeJwtClaims('a.${base64Url.encode(utf8.encode('[]'))}.c'),
          isEmpty);
    });
  });

  group('maskIdentifier', () {
    test('keeps the last four digits of a phone', () {
      expect(maskIdentifier('250700001234'), 'present (…1234)');
    });

    test('keeps the domain of an email, which is what identifies the key type',
        () {
      expect(
        maskIdentifier('250700001234@flipper.rw'),
        'present (…1234@flipper.rw)',
      );
      expect(
        maskIdentifier('someone@gmail.com'),
        'present (…eone@gmail.com)',
      );
    });

    test('does not pad a short value out to a guessable length', () {
      expect(maskIdentifier('12'), 'present (…12)');
    });

    test('reports absence distinctly from a value', () {
      expect(maskIdentifier(null), 'absent');
      expect(maskIdentifier(''), 'absent');
      expect(maskIdentifier('   '), 'absent');
    });
  });

  group('shortenId', () {
    test('truncates to the first eight characters', () {
      expect(shortenId('11111111-2222-3333-4444-555555555555'), '11111111…');
      expect(shortenId('short'), 'short');
      expect(shortenId(null), '—');
    });
  });

  group('describeSessionClaims', () {
    test('flags a missing role rather than showing a blank', () {
      expect(describeSessionClaims(const {})['role'], 'MISSING');
    });

    test('masks phone and email but shows the role plainly', () {
      final described = describeSessionClaims(const {
        'role': 'authenticated',
        'sub': '11111111-2222-3333-4444-555555555555',
        'phone': '250700001234',
        'email': '250700001234@flipper.rw',
      });

      expect(described['role'], 'authenticated');
      expect(described['sub'], '11111111…');
      expect(described['phone'], 'present (…1234)');
      expect(described['email'], 'present (…1234@flipper.rw)');
    });
  });

  group('AccessReport', () {
    const authenticated = {
      'role': 'authenticated',
      'sub': '11111111…',
      'phone': 'present (…1234)',
      'email': 'absent',
    };

    test('an anonymous request is called out as unauthenticated', () {
      final report = AccessReport(
        hasSession: false,
        claims: describeSessionClaims(const {}),
      );

      expect(report.toReport(), contains('MISSING — requests are anonymous'));
      expect(report.toReport(), contains('not authenticated'));
    });

    test('a session whose role is not authenticated is treated the same', () {
      final report = AccessReport(
        hasSession: true,
        claims: const {'role': 'anon'},
      );

      expect(report.toReport(), contains('not authenticated'));
    });

    test('a missing hr_whoami points at migration 0002', () {
      const report = AccessReport(
        hasSession: true,
        claims: authenticated,
        error: 'function public.hr_whoami() does not exist',
      );

      expect(report.toReport(), contains('apply migration 0002'));
    });

    test('an unresolvable identity points at the users row', () {
      const report = AccessReport(
        hasSession: true,
        claims: authenticated,
        whoami: {'identity_keys': [], 'business_ids': []},
      );

      expect(report.identityKeys, isEmpty);
      expect(report.toReport(), contains('cannot tie this session'));
    });

    test('an identity that owns nothing points at businesses.user_id', () {
      const report = AccessReport(
        hasSession: true,
        claims: authenticated,
        whoami: {'identity_keys': ['user-1'], 'business_ids': []},
      );

      expect(report.toReport(), contains('owns no business'));
    });

    test('a fully resolving caller points at the policies themselves', () {
      const report = AccessReport(
        hasSession: true,
        claims: authenticated,
        whoami: {
          'identity_keys': ['user-1'],
          'business_ids': ['biz-1'],
        },
      );

      expect(report.businessIds, ['biz-1']);
      expect(report.toReport(), contains('check pg_policies'));
    });

    test('the report lists both server-side sets for comparison', () {
      const report = AccessReport(
        hasSession: true,
        claims: authenticated,
        whoami: {
          'identity_keys': ['a', 'b'],
          'business_ids': ['biz'],
        },
      );
      final text = report.toReport();

      expect(text, contains('server identity_keys: a, b'));
      expect(text, contains('server business_ids: biz'));
    });

    test('a malformed whoami payload does not throw', () {
      const report = AccessReport(
        hasSession: true,
        claims: authenticated,
        whoami: {'identity_keys': 'not-a-list'},
      );

      expect(report.identityKeys, isEmpty);
      expect(report.businessIds, isEmpty);
    });

    test('the report carries no token and no unmasked identifier', () {
      final report = AccessReport(
        hasSession: true,
        claims: describeSessionClaims(const {
          'role': 'authenticated',
          'sub': '11111111-2222-3333-4444-555555555555',
          'phone': '250700001234',
          'email': '250700001234@flipper.rw',
        }),
        whoami: const {'identity_keys': ['user-1'], 'business_ids': ['biz']},
      );
      final text = report.toReport();

      expect(text, isNot(contains('250700001234')));
      expect(text, isNot(contains('signature')));
    });
  });
}
