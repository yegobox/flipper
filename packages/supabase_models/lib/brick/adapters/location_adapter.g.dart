// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Location> _$LocationFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Location(
      id: data['id'] as String?,
      serverId: data['server_id'] as int?,
      active: data['active'] as bool?,
      description: data['description'] as String?,
      name: data['name'] as String?,
      businessId: data['business_id'] as int?,
      longitude: data['longitude'] as String?,
      latitude: data['latitude'] as String?,
      location: data['location'] as String?,
      isDefault: data['is_default'] as bool,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      isOnline: data['is_online'] as bool?);
}

Future<Map<String, dynamic>> _$LocationToSupabase(Location instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'server_id': instance.serverId,
    'active': instance.active,
    'description': instance.description,
    'name': instance.name,
    'business_id': instance.businessId,
    'longitude': instance.longitude,
    'latitude': instance.latitude,
    'location': instance.location,
    'is_default': instance.isDefault,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_online': instance.isOnline
  };
}

Future<Location> _$LocationFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Location(
      id: data['id'] as String,
      serverId: data['server_id'] == null ? null : data['server_id'] as int?,
      active: data['active'] == null ? null : data['active'] == 1,
      description:
          data['description'] == null ? null : data['description'] as String?,
      name: data['name'] == null ? null : data['name'] as String?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      longitude:
          data['longitude'] == null ? null : data['longitude'] as String?,
      latitude: data['latitude'] == null ? null : data['latitude'] as String?,
      location: data['location'] == null ? null : data['location'] as String?,
      isDefault: data['is_default'] == 1,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      isOnline: data['is_online'] == null ? null : data['is_online'] == 1)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$LocationToSqlite(Location instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'server_id': instance.serverId,
    'active': instance.active == null ? null : (instance.active! ? 1 : 0),
    'description': instance.description,
    'name': instance.name,
    'business_id': instance.businessId,
    'longitude': instance.longitude,
    'latitude': instance.latitude,
    'location': instance.location,
    'is_default': instance.isDefault ? 1 : 0,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'is_online': instance.isOnline == null ? null : (instance.isOnline! ? 1 : 0)
  };
}

/// Construct a [Location]
class LocationAdapter extends OfflineFirstWithSupabaseAdapter<Location> {
  LocationAdapter();

  @override
  final supabaseTableName = 'locations';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'serverId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'server_id',
    ),
    'active': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'active',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'longitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'longitude',
    ),
    'latitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'latitude',
    ),
    'location': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'location',
    ),
    'isDefault': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_default',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
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
      type: String,
    ),
    'serverId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'server_id',
      iterable: false,
      type: int,
    ),
    'active': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'active',
      iterable: false,
      type: bool,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'longitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'longitude',
      iterable: false,
      type: String,
    ),
    'latitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'latitude',
      iterable: false,
      type: String,
    ),
    'location': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'location',
      iterable: false,
      type: String,
    ),
    'isDefault': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_default',
      iterable: false,
      type: bool,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
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
      Location instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Location` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Location';

  @override
  Future<Location> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$LocationFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Location input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$LocationToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Location> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$LocationFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Location input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$LocationToSqlite(input,
          provider: provider, repository: repository);
}
