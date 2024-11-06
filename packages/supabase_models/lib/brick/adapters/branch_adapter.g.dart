// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Branch> _$BranchFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Branch(
      id: data['id'] as int,
      name: data['name'] as String?,
      serverId: data['server_id'] as int?,
      location: data['location'] as String?,
      description: data['description'] as String?,
      active: data['active'] as bool?,
      businessId: data['business_id'] as int?,
      latitude: data['latitude'] as String?,
      longitude: data['longitude'] as String?,
      isDefault: data['is_default'] as bool?,
      isOnline: data['is_online'] as bool?);
}

Future<Map<String, dynamic>> _$BranchToSupabase(Branch instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'server_id': instance.serverId,
    'location': instance.location,
    'description': instance.description,
    'active': instance.active,
    'business_id': instance.businessId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'is_default': instance.isDefault,
    'is_online': instance.isOnline
  };
}

Future<Branch> _$BranchFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Branch(
      id: data['id'] as int,
      name: data['name'] == null ? null : data['name'] as String?,
      serverId: data['server_id'] == null ? null : data['server_id'] as int?,
      location: data['location'] == null ? null : data['location'] as String?,
      description:
          data['description'] == null ? null : data['description'] as String?,
      active: data['active'] == null ? null : data['active'] == 1,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      latitude: data['latitude'] == null ? null : data['latitude'] as String?,
      longitude:
          data['longitude'] == null ? null : data['longitude'] as String?,
      isDefault: data['is_default'] == null ? null : data['is_default'] == 1,
      isOnline: data['is_online'] == null ? null : data['is_online'] == 1)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BranchToSqlite(Branch instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'server_id': instance.serverId,
    'location': instance.location,
    'description': instance.description,
    'active': instance.active == null ? null : (instance.active! ? 1 : 0),
    'business_id': instance.businessId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'is_default':
        instance.isDefault == null ? null : (instance.isDefault! ? 1 : 0),
    'is_online': instance.isOnline == null ? null : (instance.isOnline! ? 1 : 0)
  };
}

/// Construct a [Branch]
class BranchAdapter extends OfflineFirstWithSupabaseAdapter<Branch> {
  BranchAdapter();

  @override
  final supabaseTableName = 'branchs';
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
    'serverId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'server_id',
    ),
    'location': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'location',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'active': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'active',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'latitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'latitude',
    ),
    'longitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'longitude',
    ),
    'isDefault': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_default',
    ),
    'isOnline': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_online',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
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
      type: int,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'serverId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'server_id',
      iterable: false,
      type: int,
    ),
    'location': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'location',
      iterable: false,
      type: String,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'active': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'active',
      iterable: false,
      type: bool,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'latitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'latitude',
      iterable: false,
      type: String,
    ),
    'longitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'longitude',
      iterable: false,
      type: String,
    ),
    'isDefault': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_default',
      iterable: false,
      type: bool,
    ),
    'isOnline': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_online',
      iterable: false,
      type: bool,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Branch instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Branch` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Branch';

  @override
  Future<Branch> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BranchFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Branch input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BranchToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Branch> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BranchFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Branch input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BranchToSqlite(input, provider: provider, repository: repository);
}
