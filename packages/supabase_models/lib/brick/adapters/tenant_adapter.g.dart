// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Tenant> _$TenantFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Tenant(
      id: data['id'] as String?,
      name: data['name'] as String?,
      phoneNumber: data['phone_number'] as String?,
      email: data['email'] as String?,
      nfcEnabled: data['nfc_enabled'] as bool,
      businessId: data['business_id'] as int?,
      userId: data['user_id'] as int?,
      imageUrl: data['image_url'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      pin: data['pin'] as int?,
      sessionActive: data['session_active'] as bool?,
      isDefault: data['is_default'] as bool?,
      isLongPressed: data['is_long_pressed'] as bool,
      type: data['type'] as String);
}

Future<Map<String, dynamic>> _$TenantToSupabase(Tenant instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'phone_number': instance.phoneNumber,
    'email': instance.email,
    'nfc_enabled': instance.nfcEnabled,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'image_url': instance.imageUrl,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'pin': instance.pin,
    'session_active': instance.sessionActive,
    'is_default': instance.isDefault,
    'is_long_pressed': instance.isLongPressed,
    'type': instance.type
  };
}

Future<Tenant> _$TenantFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Tenant(
      id: data['id'] as String,
      name: data['name'] == null ? null : data['name'] as String?,
      phoneNumber:
          data['phone_number'] == null ? null : data['phone_number'] as String?,
      email: data['email'] == null ? null : data['email'] as String?,
      nfcEnabled: data['nfc_enabled'] == 1,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      userId: data['user_id'] == null ? null : data['user_id'] as int?,
      imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
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
      pin: data['pin'] == null ? null : data['pin'] as int?,
      sessionActive:
          data['session_active'] == null ? null : data['session_active'] == 1,
      isDefault: data['is_default'] == null ? null : data['is_default'] == 1,
      isLongPressed: data['is_long_pressed'] == 1,
      type: data['type'] as String)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TenantToSqlite(Tenant instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'phone_number': instance.phoneNumber,
    'email': instance.email,
    'nfc_enabled': instance.nfcEnabled ? 1 : 0,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'image_url': instance.imageUrl,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'pin': instance.pin,
    'session_active': instance.sessionActive == null
        ? null
        : (instance.sessionActive! ? 1 : 0),
    'is_default':
        instance.isDefault == null ? null : (instance.isDefault! ? 1 : 0),
    'is_long_pressed': instance.isLongPressed ? 1 : 0,
    'type': instance.type
  };
}

/// Construct a [Tenant]
class TenantAdapter extends OfflineFirstWithSupabaseAdapter<Tenant> {
  TenantAdapter();

  @override
  final supabaseTableName = 'tenants';
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
    'phoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number',
    ),
    'email': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'email',
    ),
    'nfcEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'nfc_enabled',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'imageUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'image_url',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'pin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pin',
    ),
    'sessionActive': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'session_active',
    ),
    'isDefault': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_default',
    ),
    'isLongPressed': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_long_pressed',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    )
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
    'phoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number',
      iterable: false,
      type: String,
    ),
    'email': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'email',
      iterable: false,
      type: String,
    ),
    'nfcEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'nfc_enabled',
      iterable: false,
      type: bool,
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
    'imageUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'image_url',
      iterable: false,
      type: String,
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
    'pin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pin',
      iterable: false,
      type: int,
    ),
    'sessionActive': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'session_active',
      iterable: false,
      type: bool,
    ),
    'isDefault': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_default',
      iterable: false,
      type: bool,
    ),
    'isLongPressed': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_long_pressed',
      iterable: false,
      type: bool,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Tenant instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Tenant` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Tenant';

  @override
  Future<Tenant> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TenantFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Tenant input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TenantToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Tenant> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TenantFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Tenant input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$TenantToSqlite(input, provider: provider, repository: repository);
}
