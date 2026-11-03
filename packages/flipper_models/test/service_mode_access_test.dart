import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MemBox extends Fake implements LocalStorage {
  final Map<String, String> values = {};

  @override
  String? readString({required String key}) => values[key];

  @override
  Future<void> writeString({
    required String key,
    required String value,
  }) async => values[key] = value;
}

Map<String, dynamic> _row(
  String userId,
  String feature, {
  String status = 'active',
  String? userType,
  String? expiresAt,
}) => {
  'user_id': userId,
  'feature_name': feature,
  'status': status,
  'user_type': userType,
  'expires_at': expiresAt,
};

void main() {
  final now = DateTime(2026, 11, 3, 12);

  group('canUseServiceMode', () {
    test('nobody granted yet: open to everyone (grandfathered)', () {
      expect(
        canUseServiceMode(
          userId: 'u-1',
          isAdminOrOwner: false,
          grantedUserIds: const {},
        ),
        isTrue,
      );
    });

    test('once granted, only the granted users get in', () {
      expect(
        canUseServiceMode(
          userId: 'u-1',
          isAdminOrOwner: false,
          grantedUserIds: const {'u-1'},
        ),
        isTrue,
      );
      expect(
        canUseServiceMode(
          userId: 'u-2',
          isAdminOrOwner: false,
          grantedUserIds: const {'u-1'},
        ),
        isFalse,
      );
      expect(
        canUseServiceMode(
          userId: null,
          isAdminOrOwner: false,
          grantedUserIds: const {'u-1'},
        ),
        isFalse,
      );
    });

    test('admins and owners always get in', () {
      expect(
        canUseServiceMode(
          userId: 'u-admin',
          isAdminOrOwner: true,
          grantedUserIds: const {'u-1'},
        ),
        isTrue,
      );
    });
  });

  group('serviceModeGrantsFromRows', () {
    test('splits grants per mode and keeps them independent', () {
      final grants = serviceModeGrantsFromRows([
        _row('u-bar', AppFeature.BarMode),
        _row('u-hotel', AppFeature.HotelMode),
      ], now: now);

      expect(grants.isRestricted(AppFeature.BarMode), isTrue);
      expect(grants.allows(AppFeature.BarMode, 'u-bar'), isTrue);
      expect(grants.allows(AppFeature.BarMode, 'u-hotel'), isFalse);
      expect(grants.allows(AppFeature.HotelMode, 'u-hotel'), isTrue);
      expect(grants.allows(AppFeature.HotelMode, 'u-bar'), isFalse);
    });

    test('a grant to one mode leaves the other open', () {
      final grants = serviceModeGrantsFromRows([
        _row('u-bar', AppFeature.BarMode),
      ], now: now);

      expect(grants.isRestricted(AppFeature.HotelMode), isFalse);
      expect(grants.allows(AppFeature.HotelMode, 'anyone'), isTrue);
    });

    test('ignores inactive and expired grants', () {
      final grants = serviceModeGrantsFromRows([
        _row('u-off', AppFeature.BarMode, status: 'inactive'),
        _row(
          'u-old',
          AppFeature.BarMode,
          expiresAt: now.subtract(const Duration(days: 1)).toIso8601String(),
        ),
      ], now: now);

      // Nothing live: still grandfathered.
      expect(grants.isRestricted(AppFeature.BarMode), isFalse);
    });

    test('Admin user type rows and the owner are admins', () {
      final grants = serviceModeGrantsFromRows(
        [
          _row('u-bar', AppFeature.BarMode),
          _row('u-admin', AppFeature.Settings, userType: 'Admin'),
        ],
        ownerUserId: 'u-owner',
        now: now,
      );

      expect(grants.admins, {'u-admin', 'u-owner'});
      expect(grants.allows(AppFeature.BarMode, 'u-admin'), isTrue);
      expect(grants.allows(AppFeature.BarMode, 'u-owner'), isTrue);
      // A non-service module grant never counts for Bar.
      expect(grants.byFeature.containsKey(AppFeature.Settings), isFalse);
    });
  });

  group('nextExpiry', () {
    test('is the first expiry among the counted rows', () {
      final soon = now.add(const Duration(hours: 1));
      final later = now.add(const Duration(days: 2));
      final grants = serviceModeGrantsFromRows([
        _row('u-bar', AppFeature.BarMode, expiresAt: later.toIso8601String()),
        _row(
          'u-admin',
          AppFeature.Settings,
          userType: 'Admin',
          expiresAt: soon.toIso8601String(),
        ),
        // Neither a Bar/Hotel grant nor an admin: never re-read for it.
        _row(
          'u-x',
          AppFeature.Settings,
          expiresAt: now.add(const Duration(minutes: 1)).toIso8601String(),
        ),
      ], now: now);
      expect(grants.nextExpiry, soon);
    });

    test('is null when nothing counted expires', () {
      final grants = serviceModeGrantsFromRows([
        _row('u-bar', AppFeature.BarMode),
      ], now: now);
      expect(grants.nextExpiry, isNull);
    });
  });

  group('readAllServiceModeGrantPages', () {
    test('reads every page until a short one', () async {
      final ranges = <(int, int)>[];
      final all = List.generate(5, (i) => {'user_id': 'u-$i'});
      final rows = await readAllServiceModeGrantPages((from, to) async {
        ranges.add((from, to));
        return all.sublist(from, (to + 1).clamp(0, all.length));
      }, pageSize: 2);
      expect(rows, all);
      expect(ranges, [(0, 1), (2, 3), (4, 5)]);
    });

    test('an exactly full last page costs one empty read', () async {
      var reads = 0;
      final rows = await readAllServiceModeGrantPages((from, to) async {
        reads++;
        return from == 0 ? [{}, {}] : <Map<String, dynamic>>[];
      }, pageSize: 2);
      expect(rows, hasLength(2));
      expect(reads, 2);
    });
  });

  group('staffForServiceMode', () {
    final waiter = Tenant(id: 't-w', name: 'Waiter', userId: 'u-w');
    final cashier = Tenant(id: 't-c', name: 'Cashier', userId: 'u-c');
    final boss = Tenant(id: 't-b', name: 'Boss', userId: 'u-b', type: 'Admin');
    bool isAdmin(Tenant t) => t.type == 'Admin';

    test('grandfathered: the whole roster', () {
      expect(
        staffForServiceMode(
          [waiter, cashier, boss],
          const ServiceModeGrants(),
          AppFeature.BarMode,
          isAdminOrOwner: isAdmin,
        ),
        [waiter, cashier, boss],
      );
    });

    test('granted: only granted staff plus admins', () {
      final grants = serviceModeGrantsFromRows([
        _row('u-w', AppFeature.BarMode),
      ], now: now);
      expect(
        staffForServiceMode(
          [waiter, cashier, boss],
          grants,
          AppFeature.BarMode,
          isAdminOrOwner: isAdmin,
        ),
        [waiter, boss],
      );
    });
  });

  group('fetchServiceModeGrants', () {
    test('caches a fetch and serves it when the network fails', () async {
      final box = _MemBox();
      final online = await fetchServiceModeGrants(
        businessId: 'biz-1',
        box: box,
        now: () => now,
        load: (_) async =>
            (rows: [_row('u-bar', AppFeature.BarMode)], ownerUserId: 'u-o'),
      );
      expect(online.allows(AppFeature.BarMode, 'u-x'), isFalse);

      final offline = await fetchServiceModeGrants(
        businessId: 'biz-1',
        box: box,
        now: () => now,
        load: (_) async => throw Exception('offline'),
      );
      expect(offline.allows(AppFeature.BarMode, 'u-bar'), isTrue);
      expect(offline.allows(AppFeature.BarMode, 'u-x'), isFalse);
      expect(offline.allows(AppFeature.BarMode, 'u-o'), isTrue);
      expect(
        cachedServiceModeGrants(
          businessId: 'biz-1',
          box: box,
          now: () => now,
        )?.isRestricted(AppFeature.BarMode),
        isTrue,
      );
    });

    test('no network and no cache: open, so a desk never goes dark', () async {
      final grants = await fetchServiceModeGrants(
        businessId: 'biz-1',
        box: _MemBox(),
        load: (_) async => throw Exception('offline'),
      );
      expect(grants.isRestricted(AppFeature.BarMode), isFalse);
      expect(grants.isRestricted(AppFeature.HotelMode), isFalse);
    });

    test('a slow server falls back to the cache', () async {
      final box = _MemBox();
      box.values[serviceModeGrantsCacheKey('biz-1')] =
          encodeServiceModeGrantRows([_row('u-hotel', AppFeature.HotelMode)]);

      final grants = await fetchServiceModeGrants(
        businessId: 'biz-1',
        box: box,
        now: () => now,
        timeout: const Duration(milliseconds: 10),
        load: (_) => Future.delayed(
          const Duration(seconds: 1),
          () => (rows: <Map<String, dynamic>>[], ownerUserId: null),
        ),
      );
      expect(grants.allows(AppFeature.HotelMode, 'u-hotel'), isTrue);
      expect(grants.allows(AppFeature.HotelMode, 'u-x'), isFalse);
    });

    test('the cache key stays under the allow-listed roster prefix', () {
      expect(serviceModeGrantsCacheKey('biz-1'), startsWith('staff_roster_'));
    });
  });
}
