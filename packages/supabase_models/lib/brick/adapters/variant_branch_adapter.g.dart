// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<VariantBranch> _$VariantBranchFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return VariantBranch(
      id: data['id'] as String?,
      variantId:
          data['variant_id'] == null ? null : data['variant_id'] as String?,
      newVariantId: data['new_variant_id'] == null
          ? null
          : data['new_variant_id'] as String?,
      sourceBranchId: data['source_branch_id'] == null
          ? null
          : data['source_branch_id'] as String?,
      destinationBranchId: data['destination_branch_id'] == null
          ? null
          : data['destination_branch_id'] as String?);
}

Future<Map<String, dynamic>> _$VariantBranchToSupabase(VariantBranch instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'variant_id': instance.variantId,
    'new_variant_id': instance.newVariantId,
    'source_branch_id': instance.sourceBranchId,
    'destination_branch_id': instance.destinationBranchId
  };
}

Future<VariantBranch> _$VariantBranchFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return VariantBranch(
      id: data['id'] as String,
      variantId:
          data['variant_id'] == null ? null : data['variant_id'] as String?,
      newVariantId: data['new_variant_id'] == null
          ? null
          : data['new_variant_id'] as String?,
      sourceBranchId: data['source_branch_id'] == null
          ? null
          : data['source_branch_id'] as String?,
      destinationBranchId: data['destination_branch_id'] == null
          ? null
          : data['destination_branch_id'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$VariantBranchToSqlite(VariantBranch instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'variant_id': instance.variantId,
    'new_variant_id': instance.newVariantId,
    'source_branch_id': instance.sourceBranchId,
    'destination_branch_id': instance.destinationBranchId
  };
}

/// Construct a [VariantBranch]
class VariantBranchAdapter
    extends OfflineFirstWithSupabaseAdapter<VariantBranch> {
  VariantBranchAdapter();

  @override
  final supabaseTableName = 'variants_branches';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'variantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'variant_id',
    ),
    'newVariantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'new_variant_id',
    ),
    'sourceBranchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'source_branch_id',
    ),
    'destinationBranchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'destination_branch_id',
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
    'variantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variant_id',
      iterable: false,
      type: String,
    ),
    'newVariantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'new_variant_id',
      iterable: false,
      type: String,
    ),
    'sourceBranchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'source_branch_id',
      iterable: false,
      type: String,
    ),
    'destinationBranchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'destination_branch_id',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      VariantBranch instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `VariantBranch` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'VariantBranch';

  @override
  Future<VariantBranch> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantBranchFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(VariantBranch input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantBranchToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<VariantBranch> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantBranchFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(VariantBranch input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$VariantBranchToSqlite(input,
          provider: provider, repository: repository);
}
