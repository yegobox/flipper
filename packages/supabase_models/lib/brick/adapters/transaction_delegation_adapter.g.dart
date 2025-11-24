// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<TransactionDelegation> _$TransactionDelegationFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TransactionDelegation(
    id: data['id'] as String?,
    transactionId: data['transaction_id'] as String,
    branchId: data['branch_id'] as int,
    status: data['status'] as String,
    receiptType: data['receipt_type'] as String,
    paymentType: data['payment_type'] as String,
    subTotal: data['sub_total'] as double? ?? 0.0,
    customerName: data['customer_name'] == null
        ? null
        : data['customer_name'] as String?,
    customerTin: data['customer_tin'] == null
        ? null
        : data['customer_tin'] as String?,
    customerBhfId: data['customer_bhf_id'] == null
        ? null
        : data['customer_bhf_id'] as String?,
    isAutoPrint: data['is_auto_print'] as bool? ?? false,
    delegatedFromDevice: data['delegated_from_device'] as String,
    delegatedAt: data['delegated_at'] == null
        ? null
        : DateTime.tryParse(data['delegated_at'] as String),
    updatedAt: data['updated_at'] == null
        ? null
        : DateTime.tryParse(data['updated_at'] as String),
    additionalData: data['additional_data'] == null
        ? null
        : data['additional_data'],
  );
}

Future<Map<String, dynamic>> _$TransactionDelegationToSupabase(
  TransactionDelegation instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'transaction_id': instance.transactionId,
    'branch_id': instance.branchId,
    'status': instance.status,
    'receipt_type': instance.receiptType,
    'payment_type': instance.paymentType,
    'sub_total': instance.subTotal,
    'customer_name': instance.customerName,
    'customer_tin': instance.customerTin,
    'customer_bhf_id': instance.customerBhfId,
    'is_auto_print': instance.isAutoPrint,
    'delegated_from_device': instance.delegatedFromDevice,
    'delegated_at': instance.delegatedAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
    'additional_data': instance.additionalData,
  };
}

Future<TransactionDelegation> _$TransactionDelegationFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return TransactionDelegation(
    id: data['id'] as String,
    transactionId: data['transaction_id'] as String,
    branchId: data['branch_id'] as int,
    status: data['status'] as String,
    receiptType: data['receipt_type'] as String,
    paymentType: data['payment_type'] as String,
    subTotal: data['sub_total'] as double,
    customerName: data['customer_name'] == null
        ? null
        : data['customer_name'] as String?,
    customerTin: data['customer_tin'] == null
        ? null
        : data['customer_tin'] as String?,
    customerBhfId: data['customer_bhf_id'] == null
        ? null
        : data['customer_bhf_id'] as String?,
    isAutoPrint: data['is_auto_print'] == 1,
    delegatedFromDevice: data['delegated_from_device'] as String,
    delegatedAt: DateTime.parse(data['delegated_at'] as String),
    updatedAt: DateTime.parse(data['updated_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TransactionDelegationToSqlite(
  TransactionDelegation instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'transaction_id': instance.transactionId,
    'branch_id': instance.branchId,
    'status': instance.status,
    'receipt_type': instance.receiptType,
    'payment_type': instance.paymentType,
    'sub_total': instance.subTotal,
    'customer_name': instance.customerName,
    'customer_tin': instance.customerTin,
    'customer_bhf_id': instance.customerBhfId,
    'is_auto_print': instance.isAutoPrint ? 1 : 0,
    'delegated_from_device': instance.delegatedFromDevice,
    'delegated_at': instance.delegatedAt.toIso8601String(),
    'updated_at': instance.updatedAt.toIso8601String(),
  };
}

/// Construct a [TransactionDelegation]
class TransactionDelegationAdapter
    extends OfflineFirstWithSupabaseAdapter<TransactionDelegation> {
  TransactionDelegationAdapter();

  @override
  final supabaseTableName = 'transaction_delegations';
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
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'receiptType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receipt_type',
    ),
    'paymentType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_type',
    ),
    'subTotal': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sub_total',
    ),
    'customerName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_name',
    ),
    'customerTin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_tin',
    ),
    'customerBhfId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_bhf_id',
    ),
    'isAutoPrint': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_auto_print',
    ),
    'delegatedFromDevice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'delegated_from_device',
    ),
    'delegatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'delegated_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'additionalData': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'additional_data',
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
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'receiptType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receipt_type',
      iterable: false,
      type: String,
    ),
    'paymentType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_type',
      iterable: false,
      type: String,
    ),
    'subTotal': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sub_total',
      iterable: false,
      type: double,
    ),
    'customerName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_name',
      iterable: false,
      type: String,
    ),
    'customerTin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_tin',
      iterable: false,
      type: String,
    ),
    'customerBhfId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_bhf_id',
      iterable: false,
      type: String,
    ),
    'isAutoPrint': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_auto_print',
      iterable: false,
      type: bool,
    ),
    'delegatedFromDevice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'delegated_from_device',
      iterable: false,
      type: String,
    ),
    'delegatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'delegated_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    TransactionDelegation instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `TransactionDelegation` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'TransactionDelegation';

  @override
  Future<TransactionDelegation> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionDelegationFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    TransactionDelegation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionDelegationToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<TransactionDelegation> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionDelegationFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    TransactionDelegation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$TransactionDelegationToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
