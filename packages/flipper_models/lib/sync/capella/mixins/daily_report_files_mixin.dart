import 'dart:async';

import 'package:flipper_models/models/daily_report_file.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:talker/talker.dart';

/// Live list of server-generated daily transaction XLSX catalogue rows in Ditto.
mixin CapellaDailyReportFilesMixin {
  Talker get talker;

  DittoService get dittoService => DittoService.instance;

  Stream<List<DailyReportFile>> dailyReportFilesStream({
    required String branchId,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized — dailyReportFilesStream');
      return Stream.value([]);
    }

    const type = DailyReportFile.dailyDetailedTransactionsXlsxType;
    final query =
        'SELECT * FROM daily_report_files WHERE branchId = :branchId AND type = :type ORDER BY createdAt DESC';
    final arguments = <String, dynamic>{'branchId': branchId, 'type': type};

    final controller = StreamController<List<DailyReportFile>>.broadcast();
    dynamic observer;
    dynamic subscriptionRegistration;

    () async {
      try {
        final prepared = prepareDqlSyncSubscription(query, arguments);
        subscriptionRegistration = await ditto.sync.registerSubscription(
          prepared.dql,
          arguments: prepared.arguments,
        );

        observer = ditto.store.registerObserver(
          query,
          arguments: arguments,
          onChange: (queryResult) {
            if (controller.isClosed) return;
            controller.add(_mapAndSort(queryResult.items));
          },
        );
      } catch (e, st) {
        talker.error('dailyReportFilesStream setup failed: $e\n$st');
        if (!controller.isClosed) controller.add([]);
      }
    }();

    ditto.store
        .execute(query, arguments: arguments)
        .then((result) {
          if (controller.isClosed) return;
          controller.add(_mapAndSort(result.items));
        })
        .catchError((Object e) {
          talker.error('dailyReportFilesStream seed failed: $e');
        });

    controller.onCancel = () async {
      await observer?.cancel();
      try {
        subscriptionRegistration?.cancel();
      } catch (_) {/* noop */}
      await controller.close();
    };

    return controller.stream;
  }

  List<DailyReportFile> _mapAndSort(Iterable<dynamic> items) {
    final list = <DailyReportFile>[];
    for (final row in items) {
      try {
        final v = (row as dynamic).value;
        if (v is! Map) continue;
        final data = Map<String, dynamic>.from(v);
        list.add(DailyReportFile.fromDittoMap(data));
      } catch (e) {
        talker.warning('daily_report_files row parse error: $e');
      }
    }
    list.sort((a, b) {
      final ac = a.createdAt;
      final bc = b.createdAt;
      if (ac != null && bc != null && ac != bc) {
        return bc.compareTo(ac);
      }
      final an = a.fileName ?? '';
      final bn = b.fileName ?? '';
      return bn.compareTo(an);
    });
    return list;
  }
}
