import 'dart:async';

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/sync/ditto_models_loader.g.dart';

/// Convenience registry for plugging default Ditto sync adapters.
class DittoSyncRegistry {
  DittoSyncRegistry._();

  static bool _registered = false;
  static void Function(Ditto?)? _dittoListener;

  static Future<void> registerDefaults() async {
    if (_registered) {
      debugPrint(
          '⚠️  DittoSyncRegistry.registerDefaults already called, skipping');
      return;
    }
    _registered = true;
    debugPrint('🔧 DittoSyncRegistry.registerDefaults starting...');

    // Force load all Ditto-enabled models to trigger static initializers
    debugPrint('📦 Loading Ditto models...');
    ensureDittoAdaptersLoaded();
    debugPrint('✅ Ditto models loaded');

    await DittoSyncGeneratedRegistry.apply(DittoSyncCoordinator.instance);
    debugPrint('✅ DittoSyncGeneratedRegistry.apply completed');

    _dittoListener ??= (Ditto? ditto) {
      debugPrint(
          '🔔 DittoSyncRegistry listener invoked with ditto: ${ditto != null ? ditto.deviceName : 'null'}');
      if (ditto != null) {
        debugPrint(
            '🚀 Ditto instance received, starting async seeding process...');
        unawaited(() async {
          try {
            debugPrint('⏳ Waiting for Repository to be ready...');
            await Repository.waitUntilReady();
            debugPrint('✅ Repository is ready');

            // Add delay before starting Ditto sync to let app fully initialize
            debugPrint(
                '⏱️  Delaying Ditto sync for 3 seconds to allow app initialization...');
            await Future.delayed(const Duration(seconds: 3));
            debugPrint('✅ Delay completed, starting Ditto sync');

            // Skip initial fetch on startup to prevent mass upserts
            await DittoSyncCoordinator.instance
                .setDitto(ditto, skipInitialFetch: true);

            if (kDebugMode) {
              debugPrint(
                'Ditto seeding started using device: ${ditto.deviceName}',
              );
            }
            debugPrint('🔄 Resetting seed state...');
            DittoSyncGeneratedRegistry.resetSeedState();
            debugPrint('🌱 Starting seed operation...');
            await DittoSyncGeneratedRegistry.seed(
              DittoSyncCoordinator.instance,
            );
            debugPrint('✅ Seed operation completed');
          } catch (error, stack) {
            if (kDebugMode) {
              debugPrint('Ditto seeding failed: $error\n$stack');
            }
          }
        }());
      } else {
        debugPrint('⚠️  Ditto instance is null, skipping seeding');
      }
    };

    debugPrint('➕ Adding Ditto listener to DittoService...');
    DittoService.instance.addDittoListener(_dittoListener!);
    debugPrint('✅ DittoSyncRegistry.registerDefaults completed');
  }

  /// Restores data for a single registered adapter supporting backup pulls.
  static Future<int> restoreBackupFor<T extends OfflineFirstWithSupabaseModel>({
    bool includeDependencies = true,
  }) async {
    if (!_registered) {
      await registerDefaults();
    }
    return DittoSyncCoordinator.instance.pullBackupFor<T>(
      includeDependencies: includeDependencies,
    );
  }

  /// Restores data for all (or a subset of) adapters supporting backup pulls
  /// and returns the number of records restored per type.
  static Future<Map<Type, int>> restoreBackupAll({
    List<Type>? types,
    bool includeDependencies = true,
  }) async {
    if (!_registered) {
      await registerDefaults();
    }
    return DittoSyncCoordinator.instance.pullBackupForAll(
      types: types,
      includeDependencies: includeDependencies,
    );
  }
}
