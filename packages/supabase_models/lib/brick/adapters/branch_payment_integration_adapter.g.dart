// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<BranchPaymentIntegration> _$BranchPaymentIntegrationFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BranchPaymentIntegration(
    id: data['id'] as String?,
    branchId: data['branch_id'] as String,
    isEnabled: data['is_enabled'] as bool,
  );
}

Future<Map<String, dynamic>> _$BranchPaymentIntegrationToSupabase(
  BranchPaymentIntegration instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'is_enabled': instance.isEnabled,
  };
}

Future<BranchPaymentIntegration> _$BranchPaymentIntegrationFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BranchPaymentIntegration(
    id: data['id'] as String,
    branchId: data['branch_id'] as String,
    isEnabled: data['is_enabled'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BranchPaymentIntegrationToSqlite(
  BranchPaymentIntegration instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'is_enabled': instance.isEnabled ? 1 : 0,
  };
}

/// Construct a [BranchPaymentIntegration]
class BranchPaymentIntegrationAdapter
    extends OfflineFirstWithSupabaseAdapter<BranchPaymentIntegration> {
  BranchPaymentIntegrationAdapter();

  @override
  final supabaseTableName = 'branch_payment_integrations';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'isEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_enabled',
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
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
    ),
    'isEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_enabled',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    BranchPaymentIntegration instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `BranchPaymentIntegration` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'BranchPaymentIntegration';

  @override
  Future<BranchPaymentIntegration> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BranchPaymentIntegrationFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    BranchPaymentIntegration input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BranchPaymentIntegrationToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<BranchPaymentIntegration> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BranchPaymentIntegrationFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    BranchPaymentIntegration input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BranchPaymentIntegrationToSqlite(
        input,
        provider: provider,
        repository: repository,
      );
}
