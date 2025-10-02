// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<StockRecountItem> _$StockRecountItemFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StockRecountItem(
    id: data['id'] as String?,
    recountId: data['recount_id'] as String,
    variantId: data['variant_id'] as String,
    stockId: data['stock_id'] as String,
    productName: data['product_name'] as String,
    previousQuantity: data['previous_quantity'] as double? ?? 0.0,
    countedQuantity: data['counted_quantity'] as double? ?? 0.0,
    difference: data['difference'] as double? ?? 0.0,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
  );
}

Future<Map<String, dynamic>> _$StockRecountItemToSupabase(
  StockRecountItem instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'recount_id': instance.recountId,
    'variant_id': instance.variantId,
    'stock_id': instance.stockId,
    'product_name': instance.productName,
    'previous_quantity': instance.previousQuantity,
    'counted_quantity': instance.countedQuantity,
    'difference': instance.difference,
    'notes': instance.notes,
    'created_at': instance.createdAt.toIso8601String(),
  };
}

Future<StockRecountItem> _$StockRecountItemFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StockRecountItem(
    id: data['id'] as String,
    recountId: data['recount_id'] as String,
    variantId: data['variant_id'] as String,
    stockId: data['stock_id'] as String,
    productName: data['product_name'] as String,
    previousQuantity: data['previous_quantity'],
    countedQuantity: data['counted_quantity'],
    difference: data['difference'],
    notes: data['notes'] == null ? null : data['notes'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$StockRecountItemToSqlite(
  StockRecountItem instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'recount_id': instance.recountId,
    'variant_id': instance.variantId,
    'stock_id': instance.stockId,
    'product_name': instance.productName,
    'previous_quantity': instance.previousQuantity,
    'counted_quantity': instance.countedQuantity,
    'difference': instance.difference,
    'notes': instance.notes,
    'created_at': instance.createdAt.toIso8601String(),
  };
}

/// Construct a [StockRecountItem]
class StockRecountItemAdapter
    extends OfflineFirstWithSupabaseAdapter<StockRecountItem> {
  StockRecountItemAdapter();

  @override
  final supabaseTableName = 'stock_recount_items';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'recountId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recount_id',
      foreignKey: 'stock_recount_id',
    ),
    'variantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'variant_id',
      foreignKey: 'variant_id',
    ),
    'stockId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'stock_id',
      foreignKey: 'stock_id',
    ),
    'productName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'product_name',
    ),
    'previousQuantity': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'previous_quantity',
    ),
    'countedQuantity': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'counted_quantity',
    ),
    'difference': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'difference',
    ),
    'notes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notes',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    'recountId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'recount_id',
      iterable: false,
      type: String,
    ),
    'variantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variant_id',
      iterable: false,
      type: String,
    ),
    'stockId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'stock_id',
      iterable: false,
      type: String,
    ),
    'productName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'product_name',
      iterable: false,
      type: String,
    ),
    'previousQuantity': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'previous_quantity',
      iterable: false,
      type: double,
    ),
    'countedQuantity': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'counted_quantity',
      iterable: false,
      type: double,
    ),
    'difference': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'difference',
      iterable: false,
      type: double,
    ),
    'notes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notes',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    StockRecountItem instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `StockRecountItem` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'StockRecountItem';

  @override
  Future<StockRecountItem> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountItemFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    StockRecountItem input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountItemToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<StockRecountItem> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountItemFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    StockRecountItem input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountItemToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
