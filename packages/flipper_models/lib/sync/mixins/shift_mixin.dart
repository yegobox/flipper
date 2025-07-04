import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository.dart' as brick;
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';

abstract class ShiftApi {
  Future<models.Shift> startShift(
      {required int userId, required double openingBalance});
  Future<models.Shift> endShift(
      {required String shiftId, required double closingBalance});
  Future<models.Shift?> getCurrentShift({required int userId});
  Stream<List<models.Shift>> getShifts(
      {required int businessId, DateTimeRange? dateRange});
}

mixin ShiftMixin implements ShiftApi {
  final Repository repository = Repository();

  @override
  Future<models.Shift> startShift(
      {required int userId, required double openingBalance}) async {
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
    );
    return await repository.upsert(shift);
  }

  @override
  Future<models.Shift> endShift(
      {required String shiftId, required double closingBalance}) async {
    final shift = (await repository.get<models.Shift>(
      query: brick.Query(where: [brick.Where('id').isExactly(shiftId)]),
    ))
        .first;

    // TODO: Implement actual calculation of cashSales, expectedCash, cashDifference based on transactions
    // For now, using placeholders or simple calculations
    final double cashSales = 0.0; // Placeholder
    final double expectedCash = shift.openingBalance + cashSales; // Placeholder
    final double cashDifference = closingBalance - expectedCash; // Placeholder

    final updatedShift = shift.copyWith(
      endAt: DateTime.now().toUtc(),
      closingBalance: closingBalance,
      status: models.ShiftStatus.Closed,
      cashSales: cashSales,
      expectedCash: expectedCash,
      cashDifference: cashDifference,
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
