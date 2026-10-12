import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/logout/dashboard_sign_out.dart';
import 'package:flipper_dashboard/web/pos_web_entry.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// The preference box, reduced to the writes the bridge makes.
class _FakeBox extends Fake implements LocalStorage {
  final values = <String, String>{};

  @override
  Future<void> writeString({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  dynamic remove({required String key}) => values.remove(key);
}

class _Services extends BranchServices {
  const _Services(this._box);

  final _FakeBox _box;

  @override
  LocalStorage get box => _box;
}

Tenant _tenant(String name, {List<String> businessIds = const []}) => Tenant(
  id: 'tenant-$name',
  name: name,
  phoneNumber: '',
  email: '',
  imageUrl: '',
  permissions: const [],
  branches: const [],
  businesses: [for (final id in businessIds) placeholderBusiness(id)],
  nfcEnabled: false,
  userId: 1,
  pin: 1234,
  isDefault: false,
  type: 'Admin',
);

void main() {
  late _FakeBox box;

  setUp(() => box = _FakeBox());

  /// Fills Books' session providers, then runs the bridge with a real
  /// [WidgetRef].
  Future<bool> seed(
    WidgetTester tester, {
    bool selectBranch = true,
    List<Tenant> tenants = const [],
    Map<String, dynamic>? apiPayload,
  }) async {
    late WidgetRef widgetRef;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [branchServicesProvider.overrideWithValue(_Services(box))],
        child: Consumer(
          builder: (context, ref, _) {
            widgetRef = ref;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    if (selectBranch) {
      widgetRef
          .read(selectedBusinessProvider.notifier)
          .set(placeholderBusiness('biz-1'));
      widgetRef
          .read(selectedBranchProvider.notifier)
          .set(placeholderBranch(id: 'branch-1', businessId: 'biz-1'));
    }
    widgetRef.read(sessionApiUserIdProvider.notifier).state = 'user-1';
    widgetRef.read(userProfileCacheProvider.notifier).state = UserProfile(
      id: 'user-1',
      phoneNumber: '+250788000000',
      token: '',
      tenants: tenants,
    );
    widgetRef.read(userProfileApiPayloadCacheProvider.notifier).state =
        apiPayload;
    final seeded = await tester.runAsync(
      () => seedPosContextFromWeb(widgetRef),
    );
    return seeded!;
  }

  testWidgets('hands Books\' business, branch and user to the POS', (
    tester,
  ) async {
    final seeded = await seed(tester, apiPayload: {'name': 'Aline Uwase'});

    expect(seeded, isTrue);
    expect(box.values['businessId'], 'biz-1');
    expect(box.values['branchId'], 'branch-1');
    expect(box.values['branchIdString'], 'branch-1');
    expect(box.values['userId'], 'user-1');
    expect(box.values['userPhone'], '+250788000000');
    // The POS header shows this rather than the raw user id.
    expect(box.values['userName'], 'Aline Uwase');
  });

  testWidgets('falls back to the tenant name for the selected business', (
    tester,
  ) async {
    await seed(
      tester,
      tenants: [
        _tenant('Other Shop Owner', businessIds: ['biz-9']),
        _tenant('Jean Bosco', businessIds: ['biz-1']),
      ],
    );

    expect(box.values['userName'], 'Jean Bosco');
  });

  testWidgets('drops the previous user\'s name when there is none', (
    tester,
  ) async {
    box.values['userName'] = 'Previous Cashier';

    await seed(tester);

    expect(box.values.containsKey('userName'), isFalse);
  });

  testWidgets('does nothing without a business and branch from Books', (
    tester,
  ) async {
    final seeded = await seed(tester, selectBranch: false);

    expect(seeded, isFalse);
    expect(box.values, isEmpty);
  });

  group('installDashboardSignOutHostExit', () {
    tearDown(() => dashboardSignOutHostExit = null);

    test('uninstall clears its own exit', () {
      final uninstall = installDashboardSignOutHostExit(() async {});

      expect(dashboardSignOutHostExit, isNotNull);
      uninstall();
      expect(dashboardSignOutHostExit, isNull);
    });

    test('uninstall leaves a newer host\'s exit in place', () {
      final uninstallOld = installDashboardSignOutHostExit(() async {});
      Future<void> newer() async {}
      final Future<void> Function() newerExit = newer;
      installDashboardSignOutHostExit(newerExit);

      uninstallOld();

      expect(dashboardSignOutHostExit, same(newerExit));
    });
  });
}
