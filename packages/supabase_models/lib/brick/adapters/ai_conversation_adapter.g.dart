// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<AiConversation> _$AiConversationFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AiConversation(
    id: data['id'] as String?,
    title: data['title'] as String,
    branchId: data['branch_id'] as int,
    createdAt:
        data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    lastMessageAt:
        data['last_message_at'] == null
            ? null
            : DateTime.tryParse(data['last_message_at'] as String),
  );
}

Future<Map<String, dynamic>> _$AiConversationToSupabase(
  AiConversation instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'title': instance.title,
    'branch_id': instance.branchId,
    'created_at': instance.createdAt.toIso8601String(),
    'last_message_at': instance.lastMessageAt.toIso8601String(),
  };
}

Future<AiConversation> _$AiConversationFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return AiConversation(
    id: data['id'] as String,
    title: data['title'] as String,
    branchId: data['branch_id'] as int,
    createdAt: DateTime.parse(data['created_at'] as String),
    lastMessageAt: DateTime.parse(data['last_message_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$AiConversationToSqlite(
  AiConversation instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'title': instance.title,
    'branch_id': instance.branchId,
    'created_at': instance.createdAt.toIso8601String(),
    'last_message_at': instance.lastMessageAt.toIso8601String(),
  };
}

/// Construct a [AiConversation]
class AiConversationAdapter
    extends OfflineFirstWithSupabaseAdapter<AiConversation> {
  AiConversationAdapter();

  @override
  final supabaseTableName = 'ai_conversations';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'title': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'title',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'lastMessageAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_message_at',
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
    'title': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'title',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'lastMessageAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_message_at',
      iterable: false,
      type: DateTime,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    AiConversation instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `AiConversation` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'AiConversation';

  @override
  Future<AiConversation> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AiConversationFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    AiConversation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AiConversationToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<AiConversation> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AiConversationFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    AiConversation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$AiConversationToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
