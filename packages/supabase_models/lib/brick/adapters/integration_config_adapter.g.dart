// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<IntegrationConfig> _$IntegrationConfigFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return IntegrationConfig(
    id: data['id'] as String?,
    businessId: data['business_id'] as String,
    provider: data['provider'] as String,
    token: data['token'] == null ? null : data['token'] as String?,
    refreshToken: data['refresh_token'] == null
        ? null
        : data['refresh_token'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
        ? null
        : DateTime.tryParse(data['updated_at'] as String),
    config: data['config'] == null
        ? null
        : data['config'] == null
        ? null
        : data['config'] is String
        ? data['config'] as String
        : jsonEncode(data['config']),
  );
}

Future<Map<String, dynamic>> _$IntegrationConfigToSupabase(
  IntegrationConfig instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'provider': instance.provider,
    'token': instance.token,
    'refresh_token': instance.refreshToken,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'config': instance.config,
  };
}

Future<IntegrationConfig> _$IntegrationConfigFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return IntegrationConfig(
    id: data['id'] as String,
    businessId: data['business_id'] as String,
    provider: data['provider'] as String,
    token: data['token'] == null ? null : data['token'] as String?,
    refreshToken: data['refresh_token'] == null
        ? null
        : data['refresh_token'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
        ? null
        : DateTime.tryParse(data['updated_at'] as String),
    config: data['config'] == null ? null : data['config'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$IntegrationConfigToSqlite(
  IntegrationConfig instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'provider': instance.provider,
    'token': instance.token,
    'refresh_token': instance.refreshToken,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'config': instance.config,
  };
}

/// Construct a [IntegrationConfig]
class IntegrationConfigAdapter
    extends OfflineFirstWithSupabaseAdapter<IntegrationConfig> {
  IntegrationConfigAdapter();

  @override
  final supabaseTableName = 'integration_configs';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'provider': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'provider',
    ),
    'token': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'token',
    ),
    'refreshToken': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'refresh_token',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'config': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'config',
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
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: String,
    ),
    'provider': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'provider',
      iterable: false,
      type: String,
    ),
    'token': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'token',
      iterable: false,
      type: String,
    ),
    'refreshToken': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'refresh_token',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'config': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'config',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    IntegrationConfig instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `IntegrationConfig` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'IntegrationConfig';

  @override
  Future<IntegrationConfig> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$IntegrationConfigFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    IntegrationConfig input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$IntegrationConfigToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<IntegrationConfig> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$IntegrationConfigFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    IntegrationConfig input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$IntegrationConfigToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
