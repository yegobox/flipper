import 'package:flipper_models/providers/all_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

//

void main() {
  group('Access Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('featureAccess: should allow access when user has active access',
        () async {
      final now = DateTime.now();
      final access = Access(
        id: const Uuid().v4(),
        userId: 1,
        featureName: 'Sales',
        accessLevel: 'user',
        status: 'active',
        createdAt: now.subtract(const Duration(days: 1)),
        expiresAt: now.add(const Duration(days: 1)),
      );

      container.updateOverrides([
        userAccessesProvider(1).overrideWith((ref) async {
          return [access]; // Return a Future<List<Access>>
        }),
      ]);

      final hasAccess = container
          .read(featureAccessProvider(userId: 1, featureName: 'Sales'));
      expect(hasAccess, true);
    });

    //   test('featureAccess: should deny access when user has no access', () async {
    //     container.updateOverrides([
    //       userAccessesProvider(1).overrideWith(
    //         const AsyncValue.data([]),
    //       ),
    //     ]);

    //     final hasAccess = container.read(featureAccessProvider(userId: 1, featureName: 'Sales'));
    //     expect(hasAccess, false);
    //   });

    //   test('featureAccess: should deny access when access is expired', () async {
    //     final now = DateTime.now();
    //     final access = Access(
    //       id: const Uuid().v4(),
    //       userId: 1,
    //       featureName: 'Sales',
    //       accessLevel: 'user',
    //       status: 'active',
    //       createdAt: now.subtract(const Duration(days: 3)),
    //       expiresAt: now.subtract(const Duration(days: 1)), // Expired
    //     );

    //     container.updateOverrides([
    //       userAccessesProvider(1).overrideWith(
    //         AsyncValue.data([access]),
    //       ),
    //     ]);

    //     final hasAccess = container.read(featureAccessProvider(userId: 1, featureName: 'Sales'));
    //     expect(hasAccess, false);
    //   });

    //   test('featureAccess: should allow access to Tickets if user has elevated permission and requesting Tickets', () async {
    //     final now = DateTime.now();
    //     final access = Access(
    //       id: const Uuid().v4(),
    //       userId: 1,
    //       featureName: AppFeature.Tickets,
    //       accessLevel: 'admin',
    //       status: 'active',
    //       createdAt: now.subtract(const Duration(days: 1)),
    //       expiresAt: now.add(const Duration(days: 1)),
    //     );

    //     container.updateOverrides([
    //       userAccessesProvider(1).overrideWith(
    //         AsyncValue.data([access]),
    //       ),
    //     ]);

    //     final hasAccess = container.read(featureAccessProvider(userId: 1, featureName: AppFeature.Tickets));
    //     expect(hasAccess, true);
    //   });

    //   test('featureAccess: should deny access to Sales if user has elevated permission for Tickets but requesting Sales', () async {
    //     final now = DateTime.now();
    //     final access = Access(
    //       id: const Uuid().v4(),
    //       userId: 1,
    //       featureName: AppFeature.Tickets,
    //       accessLevel: 'admin',
    //       status: 'active',
    //       createdAt: now.subtract(const Duration(days: 1)),
    //       expiresAt: now.add(const Duration(days: 1)),
    //     );

    //     container.updateOverrides([
    //       userAccessesProvider(1).overrideWith(
    //         AsyncValue.data([access]),
    //       ),
    //     ]);

    //     final hasAccess = container.read(featureAccessProvider(userId: 1, featureName: 'Sales'));
    //     expect(hasAccess, false);
    //   });

    //   test('featureAccess: should allow access if user has explicit access even with elevated Tickets permission', () async {
    //     final now = DateTime.now();
    //     final ticketAccess = Access(
    //       id: const Uuid().v4(),
    //       userId: 1,
    //       featureName: AppFeature.Tickets,
    //       accessLevel: 'admin',
    //       status: 'active',
    //       createdAt: now.subtract(const Duration(days: 1)),
    //       expiresAt: now.add(const Duration(days: 1)),
    //     );
    //     final salesAccess = Access(
    //       id: const Uuid().v4(),
    //       userId: 1,
    //       featureName: 'Sales',
    //       accessLevel: 'user',
    //       status: 'active',
    //       createdAt: now.subtract(const Duration(days: 1)),
    //       expiresAt: now.add(const Duration(days: 1)),
    //     );

    //     container.updateOverrides([
    //       userAccessesProvider(1).overrideWith(
    //         AsyncValue.data([ticketAccess, salesAccess]),
    //       ),
    //     ]);

    //     final hasAccess = container.read(featureAccessProvider(userId: 1, featureName: 'Sales'));
    //     expect(hasAccess, true);
    //   });
  });
}
