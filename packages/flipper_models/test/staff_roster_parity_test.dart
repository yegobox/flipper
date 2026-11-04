import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

void main() {
  group('ownerStaffFromTenant', () {
    test('keeps the account name User Management shows', () {
      final row = Tenant(
        id: 't-owner',
        name: 'Murag',
        email: 'owner@example.com',
        userId: 'u-owner',
        pin: 1234,
        type: 'Agent',
      );

      final owner = FlipperBaseModel.ownerStaffFromTenant(
        row,
        businessUuid: 'biz-1',
        ownerPhone: '+250700000000',
      );

      expect(owner.name, 'Murag');
      expect(owner.id, 't-owner');
      expect(owner.userId, 'u-owner');
      expect(owner.email, 'owner@example.com');
      expect(owner.pin, 1234);
      expect(owner.type, 'Agent');
      expect(owner.businessId, 'biz-1');
      expect(owner.phoneNumber, '+250700000000');
      expect(owner.allowBusinessLogin, isTrue);
    });

    test('prefers the row phone and business when set', () {
      final row = Tenant(
        id: 't-owner',
        name: 'Murag',
        userId: 'u-owner',
        phoneNumber: '+250711111111',
        businessId: 'biz-row',
      )..type = null;

      final owner = FlipperBaseModel.ownerStaffFromTenant(
        row,
        businessUuid: 'biz-1',
        ownerPhone: '+250700000000',
      );

      expect(owner.phoneNumber, '+250711111111');
      expect(owner.businessId, 'biz-row');
      expect(owner.type, 'Owner');
    });
  });

  group('isPinOnlyStaff', () {
    test('true for rows built from pins (id is the user id)', () {
      expect(
        FlipperBaseModel.isPinOnlyStaff(Tenant(id: 'u-1', userId: 'u-1')),
        isTrue,
      );
    });

    test('false for real tenant rows', () {
      expect(
        FlipperBaseModel.isPinOnlyStaff(Tenant(id: 't-1', userId: 'u-1')),
        isFalse,
      );
    });

    test('false without a user id', () {
      expect(FlipperBaseModel.isPinOnlyStaff(Tenant(id: 't-1')), isFalse);
      expect(
        FlipperBaseModel.isPinOnlyStaff(Tenant(id: '', userId: '')),
        isFalse,
      );
    });
  });

  group('resolveInitialEditTenant', () {
    final loaded = [
      Tenant(id: 't-a', name: 'Agent King', userId: 'u-a'),
      Tenant(id: 't-b', name: 'Cashier', userId: 'u-b'),
    ];

    test('picks the freshly loaded row for the same user', () {
      final fromBar = Tenant(
        id: 'u-b',
        name: 'Cashier (cached)',
        userId: 'u-b',
      );
      final picked = FlipperBaseModel.resolveInitialEditTenant(loaded, fromBar);
      expect(identical(picked, loaded[1]), isTrue);
    });

    test('falls back to the given row when the user is not loaded', () {
      final fromBar = Tenant(id: 'u-z', name: 'Someone', userId: 'u-z');
      expect(
        identical(
          FlipperBaseModel.resolveInitialEditTenant(loaded, fromBar),
          fromBar,
        ),
        isTrue,
      );
    });

    test('falls back to the given row when it has no user id', () {
      final fromBar = Tenant(id: 't-x', name: 'Orphan');
      expect(
        identical(
          FlipperBaseModel.resolveInitialEditTenant(loaded, fromBar),
          fromBar,
        ),
        isTrue,
      );
    });
  });
}
