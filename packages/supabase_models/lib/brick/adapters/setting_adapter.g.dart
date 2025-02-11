// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Setting> _$SettingFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Setting(
      id: data['id'] as String?,
      email: data['email'] == null ? null : data['email'] as String?,
      userId: data['user_id'] == null ? null : data['user_id'] as int?,
      openReceiptFileOSaleComplete:
          data['open_receipt_file_o_sale_complete'] == null
              ? null
              : data['open_receipt_file_o_sale_complete'] as bool?,
      autoPrint:
          data['auto_print'] == null ? null : data['auto_print'] as bool?,
      sendDailyReport: data['send_daily_report'] == null
          ? null
          : data['send_daily_report'] as bool?,
      defaultLanguage: data['default_language'] == null
          ? null
          : data['default_language'] as String?,
      attendnaceDocCreated: data['attendnace_doc_created'] == null
          ? null
          : data['attendnace_doc_created'] as bool?,
      isAttendanceEnabled: data['is_attendance_enabled'] == null
          ? null
          : data['is_attendance_enabled'] as bool?,
      type: data['type'] == null ? null : data['type'] as String?,
      enrolledInBot: data['enrolled_in_bot'] == null
          ? null
          : data['enrolled_in_bot'] as bool?,
      deviceToken:
          data['device_token'] == null ? null : data['device_token'] as String?,
      businessPhoneNumber: data['business_phone_number'] == null
          ? null
          : data['business_phone_number'] as String?,
      autoRespond:
          data['auto_respond'] == null ? null : data['auto_respond'] as bool?,
      token: data['token'] == null ? null : data['token'] as String?,
      hasPin: data['has_pin'] == null ? null : data['has_pin'] as bool?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      createdAt:
          data['created_at'] == null ? null : data['created_at'] as String?,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String));
}

Future<Map<String, dynamic>> _$SettingToSupabase(Setting instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'email': instance.email,
    'user_id': instance.userId,
    'open_receipt_file_o_sale_complete': instance.openReceiptFileOSaleComplete,
    'auto_print': instance.autoPrint,
    'send_daily_report': instance.sendDailyReport,
    'default_language': instance.defaultLanguage,
    'attendnace_doc_created': instance.attendnaceDocCreated,
    'is_attendance_enabled': instance.isAttendanceEnabled,
    'type': instance.type,
    'enrolled_in_bot': instance.enrolledInBot,
    'device_token': instance.deviceToken,
    'business_phone_number': instance.businessPhoneNumber,
    'auto_respond': instance.autoRespond,
    'token': instance.token,
    'has_pin': instance.hasPin,
    'business_id': instance.businessId,
    'created_at': instance.createdAt,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String()
  };
}

Future<Setting> _$SettingFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Setting(
      id: data['id'] as String,
      email: data['email'] == null ? null : data['email'] as String?,
      userId: data['user_id'] == null ? null : data['user_id'] as int?,
      openReceiptFileOSaleComplete:
          data['open_receipt_file_o_sale_complete'] == null
              ? null
              : data['open_receipt_file_o_sale_complete'] == 1,
      autoPrint: data['auto_print'] == null ? null : data['auto_print'] == 1,
      sendDailyReport: data['send_daily_report'] == null
          ? null
          : data['send_daily_report'] == 1,
      defaultLanguage: data['default_language'] == null
          ? null
          : data['default_language'] as String?,
      attendnaceDocCreated: data['attendnace_doc_created'] == null
          ? null
          : data['attendnace_doc_created'] == 1,
      isAttendanceEnabled: data['is_attendance_enabled'] == null
          ? null
          : data['is_attendance_enabled'] == 1,
      type: data['type'] == null ? null : data['type'] as String?,
      enrolledInBot:
          data['enrolled_in_bot'] == null ? null : data['enrolled_in_bot'] == 1,
      deviceToken:
          data['device_token'] == null ? null : data['device_token'] as String?,
      businessPhoneNumber: data['business_phone_number'] == null
          ? null
          : data['business_phone_number'] as String?,
      autoRespond:
          data['auto_respond'] == null ? null : data['auto_respond'] == 1,
      token: data['token'] == null ? null : data['token'] as String?,
      hasPin: data['has_pin'] == null ? null : data['has_pin'] == 1,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      createdAt:
          data['created_at'] == null ? null : data['created_at'] as String?,
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

Future<Map<String, dynamic>> _$SettingToSqlite(Setting instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'email': instance.email,
    'user_id': instance.userId,
    'open_receipt_file_o_sale_complete':
        instance.openReceiptFileOSaleComplete == null
            ? null
            : (instance.openReceiptFileOSaleComplete! ? 1 : 0),
    'auto_print':
        instance.autoPrint == null ? null : (instance.autoPrint! ? 1 : 0),
    'send_daily_report': instance.sendDailyReport == null
        ? null
        : (instance.sendDailyReport! ? 1 : 0),
    'default_language': instance.defaultLanguage,
    'attendnace_doc_created': instance.attendnaceDocCreated == null
        ? null
        : (instance.attendnaceDocCreated! ? 1 : 0),
    'is_attendance_enabled': instance.isAttendanceEnabled == null
        ? null
        : (instance.isAttendanceEnabled! ? 1 : 0),
    'type': instance.type,
    'enrolled_in_bot': instance.enrolledInBot == null
        ? null
        : (instance.enrolledInBot! ? 1 : 0),
    'device_token': instance.deviceToken,
    'business_phone_number': instance.businessPhoneNumber,
    'auto_respond':
        instance.autoRespond == null ? null : (instance.autoRespond! ? 1 : 0),
    'token': instance.token,
    'has_pin': instance.hasPin == null ? null : (instance.hasPin! ? 1 : 0),
    'business_id': instance.businessId,
    'created_at': instance.createdAt,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String()
  };
}

/// Construct a [Setting]
class SettingAdapter extends OfflineFirstWithSupabaseAdapter<Setting> {
  SettingAdapter();

  @override
  final supabaseTableName = 'settings';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'email': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'email',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'openReceiptFileOSaleComplete': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'open_receipt_file_o_sale_complete',
    ),
    'autoPrint': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'auto_print',
    ),
    'sendDailyReport': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'send_daily_report',
    ),
    'defaultLanguage': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'default_language',
    ),
    'attendnaceDocCreated': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'attendnace_doc_created',
    ),
    'isAttendanceEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_attendance_enabled',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'enrolledInBot': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'enrolled_in_bot',
    ),
    'deviceToken': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'device_token',
    ),
    'businessPhoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_phone_number',
    ),
    'autoRespond': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'auto_respond',
    ),
    'token': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'token',
    ),
    'hasPin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'has_pin',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
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
    'email': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'email',
      iterable: false,
      type: String,
    ),
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: int,
    ),
    'openReceiptFileOSaleComplete': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'open_receipt_file_o_sale_complete',
      iterable: false,
      type: bool,
    ),
    'autoPrint': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'auto_print',
      iterable: false,
      type: bool,
    ),
    'sendDailyReport': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'send_daily_report',
      iterable: false,
      type: bool,
    ),
    'defaultLanguage': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'default_language',
      iterable: false,
      type: String,
    ),
    'attendnaceDocCreated': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'attendnace_doc_created',
      iterable: false,
      type: bool,
    ),
    'isAttendanceEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_attendance_enabled',
      iterable: false,
      type: bool,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'enrolledInBot': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'enrolled_in_bot',
      iterable: false,
      type: bool,
    ),
    'deviceToken': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'device_token',
      iterable: false,
      type: String,
    ),
    'businessPhoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_phone_number',
      iterable: false,
      type: String,
    ),
    'autoRespond': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'auto_respond',
      iterable: false,
      type: bool,
    ),
    'token': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'token',
      iterable: false,
      type: String,
    ),
    'hasPin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'has_pin',
      iterable: false,
      type: bool,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
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
      Setting instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Setting` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Setting';

  @override
  Future<Setting> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SettingFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Setting input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SettingToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Setting> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SettingFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Setting input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$SettingToSqlite(input,
          provider: provider, repository: repository);
}
