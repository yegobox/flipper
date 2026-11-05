import 'package:flipper_models/sync/utils/staff_roster_cache.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MemBox extends Fake implements LocalStorage {
  final Map<String, String> values = {};

  @override
  String? getBusinessId() => 'biz-1';

  @override
  String? readString({required String key}) => values[key];

  @override
  Future<void> writeString({
    required String key,
    required String value,
  }) async => values[key] = value;
}

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

    test('a blank row name falls back to the account name', () {
      for (final blank in [null, '', '  ']) {
        final owner = FlipperBaseModel.ownerStaffFromTenant(
          Tenant(id: 't-owner', name: blank, userId: 'u-owner'),
          businessUuid: 'biz-1',
          fallbackName: 'Murag',
        );
        expect(owner.name, 'Murag');
      }
      final named = FlipperBaseModel.ownerStaffFromTenant(
        Tenant(id: 't-owner', name: 'Shop owner', userId: 'u-owner'),
        businessUuid: 'biz-1',
        fallbackName: 'Murag',
      );
      expect(named.name, 'Shop owner');
    });
  });

  group('isPinOnlyStaff', () {
    test('true for rows built from pins (id is the user id)', () {
      expect(
        FlipperBaseModel.isPinOnlyStaff(
          Tenant(id: 'u-1', userId: 'u-1', pin: 1234),
        ),
        isTrue,
      );
    });

    test('offline, a cached PIN counts', () {
      final restored = decodeStaffRoster(
        encodeStaffRoster([
          Tenant(id: 'u-1', userId: 'u-1', pin: 1234),
        ], iterations: 2),
      ).single;
      expect(restored.pin, isNull);
      expect(FlipperBaseModel.isPinOnlyStaff(restored), isTrue);
    });

    test('false for the owner or signed-in stand-in without a PIN', () {
      expect(
        FlipperBaseModel.isPinOnlyStaff(Tenant(id: 'u-1', userId: 'u-1')),
        isFalse,
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

    test('missing from a fresh roster: removed, nothing to open', () {
      final fromBar = Tenant(id: 'u-z', name: 'Someone', userId: 'u-z');
      expect(
        FlipperBaseModel.resolveInitialEditTenant(loaded, fromBar, fresh: true),
        isNull,
      );
      expect(
        identical(
          FlipperBaseModel.resolveInitialEditTenant(
            loaded,
            loaded[0],
            fresh: true,
          ),
          loaded[0],
        ),
        isTrue,
      );
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

  group('selfTenantRowForBusiness', () {
    test("never another business's row", () {
      final rows = [
        {'id': 't-other', 'business_id': 'biz-2', 'user_id': 'u-1'},
        {'id': 't-legacy', 'business_id': null, 'user_id': 'u-1'},
      ];
      expect(
        FlipperBaseModel.selfTenantRowForBusiness(rows, 'biz-1')?['id'],
        't-legacy',
      );
      expect(
        FlipperBaseModel.selfTenantRowForBusiness([rows.first], 'biz-1'),
        isNull,
      );
      expect(
        FlipperBaseModel.selfTenantRowForBusiness([
          {'id': 't-own', 'business_id': 'biz-1'},
        ], 'biz-1')?['id'],
        't-own',
      );
    });
  });

  group('staff roster loading', () {
    late _MemBox box;

    setUp(() async {
      await getIt.reset();
      box = _MemBox();
      getIt.registerSingleton<LocalStorage>(box);
    });

    tearDown(() async {
      FlipperBaseModel.staffRosterLoader = FlipperBaseModel.fetchStaffRoster;
      await getIt.reset();
    });

    test('User Management loads the shared staff roster', () async {
      final roster = [
        Tenant(id: 'u-pin', name: 'Agent King', userId: 'u-pin', pin: 1234),
        Tenant(id: 't-c', name: 'Cashier', userId: 'u-c'),
      ];
      final asked = <String?>[];
      FlipperBaseModel.staffRosterLoader = ({String? businessId}) async {
        asked.add(businessId);
        return (tenants: roster, fresh: true);
      };
      final model = FlipperBaseModel();
      await model.loadTenants();
      expect(asked, ['biz-1']);
      expect(model.tenants, roster);
      expect(model.tenantsFresh, isTrue);

      FlipperBaseModel.staffRosterLoader = ({String? businessId}) async =>
          (tenants: roster, fresh: false);
      await model.loadTenants();
      expect(model.tenantsFresh, isFalse);
    });

    test('a removed person leaves the offline roster', () async {
      final key = staffRosterCacheKey('biz-1');
      box.values[key] = encodeStaffRoster([
        Tenant(id: 't-a', name: 'Agent', userId: 'u-a', pin: 1111),
        Tenant(id: 't-b', name: 'Boss', userId: 'u-b', pin: 2222),
      ], iterations: 2);

      await FlipperBaseModel.forgetStaffInRosterCache(
        'biz-1',
        Tenant(id: 't-a', userId: 'u-a'),
      );

      final left = decodeStaffRoster(box.values[key]);
      expect(left.map((t) => t.id), ['t-b']);
      expect(staffRosterPinMatches(left.single, '2222'), isTrue);
    });
  });
}
