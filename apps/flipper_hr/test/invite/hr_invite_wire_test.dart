import 'dart:convert';

import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/invite/data/hr_invite_wire.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('accountBody', () {
    test('sends the contact as phone_number, trimmed', () {
      expect(
        HrInviteWire.accountBody(contact: '  0788123456 '),
        {'phone_number': '0788123456'},
      );
    });

    test('an email goes in the same field — apihub accepts either', () {
      expect(
        HrInviteWire.accountBody(contact: 'aline@example.com'),
        {'phone_number': 'aline@example.com'},
      );
    });
  });

  group('membershipParams', () {
    Map<String, dynamic> params({HrRole role = HrRole.staff}) =>
        HrInviteWire.membershipParams(
          userId: 'user-1',
          name: 'Aline Uwase',
          contact: '0788123456',
          businessId: 'biz-1',
          branchId: 'branch-1',
          role: role,
        );

    test('grants exactly one HR access row', () {
      final accesses = params()['p_accesses'] as List;

      expect(accesses, hasLength(1));
      expect(accesses.single, {
        'feature_name': 'HR',
        'access_level': 'read',
        'status': 'active',
      });
    });

    test('a manager gets admin on the same feature, not a second one', () {
      final accesses = params(role: HrRole.manager)['p_accesses'] as List;

      expect(accesses, hasLength(1));
      expect((accesses.single as Map)['feature_name'], 'HR');
      expect((accesses.single as Map)['access_level'], 'admin');
    });

    test('never sends the Agent user type, which would be commission-only', () {
      expect(params()['p_user_type'], 'Cashier');
      expect(params(role: HrRole.manager)['p_user_type'], 'Admin');
      for (final role in HrRole.values) {
        expect(params(role: role)['p_user_type'], isNot('Agent'));
      }
    });

    test('always allows business login — an invitee must be able to sign in',
        () {
      for (final role in HrRole.values) {
        expect(params(role: role)['p_allow_business_login'], isTrue);
      }
    });

    test('carries the scope create_agent validates', () {
      final p = params();

      expect(p['p_user_id'], 'user-1');
      expect(p['p_business_id'], 'biz-1');
      expect(p['p_branch_id'], 'branch-1');
      expect(p['p_name'], 'Aline Uwase');
    });
  });

  group('pinBody', () {
    test('uses apihub camelCase and the business defaultApp', () {
      final body = HrInviteWire.pinBody(
        userId: 'user-1',
        phoneNumber: '+250788123456',
        businessId: 'biz-1',
        branchId: 'branch-1',
        ownerName: 'Aline Uwase',
      );

      expect(body, {
        'phoneNumber': '+250788123456',
        'userId': 'user-1',
        'branchId': 'branch-1',
        'businessId': 'biz-1',
        'defaultApp': 1,
        'ownerName': 'Aline Uwase',
      });
      // 2 would route this person to the POS social home.
      expect(body['defaultApp'], isNot(2));
    });
  });

  group('accountIdOf', () {
    test('reads a bare object', () {
      expect(
        HrInviteWire.accountIdOf(jsonDecode('{"id":"user-1"}')),
        'user-1',
      );
    });

    test('unwraps a data envelope', () {
      expect(
        HrInviteWire.accountIdOf(jsonDecode('{"data":{"id":"user-1"}}')),
        'user-1',
      );
    });

    test('unwraps a one-row list', () {
      expect(
        HrInviteWire.accountIdOf(jsonDecode('[{"id":"user-1"}]')),
        'user-1',
      );
    });

    test('unwraps a data-wrapped list', () {
      expect(
        HrInviteWire.accountIdOf(jsonDecode('{"data":[{"id":"user-1"}]}')),
        'user-1',
      );
    });

    test('falls back to user_id', () {
      expect(
        HrInviteWire.accountIdOf(jsonDecode('{"user_id":"user-1"}')),
        'user-1',
      );
    });

    test('is null for an empty list, an error object or a bare string', () {
      expect(HrInviteWire.accountIdOf(jsonDecode('[]')), isNull);
      expect(
        HrInviteWire.accountIdOf(jsonDecode('{"error":"not found"}')),
        isNull,
      );
      expect(HrInviteWire.accountIdOf('boom'), isNull);
    });

    test('a JSON null id reads as absent, not as the string "null"', () {
      expect(HrInviteWire.accountIdOf(jsonDecode('{"id":null}')), isNull);
    });

    test('a row that has its own data column is not mistaken for a wrapper', () {
      expect(
        HrInviteWire.accountIdOf(
          jsonDecode('{"id":"user-1","data":{"id":"other"}}'),
        ),
        'user-1',
      );
    });
  });

  group('accountPhoneOf', () {
    test('prefers phone_number and falls back to phone', () {
      expect(
        HrInviteWire.accountPhoneOf(
          jsonDecode('{"id":"u","phone_number":"+250788123456"}'),
        ),
        '+250788123456',
      );
      expect(
        HrInviteWire.accountPhoneOf(jsonDecode('{"id":"u","phone":"0788"}')),
        '0788',
      );
    });

    test('is null for an account with no phone on file', () {
      expect(HrInviteWire.accountPhoneOf(jsonDecode('{"id":"u"}')), isNull);
    });
  });

  group('pinOf', () {
    test('reads an integer pin as a string', () {
      expect(HrInviteWire.pinOf(jsonDecode('{"pin":246810}')), '246810');
    });

    test('keeps a leading zero when the pin comes back as a string', () {
      // The invitee has to type it, so a dropped zero is a login they cannot
      // complete.
      expect(HrInviteWire.pinOf(jsonDecode('{"pin":"012345"}')), '012345');
    });

    test('unwraps the shapes apihub uses interchangeably', () {
      expect(HrInviteWire.pinOf(jsonDecode('{"data":{"pin":1}}')), '1');
      expect(HrInviteWire.pinOf(jsonDecode('[{"pin":2}]')), '2');
    });

    test('accepts a bare number for deployments that answer with just that', () {
      expect(HrInviteWire.pinOf(jsonDecode('246810')), '246810');
      expect(HrInviteWire.pinOf(jsonDecode('[246810]')), '246810');
    });

    test('is null when there is no pin', () {
      expect(HrInviteWire.pinOf(jsonDecode('{"ok":true}')), isNull);
      expect(HrInviteWire.pinOf(null), isNull);
    });
  });

  group('tenantIdOf', () {
    test('reads the bare string PostgREST usually returns', () {
      expect(HrInviteWire.tenantIdOf('tenant-1'), 'tenant-1');
    });

    test('reads a one-row list', () {
      expect(HrInviteWire.tenantIdOf(['tenant-1']), 'tenant-1');
    });

    test('reads an object', () {
      expect(HrInviteWire.tenantIdOf({'id': 'tenant-1'}), 'tenant-1');
    });

    test('is null for an empty answer', () {
      expect(HrInviteWire.tenantIdOf(null), isNull);
      expect(HrInviteWire.tenantIdOf([]), isNull);
      expect(HrInviteWire.tenantIdOf(''), isNull);
    });
  });
}
