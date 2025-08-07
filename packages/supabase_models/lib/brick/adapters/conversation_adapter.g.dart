// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Conversation> _$ConversationFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Conversation(
    id: data['id'] as String?,
    title: data['title'] as String,
    branchId: data['branch_id'] as int,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    lastMessageAt:
        data['last_message_at'] == null
            ? null
            : DateTime.tryParse(data['last_message_at'] as String),
  );
}

Future<Map<String, dynamic>> _$ConversationToSupabase(
  Conversation instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'title': instance.title,
    'branch_id': instance.branchId,
    'created_at': instance.createdAt?.toIso8601String(),
    'last_message_at': instance.lastMessageAt.toIso8601String(),
  };
}

Future<Conversation> _$ConversationFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Conversation(
    id: data['id'] as String,
    title: data['title'] as String,
    branchId: data['branch_id'] as int,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    messages:
        (await provider
            .rawQuery(
              'SELECT DISTINCT `f_Message_brick_id` FROM `_brick_Conversation_messages` WHERE l_Conversation_brick_id = ?',
              [data['_brick_id'] as int],
            )
            .then((results) {
              final ids = results.map((r) => r['f_Message_brick_id']);
              return Future.wait<Message>(
                ids.map(
                  (primaryKey) => repository!
                      .getAssociation<Message>(
                        Query.where('primaryKey', primaryKey, limit1: true),
                      )
                      .then((r) => r!.first),
                ),
              );
            })).toList().cast<Message>(),
    lastMessageAt: DateTime.parse(data['last_message_at'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ConversationToSqlite(
  Conversation instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'title': instance.title,
    'branch_id': instance.branchId,
    'created_at': instance.createdAt?.toIso8601String(),
    'last_message_at': instance.lastMessageAt.toIso8601String(),
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
    'messages': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'messages',
      iterable: true,
      type: Message,
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
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final messagesOldColumns = await provider.rawQuery(
        'SELECT `f_Message_brick_id` FROM `_brick_Conversation_messages` WHERE `l_Conversation_brick_id` = ?',
        [instance.primaryKey],
      );
      final messagesOldIds = messagesOldColumns.map(
        (a) => a['f_Message_brick_id'],
      );
      final messagesNewIds =
          instance.messages?.map((s) => s.primaryKey).whereType<int>() ?? [];
      final messagesIdsToDelete = messagesOldIds.where(
        (id) => !messagesNewIds.contains(id),
      );

      await Future.wait<void>(
        messagesIdsToDelete.map((id) async {
          return await provider
              .rawExecute(
                'DELETE FROM `_brick_Conversation_messages` WHERE `l_Conversation_brick_id` = ? AND `f_Message_brick_id` = ?',
                [instance.primaryKey, id],
              )
              .catchError((e) => null);
        }),
      );

      await Future.wait<int?>(
        instance.messages?.map((s) async {
              final id =
                  s.primaryKey ??
                  await provider.upsert<Message>(s, repository: repository);
              return await provider.rawInsert(
                'INSERT OR IGNORE INTO `_brick_Conversation_messages` (`l_Conversation_brick_id`, `f_Message_brick_id`) VALUES (?, ?)',
                [instance.primaryKey, id],
              );
            }) ??
            [],
      );
    }
  }

  @override
  Future<Conversation> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Conversation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Conversation> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Conversation input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$ConversationToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
