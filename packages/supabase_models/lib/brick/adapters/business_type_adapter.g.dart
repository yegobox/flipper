// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<BusinessType> _$BusinessTypeFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BusinessType(
    id: data['id'] as String?,
    name: data['name'] as String,
    description: data['description'] == null
        ? null
        : data['description'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    features: data['features'] == null
        ? null
        : data['features']?.toList().cast<String>(),
  );
}

Future<Map<String, dynamic>> _$BusinessTypeToSupabase(
  BusinessType instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'created_at': instance.createdAt?.toIso8601String(),
    'features': instance.features,
  };
}

Future<BusinessType> _$BusinessTypeFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return BusinessType(
    id: data['id'] as String,
    name: data['name'] as String,
    description: data['description'] == null
        ? null
        : data['description'] as String?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    features: data['features'] == null
        ? null
        : jsonDecode(data['features']).toList().cast<String>(),
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BusinessTypeToSqlite(
  BusinessType instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'created_at': instance.createdAt?.toIso8601String(),
    'features': instance.features == null
        ? null
        : jsonEncode(instance.features),
  };
}

/// Construct a [BusinessType]
class BusinessTypeAdapter
    extends OfflineFirstWithSupabaseAdapter<BusinessType> {
  BusinessTypeAdapter();

  @override
  final supabaseTableName = 'business_types';
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
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'features': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'features',
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
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'features': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'features',
      iterable: true,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    BusinessType instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `BusinessType` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'BusinessType';

  @override
  Future<BusinessType> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BusinessTypeFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    BusinessType input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BusinessTypeToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<BusinessType> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BusinessTypeFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    BusinessType input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$BusinessTypeToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
