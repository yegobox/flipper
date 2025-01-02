// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Drawers> _$DrawersFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Drawers(
      id: data['id'] as String?,
      openingBalance: data['opening_balance'] as double?,
      closingBalance: data['closing_balance'] as double?,
      openingDateTime: data['opening_date_time'] == null
          ? null
          : DateTime.tryParse(data['opening_date_time'] as String),
      closingDateTime: data['closing_date_time'] == null
          ? null
          : DateTime.tryParse(data['closing_date_time'] as String),
      csSaleCount: data['cs_sale_count'] as int?,
      tradeName: data['trade_name'] as String?,
      totalNsSaleIncome: data['total_ns_sale_income'] as double?,
      totalCsSaleIncome: data['total_cs_sale_income'] as double?,
      nrSaleCount: data['nr_sale_count'] as int?,
      nsSaleCount: data['ns_sale_count'] as int?,
      trSaleCount: data['tr_sale_count'] as int?,
      psSaleCount: data['ps_sale_count'] as int?,
      incompleteSale: data['incomplete_sale'] as int?,
      otherTransactions: data['other_transactions'] as int?,
      paymentMode: data['payment_mode'] as String?,
      cashierId: data['cashier_id'] as int?,
      open: data['open'] as bool?,
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      businessId: data['business_id'] as int?,
      branchId: data['branch_id'] as int?);
}

Future<Map<String, dynamic>> _$DrawersToSupabase(Drawers instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'opening_balance': instance.openingBalance,
    'closing_balance': instance.closingBalance,
    'opening_date_time': instance.openingDateTime?.toIso8601String(),
    'closing_date_time': instance.closingDateTime?.toIso8601String(),
    'cs_sale_count': instance.csSaleCount,
    'trade_name': instance.tradeName,
    'total_ns_sale_income': instance.totalNsSaleIncome,
    'total_cs_sale_income': instance.totalCsSaleIncome,
    'nr_sale_count': instance.nrSaleCount,
    'ns_sale_count': instance.nsSaleCount,
    'tr_sale_count': instance.trSaleCount,
    'ps_sale_count': instance.psSaleCount,
    'incomplete_sale': instance.incompleteSale,
    'other_transactions': instance.otherTransactions,
    'payment_mode': instance.paymentMode,
    'cashier_id': instance.cashierId,
    'open': instance.open,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'business_id': instance.businessId,
    'branch_id': instance.branchId
  };
}

Future<Drawers> _$DrawersFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Drawers(
      id: data['id'] as String,
      openingBalance: data['opening_balance'] == null
          ? null
          : data['opening_balance'] as double?,
      closingBalance: data['closing_balance'] == null
          ? null
          : data['closing_balance'] as double?,
      openingDateTime: data['opening_date_time'] == null
          ? null
          : data['opening_date_time'] == null
              ? null
              : DateTime.tryParse(data['opening_date_time'] as String),
      closingDateTime: data['closing_date_time'] == null
          ? null
          : data['closing_date_time'] == null
              ? null
              : DateTime.tryParse(data['closing_date_time'] as String),
      csSaleCount:
          data['cs_sale_count'] == null ? null : data['cs_sale_count'] as int?,
      tradeName:
          data['trade_name'] == null ? null : data['trade_name'] as String?,
      totalNsSaleIncome: data['total_ns_sale_income'] == null
          ? null
          : data['total_ns_sale_income'] as double?,
      totalCsSaleIncome: data['total_cs_sale_income'] == null
          ? null
          : data['total_cs_sale_income'] as double?,
      nrSaleCount:
          data['nr_sale_count'] == null ? null : data['nr_sale_count'] as int?,
      nsSaleCount:
          data['ns_sale_count'] == null ? null : data['ns_sale_count'] as int?,
      trSaleCount:
          data['tr_sale_count'] == null ? null : data['tr_sale_count'] as int?,
      psSaleCount:
          data['ps_sale_count'] == null ? null : data['ps_sale_count'] as int?,
      incompleteSale: data['incomplete_sale'] == null
          ? null
          : data['incomplete_sale'] as int?,
      otherTransactions: data['other_transactions'] == null
          ? null
          : data['other_transactions'] as int?,
      paymentMode:
          data['payment_mode'] == null ? null : data['payment_mode'] as String?,
      cashierId: data['cashier_id'] == null ? null : data['cashier_id'] as int?,
      open: data['open'] == null ? null : data['open'] == 1,
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$DrawersToSqlite(Drawers instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'opening_balance': instance.openingBalance,
    'closing_balance': instance.closingBalance,
    'opening_date_time': instance.openingDateTime?.toIso8601String(),
    'closing_date_time': instance.closingDateTime?.toIso8601String(),
    'cs_sale_count': instance.csSaleCount,
    'trade_name': instance.tradeName,
    'total_ns_sale_income': instance.totalNsSaleIncome,
    'total_cs_sale_income': instance.totalCsSaleIncome,
    'nr_sale_count': instance.nrSaleCount,
    'ns_sale_count': instance.nsSaleCount,
    'tr_sale_count': instance.trSaleCount,
    'ps_sale_count': instance.psSaleCount,
    'incomplete_sale': instance.incompleteSale,
    'other_transactions': instance.otherTransactions,
    'payment_mode': instance.paymentMode,
    'cashier_id': instance.cashierId,
    'open': instance.open == null ? null : (instance.open! ? 1 : 0),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'business_id': instance.businessId,
    'branch_id': instance.branchId
  };
}

/// Construct a [Drawers]
class DrawersAdapter extends OfflineFirstWithSupabaseAdapter<Drawers> {
  DrawersAdapter();

  @override
  final supabaseTableName = 'drawers';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'openingBalance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'opening_balance',
    ),
    'closingBalance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'closing_balance',
    ),
    'openingDateTime': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'opening_date_time',
    ),
    'closingDateTime': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'closing_date_time',
    ),
    'csSaleCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cs_sale_count',
    ),
    'tradeName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'trade_name',
    ),
    'totalNsSaleIncome': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'total_ns_sale_income',
    ),
    'totalCsSaleIncome': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'total_cs_sale_income',
    ),
    'nrSaleCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'nr_sale_count',
    ),
    'nsSaleCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ns_sale_count',
    ),
    'trSaleCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tr_sale_count',
    ),
    'psSaleCount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ps_sale_count',
    ),
    'incompleteSale': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'incomplete_sale',
    ),
    'otherTransactions': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'other_transactions',
    ),
    'paymentMode': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_mode',
    ),
    'cashierId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cashier_id',
    ),
    'open': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'open',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
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
    'openingBalance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'opening_balance',
      iterable: false,
      type: double,
    ),
    'closingBalance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'closing_balance',
      iterable: false,
      type: double,
    ),
    'openingDateTime': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'opening_date_time',
      iterable: false,
      type: DateTime,
    ),
    'closingDateTime': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'closing_date_time',
      iterable: false,
      type: DateTime,
    ),
    'csSaleCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cs_sale_count',
      iterable: false,
      type: int,
    ),
    'tradeName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'trade_name',
      iterable: false,
      type: String,
    ),
    'totalNsSaleIncome': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'total_ns_sale_income',
      iterable: false,
      type: double,
    ),
    'totalCsSaleIncome': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'total_cs_sale_income',
      iterable: false,
      type: double,
    ),
    'nrSaleCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'nr_sale_count',
      iterable: false,
      type: int,
    ),
    'nsSaleCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ns_sale_count',
      iterable: false,
      type: int,
    ),
    'trSaleCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tr_sale_count',
      iterable: false,
      type: int,
    ),
    'psSaleCount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ps_sale_count',
      iterable: false,
      type: int,
    ),
    'incompleteSale': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'incomplete_sale',
      iterable: false,
      type: int,
    ),
    'otherTransactions': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'other_transactions',
      iterable: false,
      type: int,
    ),
    'paymentMode': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_mode',
      iterable: false,
      type: String,
    ),
    'cashierId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cashier_id',
      iterable: false,
      type: int,
    ),
    'open': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'open',
      iterable: false,
      type: bool,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
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
      Drawers instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Drawers` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Drawers';

  @override
  Future<Drawers> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DrawersFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Drawers input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DrawersToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Drawers> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DrawersFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Drawers input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DrawersToSqlite(input,
          provider: provider, repository: repository);
}
