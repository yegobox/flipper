// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<UnversalProduct> _$UnversalProductFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return UnversalProduct(
      id: data['id'] as String?,
      itemClsCd:
          data['item_cls_cd'] == null ? null : data['item_cls_cd'] as String?,
      itemClsNm:
          data['item_cls_nm'] == null ? null : data['item_cls_nm'] as String?,
      itemClsLvl:
          data['item_cls_lvl'] == null ? null : data['item_cls_lvl'] as int?,
      taxTyCd: data['tax_ty_cd'] == null ? null : data['tax_ty_cd'] as String?,
      mjrTgYn: data['mjr_tg_yn'] == null ? null : data['mjr_tg_yn'] as String?,
      useYn: data['use_yn'] == null ? null : data['use_yn'] as String?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?);
}

Future<Map<String, dynamic>> _$UnversalProductToSupabase(
    UnversalProduct instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'item_cls_cd': instance.itemClsCd,
    'item_cls_nm': instance.itemClsNm,
    'item_cls_lvl': instance.itemClsLvl,
    'tax_ty_cd': instance.taxTyCd,
    'mjr_tg_yn': instance.mjrTgYn,
    'use_yn': instance.useYn,
    'business_id': instance.businessId,
    'branch_id': instance.branchId
  };
}

Future<UnversalProduct> _$UnversalProductFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return UnversalProduct(
      id: data['id'] as String,
      itemClsCd:
          data['item_cls_cd'] == null ? null : data['item_cls_cd'] as String?,
      itemClsNm:
          data['item_cls_nm'] == null ? null : data['item_cls_nm'] as String?,
      itemClsLvl:
          data['item_cls_lvl'] == null ? null : data['item_cls_lvl'] as int?,
      taxTyCd: data['tax_ty_cd'] == null ? null : data['tax_ty_cd'] as String?,
      mjrTgYn: data['mjr_tg_yn'] == null ? null : data['mjr_tg_yn'] as String?,
      useYn: data['use_yn'] == null ? null : data['use_yn'] as String?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$UnversalProductToSqlite(UnversalProduct instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'item_cls_cd': instance.itemClsCd,
    'item_cls_nm': instance.itemClsNm,
    'item_cls_lvl': instance.itemClsLvl,
    'tax_ty_cd': instance.taxTyCd,
    'mjr_tg_yn': instance.mjrTgYn,
    'use_yn': instance.useYn,
    'business_id': instance.businessId,
    'branch_id': instance.branchId
  };
}

/// Construct a [UnversalProduct]
class UnversalProductAdapter
    extends OfflineFirstWithSupabaseAdapter<UnversalProduct> {
  UnversalProductAdapter();

  @override
  final supabaseTableName = 'uni_products';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'itemClsCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_cls_cd',
    ),
    'itemClsNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_cls_nm',
    ),
    'itemClsLvl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_cls_lvl',
    ),
    'taxTyCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_ty_cd',
    ),
    'mjrTgYn': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'mjr_tg_yn',
    ),
    'useYn': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'use_yn',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
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
    'itemClsCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_cls_cd',
      iterable: false,
      type: String,
    ),
    'itemClsNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_cls_nm',
      iterable: false,
      type: String,
    ),
    'itemClsLvl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_cls_lvl',
      iterable: false,
      type: int,
    ),
    'taxTyCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_ty_cd',
      iterable: false,
      type: String,
    ),
    'mjrTgYn': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'mjr_tg_yn',
      iterable: false,
      type: String,
    ),
    'useYn': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'use_yn',
      iterable: false,
      type: String,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      UnversalProduct instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `UnversalProduct` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'UnversalProduct';

  @override
  Future<UnversalProduct> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$UnversalProductFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(UnversalProduct input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$UnversalProductToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<UnversalProduct> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$UnversalProductFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(UnversalProduct input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$UnversalProductToSqlite(input,
          provider: provider, repository: repository);
}
