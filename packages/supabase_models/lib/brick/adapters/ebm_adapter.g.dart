// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Ebm> _$EbmFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Ebm(
    id: data['id'] as String?,
    bhfId: data['bhf_id'] as String,
    tinNumber: data['tin_number'] as int,
    dvcSrlNo: data['dvc_srl_no'] as String,
    userId: data['user_id'] as int,
    taxServerUrl: data['tax_server_url'] as String,
    businessId: data['business_id'] as int,
    branchId: data['branch_id'] as int,
    lastTouched:
        data['last_touched'] == null
            ? null
            : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    vatEnabled: data['vat_enabled'] as bool,
  );
}

Future<Map<String, dynamic>> _$EbmToSupabase(
  Ebm instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'bhf_id': instance.bhfId,
    'tin_number': instance.tinNumber,
    'dvc_srl_no': instance.dvcSrlNo,
    'user_id': instance.userId,
    'tax_server_url': instance.taxServerUrl,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'vat_enabled': instance.vatEnabled,
  };
}

Future<Ebm> _$EbmFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Ebm(
    id: data['id'] as String,
    bhfId: data['bhf_id'] as String,
    tinNumber: data['tin_number'] as int,
    dvcSrlNo: data['dvc_srl_no'] as String,
    userId: data['user_id'] as int,
    taxServerUrl: data['tax_server_url'] as String,
    businessId: data['business_id'] as int,
    branchId: data['branch_id'] as int,
    lastTouched:
        data['last_touched'] == null
            ? null
            : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    vatEnabled: data['vat_enabled'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$EbmToSqlite(
  Ebm instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'bhf_id': instance.bhfId,
    'tin_number': instance.tinNumber,
    'dvc_srl_no': instance.dvcSrlNo,
    'user_id': instance.userId,
    'tax_server_url': instance.taxServerUrl,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'vat_enabled': instance.vatEnabled ? 1 : 0,
  };
}

/// Construct a [Ebm]
class EbmAdapter extends OfflineFirstWithSupabaseAdapter<Ebm> {
  EbmAdapter();

  @override
  final supabaseTableName = 'ebms';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'bhfId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'bhf_id',
    ),
    'tinNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tin_number',
    ),
    'dvcSrlNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dvc_srl_no',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'taxServerUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_server_url',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'vatEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'vat_enabled',
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
    'bhfId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'bhf_id',
      iterable: false,
      type: String,
    ),
    'tinNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tin_number',
      iterable: false,
      type: int,
    ),
    'dvcSrlNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dvc_srl_no',
      iterable: false,
      type: String,
    ),
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: int,
    ),
    'taxServerUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_server_url',
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
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'vatEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'vat_enabled',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Ebm instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Ebm` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Ebm';

  @override
  Future<Ebm> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$EbmFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Ebm input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$EbmToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Ebm> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$EbmFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    Ebm input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$EbmToSqlite(input, provider: provider, repository: repository);
}
