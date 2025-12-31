// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<StockRecount> _$StockRecountFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StockRecount(
    id: data['id'] as String?,
    branchId: data['branch_id'] as String,
    status: data['status'] as String? ?? 'draft',
    userId: data['user_id'] == null ? null : data['user_id'] as String?,
    deviceId: data['device_id'] == null ? null : data['device_id'] as String?,
    deviceName: data['device_name'] == null
        ? null
        : data['device_name'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    submittedAt: data['submitted_at'] == null
        ? null
        : data['submitted_at'] == null
        ? null
        : DateTime.tryParse(data['submitted_at'] as String),
    syncedAt: data['synced_at'] == null
        ? null
        : data['synced_at'] == null
        ? null
        : DateTime.tryParse(data['synced_at'] as String),
    notes: data['notes'] == null ? null : data['notes'] as String?,
    totalItemsCounted: data['total_items_counted'] as int? ?? 0,
  );
}

Future<Map<String, dynamic>> _$StockRecountToSupabase(
  StockRecount instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'status': instance.status,
    'user_id': instance.userId,
    'device_id': instance.deviceId,
    'device_name': instance.deviceName,
    'created_at': instance.createdAt.toIso8601String(),
    'submitted_at': instance.submittedAt?.toIso8601String(),
    'synced_at': instance.syncedAt?.toIso8601String(),
    'notes': instance.notes,
    'total_items_counted': instance.totalItemsCounted,
  };
}

Future<StockRecount> _$StockRecountFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return StockRecount(
    id: data['id'] as String,
    branchId: data['branch_id'] as String,
    status: data['status'] as String ?? 'draft',
    userId: data['user_id'] == null ? null : data['user_id'] as String?,
    deviceId: data['device_id'] == null ? null : data['device_id'] as String?,
    deviceName: data['device_name'] == null
        ? null
        : data['device_name'] as String?,
    createdAt: DateTime.parse(data['created_at'] as String),
    submittedAt: data['submitted_at'] == null
        ? null
        : data['submitted_at'] == null
        ? null
        : DateTime.tryParse(data['submitted_at'] as String),
    syncedAt: data['synced_at'] == null
        ? null
        : data['synced_at'] == null
        ? null
        : DateTime.tryParse(data['synced_at'] as String),
    notes: data['notes'] == null ? null : data['notes'] as String?,
    totalItemsCounted: data['total_items_counted'] as int ?? 0,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$StockRecountToSqlite(
  StockRecount instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'status': instance.status,
    'user_id': instance.userId,
    'device_id': instance.deviceId,
    'device_name': instance.deviceName,
    'created_at': instance.createdAt.toIso8601String(),
    'submitted_at': instance.submittedAt?.toIso8601String(),
    'synced_at': instance.syncedAt?.toIso8601String(),
    'notes': instance.notes,
    'total_items_counted': instance.totalItemsCounted,
  };
}

/// Construct a [StockRecount]
class StockRecountAdapter
    extends OfflineFirstWithSupabaseAdapter<StockRecount> {
  StockRecountAdapter();

  @override
  final supabaseTableName = 'stock_recounts';
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
    'status': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'status',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'deviceId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'device_id',
    ),
    'deviceName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'device_name',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'submittedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'submitted_at',
    ),
    'syncedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'synced_at',
    ),
    'notes': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'notes',
    ),
    'totalItemsCounted': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'total_items_counted',
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
    'status': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'status',
      iterable: false,
      type: String,
    ),
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: String,
    ),
    'deviceId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'device_id',
      iterable: false,
      type: String,
    ),
    'deviceName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'device_name',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'submittedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'submitted_at',
      iterable: false,
      type: DateTime,
    ),
    'syncedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'synced_at',
      iterable: false,
      type: DateTime,
    ),
    'notes': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'notes',
      iterable: false,
      type: String,
    ),
    'totalItemsCounted': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'total_items_counted',
      iterable: false,
      type: int,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    StockRecount instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `StockRecount` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'StockRecount';

  @override
  Future<StockRecount> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    StockRecount input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<StockRecount> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    StockRecount input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$StockRecountToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
