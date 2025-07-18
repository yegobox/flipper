// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Sar> _$SarFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Sar(
    id: data['id'] as String?,
    sarNo: data['sar_no'] as int,
    branchId: data['branch_id'] as int,
    createdAt:
        data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
  );
}

Future<Map<String, dynamic>> _$SarToSupabase(
  Sar instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'sar_no': instance.sarNo,
    'branch_id': instance.branchId,
    'created_at': instance.createdAt.toIso8601String(),
  };
}

Future<Sar> _$SarFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Sar(
    id: data['id'] as String,
    sarNo: data['sar_no'] as int,
    branchId: data['branch_id'] as int,
    createdAt: DateTime.parse(data['created_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$SarToSqlite(
  Sar instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'sar_no': instance.sarNo,
    'branch_id': instance.branchId,
    'created_at': instance.createdAt.toIso8601String(),
  };
}

/// Construct a [Sar]
class SarAdapter extends OfflineFirstWithSupabaseAdapter<Sar> {
  SarAdapter();

  @override
  final supabaseTableName = 'sars';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'sarNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sar_no',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    'sarNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sar_no',
      iterable: false,
      type: int,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Sar instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Sar` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Sar';

  @override
  Future<Sar> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$SarFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Sar input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SarToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Sar> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SarFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    Sar input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$SarToSqlite(input, provider: provider, repository: repository);
}
