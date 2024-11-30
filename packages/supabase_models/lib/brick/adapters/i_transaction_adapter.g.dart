// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ITransaction> _$ITransactionFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return ITransaction(
      id: data['id'] as int,
      reference: data['reference'] as String?,
      categoryId: data['category_id'] as String?,
      transactionNumber: data['transaction_number'] as String?,
      branchId: data['branch_id'] as int?,
      status: data['status'] as String?,
      transactionType: data['transaction_type'] as String?,
      subTotal: data['sub_total'] as double,
      paymentType: data['payment_type'] as String?,
      cashReceived: data['cash_received'] as double,
      customerChangeDue: data['customer_change_due'] as double,
      createdAt: data['created_at'] as String?,
      receiptType: data['receipt_type'] as String?,
      updatedAt: data['updated_at'] as String?,
      customerId: data['customer_id'] as int?,
      customerType: data['customer_type'] as String?,
      note: data['note'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      ticketName: data['ticket_name'] as String?,
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      supplierId: data['supplier_id'] as int?,
      ebmSynced: data['ebm_synced'] as bool?,
      isIncome: data['is_income'] as bool,
      isExpense: data['is_expense'] as bool,
      isRefunded: data['is_refunded'] as bool?,
      customerName: data['customer_name'] as String?,
      customerTin: data['customer_tin'] as String?,
      remark: data['remark'] as String?,
      customerBhfId: data['customer_bhf_id'] as String?,
      sarTyCd: data['sar_ty_cd'] as String?,
      receiptNumber: data['receipt_number'] as int?,
      totalReceiptNumber: data['total_receipt_number'] as int?,
      invoiceNumber: data['invoice_number'] as int?);
}

Future<Map<String, dynamic>> _$ITransactionToSupabase(ITransaction instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'reference': instance.reference,
    'category_id': instance.categoryId,
    'transaction_number': instance.transactionNumber,
    'branch_id': instance.branchId,
    'status': instance.status,
    'transaction_type': instance.transactionType,
    'sub_total': instance.subTotal,
    'payment_type': instance.paymentType,
    'cash_received': instance.cashReceived,
    'customer_change_due': instance.customerChangeDue,
    'created_at': instance.createdAt,
    'receipt_type': instance.receiptType,
    'updated_at': instance.updatedAt,
    'customer_id': instance.customerId,
    'customer_type': instance.customerType,
    'note': instance.note,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'ticket_name': instance.ticketName,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'supplier_id': instance.supplierId,
    'ebm_synced': instance.ebmSynced,
    'is_income': instance.isIncome,
    'is_expense': instance.isExpense,
    'is_refunded': instance.isRefunded,
    'customer_name': instance.customerName,
    'customer_tin': instance.customerTin,
    'remark': instance.remark,
    'customer_bhf_id': instance.customerBhfId,
    'sar_ty_cd': instance.sarTyCd,
    'receipt_number': instance.receiptNumber,
    'total_receipt_number': instance.totalReceiptNumber,
    'invoice_number': instance.invoiceNumber
  };
}

Future<ITransaction> _$ITransactionFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return ITransaction(
      id: data['id'] as int,
      reference:
          data['reference'] == null ? null : data['reference'] as String?,
      categoryId:
          data['category_id'] == null ? null : data['category_id'] as String?,
      transactionNumber: data['transaction_number'] == null
          ? null
          : data['transaction_number'] as String?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      status: data['status'] == null ? null : data['status'] as String?,
      transactionType: data['transaction_type'] == null
          ? null
          : data['transaction_type'] as String?,
      subTotal: data['sub_total'] as double,
      paymentType:
          data['payment_type'] == null ? null : data['payment_type'] as String?,
      cashReceived: data['cash_received'] as double,
      customerChangeDue: data['customer_change_due'] as double,
      createdAt:
          data['created_at'] == null ? null : data['created_at'] as String?,
      receiptType:
          data['receipt_type'] == null ? null : data['receipt_type'] as String?,
      updatedAt:
          data['updated_at'] == null ? null : data['updated_at'] as String?,
      customerId:
          data['customer_id'] == null ? null : data['customer_id'] as int?,
      customerType: data['customer_type'] == null
          ? null
          : data['customer_type'] as String?,
      note: data['note'] == null ? null : data['note'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      ticketName:
          data['ticket_name'] == null ? null : data['ticket_name'] as String?,
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      supplierId:
          data['supplier_id'] == null ? null : data['supplier_id'] as int?,
      ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] == 1,
      isIncome: data['is_income'] == 1,
      isExpense: data['is_expense'] == 1,
      isRefunded: data['is_refunded'] == null ? null : data['is_refunded'] == 1,
      customerName: data['customer_name'] == null
          ? null
          : data['customer_name'] as String?,
      customerTin:
          data['customer_tin'] == null ? null : data['customer_tin'] as String?,
      remark: data['remark'] == null ? null : data['remark'] as String?,
      customerBhfId: data['customer_bhf_id'] == null
          ? null
          : data['customer_bhf_id'] as String?,
      sarTyCd: data['sar_ty_cd'] == null ? null : data['sar_ty_cd'] as String?,
      receiptNumber: data['receipt_number'] == null
          ? null
          : data['receipt_number'] as int?,
      totalReceiptNumber: data['total_receipt_number'] == null
          ? null
          : data['total_receipt_number'] as int?,
      invoiceNumber: data['invoice_number'] == null
          ? null
          : data['invoice_number'] as int?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ITransactionToSqlite(ITransaction instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'reference': instance.reference,
    'category_id': instance.categoryId,
    'transaction_number': instance.transactionNumber,
    'branch_id': instance.branchId,
    'status': instance.status,
    'transaction_type': instance.transactionType,
    'sub_total': instance.subTotal,
    'payment_type': instance.paymentType,
    'cash_received': instance.cashReceived,
    'customer_change_due': instance.customerChangeDue,
    'created_at': instance.createdAt,
    'receipt_type': instance.receiptType,
    'updated_at': instance.updatedAt,
    'customer_id': instance.customerId,
    'customer_type': instance.customerType,
    'note': instance.note,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'ticket_name': instance.ticketName,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'supplier_id': instance.supplierId,
    'ebm_synced':
        instance.ebmSynced == null ? null : (instance.ebmSynced! ? 1 : 0),
    'is_income': instance.isIncome ? 1 : 0,
    'is_expense': instance.isExpense ? 1 : 0,
    'is_refunded':
        instance.isRefunded == null ? null : (instance.isRefunded! ? 1 : 0),
    'customer_name': instance.customerName,
    'customer_tin': instance.customerTin,
    'remark': instance.remark,
    'customer_bhf_id': instance.customerBhfId,
    'sar_ty_cd': instance.sarTyCd,
    'receipt_number': instance.receiptNumber,
    'total_receipt_number': instance.totalReceiptNumber,
    'invoice_number': instance.invoiceNumber
  };
}

/// Construct a [ITransaction]
class ITransactionAdapter
    extends OfflineFirstWithSupabaseAdapter<ITransaction> {
  ITransactionAdapter();

  @override
  final supabaseTableName = 'transactions';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'reference': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'reference',
    ),
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
    ),
    'transactionNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_number',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'transactionType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_type',
    ),
    'subTotal': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sub_total',
    ),
    'paymentType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_type',
    ),
    'cashReceived': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cash_received',
    ),
    'customerChangeDue': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_change_due',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'receiptType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receipt_type',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'customerId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_id',
    ),
    'customerType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_type',
    ),
    'note': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'note',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'ticketName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ticket_name',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'supplierId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'supplier_id',
    ),
    'ebmSynced': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
    ),
    'isIncome': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_income',
    ),
    'isExpense': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_expense',
    ),
    'isRefunded': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_refunded',
    ),
    'customerName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_name',
    ),
    'customerTin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_tin',
    ),
    'remark': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remark',
    ),
    'customerBhfId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_bhf_id',
    ),
    'sarTyCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sar_ty_cd',
    ),
    'receiptNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receipt_number',
    ),
    'totalReceiptNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'total_receipt_number',
    ),
    'invoiceNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'invoice_number',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
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
    'reference': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'reference',
      iterable: false,
      type: String,
    ),
    'categoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_id',
      iterable: false,
      type: String,
    ),
    'transactionNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_number',
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
    'transactionType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_type',
      iterable: false,
      type: String,
    ),
    'subTotal': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sub_total',
      iterable: false,
      type: double,
    ),
    'paymentType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_type',
      iterable: false,
      type: String,
    ),
    'cashReceived': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cash_received',
      iterable: false,
      type: double,
    ),
    'customerChangeDue': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_change_due',
      iterable: false,
      type: double,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'receiptType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receipt_type',
      iterable: false,
      type: String,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: String,
    ),
    'customerId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_id',
      iterable: false,
      type: int,
    ),
    'customerType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_type',
      iterable: false,
      type: String,
    ),
    'note': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'note',
      iterable: false,
      type: String,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'ticketName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ticket_name',
      iterable: false,
      type: String,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'supplierId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'supplier_id',
      iterable: false,
      type: int,
    ),
    'ebmSynced': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
      iterable: false,
      type: bool,
    ),
    'isIncome': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_income',
      iterable: false,
      type: bool,
    ),
    'isExpense': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_expense',
      iterable: false,
      type: bool,
    ),
    'isRefunded': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_refunded',
      iterable: false,
      type: bool,
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
    'remark': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remark',
      iterable: false,
      type: String,
    ),
    'customerBhfId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_bhf_id',
      iterable: false,
      type: String,
    ),
    'sarTyCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sar_ty_cd',
      iterable: false,
      type: String,
    ),
    'receiptNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receipt_number',
      iterable: false,
      type: int,
    ),
    'totalReceiptNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'total_receipt_number',
      iterable: false,
      type: int,
    ),
    'invoiceNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'invoice_number',
      iterable: false,
      type: int,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      ITransaction instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `ITransaction` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'ITransaction';

  @override
  Future<ITransaction> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ITransactionFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(ITransaction input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ITransactionToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<ITransaction> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ITransactionFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(ITransaction input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ITransactionToSqlite(input,
          provider: provider, repository: repository);
}
