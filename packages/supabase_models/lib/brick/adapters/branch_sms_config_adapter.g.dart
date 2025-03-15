// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<BranchSmsConfig> _$BranchSmsConfigFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BranchSmsConfig(
    id: data['id'] as String,
    branchId: data['branch_id'] as int,
    smsPhoneNumber:
        data['sms_phone_number'] == null
            ? null
            : data['sms_phone_number'] as String?,
    enableOrderNotification: data['enable_order_notification'] as bool,
  );
}

Future<Map<String, dynamic>> _$BranchSmsConfigToSupabase(
  BranchSmsConfig instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'sms_phone_number': instance.smsPhoneNumber,
    'enable_order_notification': instance.enableOrderNotification,
  };
}

Future<BranchSmsConfig> _$BranchSmsConfigFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BranchSmsConfig(
    id: data['id'] as String,
    branchId: data['branch_id'] as int,
    smsPhoneNumber:
        data['sms_phone_number'] == null
            ? null
            : data['sms_phone_number'] as String?,
    enableOrderNotification: data['enable_order_notification'] == 1,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BranchSmsConfigToSqlite(
  BranchSmsConfig instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'branch_id': instance.branchId,
    'sms_phone_number': instance.smsPhoneNumber,
    'enable_order_notification': instance.enableOrderNotification ? 1 : 0,
  };
}

/// Construct a [BranchSmsConfig]
class BranchSmsConfigAdapter
    extends OfflineFirstWithSupabaseAdapter<BranchSmsConfig> {
  BranchSmsConfigAdapter();

  @override
  final supabaseTableName = 'branch_sms_configs';
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
    'smsPhoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'sms_phone_number',
    ),
    'enableOrderNotification': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'enable_order_notification',
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
      type: int,
    ),
    'smsPhoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'sms_phone_number',
      iterable: false,
      type: String,
    ),
    'enableOrderNotification': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'enable_order_notification',
      iterable: false,
      type: bool,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    BranchSmsConfig instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `BranchSmsConfig` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'BranchSmsConfig';

  @override
  Future<BranchSmsConfig> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BranchSmsConfigFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    BranchSmsConfig input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BranchSmsConfigToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<BranchSmsConfig> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BranchSmsConfigFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    BranchSmsConfig input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BranchSmsConfigToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
