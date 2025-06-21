// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<BusinessAnalytic> _$BusinessAnalyticFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BusinessAnalytic(
    id: data['id'] as String?,
    date: DateTime.parse(data['date'] as String),
    itemName: data['item_name'] as String,
    price: data['price'] as num,
    profit: data['profit'] as num,
    unitsSold: data['units_sold'] as int,
    taxRate: data['tax_rate'] as num,
    trafficCount: data['traffic_count'] as int,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    categoryName:
        data['category_name'] == null ? null : data['category_name'] as String?,
    categoryId:
        data['category_id'] == null ? null : data['category_id'] as String?,
  );
}

Future<Map<String, dynamic>> _$BusinessAnalyticToSupabase(
  BusinessAnalytic instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'date': instance.date.toIso8601String(),
    'item_name': instance.itemName,
    'price': instance.price,
    'profit': instance.profit,
    'units_sold': instance.unitsSold,
    'tax_rate': instance.taxRate,
    'traffic_count': instance.trafficCount,
    'branch_id': instance.branchId,
    'category_name': instance.categoryName,
    'category_id': instance.categoryId,
  };
}

Future<BusinessAnalytic> _$BusinessAnalyticFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BusinessAnalytic(
    id: data['id'] as String,
    date: DateTime.parse(data['date'] as String),
    itemName: data['item_name'] as String,
    price: data['price'] as num,
    profit: data['profit'] as num,
    unitsSold: data['units_sold'] as int,
    taxRate: data['tax_rate'] as num,
    trafficCount: data['traffic_count'] as int,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    categoryName:
        data['category_name'] == null ? null : data['category_name'] as String?,
    categoryId:
        data['category_id'] == null ? null : data['category_id'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BusinessAnalyticToSqlite(
  BusinessAnalytic instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'date': instance.date.toIso8601String(),
    'item_name': instance.itemName,
    'price': instance.price,
    'profit': instance.profit,
    'units_sold': instance.unitsSold,
    'tax_rate': instance.taxRate,
    'traffic_count': instance.trafficCount,
    'branch_id': instance.branchId,
    'category_name': instance.categoryName,
    'category_id': instance.categoryId,
  };
}

/// Construct a [BusinessAnalytic]
class BusinessAnalyticAdapter
    extends OfflineFirstWithSupabaseAdapter<BusinessAnalytic> {
  BusinessAnalyticAdapter();

  @override
  final supabaseTableName = 'business_analytics';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'date': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'date',
    ),
    'itemName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'item_name',
    ),
    'price': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'price',
    ),
    'profit': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profit',
    ),
    'unitsSold': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'units_sold',
    ),
    'taxRate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_rate',
    ),
    'trafficCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'traffic_count',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'categoryName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_name',
    ),
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
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
    'date': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'date',
      iterable: false,
      type: DateTime,
    ),
    'itemName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'item_name',
      iterable: false,
      type: String,
    ),
    'price': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'price',
      iterable: false,
      type: num,
    ),
    'profit': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'profit',
      iterable: false,
      type: num,
    ),
    'unitsSold': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'units_sold',
      iterable: false,
      type: int,
    ),
    'taxRate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_rate',
      iterable: false,
      type: num,
    ),
    'trafficCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'traffic_count',
      iterable: false,
      type: int,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'categoryName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_name',
      iterable: false,
      type: String,
    ),
    'categoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    BusinessAnalytic instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `BusinessAnalytic` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'BusinessAnalytic';

  @override
  Future<BusinessAnalytic> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BusinessAnalyticFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    BusinessAnalytic input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BusinessAnalyticToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<BusinessAnalytic> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BusinessAnalyticFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    BusinessAnalytic input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$BusinessAnalyticToSqlite(
        input,
        provider: provider,
        repository: repository,
      );
}
