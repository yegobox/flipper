// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<CustomerPayments> _$CustomerPaymentsFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return CustomerPayments(
    id: data['id'] as String?,
    customerId:
        data['customer_id'] == null ? null : data['customer_id'] as String?,
    phoneNumber: data['phone_number'] as String,
    paymentStatus: data['payment_status'] as String,
    transactionId: data['transaction_id'] as String,
    amountPayable: data['amount_payable'] as double,
  );
}

Future<Map<String, dynamic>> _$CustomerPaymentsToSupabase(
  CustomerPayments instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'customer_id': instance.customerId,
    'phone_number': instance.phoneNumber,
    'payment_status': instance.paymentStatus,
    'transaction_id': instance.transactionId,
    'amount_payable': instance.amountPayable,
  };
}

Future<CustomerPayments> _$CustomerPaymentsFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return CustomerPayments(
    id: data['id'] as String,
    customerId:
        data['customer_id'] == null ? null : data['customer_id'] as String?,
    phoneNumber: data['phone_number'] as String,
    paymentStatus: data['payment_status'] as String,
    transactionId: data['transaction_id'] as String,
    amountPayable: data['amount_payable'] as double,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CustomerPaymentsToSqlite(
  CustomerPayments instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'customer_id': instance.customerId,
    'phone_number': instance.phoneNumber,
    'payment_status': instance.paymentStatus,
    'transaction_id': instance.transactionId,
    'amount_payable': instance.amountPayable,
  };
}

/// Construct a [CustomerPayments]
class CustomerPaymentsAdapter
    extends OfflineFirstWithSupabaseAdapter<CustomerPayments> {
  CustomerPaymentsAdapter();

  @override
  final supabaseTableName = 'customer_payments';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'customerId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_id',
    ),
    'phoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number',
    ),
    'paymentStatus': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_status',
    ),
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'amountPayable': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount_payable',
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
    'customerId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_id',
      iterable: false,
      type: String,
    ),
    'phoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number',
      iterable: false,
      type: String,
    ),
    'paymentStatus': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_status',
      iterable: false,
      type: String,
    ),
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: String,
    ),
    'amountPayable': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount_payable',
      iterable: false,
      type: double,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    CustomerPayments instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `CustomerPayments` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'CustomerPayments';

  @override
  Future<CustomerPayments> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CustomerPaymentsFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    CustomerPayments input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CustomerPaymentsToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<CustomerPayments> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CustomerPaymentsFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    CustomerPayments input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$CustomerPaymentsToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
