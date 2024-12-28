// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Customer> _$CustomerFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Customer(
      id: data['id'] as String?,
      custNm: data['cust_nm'] as String?,
      email: data['email'] as String?,
      telNo: data['tel_no'] as String?,
      adrs: data['adrs'] as String?,
      branchId: data['branch_id'] as int?,
      updatedAt: data['updated_at'] == null
          ? null
          : DateTime.tryParse(data['updated_at'] as String),
      custNo: data['cust_no'] as String?,
      custTin: data['cust_tin'] as String?,
      regrNm: data['regr_nm'] as String?,
      regrId: data['regr_id'] as String?,
      modrNm: data['modr_nm'] as String?,
      modrId: data['modr_id'] as String?,
      ebmSynced: data['ebm_synced'] as bool?,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      tin: data['tin'] as int?,
      bhfId: data['bhf_id'] as String?,
      useYn: data['use_yn'] as String?,
      customerType: data['customer_type'] as String?);
}

Future<Map<String, dynamic>> _$CustomerToSupabase(Customer instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'cust_nm': instance.custNm,
    'email': instance.email,
    'tel_no': instance.telNo,
    'adrs': instance.adrs,
    'branch_id': instance.branchId,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'cust_no': instance.custNo,
    'cust_tin': instance.custTin,
    'regr_nm': instance.regrNm,
    'regr_id': instance.regrId,
    'modr_nm': instance.modrNm,
    'modr_id': instance.modrId,
    'ebm_synced': instance.ebmSynced,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'tin': instance.tin,
    'bhf_id': instance.bhfId,
    'use_yn': instance.useYn,
    'customer_type': instance.customerType
  };
}

Future<Customer> _$CustomerFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Customer(
      id: data['id'] as String,
      custNm: data['cust_nm'] == null ? null : data['cust_nm'] as String?,
      email: data['email'] == null ? null : data['email'] as String?,
      telNo: data['tel_no'] == null ? null : data['tel_no'] as String?,
      adrs: data['adrs'] == null ? null : data['adrs'] as String?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      updatedAt: data['updated_at'] == null
          ? null
          : data['updated_at'] == null
              ? null
              : DateTime.tryParse(data['updated_at'] as String),
      custNo: data['cust_no'] == null ? null : data['cust_no'] as String?,
      custTin: data['cust_tin'] == null ? null : data['cust_tin'] as String?,
      regrNm: data['regr_nm'] == null ? null : data['regr_nm'] as String?,
      regrId: data['regr_id'] == null ? null : data['regr_id'] as String?,
      modrNm: data['modr_nm'] == null ? null : data['modr_nm'] as String?,
      modrId: data['modr_id'] == null ? null : data['modr_id'] as String?,
      ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] == 1,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      tin: data['tin'] == null ? null : data['tin'] as int?,
      bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
      useYn: data['use_yn'] == null ? null : data['use_yn'] as String?,
      customerType: data['customer_type'] == null
          ? null
          : data['customer_type'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CustomerToSqlite(Customer instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'cust_nm': instance.custNm,
    'email': instance.email,
    'tel_no': instance.telNo,
    'adrs': instance.adrs,
    'branch_id': instance.branchId,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'cust_no': instance.custNo,
    'cust_tin': instance.custTin,
    'regr_nm': instance.regrNm,
    'regr_id': instance.regrId,
    'modr_nm': instance.modrNm,
    'modr_id': instance.modrId,
    'ebm_synced':
        instance.ebmSynced == null ? null : (instance.ebmSynced! ? 1 : 0),
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'tin': instance.tin,
    'bhf_id': instance.bhfId,
    'use_yn': instance.useYn,
    'customer_type': instance.customerType
  };
}

/// Construct a [Customer]
class CustomerAdapter extends OfflineFirstWithSupabaseAdapter<Customer> {
  CustomerAdapter();

  @override
  final supabaseTableName = 'customers';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'custNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cust_nm',
    ),
    'email': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'email',
    ),
    'telNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tel_no',
    ),
    'adrs': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'adrs',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'custNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cust_no',
    ),
    'custTin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cust_tin',
    ),
    'regrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'regr_nm',
    ),
    'regrId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'regr_id',
    ),
    'modrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'modr_nm',
    ),
    'modrId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'modr_id',
    ),
    'ebmSynced': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'tin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tin',
    ),
    'bhfId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'bhf_id',
    ),
    'useYn': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'use_yn',
    ),
    'customerType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'customer_type',
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
    'custNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cust_nm',
      iterable: false,
      type: String,
    ),
    'email': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'email',
      iterable: false,
      type: String,
    ),
    'telNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tel_no',
      iterable: false,
      type: String,
    ),
    'adrs': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'adrs',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'custNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cust_no',
      iterable: false,
      type: String,
    ),
    'custTin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cust_tin',
      iterable: false,
      type: String,
    ),
    'regrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'regr_nm',
      iterable: false,
      type: String,
    ),
    'regrId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'regr_id',
      iterable: false,
      type: String,
    ),
    'modrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'modr_nm',
      iterable: false,
      type: String,
    ),
    'modrId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'modr_id',
      iterable: false,
      type: String,
    ),
    'ebmSynced': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ebm_synced',
      iterable: false,
      type: bool,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'tin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tin',
      iterable: false,
      type: int,
    ),
    'bhfId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'bhf_id',
      iterable: false,
      type: String,
    ),
    'useYn': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'use_yn',
      iterable: false,
      type: String,
    ),
    'customerType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'customer_type',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Customer instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Customer` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Customer';

  @override
  Future<Customer> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CustomerFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Customer input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CustomerToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Customer> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CustomerFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Customer input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CustomerToSqlite(input,
          provider: provider, repository: repository);
}
