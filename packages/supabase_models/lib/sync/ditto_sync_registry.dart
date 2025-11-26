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
        debugPrint('🚀 Ditto instance received, initializing coordinator...');
        unawaited(() async {
          try {
            debugPrint(
                '⏳ Waiting for Repository to be ready (timeout: 10s)...');

            // Add timeout to prevent indefinite blocking
            await Repository.waitUntilReady().timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                debugPrint(
                    '⚠️  Repository.waitUntilReady() timed out after 10 seconds');
                throw TimeoutException(
                  'Repository initialization timed out',
                  const Duration(seconds: 10),
                );
              },
            );

            debugPrint('✅ Repository is ready');

            debugPrint('🔄 Setting Ditto instance in coordinator...');
            await DittoSyncCoordinator.instance
                .setDitto(ditto, skipInitialFetch: true);
            debugPrint('✅ Ditto coordinator initialized successfully');

            if (kDebugMode) {
              debugPrint(
                'Ditto coordinator initialized using device: ${ditto.deviceName}',
              );
              debugPrint(
                  '💡 Call DittoSyncRegistry.seedAll() or DittoSyncRegistry.seedModel<T>() to seed data');
            }
          } on TimeoutException catch (e) {
            debugPrint('❌ Timeout during Ditto initialization: $e');
            debugPrint(
                '⚠️  App will continue without Ditto sync functionality');
          } catch (error, stack) {
            if (kDebugMode) {
              debugPrint('❌ Ditto initialization failed: $error\n$stack');
              debugPrint(
                  '⚠️  App will continue without Ditto sync functionality');
            }
          }
        }());
      } else {
        debugPrint('⚠️  Ditto instance is null, coordinator not initialized');
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

  /// Manually trigger seeding for all registered adapters.
  /// This should be called by the user when they want to seed data to Ditto.
  ///
  /// Example:
  /// ```dart
  /// await DittoSyncRegistry.seedAll();
  /// ```
  static Future<void> seedAll() async {
    if (!_registered) {
      await registerDefaults();
    }

    if (kDebugMode) {
      debugPrint('🌱 Manual seed operation started for all models...');
    }

    try {
      DittoSyncGeneratedRegistry.resetSeedState();
      await DittoSyncGeneratedRegistry.seed(
        DittoSyncCoordinator.instance,
      );
      if (kDebugMode) {
        debugPrint('✅ Manual seed operation completed successfully');
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('❌ Manual seed operation failed: $error\n$stack');
      }
      rethrow;
    }
  }

  /// Manually trigger seeding for a specific model type.
  /// This should be called by the user when they want to seed data for a specific model.
  ///
  /// Example:
  /// ```dart
  /// await DittoSyncRegistry.seedModel<Product>();
  /// ```
  static Future<void>
      seedModel<T extends OfflineFirstWithSupabaseModel>() async {
    if (!_registered) {
      await registerDefaults();
    }

    if (kDebugMode) {
      debugPrint('🌱 Manual seed operation started for ${T.toString()}...');
    }

    try {
      await DittoSyncGeneratedRegistry.seedModel<T>(
        DittoSyncCoordinator.instance,
      );
      if (kDebugMode) {
        debugPrint('✅ Manual seed operation completed for ${T.toString()}');
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('❌ Manual seed failed for ${T.toString()}: $error\n$stack');
      }
      rethrow;
    }
  }
}
