import 'dart:async';

import 'package:flipper_models/daily_report_download_client.dart';
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
    // Do not filter `archivedAt IS NULL` in DQL — Ditto does not treat a missing
    // field as NULL, so legacy catalogue rows would be excluded. Filter in
    // [_mapAndSort] instead.
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

  /// Soft-archives catalogue rows (`archivedAt`). Uses data-connector when
  /// available, then patches local Ditto so the list updates immediately.
  Future<int> archiveDailyReportFiles({
    required String branchId,
    required List<DailyReportFile> files,
    String? dataConnectorUrl,
  }) async {
    if (branchId.trim().isEmpty || files.isEmpty) return 0;

    final pending = files.where((f) => !f.isArchived).toList(growable: false);
    if (pending.isEmpty) return 0;

    final objectKeys = pending
        .map((f) => f.s3ObjectKey?.trim() ?? '')
        .where((k) => k.isNotEmpty)
        .toSet()
        .toList(growable: false);

    var remoteCount = 0;
    if (objectKeys.isNotEmpty) {
      try {
        final response = await archiveDailyReportFilesViaDataConnector(
          branchId: branchId,
          objectKeys: objectKeys,
          dataConnectorUrl: dataConnectorUrl,
        );
        remoteCount = response.archivedCount;
      } catch (e, st) {
        talker.warning('archiveDailyReportFiles HTTP failed: $e\n$st');
      }
    }

    final localCount = await _archiveDailyReportFilesInDitto(
      branchId: branchId,
      files: pending,
    );

    if (remoteCount > 0) return remoteCount;
    return localCount;
  }

  Future<int> _archiveDailyReportFilesInDitto({
    required String branchId,
    required List<DailyReportFile> files,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized — archiveDailyReportFiles');
      return 0;
    }

    final now = DateTime.now().toUtc().toIso8601String();
    var archived = 0;

    for (final file in files) {
      if (file.isArchived) continue;

      final key = file.s3ObjectKey?.trim();
      final Map<String, dynamic>? existing = await _findDailyReportFileDoc(
        ditto: ditto,
        branchId: branchId,
        s3ObjectKey: key,
        documentId: file.id.trim(),
        createdAt: file.createdAt,
        fileName: file.fileName,
      );
      if (existing == null) {
        talker.warning(
          'archiveDailyReportFiles: no Ditto row for file=${file.fileName ?? file.id}',
        );
        continue;
      }

      final doc = Map<String, dynamic>.from(existing);
      final docId = (doc['_id'] ?? doc['id'])?.toString().trim();
      if (docId != null && docId.isNotEmpty) {
        doc['_id'] = docId;
        doc['id'] = docId;
      }
      doc['archivedAt'] = now;
      doc['branchId'] = branchId;

      try {
        await ditto.store.execute(
          'INSERT INTO daily_report_files DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
          arguments: {'doc': doc},
        );
        archived++;
      } catch (e, st) {
        talker.error('archiveDailyReportFiles upsert failed: $e\n$st');
      }
    }

    return archived;
  }

  Future<Map<String, dynamic>?> _findDailyReportFileDoc({
    required dynamic ditto,
    required String branchId,
    String? s3ObjectKey,
    required String documentId,
    DateTime? createdAt,
    String? fileName,
  }) async {
    if (s3ObjectKey != null && s3ObjectKey.isNotEmpty) {
      final byKey = await ditto.store.execute(
        'SELECT * FROM daily_report_files WHERE branchId = :branchId AND s3ObjectKey = :key LIMIT 1',
        arguments: {'branchId': branchId, 'key': s3ObjectKey},
      );
      final row = _firstDittoRow(byKey);
      if (row != null) return row;
    }

    final createdIso = createdAt?.toUtc().toIso8601String();
    final trimmedName = fileName?.trim() ?? '';
    if (createdIso != null &&
        createdIso.isNotEmpty &&
        trimmedName.isNotEmpty) {
      final byMeta = await ditto.store.execute(
        'SELECT * FROM daily_report_files WHERE branchId = :branchId AND createdAt = :createdAt AND fileName = :fileName LIMIT 1',
        arguments: {
          'branchId': branchId,
          'createdAt': createdIso,
          'fileName': trimmedName,
        },
      );
      final row = _firstDittoRow(byMeta);
      if (row != null) return row;
    }

    if (documentId.isEmpty) return null;

    final byId = await ditto.store.execute(
      'SELECT * FROM daily_report_files WHERE branchId = :branchId AND (_id = :id OR id = :id) LIMIT 1',
      arguments: {'branchId': branchId, 'id': documentId},
    );
    return _firstDittoRow(byId);
  }

  Map<String, dynamic>? _firstDittoRow(dynamic queryResult) {
    try {
      final items = queryResult.items as Iterable<dynamic>;
      for (final row in items) {
        final v = (row as dynamic).value;
        if (v is Map) {
          return Map<String, dynamic>.from(v);
        }
      }
    } catch (e) {
      talker.warning('daily_report_files row read failed: $e');
    }
    return null;
  }

  List<DailyReportFile> _mapAndSort(Iterable<dynamic> items) {
    final list = <DailyReportFile>[];
    for (final row in items) {
      try {
        final v = (row as dynamic).value;
        if (v is! Map) continue;
        final data = Map<String, dynamic>.from(v);
        final file = DailyReportFile.fromDittoMap(data);
        if (!file.isArchived) {
          list.add(file);
        }
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
