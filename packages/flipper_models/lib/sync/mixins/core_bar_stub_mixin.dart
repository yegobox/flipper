import 'dart:async';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/interfaces/bar_interface.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

mixin CoreBarStubMixin implements BarInterface {
  void _warn(String method) {
    talker.warning('Bar Mode is available on Capella only; $method ignored.');
  }

  @override
  Stream<List<BarTable>> barTablesStream({required String branchId}) {
    _warn('barTablesStream');
    return Stream.value(<BarTable>[]);
  }

  @override
  Future<List<BarTable>> barTables({required String branchId}) async {
    _warn('barTables');
    return [];
  }

  @override
  Future<void> saveBarTable(BarTable table) async => _warn('saveBarTable');

  @override
  Future<void> deleteBarTable({
    required String id,
    required String branchId,
  }) async =>
      _warn('deleteBarTable');

  @override
  Future<void> seedDefaultFloorPlan({required String branchId}) async =>
      _warn('seedDefaultFloorPlan');

  @override
  Stream<List<ITransaction>> barTabsStream({required String branchId}) {
    _warn('barTabsStream');
    return Stream.value(<ITransaction>[]);
  }

  @override
  Future<ITransaction?> barTabForTable({
    required String branchId,
    required String tableId,
  }) async {
    _warn('barTabForTable');
    return null;
  }

  @override
  Future<List<TransactionItem>> barTabLines({
    required String transactionId,
  }) async {
    _warn('barTabLines');
    return [];
  }

  @override
  Future<ITransaction> openBarTab({
    required String branchId,
    required BarTable table,
    required String cashierTenantId,
    required String cashierName,
  }) async {
    _warn('openBarTab');
    throw UnsupportedError('Bar Mode requires Capella strategy');
  }

  @override
  Future<void> addLineToBarTab({
    required String transactionId,
    required String branchId,
    required String variantId,
    required String productName,
    required num defaultPrice,
    required num stock,
    required String cashierTenantId,
    required String cashierName,
    String? color,
    String? sku,
  }) async =>
      _warn('addLineToBarTab');

  @override
  Future<void> setBarTabLineQty({
    required String lineId,
    required String transactionId,
    required num qty,
    required num stockCap,
  }) async =>
      _warn('setBarTabLineQty');

  @override
  Future<void> setBarTabLinePrice({
    required String lineId,
    required String transactionId,
    required num price,
  }) async =>
      _warn('setBarTabLinePrice');

  @override
  Future<void> deleteBarTabLine({
    required String lineId,
    required String transactionId,
  }) async =>
      _warn('deleteBarTabLine');

  @override
  Future<void> refreshBarTabSubTotal({required String transactionId}) async =>
      _warn('refreshBarTabSubTotal');

  @override
  Future<ITransaction> settleBarTab({
    required ITransaction transaction,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  }) async {
    _warn('settleBarTab');
    throw UnsupportedError('Bar Mode requires Capella strategy');
  }
}
