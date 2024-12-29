// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ItemCode> _$ItemCodeFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return ItemCode(
      id: data['id'] as String?,
      code: data['code'] as String,
      createdAt: DateTime.parse(data['created_at'] as String));
}

Future<Map<String, dynamic>> _$ItemCodeToSupabase(ItemCode instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'code': instance.code,
    'created_at': instance.createdAt.toIso8601String()
  };
}

Future<ItemCode> _$ItemCodeFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return ItemCode(
      id: data['id'] as String,
      code: data['code'] as String,
      createdAt: DateTime.parse(data['created_at'] as String))
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ItemCodeToSqlite(ItemCode instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'code': instance.code,
    'created_at': instance.createdAt.toIso8601String()
  };
}

/// Construct a [ItemCode]
class ItemCodeAdapter extends OfflineFirstWithSupabaseAdapter<ItemCode> {
  ItemCodeAdapter();

  @override
  final supabaseTableName = 'codes';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'code': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'code',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    'code': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'code',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      ItemCode instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `ItemCode` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'ItemCode';

  @override
  Future<ItemCode> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ItemCodeFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(ItemCode input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ItemCodeToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<ItemCode> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ItemCodeFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(ItemCode input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ItemCodeToSqlite(input,
          provider: provider, repository: repository);
}
