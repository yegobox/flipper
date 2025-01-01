// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Report> _$ReportFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Report(
      id: data['id'] as String?,
      branchId: data['branch_id'] as int?,
      businessId: data['business_id'] as int?,
      filename: data['filename'] as String?,
      s3Url: data['s3_url'] as String?,
      downloaded: data['downloaded'] as bool?);
}

Future<Map<String, dynamic>> _$ReportToSupabase(Report instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'filename': instance.filename,
    's3_url': instance.s3Url,
    'downloaded': instance.downloaded
  };
}

Future<Report> _$ReportFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Report(
      id: data['id'] as String,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      filename: data['filename'] == null ? null : data['filename'] as String?,
      s3Url: data['s3_url'] == null ? null : data['s3_url'] as String?,
      downloaded: data['downloaded'] == null ? null : data['downloaded'] == 1)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ReportToSqlite(Report instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'filename': instance.filename,
    's3_url': instance.s3Url,
    'downloaded':
        instance.downloaded == null ? null : (instance.downloaded! ? 1 : 0)
  };
}

/// Construct a [Report]
class ReportAdapter extends OfflineFirstWithSupabaseAdapter<Report> {
  ReportAdapter();

  @override
  final supabaseTableName = 'reports';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'filename': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'filename',
    ),
    's3Url': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 's3_url',
    ),
    'downloaded': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'downloaded',
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
    ),
    'filename': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'filename',
      iterable: false,
      type: String,
    ),
    's3Url': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 's3_url',
      iterable: false,
      type: String,
    ),
    'downloaded': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'downloaded',
      iterable: false,
      type: bool,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Report instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Report` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Report';

  @override
  Future<Report> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReportFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Report input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReportToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Report> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReportFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Report input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReportToSqlite(input, provider: provider, repository: repository);
}
