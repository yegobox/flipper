import 'package:flipper_models/sync/mixins/shift_mixin.dart';
import 'package:flipper_models/sync/shift_operations.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/repository.dart';

mixin CapellaShiftMixin implements ShiftApi {
  final Repository repository = Repository();
  ShiftOperations get _shiftOps => ShiftOperations(repository: repository);

  @override
  Future<models.Shift> startShift(
          {required String userId,
          required double openingBalance,
          String? note}) =>
      _shiftOps.startShift(
        userId: userId,
        openingBalance: openingBalance,
        note: note,
      );

  @override
  Future<models.Shift> endShift(
          {required String shiftId,
          required double closingBalance,
          String? note}) =>
      _shiftOps.endShift(
        shiftId: shiftId,
        closingBalance: closingBalance,
        note: note,
      );

  @override
  Future<models.Shift?> getCurrentShift({required String userId}) =>
      _shiftOps.getCurrentShift(userId: userId);

  @override
  Stream<List<models.Shift>> getShifts(
          {required String businessId, DateTimeRange? dateRange}) =>
      _shiftOps.getShifts(businessId: businessId, dateRange: dateRange);

  @override
  Future<models.Shift> updateShiftTotals(
          {required double transactionAmount, required bool isRefund}) =>
      _shiftOps.updateShiftTotals(
        transactionAmount: transactionAmount,
        isRefund: isRefund,
      );
}
