// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<User> _$UserFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return User(
    id: data['id'] as String?,
    name: data['name'] == null ? null : data['name'] as String?,
    key: data['key'] == null ? null : data['key'] as String?,
    uuid: data['uuid'] == null ? null : data['uuid'] as String?,
  );
}

Future<Map<String, dynamic>> _$UserToSupabase(
  User instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'key': instance.key,
    'uuid': instance.uuid,
  };
}

Future<User> _$UserFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return User(
    id: data['id'] as String,
    name: data['name'] == null ? null : data['name'] as String?,
    key: data['key'] == null ? null : data['key'] as String?,
    uuid: data['uuid'] == null ? null : data['uuid'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$UserToSqlite(
  User instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'key': instance.key,
    'uuid': instance.uuid,
  };
}

/// Construct a [User]
class UserAdapter extends OfflineFirstWithSupabaseAdapter<User> {
  UserAdapter();

  @override
  final supabaseTableName = 'users';
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
    'key': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'key',
    ),
    'uuid': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'uuid',
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
    'key': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'key',
      iterable: false,
      type: String,
    ),
    'uuid': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'uuid',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    User instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `User` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'User';

  @override
  Future<User> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$UserFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    User input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$UserToSupabase(input, provider: provider, repository: repository);
  @override
  Future<User> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$UserFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    User input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$UserToSqlite(input, provider: provider, repository: repository);
}
