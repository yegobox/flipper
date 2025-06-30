// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Retryable> _$RetryableFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Retryable(
    id: data['id'] as String?,
    entityId: data['entity_id'] as String,
    entityTable: data['entity_table'] as String,
    lastFailureReason: data['last_failure_reason'] as String,
    retryCount: data['retry_count'] as int,
    createdAt: DateTime.parse(data['created_at'] as String),
  );
}

Future<Map<String, dynamic>> _$RetryableToSupabase(
  Retryable instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'entity_id': instance.entityId,
    'entity_table': instance.entityTable,
    'last_failure_reason': instance.lastFailureReason,
    'retry_count': instance.retryCount,
    'created_at': instance.createdAt.toIso8601String(),
  };
}

Future<Retryable> _$RetryableFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Retryable(
    id: data['id'] as String,
    entityId: data['entity_id'] as String,
    entityTable: data['entity_table'] as String,
    lastFailureReason: data['last_failure_reason'] as String,
    retryCount: data['retry_count'] as int,
    createdAt: DateTime.parse(data['created_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$RetryableToSqlite(
  Retryable instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'entity_id': instance.entityId,
    'entity_table': instance.entityTable,
    'last_failure_reason': instance.lastFailureReason,
    'retry_count': instance.retryCount,
    'created_at': instance.createdAt.toIso8601String(),
  };
}

/// Construct a [Retryable]
class RetryableAdapter extends OfflineFirstWithSupabaseAdapter<Retryable> {
  RetryableAdapter();

  @override
  final supabaseTableName = 'retryables';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'entityId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'entity_id',
    ),
    'entityTable': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'entity_table',
    ),
    'lastFailureReason': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_failure_reason',
    ),
    'retryCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'retry_count',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    'entityId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'entity_id',
      iterable: false,
      type: String,
    ),
    'entityTable': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'entity_table',
      iterable: false,
      type: String,
    ),
    'lastFailureReason': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_failure_reason',
      iterable: false,
      type: String,
    ),
    'retryCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'retry_count',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Retryable instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Retryable` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Retryable';

  @override
  Future<Retryable> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RetryableFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Retryable input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RetryableToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Retryable> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RetryableFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Retryable input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$RetryableToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
