// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Favorite> _$FavoriteFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Favorite(
      id: data['id'] as String?,
      favIndex: data['fav_index'] as String?,
      productId: data['product_id'] as String?,
      branchId: data['branch_id'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String));
}

Future<Map<String, dynamic>> _$FavoriteToSupabase(Favorite instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'fav_index': instance.favIndex,
    'product_id': instance.productId,
    'branch_id': instance.branchId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String()
  };
}

Future<Favorite> _$FavoriteFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Favorite(
      id: data['id'] as String,
      favIndex: data['fav_index'] == null ? null : data['fav_index'] as String?,
      productId:
          data['product_id'] == null ? null : data['product_id'] as String?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String))
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$FavoriteToSqlite(Favorite instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'fav_index': instance.favIndex,
    'product_id': instance.productId,
    'branch_id': instance.branchId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String()
  };
}

/// Construct a [Favorite]
class FavoriteAdapter extends OfflineFirstWithSupabaseAdapter<Favorite> {
  FavoriteAdapter();

  @override
  final supabaseTableName = 'favorites';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'favIndex': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'fav_index',
    ),
    'productId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'product_id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
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
    'favIndex': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'fav_index',
      iterable: false,
      type: String,
    ),
    'productId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'product_id',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Favorite instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Favorite` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Favorite';

  @override
  Future<Favorite> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$FavoriteFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Favorite input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$FavoriteToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Favorite> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$FavoriteFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Favorite input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$FavoriteToSqlite(input,
          provider: provider, repository: repository);
}
