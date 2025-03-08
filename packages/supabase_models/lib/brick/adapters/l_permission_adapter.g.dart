// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<LPermission> _$LPermissionFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return LPermission(
    id: data['id'] as String?,
    name: data['name'] == null ? null : data['name'] as String?,
    userId: data['user_id'] == null ? null : data['user_id'] as int?,
  );
}

Future<Map<String, dynamic>> _$LPermissionToSupabase(
  LPermission instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {'id': instance.id, 'name': instance.name, 'user_id': instance.userId};
}

Future<LPermission> _$LPermissionFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return LPermission(
    id: data['id'] as String,
    name: data['name'] == null ? null : data['name'] as String?,
    userId: data['user_id'] == null ? null : data['user_id'] as int?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$LPermissionToSqlite(
  LPermission instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {'id': instance.id, 'name': instance.name, 'user_id': instance.userId};
}

/// Construct a [LPermission]
class LPermissionAdapter extends OfflineFirstWithSupabaseAdapter<LPermission> {
  LPermissionAdapter();

  @override
  final supabaseTableName = 'permissions';
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
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
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
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: int,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    LPermission instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `LPermission` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'LPermission';

  @override
  Future<LPermission> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LPermissionFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    LPermission input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LPermissionToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<LPermission> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LPermissionFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    LPermission input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$LPermissionToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
