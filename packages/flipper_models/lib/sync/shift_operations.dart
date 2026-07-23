import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:uuid/uuid.dart';

/// Ditto-backed shift reads/writes (no Brick/SQLite path).
///
/// Collection: `shifts`. Open-shift lookup is scoped by userId + businessId.
class ShiftOperations {
  ShiftOperations();

  static const String collection = 'shifts';

  static const String _openShiftSql =
      'SELECT * FROM $collection WHERE userId = :userId AND businessId = :businessId AND status = :status';

  static const String _byIdSql =
      'SELECT * FROM $collection WHERE _id = :id OR id = :id LIMIT 1';

  static const String _byBusinessSql =
      'SELECT * FROM $collection WHERE businessId = :businessId';

  static final Set<String> _syncSubscriptionKeys = <String>{};

  dynamic get _ditto {
    final ditto = ProxyService.ditto.dittoInstance;
    if (ditto == null) {
      throw StateError('Ditto not initialized — cannot access shifts');
    }
    return ditto;
  }

  void _ensureSyncSubscription(
    dynamic ditto,
    String key,
    String sql,
    Map<String, dynamic>? args,
  ) {
    if (_syncSubscriptionKeys.contains(key)) return;
    try {
      final prepared = prepareDqlSyncSubscription(sql, args);
      ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      _syncSubscriptionKeys.add(key);
      talker.debug('shift: registered sync subscription $key');
    } catch (e, s) {
      talker.warning('shift: sync subscription failed ($key): $e\n$s');
    }
  }

  void _ensureBusinessSync(dynamic ditto, String businessId) {
    _ensureSyncSubscription(
      ditto,
      'shifts|all',
      'SELECT * FROM $collection',
      null,
    );
    _ensureSyncSubscription(
      ditto,
      'shifts|$businessId',
      _byBusinessSql,
      {'businessId': businessId},
    );
  }

  Future<void> _upsertDoc(models.Shift shift) async {
    final ditto = _ditto;
    _ensureBusinessSync(ditto, shift.businessId);
    final doc = shift.toDittoDocument();
    await ditto.store.execute(
      'INSERT INTO $collection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  List<models.Shift> _shiftsFromResult(dynamic queryResult) {
    final list = <models.Shift>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        final raw = Map<String, dynamic>.from(item.value as Map);
        list.add(models.Shift.fromDittoDocument(raw));
      } catch (e) {
        talker.error('shift map error: $e');
      }
    }
    return list;
  }

  Future<models.Shift> startShift({
    required String userId,
    required double openingBalance,
    String? note,
  }) async {
    final existing = await getCurrentShift(userId: userId);
    if (existing != null) {
      talker.warning(
        'startShift: open shift ${existing.id} already exists for user $userId',
      );
      return existing;
    }

    final shiftId = const Uuid().v4();
    final businessId = ProxyService.box.getBusinessId()!;

    final shift = models.Shift(
      id: shiftId,
      businessId: businessId,
      userId: userId,
      startAt: DateTime.now().toUtc(),
      openingBalance: openingBalance,
      status: models.ShiftStatus.Open,
      note: note,
      cashSales: 0,
      refunds: 0,
      expectedCash: openingBalance,
    );
    await _upsertDoc(shift);
    return shift;
  }

  Future<models.Shift> endShift({
    required String shiftId,
    required double closingBalance,
    String? note,
  }) async {
    final ditto = _ditto;
    final result = await ditto.store.execute(
      _byIdSql,
      arguments: {'id': shiftId},
    );
    final rows = _shiftsFromResult(result);
    if (rows.isEmpty) {
      throw StateError('Shift $shiftId not found in Ditto');
    }
    final shift = rows.first;

    final updatedShift = shift.copyWith(
      endAt: DateTime.now().toUtc(),
      closingBalance: closingBalance,
      status: models.ShiftStatus.Closed,
      cashSales: shift.cashSales,
      expectedCash: shift.expectedCash,
      cashDifference: closingBalance - (shift.expectedCash ?? 0.0),
      note: note,
    );
    await _upsertDoc(updatedShift);
    return updatedShift;
  }

  Future<models.Shift> updateShiftTotals({
    required double transactionAmount,
    required bool isRefund,
  }) async {
    final userId = ProxyService.box.getUserId()!;
    final currentShift = await getCurrentShift(userId: userId);

    if (currentShift == null) {
      talker.warning(
        'No open shift found for user $userId. Cannot update shift totals.',
      );
      throw Exception('No open shift found. Please start a shift first.');
    }

    num cashSales = currentShift.cashSales ?? 0.0;
    num refunds = currentShift.refunds ?? 0.0;

    if (isRefund) {
      refunds += transactionAmount;
    } else {
      cashSales += transactionAmount;
    }

    final expectedCash = currentShift.openingBalance + cashSales - refunds;

    final updatedShift = currentShift.copyWith(
      cashSales: cashSales,
      refunds: refunds,
      expectedCash: expectedCash,
    );

    await _upsertDoc(updatedShift);
    return updatedShift;
  }

  /// Persist an already-mutated open shift (e.g. sale totals in collectPayment).
  Future<models.Shift> saveShift(models.Shift shift) async {
    await _upsertDoc(shift);
    return shift;
  }

  Future<models.Shift?> getCurrentShift({required String userId}) async {
    talker.debug('getCurrentShift: userId: $userId');
    final businessId = ProxyService.box.getBusinessId();
    if (businessId == null) {
      talker.warning('getCurrentShift: no businessId');
      return null;
    }
    talker.debug('getCurrentShift: businessId: $businessId');

    try {
      final ditto = _ditto;
      _ensureBusinessSync(ditto, businessId);

      final result = await ditto.store.execute(
        _openShiftSql,
        arguments: {
          'userId': userId,
          'businessId': businessId,
          'status': models.ShiftStatus.Open.name,
        },
      );

      final open = _shiftsFromResult(result);
      talker.debug('getCurrentShift: found ${open.length} open shifts');
      if (open.isEmpty) return null;

      open.sort((a, b) => b.startAt.compareTo(a.startAt));
      return open.first;
    } catch (e, s) {
      talker.warning('getCurrentShift failed: $e', s);
      return null;
    }
  }

  Stream<List<models.Shift>> getShifts({
    required String businessId,
    DateTimeRange? dateRange,
  }) {
    final ditto = ProxyService.ditto.dittoInstance;
    if (ditto == null) {
      return Stream.value(<models.Shift>[]);
    }
    _ensureBusinessSync(ditto, businessId);

    final controller = StreamController<List<models.Shift>>();
    final args = {'businessId': businessId};
    dynamic observer;

    List<models.Shift> applyRange(List<models.Shift> all) {
      if (dateRange == null) return all;
      return all
          .where(
            (s) =>
                !s.startAt.isBefore(dateRange.start) &&
                !s.startAt.isAfter(dateRange.end),
          )
          .toList();
    }

    unawaited(() async {
      try {
        final initial = await ditto.store.execute(
          _byBusinessSql,
          arguments: args,
        );
        if (!controller.isClosed) {
          controller.add(applyRange(_shiftsFromResult(initial)));
        }
        observer = ditto.store.registerObserver(
          _byBusinessSql,
          arguments: args,
          onChange: (r) {
            if (!controller.isClosed) {
              controller.add(applyRange(_shiftsFromResult(r)));
            }
          },
        );
      } catch (e, s) {
        talker.error('getShifts stream: $e\n$s');
        if (!controller.isClosed) {
          controller.add(<models.Shift>[]);
        }
      }
    }());

    controller.onCancel = () async {
      try {
        await observer?.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
  }
}
