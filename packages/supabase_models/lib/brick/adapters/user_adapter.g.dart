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
    pin: data['pin'] == null ? null : data['pin'] as int?,
    editId: data['edit_id'] == null ? null : data['edit_id'] as bool?,
    isExternal: data['is_external'] == null
        ? null
        : data['is_external'] as bool?,
    ownership: data['ownership'] == null ? null : data['ownership'] as String?,
    groupId: data['group_id'] == null ? null : data['group_id'] as int?,
    external: data['external'] == null ? null : data['external'] as bool?,
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
        ? null
        : DateTime.tryParse(data['updated_at'] as String),
    deletedAt: data['deleted_at'] == null
        ? null
        : data['deleted_at'] == null
        ? null
        : DateTime.tryParse(data['deleted_at'] as String),
    phoneNumber: data['phone_number'] == null
        ? null
        : data['phone_number'] as String?,
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
    'pin': instance.pin,
    'edit_id': instance.editId,
    'is_external': instance.isExternal,
    'ownership': instance.ownership,
    'group_id': instance.groupId,
    'external': instance.external,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'phone_number': instance.phoneNumber,
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
    pin: data['pin'] == null ? null : data['pin'] as int?,
    editId: data['edit_id'] == null ? null : data['edit_id'] == 1,
    isExternal: data['is_external'] == null ? null : data['is_external'] == 1,
    ownership: data['ownership'] == null ? null : data['ownership'] as String?,
    groupId: data['group_id'] == null ? null : data['group_id'] as int?,
    external: data['external'] == null ? null : data['external'] == 1,
    updatedAt: data['updated_at'] == null
        ? null
        : data['updated_at'] == null
        ? null
        : DateTime.tryParse(data['updated_at'] as String),
    deletedAt: data['deleted_at'] == null
        ? null
        : data['deleted_at'] == null
        ? null
        : DateTime.tryParse(data['deleted_at'] as String),
    phoneNumber: data['phone_number'] == null
        ? null
        : data['phone_number'] as String?,
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
    'pin': instance.pin,
    'edit_id': instance.editId == null ? null : (instance.editId! ? 1 : 0),
    'is_external': instance.isExternal == null
        ? null
        : (instance.isExternal! ? 1 : 0),
    'ownership': instance.ownership,
    'group_id': instance.groupId,
    'external': instance.external == null ? null : (instance.external! ? 1 : 0),
    'updated_at': instance.updatedAt?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'phone_number': instance.phoneNumber,
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
    'pin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pin',
    ),
    'editId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'edit_id',
    ),
    'isExternal': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_external',
    ),
    'ownership': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ownership',
    ),
    'groupId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_id',
    ),
    'external': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'external',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'phoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number',
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
    'pin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pin',
      iterable: false,
      type: int,
    ),
    'editId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'edit_id',
      iterable: false,
      type: bool,
    ),
    'isExternal': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_external',
      iterable: false,
      type: bool,
    ),
    'ownership': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ownership',
      iterable: false,
      type: String,
    ),
    'groupId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'group_id',
      iterable: false,
      type: int,
    ),
    'external': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'external',
      iterable: false,
      type: bool,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'phoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number',
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
