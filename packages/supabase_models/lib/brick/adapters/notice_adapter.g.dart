// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Notice> _$NoticeFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Notice(
    id: data['id'] as String?,
    noticeNo: data['notice_no'] == null ? null : data['notice_no'] as int?,
    title: data['title'] == null ? null : data['title'] as String?,
    cont: data['cont'] == null ? null : data['cont'] as String?,
    dtlUrl: data['dtl_url'] == null ? null : data['dtl_url'] as String?,
    regrNm: data['regr_nm'] == null ? null : data['regr_nm'] as String?,
    regDt: data['reg_dt'] == null ? null : data['reg_dt'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
  );
}

Future<Map<String, dynamic>> _$NoticeToSupabase(
  Notice instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'notice_no': instance.noticeNo,
    'title': instance.title,
    'cont': instance.cont,
    'dtl_url': instance.dtlUrl,
    'regr_nm': instance.regrNm,
    'reg_dt': instance.regDt,
    'branch_id': instance.branchId,
  };
}

Future<Notice> _$NoticeFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Notice(
    id: data['id'] as String,
    noticeNo: data['notice_no'] == null ? null : data['notice_no'] as int?,
    title: data['title'] == null ? null : data['title'] as String?,
    cont: data['cont'] == null ? null : data['cont'] as String?,
    dtlUrl: data['dtl_url'] == null ? null : data['dtl_url'] as String?,
    regrNm: data['regr_nm'] == null ? null : data['regr_nm'] as String?,
    regDt: data['reg_dt'] == null ? null : data['reg_dt'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$NoticeToSqlite(
  Notice instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'notice_no': instance.noticeNo,
    'title': instance.title,
    'cont': instance.cont,
    'dtl_url': instance.dtlUrl,
    'regr_nm': instance.regrNm,
    'reg_dt': instance.regDt,
    'branch_id': instance.branchId,
  };
}

/// Construct a [Notice]
class NoticeAdapter extends OfflineFirstWithSupabaseAdapter<Notice> {
  NoticeAdapter();

  @override
  final supabaseTableName = 'notices';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'noticeNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notice_no',
    ),
    'title': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'title',
    ),
    'cont': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'cont',
    ),
    'dtlUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dtl_url',
    ),
    'regrNm': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'regr_nm',
    ),
    'regDt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'reg_dt',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
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
    'noticeNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notice_no',
      iterable: false,
      type: int,
    ),
    'title': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'title',
      iterable: false,
      type: String,
    ),
    'cont': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'cont',
      iterable: false,
      type: String,
    ),
    'dtlUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dtl_url',
      iterable: false,
      type: String,
    ),
    'regrNm': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'regr_nm',
      iterable: false,
      type: String,
    ),
    'regDt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'reg_dt',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Notice instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Notice` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Notice';

  @override
  Future<Notice> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$NoticeFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Notice input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$NoticeToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Notice> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$NoticeFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Notice input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$NoticeToSqlite(input, provider: provider, repository: repository);
}
