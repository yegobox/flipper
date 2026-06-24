// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Supplier> _$SupplierFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Supplier(
    id: data['id'] as String?,
    custNm: data['cust_nm'] == null ? null : data['cust_nm'] as String?,
    email: data['email'] == null ? null : data['email'] as String?,
    telNo: data['tel_no'] == null ? null : data['tel_no'] as String?,
    adrs: data['adrs'] == null ? null : data['adrs'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
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
    ebmSynced: data['ebm_synced'] == null ? null : data['ebm_synced'] as bool?,
    bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
    useYn: data['use_yn'] == null ? null : data['use_yn'] as String?,
    customerType: data['customer_type'] == null
        ? null
        : data['customer_type'] as String?,
  );
}

Future<Map<String, dynamic>> _$SupplierToSupabase(
  Supplier instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
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
    'bhf_id': instance.bhfId,
    'use_yn': instance.useYn,
    'customer_type': instance.customerType,
  };
}

Future<Supplier> _$SupplierFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Supplier(
    id: data['id'] as String,
    custNm: data['cust_nm'] == null ? null : data['cust_nm'] as String?,
    email: data['email'] == null ? null : data['email'] as String?,
    telNo: data['tel_no'] == null ? null : data['tel_no'] as String?,
    adrs: data['adrs'] == null ? null : data['adrs'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
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
    bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
    useYn: data['use_yn'] == null ? null : data['use_yn'] as String?,
    customerType: data['customer_type'] == null
        ? null
        : data['customer_type'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$SupplierToSqlite(
  Supplier instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
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
    'ebm_synced': instance.ebmSynced == null
        ? null
        : (instance.ebmSynced! ? 1 : 0),
    'bhf_id': instance.bhfId,
    'use_yn': instance.useYn,
    'customer_type': instance.customerType,
  };
}

/// Construct a [Supplier]
class SupplierAdapter extends OfflineFirstWithSupabaseAdapter<Supplier> {
  SupplierAdapter();

  @override
  final supabaseTableName = 'suppliers';
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
      type: String,
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
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Supplier instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Supplier` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Supplier';

  @override
  Future<Supplier> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SupplierFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Supplier input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SupplierToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Supplier> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SupplierFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Supplier input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SupplierToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
