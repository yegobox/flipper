import 'package:flipper_models/sync/mixins/shift_mixin.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/repository.dart';

mixin CapellaShiftMixin implements ShiftApi {
  final Repository repository = Repository();

  @override
  Future<models.Shift> startShift(
      {required int userId,
      required double openingBalance,
      String? note}) async {
    throw UnimplementedError('startShift needs to be implemented for Capella');
  }

  @override
  Future<models.Shift> endShift(
      {required String shiftId,
      required double closingBalance,
      String? note}) async {
    throw UnimplementedError('endShift needs to be implemented for Capella');
  }

  @override
  Future<models.Shift?> getCurrentShift({required int userId}) async {
    throw UnimplementedError(
        'getCurrentShift needs to be implemented for Capella');
  }

  @override
  Stream<List<models.Shift>> getShifts(
      {required int businessId, DateTimeRange? dateRange}) {
    throw UnimplementedError('getShifts needs to be implemented for Capella');
  }

  @override
  Future<models.Shift> updateShiftTotals(
      {required double transactionAmount, required bool isRefund}) {
    throw UnimplementedError(
        'updateShiftTotals needs to be implemented for Capella');
  }
}
