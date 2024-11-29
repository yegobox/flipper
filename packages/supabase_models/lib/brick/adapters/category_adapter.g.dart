// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Category> _$CategoryFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Category(
      id: data['id'] as int,
      active: data['active'] as bool?,
      focused: data['focused'] as bool,
      name: data['name'] as String?,
      branchId: data['branch_id'] as int?,
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String));
}

Future<Map<String, dynamic>> _$CategoryToSupabase(Category instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'active': instance.active,
    'focused': instance.focused,
    'name': instance.name,
    'branch_id': instance.branchId,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'last_touched': instance.lastTouched?.toIso8601String()
  };
}

Future<Category> _$CategoryFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Category(
      id: data['id'] as int,
      active: data['active'] == null ? null : data['active'] == 1,
      focused: data['focused'] == 1,
      name: data['name'] == null ? null : data['name'] as String?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String))
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$CategoryToSqlite(Category instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'active': instance.active == null ? null : (instance.active! ? 1 : 0),
    'focused': instance.focused ? 1 : 0,
    'name': instance.name,
    'branch_id': instance.branchId,
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'last_touched': instance.lastTouched?.toIso8601String()
  };
}

/// Construct a [Category]
class CategoryAdapter extends OfflineFirstWithSupabaseAdapter<Category> {
  CategoryAdapter();

  @override
  final supabaseTableName = 'categories';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'active': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'active',
    ),
    'focused': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'focused',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
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
      type: int,
    ),
    'active': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'active',
      iterable: false,
      type: bool,
    ),
    'focused': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'focused',
      iterable: false,
      type: bool,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Category instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Category` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Category';

  @override
  Future<Category> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategoryFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Category input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategoryToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Category> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategoryFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Category input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$CategoryToSqlite(input,
          provider: provider, repository: repository);
}
