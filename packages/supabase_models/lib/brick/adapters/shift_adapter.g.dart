// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Shift> _$ShiftFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Shift(
    id: data['id'] as String,
    businessId: data['business_id'] as int,
    userId: data['user_id'] as int,
    startAt: DateTime.parse(data['start_at'] as String),
    endAt:
        data['end_at'] == null
            ? null
            : data['end_at'] == null
            ? null
            : DateTime.tryParse(data['end_at'] as String),
    openingBalance: data['opening_balance'] as double,
    closingBalance:
        data['closing_balance'] == null
            ? null
            : data['closing_balance'] as double?,
    status: ShiftStatus.values[data['status'] as int],
    cashSales:
        data['cash_sales'] == null ? null : data['cash_sales'] as double?,
    expectedCash:
        data['expected_cash'] == null ? null : data['expected_cash'] as double?,
    cashDifference:
        data['cash_difference'] == null
            ? null
            : data['cash_difference'] as double?,
  );
}

Future<Map<String, dynamic>> _$ShiftToSupabase(
  Shift instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'start_at': instance.startAt.toIso8601String(),
    'end_at': instance.endAt?.toIso8601String(),
    'opening_balance': instance.openingBalance,
    'closing_balance': instance.closingBalance,
    'status': ShiftStatus.values.indexOf(instance.status),
    'cash_sales': instance.cashSales,
    'expected_cash': instance.expectedCash,
    'cash_difference': instance.cashDifference,
  };
}

Future<Shift> _$ShiftFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Shift(
    id: data['id'] as String,
    businessId: data['business_id'] as int,
    userId: data['user_id'] as int,
    startAt: DateTime.parse(data['start_at'] as String),
    endAt:
        data['end_at'] == null
            ? null
            : data['end_at'] == null
            ? null
            : DateTime.tryParse(data['end_at'] as String),
    openingBalance: data['opening_balance'] as double,
    closingBalance:
        data['closing_balance'] == null
            ? null
            : data['closing_balance'] as double?,
    status: data['status'],
    cashSales:
        data['cash_sales'] == null ? null : data['cash_sales'] as double?,
    expectedCash:
        data['expected_cash'] == null ? null : data['expected_cash'] as double?,
    cashDifference:
        data['cash_difference'] == null
            ? null
            : data['cash_difference'] as double?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ShiftToSqlite(
  Shift instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'user_id': instance.userId,
    'start_at': instance.startAt.toIso8601String(),
    'end_at': instance.endAt?.toIso8601String(),
    'opening_balance': instance.openingBalance,
    'closing_balance': instance.closingBalance,
    'status': instance.status,
    'cash_sales': instance.cashSales,
    'expected_cash': instance.expectedCash,
    'cash_difference': instance.cashDifference,
  };
}

/// Construct a [Shift]
class ShiftAdapter extends OfflineFirstWithSupabaseAdapter<Shift> {
  ShiftAdapter();

  @override
  final supabaseTableName = 'shifts';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'startAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'start_at',
    ),
    'endAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'end_at',
    ),
    'openingBalance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'opening_balance',
    ),
    'closingBalance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'closing_balance',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'cashSales': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cash_sales',
    ),
    'expectedCash': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'expected_cash',
    ),
    'cashDifference': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cash_difference',
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
    'startAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'start_at',
      iterable: false,
      type: DateTime,
    ),
    'endAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'end_at',
      iterable: false,
      type: DateTime,
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
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: ShiftStatus,
    ),
    'cashSales': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cash_sales',
      iterable: false,
      type: double,
    ),
    'expectedCash': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'expected_cash',
      iterable: false,
      type: double,
    ),
    'cashDifference': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cash_difference',
      iterable: false,
      type: double,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Shift instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Shift` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Shift';

  @override
  Future<Shift> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ShiftFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Shift input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ShiftToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Shift> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ShiftFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Shift input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$ShiftToSqlite(input, provider: provider, repository: repository);
}
