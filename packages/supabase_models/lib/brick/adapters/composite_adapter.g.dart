// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Composite> _$CompositeFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Composite(
      id: data['id'] as int,
      productId: data['product_id'] as int?,
      variantId: data['variant_id'] as int?,
      qty: data['qty'] as double?,
      branchId: data['branch_id'] as int?,
      businessId: data['business_id'] as int?,
      actualPrice: data['actual_price'] as double?);
}

Future<Map<String, dynamic>> _$CompositeToSupabase(Composite instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'product_id': instance.productId,
    'variant_id': instance.variantId,
    'qty': instance.qty,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'actual_price': instance.actualPrice
  };
}


Future<Composite> _$CompositeFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Composite(
      id: data['id'] as int,
      productId: data['product_id'] == null ? null : data['product_id'] as int?,
      variantId: data['variant_id'] == null ? null : data['variant_id'] as int?,
      qty: data['qty'] == null ? null : data['qty'] as double?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      actualPrice:
          data['actual_price'] == null ? null : data['actual_price'] as double?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CompositeToSqlite(Composite instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'product_id': instance.productId,
    'variant_id': instance.variantId,
    'qty': instance.qty,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'actual_price': instance.actualPrice
  };
}

/// Construct a [Composite]
class CompositeAdapter extends OfflineFirstWithSupabaseAdapter<Composite> {
  CompositeAdapter();

  @override
  final supabaseTableName = 'composites';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'productId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'product_id',
    ),
    'variantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'variant_id',
    ),
    'qty': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'qty',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'actualPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'actual_price',
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
      type: int,
    ),
    'productId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'product_id',
      iterable: false,
      type: int,
    ),
    'variantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variant_id',
      iterable: false,
      type: int,
    ),
    'qty': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'qty',
      iterable: false,
      type: double,
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
    'actualPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'actual_price',
      iterable: false,
      type: double,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Composite instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Composite` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Composite';

  @override
  Future<Composite> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CompositeFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Composite input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CompositeToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Composite> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CompositeFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Composite input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CompositeToSqlite(input,
          provider: provider, repository: repository);
}
