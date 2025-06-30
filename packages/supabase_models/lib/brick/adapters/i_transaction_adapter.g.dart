// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ITransaction> _$ITransactionFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ITransaction(
    id: data['id'] as String?,
    reference: data['reference'] == null ? null : data['reference'] as String?,
    categoryId:
        data['category_id'] == null ? null : data['category_id'] as String?,
    transactionNumber:
        data['transaction_number'] == null
            ? null
            : data['transaction_number'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    status: data['status'] == null ? null : data['status'] as String?,
    transactionType:
        data['transaction_type'] == null
            ? null
            : data['transaction_type'] as String?,
    subTotal:
        data['sub_total'] == null ? null : data['sub_total'] as double? ?? 0.0,
    paymentType:
        data['payment_type'] == null ? null : data['payment_type'] as String?,
    cashReceived:
        data['cash_received'] == null
            ? null
            : data['cash_received'] as double? ?? 0.0,
    customerChangeDue:
        data['customer_change_due'] == null
            ? null
            : data['customer_change_due'] as double? ?? 0.0,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    receiptType:
        data['receipt_type'] == null ? null : data['receipt_type'] as String?,
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    customerId:
        data['customer_id'] == null ? null : data['customer_id'] as String?,
    customerType:
        data['customer_type'] == null ? null : data['customer_type'] as String?,
    note: data['note'] == null ? null : data['note'] as String?,
    lastTouched:
        data['last_touched'] == null
            ? null
            : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    ticketName:
        data['ticket_name'] == null ? null : data['ticket_name'] as String?,
    supplierId:
        data['supplier_id'] == null ? null : data['supplier_id'] as int?,
    ebmSynced:
        data['ebm_synced'] == null
            ? null
            : data['ebm_synced'] as bool? ?? false,
    isIncome:
        data['is_income'] == null ? null : data['is_income'] as bool? ?? true,
    isExpense:
        data['is_expense'] == null
            ? null
            : data['is_expense'] as bool? ?? false,
    isRefunded:
        data['is_refunded'] == null
            ? null
            : data['is_refunded'] as bool? ?? false,
    customerName:
        data['customer_name'] == null ? null : data['customer_name'] as String?,
    customerTin:
        data['customer_tin'] == null ? null : data['customer_tin'] as String?,
    remark: data['remark'] == null ? null : data['remark'] as String?,
    customerBhfId:
        data['customer_bhf_id'] == null
            ? null
            : data['customer_bhf_id'] as String?,
    sarTyCd: data['sar_ty_cd'] == null ? null : data['sar_ty_cd'] as String?,
    receiptNumber:
        data['receipt_number'] == null ? null : data['receipt_number'] as int?,
    totalReceiptNumber:
        data['total_receipt_number'] == null
            ? null
            : data['total_receipt_number'] as int?,
    invoiceNumber:
        data['invoice_number'] == null ? null : data['invoice_number'] as int?,
    isDigitalReceiptGenerated:
        data['is_digital_receipt_generated'] == null
            ? null
            : data['is_digital_receipt_generated'] as bool?,
    receiptFileName:
        data['receipt_file_name'] == null
            ? null
            : data['receipt_file_name'] as String?,
    currentSaleCustomerPhoneNumber:
        data['current_sale_customer_phone_number'] == null
            ? null
            : data['current_sale_customer_phone_number'] as String?,
    sarNo: data['sar_no'] == null ? null : data['sar_no'] as String?,
    orgSarNo: data['org_sar_no'] == null ? null : data['org_sar_no'] as String?,
    isLoan: data['is_loan'] == null ? null : data['is_loan'] as bool? ?? false,
    dueDate:
        data['due_date'] == null
            ? null
            : data['due_date'] == null
            ? null
            : DateTime.tryParse(data['due_date'] as String),
    isAutoBilled:
        data['is_auto_billed'] == null
            ? null
            : data['is_auto_billed'] as bool? ?? false,
    nextBillingDate:
        data['next_billing_date'] == null
            ? null
            : data['next_billing_date'] == null
            ? null
            : DateTime.tryParse(data['next_billing_date'] as String),
    billingFrequency:
        data['billing_frequency'] == null
            ? null
            : data['billing_frequency'] as String?,
    billingAmount:
        data['billing_amount'] == null
            ? null
            : data['billing_amount'] as num? ?? 0.0,
    totalInstallments:
        data['total_installments'] == null
            ? null
            : data['total_installments'] as int? ?? 1,
    paidInstallments:
        data['paid_installments'] == null
            ? null
            : data['paid_installments'] as int? ?? 0,
    lastBilledDate:
        data['last_billed_date'] == null
            ? null
            : data['last_billed_date'] == null
            ? null
            : DateTime.tryParse(data['last_billed_date'] as String),
    originalLoanAmount:
        data['original_loan_amount'] == null
            ? null
            : data['original_loan_amount'] as num? ?? 0.0,
    remainingBalance:
        data['remaining_balance'] == null
            ? null
            : data['remaining_balance'] as num? ?? 0.0,
    lastPaymentDate:
        data['last_payment_date'] == null
            ? null
            : data['last_payment_date'] == null
            ? null
            : DateTime.tryParse(data['last_payment_date'] as String),
    lastPaymentAmount:
        data['last_payment_amount'] == null
            ? null
            : data['last_payment_amount'] as num? ?? 0.0,
    originalTransactionId:
        data['original_transaction_id'] == null
            ? null
            : data['original_transaction_id'] as String?,
    isOriginalTransaction:
        data['is_original_transaction'] == null
            ? null
            : data['is_original_transaction'] as bool?,
    taxAmount: data['tax_amount'] == null ? null : data['tax_amount'] as num?,
    numberOfItems:
        data['number_of_items'] == null
            ? null
            : data['number_of_items'] as int?,
    discountAmount:
        data['discount_amount'] == null
            ? null
            : data['discount_amount'] as num?,
    items:
        data['items'] == null
            ? null
            : await Future.wait<TransactionItem>(
              data['items']
                      ?.map(
                        (d) => TransactionItemAdapter().fromSupabase(
                          d,
                          provider: provider,
                          repository: repository,
                        ),
                      )
                      .toList()
                      .cast<Future<TransactionItem>>() ??
                  [],
            ),
    customerPhone:
        data['customer_phone'] == null
            ? null
            : data['customer_phone'] as String?,
  );
}

Future<Map<String, dynamic>> _$ITransactionToSupabase(
  ITransaction instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
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
    'created_at': instance.createdAt?.toIso8601String(),
    'receipt_type': instance.receiptType,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'customer_id': instance.customerId,
    'customer_type': instance.customerType,
    'note': instance.note,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'ticket_name': instance.ticketName,
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
    'invoice_number': instance.invoiceNumber,
    'is_digital_receipt_generated': instance.isDigitalReceiptGenerated,
    'receipt_file_name': instance.receiptFileName,
    'current_sale_customer_phone_number':
        instance.currentSaleCustomerPhoneNumber,
    'sar_no': instance.sarNo,
    'org_sar_no': instance.orgSarNo,
    'is_loan': instance.isLoan,
    'due_date': instance.dueDate?.toIso8601String(),
    'is_auto_billed': instance.isAutoBilled,
    'next_billing_date': instance.nextBillingDate?.toIso8601String(),
    'billing_frequency': instance.billingFrequency,
    'billing_amount': instance.billingAmount,
    'total_installments': instance.totalInstallments,
    'paid_installments': instance.paidInstallments,
    'last_billed_date': instance.lastBilledDate?.toIso8601String(),
    'original_loan_amount': instance.originalLoanAmount,
    'remaining_balance': instance.remainingBalance,
    'last_payment_date': instance.lastPaymentDate?.toIso8601String(),
    'last_payment_amount': instance.lastPaymentAmount,
    'original_transaction_id': instance.originalTransactionId,
    'is_original_transaction': instance.isOriginalTransaction,
    'tax_amount': instance.taxAmount,
    'number_of_items': instance.numberOfItems,
    'discount_amount': instance.discountAmount,
    'items': await Future.wait<Map<String, dynamic>>(
      instance.items
              ?.map(
                (s) => TransactionItemAdapter().toSupabase(
                  s,
                  provider: provider,
                  repository: repository,
                ),
              )
              .toList() ??
          [],
    ),
    'customer_phone': instance.customerPhone,
  };
}

Future<ITransaction> _$ITransactionFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ITransaction(
    id: data['id'] as String,
    reference: data['reference'] == null ? null : data['reference'] as String?,
    categoryId:
        data['category_id'] == null ? null : data['category_id'] as String?,
    transactionNumber:
        data['transaction_number'] == null
            ? null
            : data['transaction_number'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    status: data['status'] == null ? null : data['status'] as String?,
    transactionType:
        data['transaction_type'] == null
            ? null
            : data['transaction_type'] as String?,
    subTotal: data['sub_total'] == null ? null : data['sub_total'] as double?,
    paymentType:
        data['payment_type'] == null ? null : data['payment_type'] as String?,
    cashReceived:
        data['cash_received'] == null ? null : data['cash_received'] as double?,
    customerChangeDue:
        data['customer_change_due'] == null
            ? null
            : data['customer_change_due'] as double?,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    receiptType:
        data['receipt_type'] == null ? null : data['receipt_type'] as String?,
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    customerId:
        data['customer_id'] == null ? null : data['customer_id'] as String?,
    customerType:
        data['customer_type'] == null ? null : data['customer_type'] as String?,
    note: data['note'] == null ? null : data['note'] as String?,
    lastTouched:
        data['last_touched'] == null
            ? null
            : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    ticketName:
        data['ticket_name'] == null ? null : data['ticket_name'] as String?,
    supplierId:
        data['supplier_id'] == null ? null : data['supplier_id'] as int?,
    ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] == 1,
    isIncome: data['is_income'] == null ? null : data['is_income'] == 1,
    isExpense: data['is_expense'] == null ? null : data['is_expense'] == 1,
    isRefunded: data['is_refunded'] == null ? null : data['is_refunded'] == 1,
    customerName:
        data['customer_name'] == null ? null : data['customer_name'] as String?,
    customerTin:
        data['customer_tin'] == null ? null : data['customer_tin'] as String?,
    remark: data['remark'] == null ? null : data['remark'] as String?,
    customerBhfId:
        data['customer_bhf_id'] == null
            ? null
            : data['customer_bhf_id'] as String?,
    sarTyCd: data['sar_ty_cd'] == null ? null : data['sar_ty_cd'] as String?,
    receiptNumber:
        data['receipt_number'] == null ? null : data['receipt_number'] as int?,
    totalReceiptNumber:
        data['total_receipt_number'] == null
            ? null
            : data['total_receipt_number'] as int?,
    invoiceNumber:
        data['invoice_number'] == null ? null : data['invoice_number'] as int?,
    isDigitalReceiptGenerated:
        data['is_digital_receipt_generated'] == null
            ? null
            : data['is_digital_receipt_generated'] == 1,
    receiptFileName:
        data['receipt_file_name'] == null
            ? null
            : data['receipt_file_name'] as String?,
    currentSaleCustomerPhoneNumber:
        data['current_sale_customer_phone_number'] == null
            ? null
            : data['current_sale_customer_phone_number'] as String?,
    sarNo: data['sar_no'] == null ? null : data['sar_no'] as String?,
    orgSarNo: data['org_sar_no'] == null ? null : data['org_sar_no'] as String?,
    isLoan: data['is_loan'] == null ? null : data['is_loan'] == 1,
    dueDate:
        data['due_date'] == null
            ? null
            : data['due_date'] == null
            ? null
            : DateTime.tryParse(data['due_date'] as String),
    isAutoBilled:
        data['is_auto_billed'] == null ? null : data['is_auto_billed'] == 1,
    nextBillingDate:
        data['next_billing_date'] == null
            ? null
            : data['next_billing_date'] == null
            ? null
            : DateTime.tryParse(data['next_billing_date'] as String),
    billingFrequency:
        data['billing_frequency'] == null
            ? null
            : data['billing_frequency'] as String?,
    billingAmount:
        data['billing_amount'] == null ? null : data['billing_amount'] as num?,
    totalInstallments:
        data['total_installments'] == null
            ? null
            : data['total_installments'] as int?,
    paidInstallments:
        data['paid_installments'] == null
            ? null
            : data['paid_installments'] as int?,
    lastBilledDate:
        data['last_billed_date'] == null
            ? null
            : data['last_billed_date'] == null
            ? null
            : DateTime.tryParse(data['last_billed_date'] as String),
    originalLoanAmount:
        data['original_loan_amount'] == null
            ? null
            : data['original_loan_amount'] as num?,
    remainingBalance:
        data['remaining_balance'] == null
            ? null
            : data['remaining_balance'] as num?,
    lastPaymentDate:
        data['last_payment_date'] == null
            ? null
            : data['last_payment_date'] == null
            ? null
            : DateTime.tryParse(data['last_payment_date'] as String),
    lastPaymentAmount:
        data['last_payment_amount'] == null
            ? null
            : data['last_payment_amount'] as num?,
    originalTransactionId:
        data['original_transaction_id'] == null
            ? null
            : data['original_transaction_id'] as String?,
    isOriginalTransaction:
        data['is_original_transaction'] == null
            ? null
            : data['is_original_transaction'] == 1,
    taxAmount: data['tax_amount'] == null ? null : data['tax_amount'] as num?,
    numberOfItems:
        data['number_of_items'] == null
            ? null
            : data['number_of_items'] as int?,
    discountAmount:
        data['discount_amount'] == null
            ? null
            : data['discount_amount'] as num?,
    items:
        (await provider
            .rawQuery(
              'SELECT DISTINCT `f_TransactionItem_brick_id` FROM `_brick_ITransaction_items` WHERE l_ITransaction_brick_id = ?',
              [data['_brick_id'] as int],
            )
            .then((results) {
              final ids = results.map((r) => r['f_TransactionItem_brick_id']);
              return Future.wait<TransactionItem>(
                ids.map(
                  (primaryKey) => repository!
                      .getAssociation<TransactionItem>(
                        Query.where('primaryKey', primaryKey, limit1: true),
                      )
                      .then((r) => r!.first),
                ),
              );
            })).toList().cast<TransactionItem>(),
    customerPhone:
        data['customer_phone'] == null
            ? null
            : data['customer_phone'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ITransactionToSqlite(
  ITransaction instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
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
    'created_at': instance.createdAt?.toIso8601String(),
    'receipt_type': instance.receiptType,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'customer_id': instance.customerId,
    'customer_type': instance.customerType,
    'note': instance.note,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'ticket_name': instance.ticketName,
    'supplier_id': instance.supplierId,
    'ebm_synced':
        instance.ebmSynced == null ? null : (instance.ebmSynced! ? 1 : 0),
    'is_income':
        instance.isIncome == null ? null : (instance.isIncome! ? 1 : 0),
    'is_expense':
        instance.isExpense == null ? null : (instance.isExpense! ? 1 : 0),
    'is_refunded':
        instance.isRefunded == null ? null : (instance.isRefunded! ? 1 : 0),
    'customer_name': instance.customerName,
    'customer_tin': instance.customerTin,
    'remark': instance.remark,
    'customer_bhf_id': instance.customerBhfId,
    'sar_ty_cd': instance.sarTyCd,
    'receipt_number': instance.receiptNumber,
    'total_receipt_number': instance.totalReceiptNumber,
    'invoice_number': instance.invoiceNumber,
    'is_digital_receipt_generated':
        instance.isDigitalReceiptGenerated == null
            ? null
            : (instance.isDigitalReceiptGenerated! ? 1 : 0),
    'receipt_file_name': instance.receiptFileName,
    'current_sale_customer_phone_number':
        instance.currentSaleCustomerPhoneNumber,
    'sar_no': instance.sarNo,
    'org_sar_no': instance.orgSarNo,
    'is_loan': instance.isLoan == null ? null : (instance.isLoan! ? 1 : 0),
    'due_date': instance.dueDate?.toIso8601String(),
    'is_auto_billed':
        instance.isAutoBilled == null ? null : (instance.isAutoBilled! ? 1 : 0),
    'next_billing_date': instance.nextBillingDate?.toIso8601String(),
    'billing_frequency': instance.billingFrequency,
    'billing_amount': instance.billingAmount,
    'total_installments': instance.totalInstallments,
    'paid_installments': instance.paidInstallments,
    'last_billed_date': instance.lastBilledDate?.toIso8601String(),
    'original_loan_amount': instance.originalLoanAmount,
    'remaining_balance': instance.remainingBalance,
    'last_payment_date': instance.lastPaymentDate?.toIso8601String(),
    'last_payment_amount': instance.lastPaymentAmount,
    'original_transaction_id': instance.originalTransactionId,
    'is_original_transaction':
        instance.isOriginalTransaction == null
            ? null
            : (instance.isOriginalTransaction! ? 1 : 0),
    'tax_amount': instance.taxAmount,
    'number_of_items': instance.numberOfItems,
    'discount_amount': instance.discountAmount,
    'customer_phone': instance.customerPhone,
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
    ),
    'isDigitalReceiptGenerated': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_digital_receipt_generated',
    ),
    'receiptFileName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receipt_file_name',
    ),
    'currentSaleCustomerPhoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'current_sale_customer_phone_number',
    ),
    'sarNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sar_no',
    ),
    'orgSarNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'org_sar_no',
    ),
    'isLoan': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_loan',
    ),
    'dueDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'due_date',
    ),
    'isAutoBilled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_auto_billed',
    ),
    'nextBillingDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'next_billing_date',
    ),
    'billingFrequency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'billing_frequency',
    ),
    'billingAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'billing_amount',
    ),
    'totalInstallments': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'total_installments',
    ),
    'paidInstallments': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'paid_installments',
    ),
    'lastBilledDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_billed_date',
    ),
    'originalLoanAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'original_loan_amount',
    ),
    'remainingBalance': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'remaining_balance',
    ),
    'lastPaymentDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_payment_date',
    ),
    'lastPaymentAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_payment_amount',
    ),
    'originalTransactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'original_transaction_id',
    ),
    'isOriginalTransaction': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_original_transaction',
    ),
    'taxAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_amount',
    ),
    'numberOfItems': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'number_of_items',
    ),
    'discountAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount_amount',
    ),
    'items': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'items',
      associationType: TransactionItem,
      associationIsNullable: true,
    ),
    'customerPhone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_phone',
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
      type: DateTime,
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
      type: DateTime,
    ),
    'customerId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_id',
      iterable: false,
      type: String,
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
    ),
    'isDigitalReceiptGenerated': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_digital_receipt_generated',
      iterable: false,
      type: bool,
    ),
    'receiptFileName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receipt_file_name',
      iterable: false,
      type: String,
    ),
    'currentSaleCustomerPhoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'current_sale_customer_phone_number',
      iterable: false,
      type: String,
    ),
    'sarNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sar_no',
      iterable: false,
      type: String,
    ),
    'orgSarNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'org_sar_no',
      iterable: false,
      type: String,
    ),
    'isLoan': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_loan',
      iterable: false,
      type: bool,
    ),
    'dueDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'due_date',
      iterable: false,
      type: DateTime,
    ),
    'isAutoBilled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_auto_billed',
      iterable: false,
      type: bool,
    ),
    'nextBillingDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'next_billing_date',
      iterable: false,
      type: DateTime,
    ),
    'billingFrequency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'billing_frequency',
      iterable: false,
      type: String,
    ),
    'billingAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'billing_amount',
      iterable: false,
      type: num,
    ),
    'totalInstallments': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'total_installments',
      iterable: false,
      type: int,
    ),
    'paidInstallments': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'paid_installments',
      iterable: false,
      type: int,
    ),
    'lastBilledDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_billed_date',
      iterable: false,
      type: DateTime,
    ),
    'originalLoanAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'original_loan_amount',
      iterable: false,
      type: num,
    ),
    'remainingBalance': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'remaining_balance',
      iterable: false,
      type: num,
    ),
    'lastPaymentDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_payment_date',
      iterable: false,
      type: DateTime,
    ),
    'lastPaymentAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_payment_amount',
      iterable: false,
      type: num,
    ),
    'originalTransactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'original_transaction_id',
      iterable: false,
      type: String,
    ),
    'isOriginalTransaction': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_original_transaction',
      iterable: false,
      type: bool,
    ),
    'taxAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_amount',
      iterable: false,
      type: num,
    ),
    'numberOfItems': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'number_of_items',
      iterable: false,
      type: int,
    ),
    'discountAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount_amount',
      iterable: false,
      type: num,
    ),
    'items': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'items',
      iterable: true,
      type: TransactionItem,
    ),
    'customerPhone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_phone',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    ITransaction instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `ITransaction` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'ITransaction';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final itemsOldColumns = await provider.rawQuery(
        'SELECT `f_TransactionItem_brick_id` FROM `_brick_ITransaction_items` WHERE `l_ITransaction_brick_id` = ?',
        [instance.primaryKey],
      );
      final itemsOldIds = itemsOldColumns.map(
        (a) => a['f_TransactionItem_brick_id'],
      );
      final itemsNewIds =
          instance.items?.map((s) => s.primaryKey).whereType<int>() ?? [];
      final itemsIdsToDelete = itemsOldIds.where(
        (id) => !itemsNewIds.contains(id),
      );

      await Future.wait<void>(
        itemsIdsToDelete.map((id) async {
          return await provider
              .rawExecute(
                'DELETE FROM `_brick_ITransaction_items` WHERE `l_ITransaction_brick_id` = ? AND `f_TransactionItem_brick_id` = ?',
                [instance.primaryKey, id],
              )
              .catchError((e) => null);
        }),
      );

      await Future.wait<int?>(
        instance.items?.map((s) async {
              final id =
                  s.primaryKey ??
                  await provider.upsert<TransactionItem>(
                    s,
                    repository: repository,
                  );
              return await provider.rawInsert(
                'INSERT OR IGNORE INTO `_brick_ITransaction_items` (`l_ITransaction_brick_id`, `f_TransactionItem_brick_id`) VALUES (?, ?)',
                [instance.primaryKey, id],
              );
            }) ??
            [],
      );
    }
  }

  @override
  Future<ITransaction> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ITransactionFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    ITransaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ITransactionToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<ITransaction> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ITransactionFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    ITransaction input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ITransactionToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
