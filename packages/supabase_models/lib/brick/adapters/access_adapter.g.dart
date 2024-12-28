// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Access> _$AccessFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Access(
      id: data['id'] as String?,
      branchId: data['branch_id'] as int?,
      businessId: data['business_id'] as int?,
      userId: data['user_id'] as int?,
      featureName: data['feature_name'] as String?,
      userType: data['user_type'] as String?,
      accessLevel: data['access_level'] as String?,
      createdAt: data['created_at'] == null
          ? null
          : DateTime.tryParse(data['created_at'] as String),
      expiresAt: data['expires_at'] == null
          ? null
          : DateTime.tryParse(data['expires_at'] as String),
      status: data['status'] as String?);
}

Future<Map<String, dynamic>> _$AccessToSupabase(Access instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'feature_name': instance.featureName,
    'user_type': instance.userType,
    'access_level': instance.accessLevel,
    'created_at': instance.createdAt?.toIso8601String(),
    'expires_at': instance.expiresAt?.toIso8601String(),
    'status': instance.status
  };
}

Future<Access> _$AccessFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Access(
      id: data['id'] as String,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      userId: data['user_id'] == null ? null : data['user_id'] as int?,
      featureName:
          data['feature_name'] == null ? null : data['feature_name'] as String?,
      userType: data['user_type'] == null ? null : data['user_type'] as String?,
      accessLevel:
          data['access_level'] == null ? null : data['access_level'] as String?,
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      expiresAt: data['expires_at'] == null
          ? null
          : data['expires_at'] == null
              ? null
              : DateTime.tryParse(data['expires_at'] as String),
      status: data['status'] == null ? null : data['status'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$AccessToSqlite(Access instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'feature_name': instance.featureName,
    'user_type': instance.userType,
    'access_level': instance.accessLevel,
    'created_at': instance.createdAt?.toIso8601String(),
    'expires_at': instance.expiresAt?.toIso8601String(),
    'status': instance.status
  };
}

/// Construct a [Access]
class AccessAdapter extends OfflineFirstWithSupabaseAdapter<Access> {
  AccessAdapter();

  @override
  final supabaseTableName = 'accesses';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
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
    'featureName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'feature_name',
    ),
    'userType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_type',
    ),
    'accessLevel': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'access_level',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'expiresAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'expires_at',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
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
    'featureName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'feature_name',
      iterable: false,
      type: String,
    ),
    'userType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_type',
      iterable: false,
      type: String,
    ),
    'accessLevel': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'access_level',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'expiresAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'expires_at',
      iterable: false,
      type: DateTime,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Access instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Access` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Access';

  @override
  Future<Access> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$AccessFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Access input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$AccessToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Access> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$AccessFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Access input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$AccessToSqlite(input, provider: provider, repository: repository);
}
