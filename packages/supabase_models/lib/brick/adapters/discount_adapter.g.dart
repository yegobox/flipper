// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Discount> _$DiscountFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Discount(
      id: data['id'] as String?,
      name: data['name'] == null ? null : data['name'] as String?,
      amount: data['amount'] == null ? null : data['amount'] as double?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?);
}

Future<Map<String, dynamic>> _$DiscountToSupabase(Discount instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'amount': instance.amount,
    'branch_id': instance.branchId
  };
}

Future<Discount> _$DiscountFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Discount(
      id: data['id'] as String,
      name: data['name'] == null ? null : data['name'] as String?,
      amount: data['amount'] == null ? null : data['amount'] as double?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$DiscountToSqlite(Discount instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'amount': instance.amount,
    'branch_id': instance.branchId
  };
}

/// Construct a [Discount]
class DiscountAdapter extends OfflineFirstWithSupabaseAdapter<Discount> {
  DiscountAdapter();

  @override
  final supabaseTableName = 'discounts';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'amount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'amount',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'amount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'amount',
      iterable: false,
      type: double,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Discount instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Discount` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Discount';

  @override
  Future<Discount> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DiscountFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Discount input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DiscountToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Discount> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DiscountFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Discount input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DiscountToSqlite(input,
          provider: provider, repository: repository);
}
