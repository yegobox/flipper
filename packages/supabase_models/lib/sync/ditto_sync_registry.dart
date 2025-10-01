import 'dart:async';

import 'package:brick_core/query.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/models/counter.model.dart';

/// Convenience registry for plugging default Ditto sync adapters.
class DittoSyncRegistry {
  DittoSyncRegistry._();

  static bool _registered = false;
  static void Function(Ditto?)? _dittoListener;
  static bool _seededCounters = false;

  static Future<void> registerDefaults() async {
    if (_registered) {
      return;
    }
    _registered = true;

    await DittoSyncCoordinator.instance
        .registerAdapter<Counter>(CounterDittoAdapter.instance);

    _dittoListener ??= (Ditto? ditto) {
      unawaited(DittoSyncCoordinator.instance.setDitto(ditto));
      if (ditto != null) {
        unawaited(_seedCounters());
      }
    };

    DittoService.instance.addDittoListener(_dittoListener!);
  }

  static Future<void> _seedCounters() async {
    if (_seededCounters) {
      return;
    }

    try {
      final branchId = ProxyService.box.getBranchId();

      final counters = await Repository().get<Counter>(
        query: branchId != null
            ? Query(
                where: [Where('branchId').isExactly(branchId)],
              )
            : null,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );

      for (final counter in counters) {
        unawaited(
          DittoSyncCoordinator.instance.notifyLocalUpsert(counter),
        );
      }

      _seededCounters = true;
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto counter seeding failed: $error\n$stack');
      }
    }
  }
}
