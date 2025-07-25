import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';

abstract class ShiftApi {
  Future<models.Shift> startShift(
      {required int userId, required double openingBalance, String? note});
  Future<models.Shift> endShift(
      {required String shiftId, required double closingBalance, String? note});
  Future<models.Shift?> getCurrentShift({required int userId});
  Stream<List<models.Shift>> getShifts(
      {required int businessId, DateTimeRange? dateRange});
  Future<models.Shift> updateShiftTotals(
      {required double transactionAmount, required bool isRefund});
}

mixin ShiftMixin implements ShiftApi {
  final Repository repository = Repository();

  @override
  Future<models.Shift> startShift(
      {required int userId,
      required double openingBalance,
      String? note}) async {
    final String shiftId = const Uuid().v4();
    final int businessId =
        ProxyService.box.getBusinessId()!; // Assuming businessId is available

    final shift = models.Shift(
      id: shiftId,
      businessId: businessId,
      userId: userId,
      startAt: DateTime.now().toUtc(),
      openingBalance: openingBalance,
      status: models.ShiftStatus.Open,
      note: note,
    );
    return await repository.upsert(shift);
  }

  @override
  Future<models.Shift> endShift(
      {required String shiftId,
      required double closingBalance,
      String? note}) async {
    final shift = (await repository.get<models.Shift>(
      query: brick.Query(where: [brick.Where('id').isExactly(shiftId)]),
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
    return await repository.upsert(updatedShift);
  }

  @override
  Future<models.Shift> updateShiftTotals(
      {required double transactionAmount, required bool isRefund}) async {
    final int userId = ProxyService.box.getUserId()!;
    models.Shift? currentShift = await getCurrentShift(userId: userId);

    if (currentShift == null) {
      talker.warning('No open shift found for user $userId. Cannot update shift totals.');
      throw Exception('No open shift found. Please start a shift first.');
    }

    num cashSales = currentShift.cashSales ?? 0.0;
    num refunds = currentShift.refunds ?? 0.0;

    if (isRefund) {
      refunds += transactionAmount;
    } else {
      cashSales += transactionAmount;
    }

    final num expectedCash = currentShift.openingBalance + cashSales - refunds;

    final updatedShift = currentShift.copyWith(
      cashSales: cashSales,
      refunds: refunds,
      expectedCash: expectedCash,
    );

    return await repository.upsert(updatedShift);
  }

  @override
  Future<models.Shift?> getCurrentShift({required int userId}) async {
    talker.debug('getCurrentShift: userId: $userId');
    final int businessId = ProxyService.box.getBusinessId()!;
    talker.debug('getCurrentShift: businessId: $businessId');
    final shifts = await repository.get<models.Shift>(
      query: brick.Query(where: [
        brick.Where('userId').isExactly(userId),
        brick.Where('businessId').isExactly(businessId),
        brick.Where('status').isExactly(models.ShiftStatus.Open.name),
      ]),
    );
    talker.debug('getCurrentShift: found ${shifts.length} shifts');
    return shifts.lastOrNull;
  }

  @override
  Stream<List<models.Shift>> getShifts(
      {required int businessId, DateTimeRange? dateRange}) {
    final whereConditions = <brick.Where>[
      brick.Where('businessId').isExactly(businessId),
    ];

    if (dateRange != null) {
      whereConditions
          .add(brick.Where('startAt').isGreaterThanOrEqualTo(dateRange.start));
      whereConditions
          .add(brick.Where('startAt').isLessThanOrEqualTo(dateRange.end));
    }

    return repository.subscribe<models.Shift>(
      query: brick.Query(where: whereConditions),
    );
  }
}
