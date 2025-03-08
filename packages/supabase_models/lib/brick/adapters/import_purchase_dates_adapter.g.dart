// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ImportPurchaseDates> _$ImportPurchaseDatesFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ImportPurchaseDates(
    id: data['id'] as String?,
    lastRequestDate:
        data['last_request_date'] == null
            ? null
            : data['last_request_date'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
    requestType:
        data['request_type'] == null ? null : data['request_type'] as String?,
    purchaseId:
        data['purchase_id'] == null ? null : data['purchase_id'] as String?,
  );
}

Future<Map<String, dynamic>> _$ImportPurchaseDatesToSupabase(
  ImportPurchaseDates instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'last_request_date': instance.lastRequestDate,
    'branch_id': instance.branchId,
    'request_type': instance.requestType,
    'purchase_id': instance.purchaseId,
  };
}

Future<ImportPurchaseDates> _$ImportPurchaseDatesFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ImportPurchaseDates(
    id: data['id'] as String,
    lastRequestDate:
        data['last_request_date'] == null
            ? null
            : data['last_request_date'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
    requestType:
        data['request_type'] == null ? null : data['request_type'] as String?,
    purchaseId:
        data['purchase_id'] == null ? null : data['purchase_id'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ImportPurchaseDatesToSqlite(
  ImportPurchaseDates instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'last_request_date': instance.lastRequestDate,
    'branch_id': instance.branchId,
    'request_type': instance.requestType,
    'purchase_id': instance.purchaseId,
  };
}

/// Construct a [ImportPurchaseDates]
class ImportPurchaseDatesAdapter
    extends OfflineFirstWithSupabaseAdapter<ImportPurchaseDates> {
  ImportPurchaseDatesAdapter();

  @override
  final supabaseTableName = 'import_purchase_dates';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'lastRequestDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_request_date',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'requestType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'request_type',
    ),
    'purchaseId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'purchase_id',
      foreignKey: 'purchase_id',
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
    'lastRequestDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_request_date',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
    ),
    'requestType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'request_type',
      iterable: false,
      type: String,
    ),
    'purchaseId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'purchase_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    ImportPurchaseDates instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `ImportPurchaseDates` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'ImportPurchaseDates';

  @override
  Future<ImportPurchaseDates> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImportPurchaseDatesFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    ImportPurchaseDates input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImportPurchaseDatesToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<ImportPurchaseDates> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImportPurchaseDatesFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    ImportPurchaseDates input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ImportPurchaseDatesToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
