// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<FinanceProvider> _$FinanceProviderFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FinanceProvider(
    id: data['id'] as String?,
    name: data['name'] as String,
    interestRate: data['interest_rate'] as num,
    suppliersThatAcceptThisFinanceFacility:
        data['suppliers_that_accept_this_finance_facility'] as String,
  );
}

Future<Map<String, dynamic>> _$FinanceProviderToSupabase(
  FinanceProvider instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'interest_rate': instance.interestRate,
    'suppliers_that_accept_this_finance_facility':
        instance.suppliersThatAcceptThisFinanceFacility,
  };
}

Future<FinanceProvider> _$FinanceProviderFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FinanceProvider(
    id: data['id'] as String,
    name: data['name'] as String,
    interestRate: data['interest_rate'] as num,
    suppliersThatAcceptThisFinanceFacility:
        data['suppliers_that_accept_this_finance_facility'] as String,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$FinanceProviderToSqlite(
  FinanceProvider instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'interest_rate': instance.interestRate,
    'suppliers_that_accept_this_finance_facility':
        instance.suppliersThatAcceptThisFinanceFacility,
  };
}

/// Construct a [FinanceProvider]
class FinanceProviderAdapter
    extends OfflineFirstWithSupabaseAdapter<FinanceProvider> {
  FinanceProviderAdapter();

  @override
  final supabaseTableName = 'finance_providers';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'interestRate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'interest_rate',
    ),
    'suppliersThatAcceptThisFinanceFacility':
        const RuntimeSupabaseColumnDefinition(
          association: false,
          columnName: 'suppliers_that_accept_this_finance_facility',
        ),
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'interestRate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'interest_rate',
      iterable: false,
      type: num,
    ),
    'suppliersThatAcceptThisFinanceFacility':
        const RuntimeSqliteColumnDefinition(
          association: false,
          columnName: 'suppliers_that_accept_this_finance_facility',
          iterable: false,
          type: String,
        ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    FinanceProvider instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `FinanceProvider` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'FinanceProvider';

  @override
  Future<FinanceProvider> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinanceProviderFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    FinanceProvider input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinanceProviderToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<FinanceProvider> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinanceProviderFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    FinanceProvider input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FinanceProviderToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
