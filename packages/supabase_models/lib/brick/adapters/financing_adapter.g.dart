// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Financing> _$FinancingFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Financing(
    id: data['id'] as String?,
    requested: data['requested'] as bool,
    status: data['status'] as String,
    provider: data['provider'] == null
        ? null
        : await FinanceProviderAdapter().fromSupabase(
            data['provider'],
            provider: provider,
            repository: repository,
          ),
    financeProviderId: data['finance_provider_id'] == null
        ? null
        : data['finance_provider_id'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as num?,
    approvalDate: DateTime.parse(data['approval_date'] as String),
  );
}

Future<Map<String, dynamic>> _$FinancingToSupabase(
  Financing instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'requested': instance.requested,
    'status': instance.status,
    'provider': instance.provider != null
        ? await FinanceProviderAdapter().toSupabase(
            instance.provider!,
            provider: provider,
            repository: repository,
          )
        : null,
    'finance_provider_id': instance.financeProviderId,
    'amount': instance.amount,
    'approval_date': instance.approvalDate.toIso8601String(),
  };
}

Future<Financing> _$FinancingFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Financing(
    id: data['id'] as String,
    requested: data['requested'] == 1,
    status: data['status'] as String,
    provider: data['provider_FinanceProvider_brick_id'] == null
        ? null
        : (data['provider_FinanceProvider_brick_id'] > -1
            ? (await repository?.getAssociation<FinanceProvider>(
                Query.where(
                  'primaryKey',
                  data['provider_FinanceProvider_brick_id'] as int,
                  limit1: true,
                ),
              ))
                ?.first
            : null),
    financeProviderId: data['finance_provider_id'] == null
        ? null
        : data['finance_provider_id'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as num?,
    approvalDate: DateTime.parse(data['approval_date'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$FinancingToSqlite(
  Financing instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'requested': instance.requested ? 1 : 0,
    'status': instance.status,
    'provider_FinanceProvider_brick_id': instance.provider != null
        ? instance.provider!.primaryKey ??
            await provider.upsert<FinanceProvider>(
              instance.provider!,
              repository: repository,
            )
        : null,
    'finance_provider_id': instance.financeProviderId,
    'amount': instance.amount,
    'approval_date': instance.approvalDate.toIso8601String(),
  };
}

/// Construct a [Financing]
class FinancingAdapter extends OfflineFirstWithSupabaseAdapter<Financing> {
  FinancingAdapter();

  @override
  final supabaseTableName = 'purchase_financings';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'requested': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'requested',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'provider': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'provider',
      associationType: FinanceProvider,
      associationIsNullable: true,
    ),
    'financeProviderId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'finance_provider_id',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'approvalDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'approval_date',
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
    'requested': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'requested',
      iterable: false,
      type: bool,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'provider': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'provider_FinanceProvider_brick_id',
      iterable: false,
      type: FinanceProvider,
    ),
    'financeProviderId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'finance_provider_id',
      iterable: false,
      type: String,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: num,
    ),
    'approvalDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'approval_date',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Financing instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Financing` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Financing';

  @override
  Future<Financing> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$FinancingFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Financing input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$FinancingToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Financing> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$FinancingFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Financing input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$FinancingToSqlite(
        input,
        provider: provider,
        repository: repository,
      );
}
