import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:uuid/uuid.dart';

/// Brick-backed shift reads/writes shared by CoreSync and Capella.
///
/// [getCurrentShift] avoids resurrecting a shift as Open after a local close:
/// when no local Open row exists, remote hydration skips ids already Closed
/// locally, and reconciles a local Open row if the server already Closed it.
class ShiftOperations {
  ShiftOperations({Repository? repository})
      : repository = repository ?? Repository();

  final Repository repository;

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
    );
    return repository.upsert(shift);
  }

  Future<models.Shift> endShift({
    required String shiftId,
    required double closingBalance,
    String? note,
  }) async {
    final shift = (await repository.get<models.Shift>(
      query: brick.Query(where: [brick.Where('id').isExactly(shiftId)]),
      policy: OfflineFirstGetPolicy.localOnly,
    ))
        .first;

    final updatedShift = shift.copyWith(
      endAt: DateTime.now().toUtc(),
      closingBalance: closingBalance,
      status: models.ShiftStatus.Closed,
      cashSales: shift.cashSales,
      expectedCash: shift.expectedCash,
      cashDifference: closingBalance - (shift.expectedCash ?? 0.0),
      note: note,
    );
    return repository.upsert(updatedShift);
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

    return repository.upsert(updatedShift);
  }

  Future<models.Shift?> getCurrentShift({required String userId}) async {
    talker.debug('getCurrentShift: userId: $userId');
    final businessId = ProxyService.box.getBusinessId()!;
    talker.debug('getCurrentShift: businessId: $businessId');

    final whereOpen = [
      brick.Where('userId').isExactly(userId),
      brick.Where('businessId').isExactly(businessId),
      brick.Where('status').isExactly(models.ShiftStatus.Open.name),
    ];

    final localOpen = await repository.get<models.Shift>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: brick.Query(where: whereOpen),
    );

    if (localOpen.isNotEmpty) {
      localOpen.sort((a, b) => b.startAt.compareTo(a.startAt));
      final newest = localOpen.first;
      return _reconcileWithRemoteIfClosed(newest);
    }

    final localClosed = await repository.get<models.Shift>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: brick.Query(where: [
        brick.Where('userId').isExactly(userId),
        brick.Where('businessId').isExactly(businessId),
        brick.Where('status').isExactly(models.ShiftStatus.Closed.name),
      ]),
    );
    final locallyClosedIds = localClosed.map((s) => s.id).toSet();

    final remoteOpen = await repository.get<models.Shift>(
      // Hydrate when this device has no local Open row (e.g. shift opened elsewhere).
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: brick.Query(where: whereOpen),
    );

    final viable = remoteOpen
        .where((shift) => !locallyClosedIds.contains(shift.id))
        .toList();
    talker.debug('getCurrentShift: found ${viable.length} open shifts');
    if (viable.isEmpty) return null;

    viable.sort((a, b) => b.startAt.compareTo(a.startAt));
    return viable.first;
  }

  /// If another device closed the shift on the server, mirror Closed locally.
  Future<models.Shift?> _reconcileWithRemoteIfClosed(
    models.Shift localOpen,
  ) async {
    try {
      final remoteRows = await repository.get<models.Shift>(
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(
          where: [brick.Where('id').isExactly(localOpen.id)],
        ),
      );
      final remote = remoteRows.firstOrNull;
      if (remote == null || remote.status == models.ShiftStatus.Open) {
        return localOpen;
      }
      await repository.upsert(remote);
      talker.info(
        'getCurrentShift: reconciled closed shift ${remote.id} from remote',
      );
      return null;
    } catch (e, s) {
      talker.warning('getCurrentShift remote reconcile failed: $e', s);
      return localOpen;
    }
  }

  Stream<List<models.Shift>> getShifts({
    required String businessId,
    DateTimeRange? dateRange,
  }) {
    final whereConditions = <brick.Where>[
      brick.Where('businessId').isExactly(businessId),
    ];

    if (dateRange != null) {
      whereConditions.add(
        brick.Where('startAt').isGreaterThanOrEqualTo(dateRange.start),
      );
      whereConditions.add(
        brick.Where('startAt').isLessThanOrEqualTo(dateRange.end),
      );
    }

    return repository.subscribe<models.Shift>(
      query: brick.Query(where: whereConditions),
    );
  }
}
