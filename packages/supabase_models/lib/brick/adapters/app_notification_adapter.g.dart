// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<AppNotification> _$AppNotificationFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AppNotification(
    id: data['id'] as String?,
    type: data['type'] == null ? null : data['type'] as String?,
    message: data['message'] == null ? null : data['message'] as String?,
    identifier: data['identifier'] == null ? null : data['identifier'] as int?,
    completed: data['completed'] == null ? null : data['completed'] as bool?,
  );
}

Future<Map<String, dynamic>> _$AppNotificationToSupabase(
  AppNotification instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'type': instance.type,
    'message': instance.message,
    'identifier': instance.identifier,
    'completed': instance.completed,
  };
}

Future<AppNotification> _$AppNotificationFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AppNotification(
    id: data['id'] as String,
    type: data['type'] == null ? null : data['type'] as String?,
    message: data['message'] == null ? null : data['message'] as String?,
    identifier: data['identifier'] == null ? null : data['identifier'] as int?,
    completed: data['completed'] == null ? null : data['completed'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$AppNotificationToSqlite(
  AppNotification instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'type': instance.type,
    'message': instance.message,
    'identifier': instance.identifier,
    'completed':
        instance.completed == null ? null : (instance.completed! ? 1 : 0),
  };
}

/// Construct a [AppNotification]
class AppNotificationAdapter
    extends OfflineFirstWithSupabaseAdapter<AppNotification> {
  AppNotificationAdapter();

  @override
  final supabaseTableName = 'branches';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'message': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'message',
    ),
    'identifier': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'identifier',
    ),
    'completed': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'completed',
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
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'message': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'message',
      iterable: false,
      type: String,
    ),
    'identifier': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'identifier',
      iterable: false,
      type: int,
    ),
    'completed': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'completed',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    AppNotification instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `AppNotification` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'AppNotification';

  @override
  Future<AppNotification> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AppNotificationFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    AppNotification input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AppNotificationToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<AppNotification> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AppNotificationFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    AppNotification input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AppNotificationToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
