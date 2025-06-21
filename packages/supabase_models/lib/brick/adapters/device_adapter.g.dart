// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Device> _$DeviceFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Device(
    id: data['id'] as String?,
    linkingCode:
        data['linking_code'] == null ? null : data['linking_code'] as String?,
    deviceName:
        data['device_name'] == null ? null : data['device_name'] as String?,
    deviceVersion: data['device_version'] == null
        ? null
        : data['device_version'] as String?,
    pubNubPublished: data['pub_nub_published'] == null
        ? null
        : data['pub_nub_published'] as bool?,
    phone: data['phone'] == null ? null : data['phone'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    userId: data['user_id'] == null ? null : data['user_id'] as int?,
    defaultApp:
        data['default_app'] == null ? null : data['default_app'] as String?,
    deletedAt: data['deleted_at'] == null
        ? null
        : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
  );
}

Future<Map<String, dynamic>> _$DeviceToSupabase(
  Device instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'linking_code': instance.linkingCode,
    'device_name': instance.deviceName,
    'device_version': instance.deviceVersion,
    'pub_nub_published': instance.pubNubPublished,
    'phone': instance.phone,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'default_app': instance.defaultApp,
    'deleted_at': instance.deletedAt?.toIso8601String(),
  };
}

Future<Device> _$DeviceFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Device(
    id: data['id'] as String,
    linkingCode:
        data['linking_code'] == null ? null : data['linking_code'] as String?,
    deviceName:
        data['device_name'] == null ? null : data['device_name'] as String?,
    deviceVersion: data['device_version'] == null
        ? null
        : data['device_version'] as String?,
    pubNubPublished: data['pub_nub_published'] == null
        ? null
        : data['pub_nub_published'] == 1,
    phone: data['phone'] == null ? null : data['phone'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    userId: data['user_id'] == null ? null : data['user_id'] as int?,
    defaultApp:
        data['default_app'] == null ? null : data['default_app'] as String?,
    deletedAt: data['deleted_at'] == null
        ? null
        : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$DeviceToSqlite(
  Device instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'linking_code': instance.linkingCode,
    'device_name': instance.deviceName,
    'device_version': instance.deviceVersion,
    'pub_nub_published': instance.pubNubPublished == null
        ? null
        : (instance.pubNubPublished! ? 1 : 0),
    'phone': instance.phone,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'default_app': instance.defaultApp,
    'deleted_at': instance.deletedAt?.toIso8601String(),
  };
}

/// Construct a [Device]
class DeviceAdapter extends OfflineFirstWithSupabaseAdapter<Device> {
  DeviceAdapter();

  @override
  final supabaseTableName = 'devices';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'linkingCode': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'linking_code',
    ),
    'deviceName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'device_name',
    ),
    'deviceVersion': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'device_version',
    ),
    'pubNubPublished': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pub_nub_published',
    ),
    'phone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'defaultApp': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'default_app',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
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
    'linkingCode': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'linking_code',
      iterable: false,
      type: String,
    ),
    'deviceName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'device_name',
      iterable: false,
      type: String,
    ),
    'deviceVersion': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'device_version',
      iterable: false,
      type: String,
    ),
    'pubNubPublished': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pub_nub_published',
      iterable: false,
      type: bool,
    ),
    'phone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: int,
    ),
    'defaultApp': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'default_app',
      iterable: false,
      type: String,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Device instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Device` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Device';

  @override
  Future<Device> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$DeviceFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Device input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$DeviceToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Device> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$DeviceFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Device input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$DeviceToSqlite(input, provider: provider, repository: repository);
}
