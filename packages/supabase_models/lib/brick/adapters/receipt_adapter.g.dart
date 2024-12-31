// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Receipt> _$ReceiptFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Receipt(
      id: data['id'] as String?,
      resultCd: data['result_cd'] as String?,
      resultMsg: data['result_msg'] as String?,
      resultDt: data['result_dt'] as String?,
      rcptNo: data['rcpt_no'] as int?,
      intrlData: data['intrl_data'] as String?,
      rcptSign: data['rcpt_sign'] as String?,
      totRcptNo: data['tot_rcpt_no'] as int?,
      vsdcRcptPbctDate: data['vsdc_rcpt_pbct_date'] as String?,
      sdcId: data['sdc_id'] as String?,
      mrcNo: data['mrc_no'] as String?,
      qrCode: data['qr_code'] as String?,
      receiptType: data['receipt_type'] as String?,
      branchId: data['branch_id'] as int?,
      transactionId: data['transaction_id'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      invcNo: data['invc_no'] as int?,
      whenCreated: data['when_created'] == null
          ? null
          : DateTime.tryParse(data['when_created'] as String),
      invoiceNumber: data['invoice_number'] as int?);
}

Future<Map<String, dynamic>> _$ReceiptToSupabase(Receipt instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'result_cd': instance.resultCd,
    'result_msg': instance.resultMsg,
    'result_dt': instance.resultDt,
    'rcpt_no': instance.rcptNo,
    'intrl_data': instance.intrlData,
    'rcpt_sign': instance.rcptSign,
    'tot_rcpt_no': instance.totRcptNo,
    'vsdc_rcpt_pbct_date': instance.vsdcRcptPbctDate,
    'sdc_id': instance.sdcId,
    'mrc_no': instance.mrcNo,
    'qr_code': instance.qrCode,
    'receipt_type': instance.receiptType,
    'branch_id': instance.branchId,
    'transaction_id': instance.transactionId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'invc_no': instance.invcNo,
    'when_created': instance.whenCreated?.toIso8601String(),
    'invoice_number': instance.invoiceNumber
  };
}

Future<Receipt> _$ReceiptFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Receipt(
      id: data['id'] as String,
      resultCd: data['result_cd'] == null ? null : data['result_cd'] as String?,
      resultMsg:
          data['result_msg'] == null ? null : data['result_msg'] as String?,
      resultDt: data['result_dt'] == null ? null : data['result_dt'] as String?,
      rcptNo: data['rcpt_no'] == null ? null : data['rcpt_no'] as int?,
      intrlData:
          data['intrl_data'] == null ? null : data['intrl_data'] as String?,
      rcptSign: data['rcpt_sign'] == null ? null : data['rcpt_sign'] as String?,
      totRcptNo:
          data['tot_rcpt_no'] == null ? null : data['tot_rcpt_no'] as int?,
      vsdcRcptPbctDate: data['vsdc_rcpt_pbct_date'] == null
          ? null
          : data['vsdc_rcpt_pbct_date'] as String?,
      sdcId: data['sdc_id'] == null ? null : data['sdc_id'] as String?,
      mrcNo: data['mrc_no'] == null ? null : data['mrc_no'] as String?,
      qrCode: data['qr_code'] == null ? null : data['qr_code'] as String?,
      receiptType:
          data['receipt_type'] == null ? null : data['receipt_type'] as String?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      transactionId: data['transaction_id'] == null
          ? null
          : data['transaction_id'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      invcNo: data['invc_no'] == null ? null : data['invc_no'] as int?,
      whenCreated: data['when_created'] == null
          ? null
          : data['when_created'] == null
              ? null
              : DateTime.tryParse(data['when_created'] as String),
      invoiceNumber: data['invoice_number'] == null
          ? null
          : data['invoice_number'] as int?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ReceiptToSqlite(Receipt instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'result_cd': instance.resultCd,
    'result_msg': instance.resultMsg,
    'result_dt': instance.resultDt,
    'rcpt_no': instance.rcptNo,
    'intrl_data': instance.intrlData,
    'rcpt_sign': instance.rcptSign,
    'tot_rcpt_no': instance.totRcptNo,
    'vsdc_rcpt_pbct_date': instance.vsdcRcptPbctDate,
    'sdc_id': instance.sdcId,
    'mrc_no': instance.mrcNo,
    'qr_code': instance.qrCode,
    'receipt_type': instance.receiptType,
    'branch_id': instance.branchId,
    'transaction_id': instance.transactionId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'invc_no': instance.invcNo,
    'when_created': instance.whenCreated?.toIso8601String(),
    'invoice_number': instance.invoiceNumber
  };
}

/// Construct a [Receipt]
class ReceiptAdapter extends OfflineFirstWithSupabaseAdapter<Receipt> {
  ReceiptAdapter();

  @override
  final supabaseTableName = 'receipts';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'resultCd': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'result_cd',
    ),
    'resultMsg': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'result_msg',
    ),
    'resultDt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'result_dt',
    ),
    'rcptNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'rcpt_no',
    ),
    'intrlData': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'intrl_data',
    ),
    'rcptSign': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'rcpt_sign',
    ),
    'totRcptNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_rcpt_no',
    ),
    'vsdcRcptPbctDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'vsdc_rcpt_pbct_date',
    ),
    'sdcId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sdc_id',
    ),
    'mrcNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'mrc_no',
    ),
    'qrCode': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'qr_code',
    ),
    'receiptType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receipt_type',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'transactionId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'transaction_id',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'invcNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'invc_no',
    ),
    'whenCreated': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'when_created',
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
      type: String,
    ),
    'resultCd': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'result_cd',
      iterable: false,
      type: String,
    ),
    'resultMsg': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'result_msg',
      iterable: false,
      type: String,
    ),
    'resultDt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'result_dt',
      iterable: false,
      type: String,
    ),
    'rcptNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'rcpt_no',
      iterable: false,
      type: int,
    ),
    'intrlData': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'intrl_data',
      iterable: false,
      type: String,
    ),
    'rcptSign': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'rcpt_sign',
      iterable: false,
      type: String,
    ),
    'totRcptNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_rcpt_no',
      iterable: false,
      type: int,
    ),
    'vsdcRcptPbctDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'vsdc_rcpt_pbct_date',
      iterable: false,
      type: String,
    ),
    'sdcId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sdc_id',
      iterable: false,
      type: String,
    ),
    'mrcNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'mrc_no',
      iterable: false,
      type: String,
    ),
    'qrCode': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'qr_code',
      iterable: false,
      type: String,
    ),
    'receiptType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receipt_type',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'transactionId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'transaction_id',
      iterable: false,
      type: String,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'invcNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'invc_no',
      iterable: false,
      type: int,
    ),
    'whenCreated': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'when_created',
      iterable: false,
      type: DateTime,
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
      Receipt instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Receipt` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Receipt';

  @override
  Future<Receipt> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReceiptFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Receipt input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReceiptToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Receipt> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReceiptFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Receipt input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReceiptToSqlite(input,
          provider: provider, repository: repository);
}
