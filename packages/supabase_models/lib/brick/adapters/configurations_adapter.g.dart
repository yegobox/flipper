// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Configurations> _$ConfigurationsFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Configurations(
    id: data['id'] as String?,
    taxType: data['tax_type'] == null ? null : data['tax_type'] as String?,
    taxPercentage:
        data['tax_percentage'] == null
            ? null
            : data['tax_percentage'] as double?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
  );
}

Future<Map<String, dynamic>> _$ConfigurationsToSupabase(
  Configurations instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'tax_type': instance.taxType,
    'tax_percentage': instance.taxPercentage,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
  };
}

Future<Configurations> _$ConfigurationsFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Configurations(
    id: data['id'] as String,
    taxType: data['tax_type'] == null ? null : data['tax_type'] as String?,
    taxPercentage:
        data['tax_percentage'] == null
            ? null
            : data['tax_percentage'] as double?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ConfigurationsToSqlite(
  Configurations instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'tax_type': instance.taxType,
    'tax_percentage': instance.taxPercentage,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
  };
}

/// Construct a [Configurations]
class ConfigurationsAdapter
    extends OfflineFirstWithSupabaseAdapter<Configurations> {
  ConfigurationsAdapter();

  @override
  final supabaseTableName = 'configurations';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'taxType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_type',
    ),
    'taxPercentage': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_percentage',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
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
    'taxType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_type',
      iterable: false,
      type: String,
    ),
    'taxPercentage': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_percentage',
      iterable: false,
      type: double,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Configurations instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Configurations` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Configurations';

  @override
  Future<Configurations> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConfigurationsFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Configurations input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConfigurationsToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Configurations> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConfigurationsFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Configurations input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConfigurationsToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
