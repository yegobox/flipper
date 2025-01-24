// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<BusinessAnalytic> _$BusinessAnalyticFromSupabase(
    Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return BusinessAnalytic(
      id: data['id'] as String?,
      date: DateTime.parse(data['date'] as String),
      value: data['value'] as num,
      type: data['type'] as String,
      branchId: data['branch_id'] as int?,
      businessId: data['business_id'] as int?);
}

Future<Map<String, dynamic>> _$BusinessAnalyticToSupabase(
    BusinessAnalytic instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'date': instance.date.toIso8601String(),
    'value': instance.value,
    'type': instance.type,
    'branch_id': instance.branchId,
    'business_id': instance.businessId
  };
}

Future<BusinessAnalytic> _$BusinessAnalyticFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return BusinessAnalytic(
      id: data['id'] as String,
      date: DateTime.parse(data['date'] as String),
      value: data['value'] as num,
      type: data['type'] as String,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BusinessAnalyticToSqlite(
    BusinessAnalytic instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'date': instance.date.toIso8601String(),
    'value': instance.value,
    'type': instance.type,
    'branch_id': instance.branchId,
    'business_id': instance.businessId
  };
}

/// Construct a [BusinessAnalytic]
class BusinessAnalyticAdapter
    extends OfflineFirstWithSupabaseAdapter<BusinessAnalytic> {
  BusinessAnalyticAdapter();

  @override
  final supabaseTableName = 'business_analytics';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'date': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'date',
    ),
    'value': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'value',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
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
    'date': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'date',
      iterable: false,
      type: DateTime,
    ),
    'value': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'value',
      iterable: false,
      type: num,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      BusinessAnalytic instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `BusinessAnalytic` WHERE id = ? LIMIT 1''',
        [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'BusinessAnalytic';

  @override
  Future<BusinessAnalytic> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessAnalyticFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(BusinessAnalytic input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessAnalyticToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<BusinessAnalytic> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessAnalyticFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(BusinessAnalytic input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessAnalyticToSqlite(input,
          provider: provider, repository: repository);
}
