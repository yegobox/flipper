import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/access.model.dart';

final _now = DateTime(2026, 10, 3, 12);

Access _row({
  required String userType,
  required String accessLevel,
  String featureName = 'general',
  String status = 'active',
  DateTime? expiresAt,
  String? businessId,
}) => Access(
  userId: 'u1',
  businessId: businessId,
  featureName: featureName,
  userType: userType,
  accessLevel: accessLevel,
  status: status,
  expiresAt: expiresAt,
);

/// Rows create_agent writes for a user whose modules are at write, not admin.
List<Access> _writeOnlyRows(String userType) => [
  _row(userType: userType, accessLevel: 'read_write'),
  _row(userType: userType, accessLevel: 'write', featureName: 'Sales'),
  _row(userType: userType, accessLevel: 'write', featureName: 'Inventory'),
];

void main() {
  group('hasAccessLevel', () {
    test('Admin user type with only read/write rows passes an admin check', () {
      expect(
        hasAccessLevel(_writeOnlyRows('Admin'), UserType.ADMIN, _now),
        isTrue,
      );
    });

    test('Cashier with the same rows fails an admin check', () {
      expect(
        hasAccessLevel(_writeOnlyRows('Cashier'), UserType.ADMIN, _now),
        isFalse,
      );
    });

    test('Cashier with one module at admin still passes', () {
      final rows = [
        ..._writeOnlyRows('Cashier'),
        _row(
          userType: 'Cashier',
          accessLevel: 'admin',
          featureName: 'Add Product',
        ),
      ];
      expect(hasAccessLevel(rows, UserType.ADMIN, _now), isTrue);
    });

    test('Admin user type on an inactive row does not count', () {
      final rows = [
        _row(userType: 'Admin', accessLevel: 'write', status: 'inactive'),
      ];
      expect(hasAccessLevel(rows, UserType.ADMIN, _now), isFalse);
    });

    test('Admin user type on an expired row does not count', () {
      final rows = [
        _row(
          userType: 'Admin',
          accessLevel: 'write',
          expiresAt: _now.subtract(const Duration(days: 1)),
        ),
      ];
      expect(hasAccessLevel(rows, UserType.ADMIN, _now), isFalse);
    });

    test('Admin user type only widens admin checks, not write', () {
      final rows = [
        _row(userType: 'Admin', accessLevel: 'read', featureName: 'Sales'),
      ];
      expect(hasAccessLevel(rows, AccessLevel.WRITE, _now), isFalse);
    });

    test('user type match is case-insensitive', () {
      for (final type in ['ADMIN', 'admin']) {
        expect(
          hasAccessLevel(_writeOnlyRows(type), UserType.ADMIN, _now),
          isTrue,
          reason: type,
        );
      }
    });
  });

  group('isAdminUserType', () {
    const biz = 'b1';

    test('Admin user type of this business passes with no module grants', () {
      final rows = [
        _row(userType: 'Admin', accessLevel: 'read_write', businessId: biz),
      ];
      expect(isAdminUserType(rows, businessId: biz, now: _now), isTrue);
    });

    test('Admin of another business does not count', () {
      final rows = [
        _row(userType: 'Admin', accessLevel: 'read_write', businessId: 'b2'),
        _row(userType: 'Cashier', accessLevel: 'write', businessId: biz),
      ];
      expect(isAdminUserType(rows, businessId: biz, now: _now), isFalse);
    });

    test('no signed-in business means no override', () {
      final rows = [
        _row(userType: 'Admin', accessLevel: 'read_write', businessId: biz),
      ];
      expect(isAdminUserType(rows, businessId: null, now: _now), isFalse);
      expect(isAdminUserType(rows, businessId: '', now: _now), isFalse);
    });

    test('a module at the admin level does not make a cashier an Admin', () {
      final rows = [
        _row(
          userType: 'Cashier',
          accessLevel: 'admin',
          featureName: 'Add Product',
          businessId: biz,
        ),
      ];
      expect(isAdminUserType(rows, businessId: biz, now: _now), isFalse);
    });

    test('inactive or expired Admin rows do not count', () {
      final rows = [
        _row(
          userType: 'Admin',
          accessLevel: 'write',
          status: 'inactive',
          businessId: biz,
        ),
        _row(
          userType: 'Admin',
          accessLevel: 'write',
          expiresAt: _now.subtract(const Duration(days: 1)),
          businessId: biz,
        ),
      ];
      expect(isAdminUserType(rows, businessId: biz, now: _now), isFalse);
    });

    test('user type match is case-insensitive', () {
      final rows = [
        _row(userType: 'ADMIN', accessLevel: 'read', businessId: biz),
      ];
      expect(isAdminUserType(rows, businessId: biz, now: _now), isTrue);
    });
  });
}
