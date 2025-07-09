// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Log> _$LogFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Log(
    id: data['id'] as String?,
    message: data['message'] == null ? null : data['message'] as String?,
    type: data['type'] == null ? null : data['type'] as String?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    tags: null,
    extra: null,
  );
}

Future<Map<String, dynamic>> _$LogToSupabase(
  Log instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'message': instance.message,
    'type': instance.type,
    'business_id': instance.businessId,
    'created_at': instance.createdAt?.toIso8601String(),
    'tags': instance.tags,
    'extra': instance.extra,
  };
}

Future<Log> _$LogFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Log(
    id: data['id'] as String,
    message: data['message'] == null ? null : data['message'] as String?,
    type: data['type'] == null ? null : data['type'] as String?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    tags: data['tags'] == null ? null : jsonDecode(data['tags']),
    extra: data['extra'] == null ? null : jsonDecode(data['extra']),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$LogToSqlite(
  Log instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'message': instance.message,
    'type': instance.type,
    'business_id': instance.businessId,
    'created_at': instance.createdAt?.toIso8601String(),
    'tags': instance.tags != null ? jsonEncode(instance.tags) : null,
    'extra': instance.extra != null ? jsonEncode(instance.extra) : null,
  };
}

/// Construct a [Log]
class LogAdapter extends OfflineFirstWithSupabaseAdapter<Log> {
  LogAdapter();

  @override
  final supabaseTableName = 'logs';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'message': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'message',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'tags': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tags',
    ),
    'extra': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'extra',
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
    'message': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'message',
      iterable: false,
      type: String,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'tags': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tags',
      iterable: false,
      type: Map,
    ),
    'extra': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'extra',
      iterable: false,
      type: Map,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Log instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Log` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Log';

  @override
  Future<Log> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$LogFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Log input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$LogToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Log> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$LogFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    Log input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$LogToSqlite(input, provider: provider, repository: repository);
}
