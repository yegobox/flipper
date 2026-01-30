// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<WorkOrder> _$WorkOrderFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return WorkOrder(
    id: data['id'] as String?,
    branchId: data['branch_id'] as String,
    businessId: data['business_id'] as String,
    variantId: data['variant_id'] as String,
    variantName: data['variant_name'] == null
        ? null
        : data['variant_name'] as String?,
    plannedQuantity: data['planned_quantity'] as double,
    actualQuantity: data['actual_quantity'] as double? ?? 0.0,
    targetDate: DateTime.parse(data['target_date'] as String),
    shiftId: data['shift_id'] == null ? null : data['shift_id'] as String?,
    status: data['status'] as String? ?? 'planned',
    unitOfMeasure: data['unit_of_measure'] == null
        ? null
        : data['unit_of_measure'] as String?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    createdBy: data['created_by'] == null
        ? null
        : data['created_by'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
        ? null
        : DateTime.tryParse(data['last_touched'] as String),
  );
}

Future<Map<String, dynamic>> _$WorkOrderToSupabase(
  WorkOrder instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'variant_id': instance.variantId,
    'variant_name': instance.variantName,
    'planned_quantity': instance.plannedQuantity,
    'actual_quantity': instance.actualQuantity,
    'target_date': instance.targetDate.toIso8601String(),
    'shift_id': instance.shiftId,
    'status': instance.status,
    'unit_of_measure': instance.unitOfMeasure,
    'notes': instance.notes,
    'created_by': instance.createdBy,
    'created_at': instance.createdAt?.toIso8601String(),
    'last_touched': instance.lastTouched?.toIso8601String(),
  };
}

Future<WorkOrder> _$WorkOrderFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return WorkOrder(
    id: data['id'] as String,
    branchId: data['branch_id'] as String,
    businessId: data['business_id'] as String,
    variantId: data['variant_id'] as String,
    variantName: data['variant_name'] == null
        ? null
        : data['variant_name'] as String?,
    plannedQuantity: data['planned_quantity'] as double,
    actualQuantity: data['actual_quantity'],
    targetDate: DateTime.parse(data['target_date'] as String),
    shiftId: data['shift_id'] == null ? null : data['shift_id'] as String?,
    status: data['status'] as String ?? 'planned',
    unitOfMeasure: data['unit_of_measure'] == null
        ? null
        : data['unit_of_measure'] as String?,
    notes: data['notes'] == null ? null : data['notes'] as String?,
    createdBy: data['created_by'] == null
        ? null
        : data['created_by'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
        ? null
        : DateTime.tryParse(data['last_touched'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$WorkOrderToSqlite(
  WorkOrder instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'variant_id': instance.variantId,
    'variant_name': instance.variantName,
    'planned_quantity': instance.plannedQuantity,
    'actual_quantity': instance.actualQuantity,
    'target_date': instance.targetDate.toIso8601String(),
    'shift_id': instance.shiftId,
    'status': instance.status,
    'unit_of_measure': instance.unitOfMeasure,
    'notes': instance.notes,
    'created_by': instance.createdBy,
    'created_at': instance.createdAt?.toIso8601String(),
    'last_touched': instance.lastTouched?.toIso8601String(),
  };
}

/// Construct a [WorkOrder]
class WorkOrderAdapter extends OfflineFirstWithSupabaseAdapter<WorkOrder> {
  WorkOrderAdapter();

  @override
  final supabaseTableName = 'work_orders';
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
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'variantId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'variant_id',
    ),
    'variantName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'variant_name',
    ),
    'plannedQuantity': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'planned_quantity',
    ),
    'actualQuantity': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'actual_quantity',
    ),
    'targetDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'target_date',
    ),
    'shiftId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'shift_id',
    ),
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'unitOfMeasure': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'unit_of_measure',
    ),
    'notes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notes',
    ),
    'createdBy': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_by',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: String,
    ),
    'variantId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variant_id',
      iterable: false,
      type: String,
    ),
    'variantName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'variant_name',
      iterable: false,
      type: String,
    ),
    'plannedQuantity': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'planned_quantity',
      iterable: false,
      type: double,
    ),
    'actualQuantity': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'actual_quantity',
      iterable: false,
      type: double,
    ),
    'targetDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'target_date',
      iterable: false,
      type: DateTime,
    ),
    'shiftId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'shift_id',
      iterable: false,
      type: String,
    ),
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'unitOfMeasure': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'unit_of_measure',
      iterable: false,
      type: String,
    ),
    'notes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notes',
      iterable: false,
      type: String,
    ),
    'createdBy': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_by',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
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
    WorkOrder instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `WorkOrder` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'WorkOrder';

  @override
  Future<WorkOrder> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WorkOrderFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    WorkOrder input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WorkOrderToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<WorkOrder> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WorkOrderFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    WorkOrder input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$WorkOrderToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
