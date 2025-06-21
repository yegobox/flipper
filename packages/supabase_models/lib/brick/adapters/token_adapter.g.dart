// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Token> _$TokenFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Token(
    id: data['id'] as String?,
    name: data['name'] == null ? null : data['name'] as String?,
    type: data['type'] == null ? null : data['type'] as String?,
    token: data['token'] == null ? null : data['token'] as String?,
    validFrom: data['valid_from'] == null
        ? null
        : data['valid_from'] == null
            ? null
            : DateTime.tryParse(data['valid_from'] as String),
    validUntil: data['valid_until'] == null
        ? null
        : data['valid_until'] == null
            ? null
            : DateTime.tryParse(data['valid_until'] as String),
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
  );
}

Future<Map<String, dynamic>> _$TokenToSupabase(
  Token instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'type': instance.type,
    'token': instance.token,
    'valid_from': instance.validFrom?.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'business_id': instance.businessId,
    'last_touched': instance.lastTouched?.toIso8601String(),
  };
}

Future<Token> _$TokenFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Token(
    id: data['id'] as String,
    name: data['name'] == null ? null : data['name'] as String?,
    type: data['type'] == null ? null : data['type'] as String?,
    token: data['token'] == null ? null : data['token'] as String?,
    validFrom: data['valid_from'] == null
        ? null
        : data['valid_from'] == null
            ? null
            : DateTime.tryParse(data['valid_from'] as String),
    validUntil: data['valid_until'] == null
        ? null
        : data['valid_until'] == null
            ? null
            : DateTime.tryParse(data['valid_until'] as String),
    businessId:
        data['business_id'] == null ? null : data['business_id'] as int?,
    lastTouched: data['last_touched'] == null
        ? null
        : data['last_touched'] == null
            ? null
            : DateTime.tryParse(data['last_touched'] as String),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$TokenToSqlite(
  Token instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'type': instance.type,
    'token': instance.token,
    'valid_from': instance.validFrom?.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'business_id': instance.businessId,
    'last_touched': instance.lastTouched?.toIso8601String(),
  };
}

/// Construct a [Token]
class TokenAdapter extends OfflineFirstWithSupabaseAdapter<Token> {
  TokenAdapter();

  @override
  final supabaseTableName = 'tokens';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'token': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'token',
    ),
    'validFrom': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_from',
    ),
    'validUntil': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_until',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
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
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'token': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'token',
      iterable: false,
      type: String,
    ),
    'validFrom': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'valid_from',
      iterable: false,
      type: DateTime,
    ),
    'validUntil': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'valid_until',
      iterable: false,
      type: DateTime,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
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
    Token instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Token` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Token';

  @override
  Future<Token> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TokenFromSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Token input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TokenToSupabase(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Token> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TokenFromSqlite(
        input,
        provider: provider,
        repository: repository,
      );
  @override
  Future<Map<String, dynamic>> toSqlite(
    Token input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$TokenToSqlite(input, provider: provider, repository: repository);
}
