// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<PlanAddon> _$PlanAddonFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return PlanAddon(
    id: data['id'] as String?,
    planId: data['plan_id'] == null ? null : data['plan_id'] as int?,
    addonName:
        data['addon_name'] == null ? null : data['addon_name'] as String?,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
  );
}

Future<Map<String, dynamic>> _$PlanAddonToSupabase(
  PlanAddon instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'plan_id': instance.planId,
    'addon_name': instance.addonName,
    'created_at': instance.createdAt?.toIso8601String(),
  };
}

Future<PlanAddon> _$PlanAddonFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return PlanAddon(
    id: data['id'] as String,
    planId: data['plan_id'] == null ? null : data['plan_id'] as int?,
    addonName:
        data['addon_name'] == null ? null : data['addon_name'] as String?,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$PlanAddonToSqlite(
  PlanAddon instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'plan_id': instance.planId,
    'addon_name': instance.addonName,
    'created_at': instance.createdAt?.toIso8601String(),
  };
}

/// Construct a [PlanAddon]
class PlanAddonAdapter extends OfflineFirstWithSupabaseAdapter<PlanAddon> {
  PlanAddonAdapter();

  @override
  final supabaseTableName = 'addons';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'planId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'plan_id',
    ),
    'addonName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'addon_name',
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
    'planId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'plan_id',
      iterable: false,
      type: int,
    ),
    'addonName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'addon_name',
      iterable: false,
      type: String,
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
    PlanAddon instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `PlanAddon` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'PlanAddon';

  @override
  Future<PlanAddon> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanAddonFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    PlanAddon input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanAddonToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<PlanAddon> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanAddonFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    PlanAddon input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanAddonToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
