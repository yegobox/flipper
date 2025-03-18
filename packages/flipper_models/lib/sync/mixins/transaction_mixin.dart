import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin TransactionMixin implements TransactionInterface {
  Repository get repository;

  @override
  FutureOr<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
  }) async {
    final query = Query(where: [
      if (branchId != null) Where('branchId').isExactly(branchId),
      if (id != null) Where('id').isExactly(id),
      if (status != null) Where('status').isExactly(status),
      if (transactionType != null) Where('type').isExactly(transactionType),
      if (startDate != null)
        Where('createdAt').isGreaterThanOrEqualTo(startDate),
      if (endDate != null) Where('createdAt').isLessThanOrEqualTo(endDate),
    ]);

    return await repository.get<ITransaction>(query: query);
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) async {
    return await repository.get<Configurations>(
      query: Query(where: [
        Where('branchId').isExactly(branchId),
        Where('type').isExactly('tax'),
      ]),
    );
  }

  @override
  Future<Configurations> saveTax({
    required String configId,
    required double taxPercentage,
  }) async {
    final config = Configurations(
        id: configId, taxPercentage: taxPercentage, taxType: 'vat');

    return (await repository.upsert<Configurations>(config));
  }

  @override
  FutureOr<Configurations?> getByTaxType({required String taxtype}) async {
    return (await repository.get<Configurations>(
      query: Query(where: [
        Where('type').isExactly('tax'),
        Where('taxType').isExactly(taxtype),
      ]),
    ))
        .firstOrNull;
  }
}
