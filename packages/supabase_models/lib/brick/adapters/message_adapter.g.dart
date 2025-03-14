// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Message> _$MessageFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Message(
    id: data['id'] as String?,
    text: data['text'] as String,
    phoneNumber: data['phone_number'] as String,
    delivered: data['delivered'] as bool,
    branchId: data['branch_id'] as int,
    role: data['role'] == null ? null : data['role'] as String?,
    timestamp:
        data['timestamp'] == null
            ? null
            : data['timestamp'] == null
            ? null
            : DateTime.tryParse(data['timestamp'] as String),
    conversationId:
        data['conversation_id'] == null
            ? null
            : data['conversation_id'] as String?,
    aiResponse:
        data['ai_response'] == null ? null : data['ai_response'] as String?,
    aiContext:
        data['ai_context'] == null ? null : data['ai_context'] as String?,
  );
}

Future<Map<String, dynamic>> _$MessageToSupabase(
  Message instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'text': instance.text,
    'phone_number': instance.phoneNumber,
    'delivered': instance.delivered,
    'branch_id': instance.branchId,
    'role': instance.role,
    'timestamp': instance.timestamp?.toIso8601String(),
    'conversation_id': instance.conversationId,
    'ai_response': instance.aiResponse,
    'ai_context': instance.aiContext,
  };
}

Future<Message> _$MessageFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Message(
    id: data['id'] as String,
    text: data['text'] as String,
    phoneNumber: data['phone_number'] as String,
    delivered: data['delivered'] == 1,
    branchId: data['branch_id'] as int,
    role: data['role'] == null ? null : data['role'] as String?,
    timestamp:
        data['timestamp'] == null
            ? null
            : data['timestamp'] == null
            ? null
            : DateTime.tryParse(data['timestamp'] as String),
    conversationId:
        data['conversation_id'] == null
            ? null
            : data['conversation_id'] as String?,
    aiResponse:
        data['ai_response'] == null ? null : data['ai_response'] as String?,
    aiContext:
        data['ai_context'] == null ? null : data['ai_context'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$MessageToSqlite(
  Message instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'text': instance.text,
    'phone_number': instance.phoneNumber,
    'delivered': instance.delivered ? 1 : 0,
    'branch_id': instance.branchId,
    'role': instance.role,
    'timestamp': instance.timestamp?.toIso8601String(),
    'conversation_id': instance.conversationId,
    'ai_response': instance.aiResponse,
    'ai_context': instance.aiContext,
  };
}

/// Construct a [Message]
class MessageAdapter extends OfflineFirstWithSupabaseAdapter<Message> {
  MessageAdapter();

  @override
  final supabaseTableName = 'messages';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'text': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'text',
    ),
    'phoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number',
    ),
    'delivered': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'delivered',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'role': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'role',
    ),
    'timestamp': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'timestamp',
    ),
    'conversationId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'conversation_id',
    ),
    'aiResponse': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ai_response',
    ),
    'aiContext': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'ai_context',
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
    'text': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'text',
      iterable: false,
      type: String,
    ),
    'phoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number',
      iterable: false,
      type: String,
    ),
    'delivered': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'delivered',
      iterable: false,
      type: bool,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'role': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'role',
      iterable: false,
      type: String,
    ),
    'timestamp': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'timestamp',
      iterable: false,
      type: DateTime,
    ),
    'conversationId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'conversation_id',
      iterable: false,
      type: String,
    ),
    'aiResponse': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ai_response',
      iterable: false,
      type: String,
    ),
    'aiContext': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'ai_context',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Message instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Message` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Message';

  @override
  Future<Message> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Message input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Message> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Message input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$MessageToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
