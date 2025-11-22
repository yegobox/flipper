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
    stockRemainedAtTheTimeOfSale:
        data['stock_remained_at_the_time_of_sale'] as num,
    taxRate: data['tax_rate'] as num,
    trafficCount: data['traffic_count'] as int,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    categoryName: data['category_name'] == null
        ? null
        : data['category_name'] as String?,
    categoryId: data['category_id'] == null
        ? null
        : data['category_id'] as String?,
    transactionId: data['transaction_id'] == null
        ? null
        : data['transaction_id'] as String?,
    value: data['value'] as num,
    supplyPrice: data['supply_price'] as num,
    retailPrice: data['retail_price'] as num,
    currentStock: data['current_stock'] as num,
    stockValue: data['stock_value'] as num,
    paymentMethod: data['payment_method'] as String,
    customerType: data['customer_type'] as String,
    discountAmount: data['discount_amount'] as num,
    taxAmount: data['tax_amount'] as num,
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
    'stock_remained_at_the_time_of_sale': instance.stockRemainedAtTheTimeOfSale,
    'tax_rate': instance.taxRate,
    'traffic_count': instance.trafficCount,
    'branch_id': instance.branchId,
    'category_name': instance.categoryName,
    'category_id': instance.categoryId,
    'transaction_id': instance.transactionId,
    'value': instance.value,
    'supply_price': instance.supplyPrice,
    'retail_price': instance.retailPrice,
    'current_stock': instance.currentStock,
    'stock_value': instance.stockValue,
    'payment_method': instance.paymentMethod,
    'customer_type': instance.customerType,
    'discount_amount': instance.discountAmount,
    'tax_amount': instance.taxAmount,
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
    stockRemainedAtTheTimeOfSale:
        data['stock_remained_at_the_time_of_sale'] as num,
    taxRate: data['tax_rate'] as num,
    trafficCount: data['traffic_count'] as int,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    categoryName: data['category_name'] == null
        ? null
        : data['category_name'] as String?,
    categoryId: data['category_id'] == null
        ? null
        : data['category_id'] as String?,
    transactionId: data['transaction_id'] == null
        ? null
        : data['transaction_id'] as String?,
    value: data['value'] as num,
    supplyPrice: data['supply_price'] as num,
    retailPrice: data['retail_price'] as num,
    currentStock: data['current_stock'] as num,
    stockValue: data['stock_value'] as num,
    paymentMethod: data['payment_method'] as String,
    customerType: data['customer_type'] as String,
    discountAmount: data['discount_amount'] as num,
    taxAmount: data['tax_amount'] as num,
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
    'stock_remained_at_the_time_of_sale': instance.stockRemainedAtTheTimeOfSale,
    'tax_rate': instance.taxRate,
    'traffic_count': instance.trafficCount,
    'branch_id': instance.branchId,
    'category_name': instance.categoryName,
    'category_id': instance.categoryId,
    'transaction_id': instance.transactionId,
    'value': instance.value,
    'supply_price': instance.supplyPrice,
    'retail_price': instance.retailPrice,
    'current_stock': instance.currentStock,
    'stock_value': instance.stockValue,
    'payment_method': instance.paymentMethod,
    'customer_type': instance.customerType,
    'discount_amount': instance.discountAmount,
    'tax_amount': instance.taxAmount,
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
    'stockRemainedAtTheTimeOfSale': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'stock_remained_at_the_time_of_sale',
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
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'value': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'value',
    ),
    'supplyPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'supply_price',
    ),
    'retailPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'retail_price',
    ),
    'currentStock': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'current_stock',
    ),
    'stockValue': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'stock_value',
    ),
    'paymentMethod': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_method',
    ),
    'customerType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_type',
    ),
    'discountAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount_amount',
    ),
    'taxAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_amount',
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
    'stockRemainedAtTheTimeOfSale': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'stock_remained_at_the_time_of_sale',
      iterable: false,
      type: num,
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
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: String,
    ),
    'value': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'value',
      iterable: false,
      type: num,
    ),
    'supplyPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'supply_price',
      iterable: false,
      type: num,
    ),
    'retailPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'retail_price',
      iterable: false,
      type: num,
    ),
    'currentStock': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'current_stock',
      iterable: false,
      type: num,
    ),
    'stockValue': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'stock_value',
      iterable: false,
      type: num,
    ),
    'paymentMethod': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_method',
      iterable: false,
      type: String,
    ),
    'customerType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_type',
      iterable: false,
      type: String,
    ),
    'discountAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount_amount',
      iterable: false,
      type: num,
    ),
    'taxAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amount',
      iterable: false,
      type: num,
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
  }) async => await _$BusinessAnalyticFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    BusinessAnalytic input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BusinessAnalyticToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<BusinessAnalytic> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BusinessAnalyticFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    BusinessAnalytic input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BusinessAnalyticToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
