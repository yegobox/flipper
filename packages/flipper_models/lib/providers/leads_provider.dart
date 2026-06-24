import 'dart:async';

import 'package:flipper_models/models/lead.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leadsStreamProvider = StreamProvider.autoDispose<List<Lead>>((ref) {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) {
    return Stream.value(const <Lead>[]);
  }

  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) {
    return Stream.value(const <Lead>[]);
  }

  final query =
      'SELECT * FROM leads WHERE branchId = :branchId ORDER BY lastTouched DESC';
  final args = {'branchId': branchId};

  // Ensure sync subscription is active (Ditto dedupes).
  // Ditto returns a SyncSubscription; just register once (deduped internally).
  try {
    final preparedLeads = prepareDqlSyncSubscription(query, args);
    ditto.sync.registerSubscription(
      preparedLeads.dql,
      arguments: preparedLeads.arguments,
    );
  } catch (_) {
    // Ignore subscription errors; observer query will still work on local store.
  }

  final controller = StreamController<List<Lead>>.broadcast();
  final observer = ditto.store.registerObserver(
    query,
    arguments: args,
    onChange: (result) {
      if (controller.isClosed) return;
      final leads = result.items
          .map((i) => Lead.fromDitto(Map<String, dynamic>.from(i.value)))
          .toList();
      controller.add(leads);
    },
  );

  ref.onDispose(() async {
    observer.cancel();
    await controller.close();
  });

  return controller.stream;
});

final leadsUpsertProvider = Provider<Future<void> Function(Lead lead)>((ref) {
  return (Lead lead) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return;
    await ditto.store.execute(
      'INSERT INTO leads DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': lead.toDitto()},
    );
  };
});

class LeadsStats {
  final int totalLeads;
  final int fromGmail;
  final int converted;
  final double pipelineValue;
  final double conversionRate; // 0..1

  const LeadsStats({
    required this.totalLeads,
    required this.fromGmail,
    required this.converted,
    required this.pipelineValue,
    required this.conversionRate,
  });
}

final leadsStatsProvider = Provider.autoDispose<AsyncValue<LeadsStats>>((ref) {
  final leadsAsync = ref.watch(leadsStreamProvider);
  return leadsAsync.whenData((leads) {
    final total = leads.length;
    final converted = leads.where((l) => l.status == LeadStatus.converted).length;
    final fromGmail = leads.where((l) => l.source == LeadSource.gmail).length;
    final pipeline = leads.fold<double>(0.0, (a, b) {
      final v = b.estimatedValue;
      if (v == null) return a;
      return a + v.toDouble();
    });
    final rate = total == 0 ? 0.0 : (converted / total);
    return LeadsStats(
      totalLeads: total,
      fromGmail: fromGmail,
      converted: converted,
      pipelineValue: pipeline,
      conversionRate: rate,
    );
  });
});

