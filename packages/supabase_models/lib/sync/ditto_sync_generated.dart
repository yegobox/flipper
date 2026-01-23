import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:flutter/foundation.dart' hide Category;

typedef DittoAdapterRegistrar = Future<void> Function(
  DittoSyncCoordinator coordinator,
);

typedef DittoAdapterSeeder = Future<void> Function(
  DittoSyncCoordinator coordinator,
);

class _DittoSyncGeneratedEntry {
  _DittoSyncGeneratedEntry({
    required this.registrar,
    required this.modelType,
    this.seeder,
    this.reset,
  });

  final DittoAdapterRegistrar registrar;
  final Type modelType;
  final DittoAdapterSeeder? seeder;
  final void Function()? reset;
  bool seeded = false;
}

/// Holds build-generated Ditto adapter registrations.
class DittoSyncGeneratedRegistry {
  DittoSyncGeneratedRegistry._();

  static final List<_DittoSyncGeneratedEntry> _entries = [];

  /// Adds a generated registrar and returns the total number registered.
  static int register(
    DittoAdapterRegistrar registrar, {
    required Type modelType,
    DittoAdapterSeeder? seed,
    void Function()? reset,
  }) {
    _entries.add(
      _DittoSyncGeneratedEntry(
        registrar: registrar,
        modelType: modelType,
        seeder: seed,
        reset: reset,
      ),
    );
    if (kDebugMode) {
      debugPrint(
          '📝 Registered adapter #${_entries.length} for ${modelType.toString()}');
    }
    return _entries.length;
  }

  /// Applies all generated registrars against the given coordinator.
  static Future<void> apply(DittoSyncCoordinator coordinator) async {
    if (kDebugMode) {
      debugPrint('🔧 Applying ${_entries.length} adapter(s) to coordinator...');
    }
    for (final entry in _entries) {
      await entry.registrar(coordinator);
    }
    if (kDebugMode) {
      debugPrint('✅ Applied all adapters');
    }
  }

  /// Runs all generated seeders once against the given coordinator.
  static Future<void> seed(DittoSyncCoordinator coordinator) async {
    if (kDebugMode) {
      debugPrint('🌱 Seeding ${_entries.length} adapter(s)...');
    }
    var seededCount = 0;
    for (final entry in _entries) {
      final seeder = entry.seeder;
      if (seeder != null && !entry.seeded) {
        if (kDebugMode) {
          debugPrint('🌱 Running seeder #${seededCount + 1}...');
        }
        await seeder(coordinator);
        entry.seeded = true;
        seededCount++;
      } else if (seeder != null && entry.seeded) {
        if (kDebugMode) {
          debugPrint('⏭️  Skipping already-seeded adapter');
        }
      }
    }
    if (kDebugMode) {
      debugPrint('✅ Seeding complete: ran $seededCount seeder(s)');
    }
  }

  /// Runs seeder for a specific model type.
  /// This is useful when you only want to seed one model at a time.
  static Future<void> seedModel<T>(DittoSyncCoordinator coordinator) async {
    if (kDebugMode) {
      debugPrint('🌱 Seeding model ${T.toString()}...');
    }

    _DittoSyncGeneratedEntry? targetEntry;
    for (final entry in _entries) {
      if (entry.modelType == T) {
        targetEntry = entry;
        break;
      }
    }

    if (targetEntry == null) {
      if (kDebugMode) {
        debugPrint('⚠️  No seeder found for model ${T.toString()}');
      }
      return;
    }

    final seeder = targetEntry.seeder;
    if (seeder == null) {
      if (kDebugMode) {
        debugPrint('⚠️  Model ${T.toString()} has no seeder defined');
      }
      return;
    }

    try {
      // Reset the seeded flag to allow re-seeding
      targetEntry.seeded = false;
      await seeder(coordinator);
      targetEntry.seeded = true;
      if (kDebugMode) {
        debugPrint('✅ Seeded model ${T.toString()}');
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('❌ Failed to seed model ${T.toString()}: $error\n$stack');
      }
      rethrow;
    }
  }

  /// Allows forcing all seeders to run again, e.g. after a new Ditto instance.
  static void resetSeedState() {
    if (kDebugMode) {
      debugPrint('🔄 Resetting seed state for ${_entries.length} adapter(s)');
    }
    for (final entry in _entries) {
      entry.seeded = false;
      entry.reset?.call();
    }
  }

  /// Exposes a read-only view of the registered adapters (mainly for tests).
  static List<DittoAdapterRegistrar> get registrars =>
      List.unmodifiable(_entries.map((entry) => entry.registrar));
}
