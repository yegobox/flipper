// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<SKU> _$SKUFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return SKU(
    id: data['id'] as String?,
    sku: data['sku'] == null ? null : data['sku'] as int?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    consumed: data['consumed'] == null ? null : data['consumed'] as bool?,
  );
}

Future<Map<String, dynamic>> _$SKUToSupabase(
  SKU instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'sku': instance.sku,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'consumed': instance.consumed,
  };
}

Future<SKU> _$SKUFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return SKU(
    id: data['id'] as String,
    sku: data['sku'] == null ? null : data['sku'] as int?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    consumed: data['consumed'] == null ? null : data['consumed'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$SKUToSqlite(
  SKU instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'sku': instance.sku,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'consumed': instance.consumed == null ? null : (instance.consumed! ? 1 : 0),
  };
}

/// Construct a [SKU]
class SKUAdapter extends OfflineFirstWithSupabaseAdapter<SKU> {
  SKUAdapter();

  @override
  final supabaseTableName = 'skus';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'sku': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sku',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'consumed': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'consumed',
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
    'sku': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sku',
      iterable: false,
      type: int,
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
    'consumed': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'consumed',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    SKU instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `SKU` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'SKU';

  @override
  Future<SKU> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SKUFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    SKU input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SKUToSupabase(input, provider: provider, repository: repository);
  @override
  Future<SKU> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SKUFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    SKU input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SKUToSqlite(input, provider: provider, repository: repository);
}
