import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';

/// Convenience registry for plugging default Ditto sync adapters.
class DittoSyncRegistry {
  DittoSyncRegistry._();

  static bool _registered = false;
  static void Function(Ditto?)? _dittoListener;

  static Future<void> registerDefaults() async {
    if (_registered) {
      return;
    }
    _registered = true;

    await DittoSyncGeneratedRegistry.apply(DittoSyncCoordinator.instance);

    _dittoListener ??= (Ditto? ditto) {
      unawaited(DittoSyncCoordinator.instance.setDitto(ditto));
      if (ditto != null) {
        unawaited(
          DittoSyncGeneratedRegistry.seed(DittoSyncCoordinator.instance),
        );
      }
    };

    DittoService.instance.addDittoListener(_dittoListener!);
  }
}
