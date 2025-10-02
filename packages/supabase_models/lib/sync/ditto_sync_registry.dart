import 'dart:async';

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
      unawaited(DittoSyncCoordinator.instance.setDitto(ditto));
      if (ditto != null) {
        debugPrint(
            '🚀 Ditto instance received, starting async seeding process...');
        unawaited(() async {
          try {
            debugPrint('⏳ Waiting for Repository to be ready...');
            await Repository.waitUntilReady();
            debugPrint('✅ Repository is ready');
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
}
