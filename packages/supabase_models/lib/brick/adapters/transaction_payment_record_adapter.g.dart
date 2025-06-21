// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<TransactionPaymentRecord> _$TransactionPaymentRecordFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TransactionPaymentRecord(
    id: data['id'] as String?,
    transactionId: data['transaction_id'] == null
        ? null
        : data['transaction_id'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as double? ?? 0.0,
    paymentMethod: data['payment_method'] == null
        ? null
        : data['payment_method'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
  );
}

Future<Map<String, dynamic>> _$TransactionPaymentRecordToSupabase(
  TransactionPaymentRecord instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'transaction_id': instance.transactionId,
    'amount': instance.amount,
    'payment_method': instance.paymentMethod,
    'created_at': instance.createdAt?.toIso8601String(),
  };
}

Future<TransactionPaymentRecord> _$TransactionPaymentRecordFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TransactionPaymentRecord(
    id: data['id'] as String,
    transactionId: data['transaction_id'] == null
        ? null
        : data['transaction_id'] as String?,
    amount: data['amount'] == null ? null : data['amount'] as double? ?? 0.0,
    paymentMethod: data['payment_method'] == null
        ? null
        : data['payment_method'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TransactionPaymentRecordToSqlite(
  TransactionPaymentRecord instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'transaction_id': instance.transactionId,
    'amount': instance.amount,
    'payment_method': instance.paymentMethod,
    'created_at': instance.createdAt?.toIso8601String(),
  };
}

/// Construct a [TransactionPaymentRecord]
class TransactionPaymentRecordAdapter
    extends OfflineFirstWithSupabaseAdapter<TransactionPaymentRecord> {
  TransactionPaymentRecordAdapter();

  @override
  final supabaseTableName = 'transaction_payment_records';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'paymentMethod': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_method',
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
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: String,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: double,
    ),
    'paymentMethod': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_method',
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
    TransactionPaymentRecord instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `TransactionPaymentRecord` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'TransactionPaymentRecord';

  @override
  Future<TransactionPaymentRecord> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionPaymentRecordFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    TransactionPaymentRecord input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionPaymentRecordToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<TransactionPaymentRecord> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionPaymentRecordFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    TransactionPaymentRecord input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TransactionPaymentRecordToSqlite(
        input,
        provider: provider,
        repository: repository,
      );
}
