// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<ActualOutput> _$ActualOutputFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ActualOutput(
    id: data['id'] as String?,
    workOrderId: data['work_order_id'] as String,
    branchId: data['branch_id'] as String,
    actualQuantity: data['actual_quantity'] as double,
    recordedAt: data['recorded_at'] == null
        ? null
        : DateTime.tryParse(data['recorded_at'] as String),
    userId: data['user_id'] as String,
    userName: data['user_name'] == null ? null : data['user_name'] as String?,
    varianceReason: data['variance_reason'] == null
        ? null
        : data['variance_reason'] as String?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    shiftId: data['shift_id'] == null ? null : data['shift_id'] as String?,
    qualityStatus: data['quality_status'] == null
        ? null
        : data['quality_status'] as String?,
    reworkQuantity: data['rework_quantity'] as double? ?? 0.0,
    scrapQuantity: data['scrap_quantity'] as double? ?? 0.0,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
        ? null
        : DateTime.tryParse(data['last_touched'] as String),
  );
}

Future<Map<String, dynamic>> _$ActualOutputToSupabase(
  ActualOutput instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'work_order_id': instance.workOrderId,
    'branch_id': instance.branchId,
    'actual_quantity': instance.actualQuantity,
    'recorded_at': instance.recordedAt.toIso8601String(),
    'user_id': instance.userId,
    'user_name': instance.userName,
    'variance_reason': instance.varianceReason,
    'notes': instance.notes,
    'shift_id': instance.shiftId,
    'quality_status': instance.qualityStatus,
    'rework_quantity': instance.reworkQuantity,
    'scrap_quantity': instance.scrapQuantity,
    'last_touched': instance.lastTouched?.toIso8601String(),
  };
}

Future<ActualOutput> _$ActualOutputFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return ActualOutput(
    id: data['id'] as String,
    workOrderId: data['work_order_id'] as String,
    branchId: data['branch_id'] as String,
    actualQuantity: data['actual_quantity'] as double,
    recordedAt: DateTime.parse(data['recorded_at'] as String),
    userId: data['user_id'] as String,
    userName: data['user_name'] == null ? null : data['user_name'] as String?,
    varianceReason: data['variance_reason'] == null
        ? null
        : data['variance_reason'] as String?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    shiftId: data['shift_id'] == null ? null : data['shift_id'] as String?,
    qualityStatus: data['quality_status'] == null
        ? null
        : data['quality_status'] as String?,
    reworkQuantity: data['rework_quantity'],
    scrapQuantity: data['scrap_quantity'],
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
        ? null
        : DateTime.tryParse(data['last_touched'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ActualOutputToSqlite(
  ActualOutput instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'work_order_id': instance.workOrderId,
    'branch_id': instance.branchId,
    'actual_quantity': instance.actualQuantity,
    'recorded_at': instance.recordedAt.toIso8601String(),
    'user_id': instance.userId,
    'user_name': instance.userName,
    'variance_reason': instance.varianceReason,
    'notes': instance.notes,
    'shift_id': instance.shiftId,
    'quality_status': instance.qualityStatus,
    'rework_quantity': instance.reworkQuantity,
    'scrap_quantity': instance.scrapQuantity,
    'last_touched': instance.lastTouched?.toIso8601String(),
  };
}

/// Construct a [ActualOutput]
class ActualOutputAdapter
    extends OfflineFirstWithSupabaseAdapter<ActualOutput> {
  ActualOutputAdapter();

  @override
  final supabaseTableName = 'actual_outputs';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'workOrderId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'work_order_id',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'actualQuantity': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'actual_quantity',
    ),
    'recordedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recorded_at',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'userName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_name',
    ),
    'varianceReason': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'variance_reason',
    ),
    'notes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notes',
    ),
    'shiftId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shift_id',
    ),
    'qualityStatus': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'quality_status',
    ),
    'reworkQuantity': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'rework_quantity',
    ),
    'scrapQuantity': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'scrap_quantity',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
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
    'workOrderId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'work_order_id',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
    ),
    'actualQuantity': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'actual_quantity',
      iterable: false,
      type: double,
    ),
    'recordedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'recorded_at',
      iterable: false,
      type: DateTime,
    ),
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: String,
    ),
    'userName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_name',
      iterable: false,
      type: String,
    ),
    'varianceReason': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variance_reason',
      iterable: false,
      type: String,
    ),
    'notes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notes',
      iterable: false,
      type: String,
    ),
    'shiftId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'shift_id',
      iterable: false,
      type: String,
    ),
    'qualityStatus': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'quality_status',
      iterable: false,
      type: String,
    ),
    'reworkQuantity': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'rework_quantity',
      iterable: false,
      type: double,
    ),
    'scrapQuantity': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'scrap_quantity',
      iterable: false,
      type: double,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    ActualOutput instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `ActualOutput` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'ActualOutput';

  @override
  Future<ActualOutput> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ActualOutputFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    ActualOutput input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ActualOutputToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<ActualOutput> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ActualOutputFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    ActualOutput input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ActualOutputToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
