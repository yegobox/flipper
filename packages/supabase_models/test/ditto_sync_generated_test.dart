import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';

void main() {
  test('seed invokes registered seeders exactly once', () async {
    final initialCount = DittoSyncGeneratedRegistry.registrars.length;
    var seedInvocations = 0;

    DittoSyncGeneratedRegistry.register(
      (_) async {},
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
}
