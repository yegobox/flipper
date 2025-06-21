// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Assets> _$AssetsFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Assets(
    id: data['id'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    assetName:
        data['asset_name'] == null ? null : data['asset_name'] as String?,
    productId:
        data['product_id'] == null ? null : data['product_id'] as String?,
    isUploaded: data['is_uploaded'] as bool,
    localPath:
        data['local_path'] == null ? null : data['local_path'] as String?,
  );
}

Future<Map<String, dynamic>> _$AssetsToSupabase(
  Assets instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'asset_name': instance.assetName,
    'product_id': instance.productId,
    'is_uploaded': instance.isUploaded,
    'local_path': instance.localPath,
  };
}

Future<Assets> _$AssetsFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Assets(
    id: data['id'] as String,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    assetName:
        data['asset_name'] == null ? null : data['asset_name'] as String?,
    productId:
        data['product_id'] == null ? null : data['product_id'] as String?,
    isUploaded: data['is_uploaded'] == 1,
    localPath:
        data['local_path'] == null ? null : data['local_path'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$AssetsToSqlite(
  Assets instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'asset_name': instance.assetName,
    'product_id': instance.productId,
    'is_uploaded': instance.isUploaded ? 1 : 0,
    'local_path': instance.localPath,
  };
}

/// Construct a [Assets]
class AssetsAdapter extends OfflineFirstWithSupabaseAdapter<Assets> {
  AssetsAdapter();

  @override
  final supabaseTableName = 'assets';
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
    'assetName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'asset_name',
    ),
    'productId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'product_id',
    ),
    'isUploaded': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_uploaded',
    ),
    'localPath': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'local_path',
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
    'assetName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'asset_name',
      iterable: false,
      type: String,
    ),
    'productId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'product_id',
      iterable: false,
      type: String,
    ),
    'isUploaded': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_uploaded',
      iterable: false,
      type: bool,
    ),
    'localPath': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'local_path',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Assets instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Assets` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Assets';

  @override
  Future<Assets> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$AssetsFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Assets input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$AssetsToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Assets> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$AssetsFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Assets input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$AssetsToSqlite(input, provider: provider, repository: repository);
}
