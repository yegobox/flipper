import 'package:supabase_models/sync/ditto_sync_coordinator.dart';

typedef DittoAdapterRegistrar = Future<void> Function(
  DittoSyncCoordinator coordinator,
);

typedef DittoAdapterSeeder = Future<void> Function(
  DittoSyncCoordinator coordinator,
);

class _DittoSyncGeneratedEntry {
  _DittoSyncGeneratedEntry({
    required this.registrar,
    this.seeder,
  });

  final DittoAdapterRegistrar registrar;
  final DittoAdapterSeeder? seeder;
  bool seeded = false;
}

/// Holds build-generated Ditto adapter registrations.
class DittoSyncGeneratedRegistry {
  DittoSyncGeneratedRegistry._();

  static final List<_DittoSyncGeneratedEntry> _entries = [];

  /// Adds a generated registrar and returns the total number registered.
  static int register(
    DittoAdapterRegistrar registrar, {
    DittoAdapterSeeder? seed,
  }) {
    _entries.add(
      _DittoSyncGeneratedEntry(registrar: registrar, seeder: seed),
    );
    return _entries.length;
  }

  /// Applies all generated registrars against the given coordinator.
  static Future<void> apply(DittoSyncCoordinator coordinator) async {
    for (final entry in _entries) {
      await entry.registrar(coordinator);
    }
  }

  /// Runs all generated seeders once against the given coordinator.
  static Future<void> seed(DittoSyncCoordinator coordinator) async {
    for (final entry in _entries) {
      final seeder = entry.seeder;
      if (seeder != null && !entry.seeded) {
        await seeder(coordinator);
        entry.seeded = true;
      }
    }
  }

  /// Exposes a read-only view of the registered adapters (mainly for tests).
  static List<DittoAdapterRegistrar> get registrars =>
      List.unmodifiable(_entries.map((entry) => entry.registrar));
}
