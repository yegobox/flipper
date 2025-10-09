import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';

// Dummy model types for testing
class TestModel {}

class AnotherTestModel {}

class UnregisteredModel {}

void main() {
  test('seed invokes registered seeders exactly once', () async {
    final initialCount = DittoSyncGeneratedRegistry.registrars.length;
    var seedInvocations = 0;

    DittoSyncGeneratedRegistry.register(
      (_) async {},
      modelType: TestModel,
      seed: (_) async {
        seedInvocations++;
      },
    );

    expect(
      DittoSyncGeneratedRegistry.registrars.length,
      initialCount + 1,
    );

    final coordinator = DittoSyncCoordinator.instance;

    await DittoSyncGeneratedRegistry.seed(coordinator);
    await DittoSyncGeneratedRegistry.seed(coordinator);

    expect(seedInvocations, equals(1));
  });

  test('seedModel invokes seeder for specific model type', () async {
    var seedInvocations = 0;

    DittoSyncGeneratedRegistry.register(
      (_) async {},
      modelType: AnotherTestModel,
      seed: (_) async {
        seedInvocations++;
      },
    );

    final coordinator = DittoSyncCoordinator.instance;

    // Seed the specific model
    await DittoSyncGeneratedRegistry.seedModel<AnotherTestModel>(coordinator);
    expect(seedInvocations, equals(1));

    // Seeding the same model again should work (re-seeding allowed)
    await DittoSyncGeneratedRegistry.seedModel<AnotherTestModel>(coordinator);
    expect(seedInvocations, equals(2));
  });

  test('seedModel does nothing for unregistered model type', () async {
    final coordinator = DittoSyncCoordinator.instance;

    // Should not throw, just do nothing
    await DittoSyncGeneratedRegistry.seedModel<UnregisteredModel>(coordinator);
  });
}
