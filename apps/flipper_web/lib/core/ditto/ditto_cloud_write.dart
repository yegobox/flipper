import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flutter/foundation.dart';

/// Ensures [ditto] can replicate writes to Ditto Cloud.
///
/// On web the local store is in-memory; without auth + active sync, upserts
/// vanish on reload and never reach the big peer.
Future<void> ensureDittoCloudWriteReady(Ditto ditto) async {
  if (!DittoSingleton.isAuthenticated(ditto)) {
    throw StateError(
      'Ditto not authenticated — cloud write blocked '
      '(auth=${ditto.auth.status})',
    );
  }
  if (!ditto.sync.isActive) {
    debugPrint('[Ditto] ensureDittoCloudWriteReady: starting sync');
    ditto.sync.start();
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  if (!ditto.sync.isActive) {
    throw StateError(
      'Ditto sync inactive — cloud write would stay local-only',
    );
  }
}

/// Confirms an upsert is readable from the local Ditto store.
Future<bool> waitForDittoDocumentLocal({
  required Ditto ditto,
  required String collection,
  required String docId,
  Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    try {
      final result = await ditto.store.execute(
        'SELECT _id FROM $collection WHERE _id = :id LIMIT 1',
        arguments: {'id': docId},
      );
      if (result.items.isNotEmpty) return true;
    } catch (e) {
      debugPrint('[Ditto] waitForDittoDocumentLocal($collection/$docId): $e');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  return false;
}
