import 'package:supabase_models/sync/ditto_sync_coordinator.dart';

typedef DittoAdapterRegistrar = Future<void> Function(
  DittoSyncCoordinator coordinator,
);

/// Holds build-generated Ditto adapter registrations.
class DittoSyncGeneratedRegistry {
  DittoSyncGeneratedRegistry._();

  static final List<DittoAdapterRegistrar> _registrars = [];

  /// Adds a generated registrar and returns the total number registered.
  static int register(DittoAdapterRegistrar registrar) {
    _registrars.add(registrar);
    return _registrars.length;
  }

  /// Applies all generated registrars against the given coordinator.
  static Future<void> apply(DittoSyncCoordinator coordinator) async {
    for (final registrar in _registrars) {
      await registrar(coordinator);
    }
  }

  /// Exposes a read-only view of the registered adapters (mainly for tests).
  static List<DittoAdapterRegistrar> get registrars =>
      List.unmodifiable(_registrars);
}
