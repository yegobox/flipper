// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<IUnit> _$IUnitFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return IUnit(
    id: data['id'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    name: data['name'] == null ? null : data['name'] as String?,
    value: data['value'] == null ? null : data['value'] as String?,
    active: data['active'] == null ? null : data['active'] as bool? ?? false,
    code: data['code'] == null ? null : data['code'] as String?,
    description:
        data['description'] == null ? null : data['description'] as String?,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
  );
}

Future<Map<String, dynamic>> _$IUnitToSupabase(
  IUnit instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'name': instance.name,
    'value': instance.value,
    'active': instance.active,
    'code': instance.code,
    'description': instance.description,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'created_at': instance.createdAt,
  };
}

Future<IUnit> _$IUnitFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return IUnit(
    id: data['id'] as String,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
    name: data['name'] == null ? null : data['name'] as String?,
    value: data['value'] == null ? null : data['value'] as String?,
    active: data['active'] == null ? null : data['active'] == 1,
    code: data['code'] == null ? null : data['code'] as String?,
    description:
        data['description'] == null ? null : data['description'] as String?,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    createdAt:
        data['created_at'] == null ? null : data['created_at'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$IUnitToSqlite(
  IUnit instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'name': instance.name,
    'value': instance.value,
    'active': instance.active == null ? null : (instance.active! ? 1 : 0),
    'code': instance.code,
    'description': instance.description,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'created_at': instance.createdAt,
  };
}

/// Construct a [IUnit]
class IUnitAdapter extends OfflineFirstWithSupabaseAdapter<IUnit> {
  IUnitAdapter();

  @override
  final supabaseTableName = 'units';
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
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'value': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'value',
    ),
    'active': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'active',
    ),
    'code': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'code',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
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
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'value': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'value',
      iterable: false,
      type: String,
    ),
    'active': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'active',
      iterable: false,
      type: bool,
    ),
    'code': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'code',
      iterable: false,
      type: String,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
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
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    IUnit instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `IUnit` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'IUnit';

  @override
  Future<IUnit> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$IUnitFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    IUnit input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$IUnitToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<IUnit> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$IUnitFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    IUnit input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$IUnitToSqlite(input, provider: provider, repository: repository);
}
