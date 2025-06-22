// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Conversation> _$ConversationFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Conversation(
    id: data['id'] as String?,
    userName: data['user_name'] == null ? null : data['user_name'] as String?,
    body: data['body'] == null ? null : data['body'] as String?,
    avatar: data['avatar'] == null ? null : data['avatar'] as String?,
    channelType:
        data['channel_type'] == null ? null : data['channel_type'] as String?,
    fromNumber:
        data['from_number'] == null ? null : data['from_number'] as String?,
    toNumber: data['to_number'] == null ? null : data['to_number'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    messageType:
        data['message_type'] == null ? null : data['message_type'] as String?,
    phoneNumberId: data['phone_number_id'] == null
        ? null
        : data['phone_number_id'] as String?,
    messageId:
        data['message_id'] == null ? null : data['message_id'] as String?,
    respondedBy:
        data['responded_by'] == null ? null : data['responded_by'] as String?,
    conversationId: data['conversation_id'] == null
        ? null
        : data['conversation_id'] as String?,
    businessPhoneNumber: data['business_phone_number'] == null
        ? null
        : data['business_phone_number'] as String?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    scheduledAt: data['scheduled_at'] == null
        ? null
        : data['scheduled_at'] == null
            ? null
            : DateTime.tryParse(data['scheduled_at'] as String),
    delivered: data['delivered'] == null ? null : data['delivered'] as bool?,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    deletedAt: data['deleted_at'] == null
        ? null
        : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
  );
}

Future<Map<String, dynamic>> _$ConversationToSupabase(
  Conversation instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_name': instance.userName,
    'body': instance.body,
    'avatar': instance.avatar,
    'channel_type': instance.channelType,
    'from_number': instance.fromNumber,
    'to_number': instance.toNumber,
    'created_at': instance.createdAt?.toIso8601String(),
    'message_type': instance.messageType,
    'phone_number_id': instance.phoneNumberId,
    'message_id': instance.messageId,
    'responded_by': instance.respondedBy,
    'conversation_id': instance.conversationId,
    'business_phone_number': instance.businessPhoneNumber,
    'business_id': instance.businessId,
    'scheduled_at': instance.scheduledAt?.toIso8601String(),
    'delivered': instance.delivered,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
  };
}

Future<Conversation> _$ConversationFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Conversation(
    id: data['id'] as String,
    userName: data['user_name'] == null ? null : data['user_name'] as String?,
    body: data['body'] == null ? null : data['body'] as String?,
    avatar: data['avatar'] == null ? null : data['avatar'] as String?,
    channelType:
        data['channel_type'] == null ? null : data['channel_type'] as String?,
    fromNumber:
        data['from_number'] == null ? null : data['from_number'] as String?,
    toNumber: data['to_number'] == null ? null : data['to_number'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    messageType:
        data['message_type'] == null ? null : data['message_type'] as String?,
    phoneNumberId: data['phone_number_id'] == null
        ? null
        : data['phone_number_id'] as String?,
    messageId:
        data['message_id'] == null ? null : data['message_id'] as String?,
    respondedBy:
        data['responded_by'] == null ? null : data['responded_by'] as String?,
    conversationId: data['conversation_id'] == null
        ? null
        : data['conversation_id'] as String?,
    businessPhoneNumber: data['business_phone_number'] == null
        ? null
        : data['business_phone_number'] as String?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    scheduledAt: data['scheduled_at'] == null
        ? null
        : data['scheduled_at'] == null
            ? null
            : DateTime.tryParse(data['scheduled_at'] as String),
    delivered: data['delivered'] == null ? null : data['delivered'] == 1,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
    deletedAt: data['deleted_at'] == null
        ? null
        : data['deleted_at'] == null
            ? null
            : DateTime.tryParse(data['deleted_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ConversationToSqlite(
  Conversation instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'user_name': instance.userName,
    'body': instance.body,
    'avatar': instance.avatar,
    'channel_type': instance.channelType,
    'from_number': instance.fromNumber,
    'to_number': instance.toNumber,
    'created_at': instance.createdAt?.toIso8601String(),
    'message_type': instance.messageType,
    'phone_number_id': instance.phoneNumberId,
    'message_id': instance.messageId,
    'responded_by': instance.respondedBy,
    'conversation_id': instance.conversationId,
    'business_phone_number': instance.businessPhoneNumber,
    'business_id': instance.businessId,
    'scheduled_at': instance.scheduledAt?.toIso8601String(),
    'delivered':
        instance.delivered == null ? null : (instance.delivered! ? 1 : 0),
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
  };
}

/// Construct a [Conversation]
class ConversationAdapter
    extends OfflineFirstWithSupabaseAdapter<Conversation> {
  ConversationAdapter();

  @override
  final supabaseTableName = 'conversations';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'userName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_name',
    ),
    'body': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'body',
    ),
    'avatar': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'avatar',
    ),
    'channelType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'channel_type',
    ),
    'fromNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'from_number',
    ),
    'toNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'to_number',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'messageType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'message_type',
    ),
    'phoneNumberId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number_id',
    ),
    'messageId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'message_id',
    ),
    'respondedBy': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'responded_by',
    ),
    'conversationId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'conversation_id',
    ),
    'businessPhoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_phone_number',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'scheduledAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'scheduled_at',
    ),
    'delivered': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'delivered',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
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
    'userName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_name',
      iterable: false,
      type: String,
    ),
    'body': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'body',
      iterable: false,
      type: String,
    ),
    'avatar': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'avatar',
      iterable: false,
      type: String,
    ),
    'channelType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'channel_type',
      iterable: false,
      type: String,
    ),
    'fromNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'from_number',
      iterable: false,
      type: String,
    ),
    'toNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'to_number',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'messageType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'message_type',
      iterable: false,
      type: String,
    ),
    'phoneNumberId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number_id',
      iterable: false,
      type: String,
    ),
    'messageId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'message_id',
      iterable: false,
      type: String,
    ),
    'respondedBy': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'responded_by',
      iterable: false,
      type: String,
    ),
    'conversationId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'conversation_id',
      iterable: false,
      type: String,
    ),
    'businessPhoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_phone_number',
      iterable: false,
      type: String,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'scheduledAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'scheduled_at',
      iterable: false,
      type: DateTime,
    ),
    'delivered': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'delivered',
      iterable: false,
      type: bool,
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
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Conversation instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Conversation` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Conversation';

  @override
  Future<Conversation> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$ConversationFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Conversation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$ConversationToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Conversation> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$ConversationFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Conversation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$ConversationToSqlite(
        input,
        provider: provider,
        repository: repository,
      );
}
