// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Counter> _$CounterFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Counter(
      id: data['id'] as String?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      receiptType:
          data['receipt_type'] == null ? null : data['receipt_type'] as String?,
      totRcptNo:
          data['tot_rcpt_no'] == null ? null : data['tot_rcpt_no'] as int?,
      curRcptNo:
          data['cur_rcpt_no'] == null ? null : data['cur_rcpt_no'] as int?,
      invcNo: data['invc_no'] == null ? null : data['invc_no'] as int?,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String));
}

Future<Map<String, dynamic>> _$CounterToSupabase(Counter instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'receipt_type': instance.receiptType,
    'tot_rcpt_no': instance.totRcptNo,
    'cur_rcpt_no': instance.curRcptNo,
    'invc_no': instance.invcNo,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String()
  };
}

Future<Counter> _$CounterFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Counter(
      id: data['id'] as String,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      receiptType:
          data['receipt_type'] == null ? null : data['receipt_type'] as String?,
      totRcptNo:
          data['tot_rcpt_no'] == null ? null : data['tot_rcpt_no'] as int?,
      curRcptNo:
          data['cur_rcpt_no'] == null ? null : data['cur_rcpt_no'] as int?,
      invcNo: data['invc_no'] == null ? null : data['invc_no'] as int?,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String))
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CounterToSqlite(Counter instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'receipt_type': instance.receiptType,
    'tot_rcpt_no': instance.totRcptNo,
    'cur_rcpt_no': instance.curRcptNo,
    'invc_no': instance.invcNo,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'created_at': instance.createdAt?.toIso8601String()
  };
}

/// Construct a [Counter]
class CounterAdapter extends OfflineFirstWithSupabaseAdapter<Counter> {
  CounterAdapter();

  @override
  final supabaseTableName = 'counters';
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
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'receiptType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'receipt_type',
    ),
    'totRcptNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tot_rcpt_no',
    ),
    'curRcptNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cur_rcpt_no',
    ),
    'invcNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'invc_no',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    ),
    'receiptType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'receipt_type',
      iterable: false,
      type: String,
    ),
    'totRcptNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tot_rcpt_no',
      iterable: false,
      type: int,
    ),
    'curRcptNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cur_rcpt_no',
      iterable: false,
      type: int,
    ),
    'invcNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'invc_no',
      iterable: false,
      type: int,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Counter instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Counter` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Counter';

  @override
  Future<Counter> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CounterFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Counter input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CounterToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Counter> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CounterFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Counter input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CounterToSqlite(input,
          provider: provider, repository: repository);
}
