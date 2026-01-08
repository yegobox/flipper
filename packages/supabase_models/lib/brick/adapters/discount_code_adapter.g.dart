// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<DiscountCode> _$DiscountCodeFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return DiscountCode(
    id: data['id'] as String?,
    code: data['code'] as String,
    discountType: data['discount_type'] as String,
    discountValue: data['discount_value'] as double,
    maxUses: data['max_uses'] == null ? null : data['max_uses'] as int?,
    currentUses: data['current_uses'] as int,
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
    applicablePlans: data['applicable_plans'] == null
        ? null
        : data['applicable_plans']?.toList().cast<String>(),
    minimumAmount: data['minimum_amount'] == null
        ? null
        : data['minimum_amount'] as double?,
    isActive: data['is_active'] as bool,
    createdAt: data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    description: data['description'] == null
        ? null
        : data['description'] as String?,
  );
}

Future<Map<String, dynamic>> _$DiscountCodeToSupabase(
  DiscountCode instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'code': instance.code,
    'discount_type': instance.discountType,
    'discount_value': instance.discountValue,
    'max_uses': instance.maxUses,
    'current_uses': instance.currentUses,
    'valid_from': instance.validFrom?.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'applicable_plans': instance.applicablePlans,
    'minimum_amount': instance.minimumAmount,
    'is_active': instance.isActive,
    'created_at': instance.createdAt.toIso8601String(),
    'description': instance.description,
  };
}

Future<DiscountCode> _$DiscountCodeFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return DiscountCode(
    id: data['id'] as String,
    code: data['code'] as String,
    discountType: data['discount_type'] as String,
    discountValue: data['discount_value'] as double,
    maxUses: data['max_uses'] == null ? null : data['max_uses'] as int?,
    currentUses: data['current_uses'] as int,
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
    applicablePlans: data['applicable_plans'] == null
        ? null
        : jsonDecode(data['applicable_plans']).toList().cast<String>(),
    minimumAmount: data['minimum_amount'] == null
        ? null
        : data['minimum_amount'] as double?,
    isActive: data['is_active'] == 1,
    createdAt: DateTime.parse(data['created_at'] as String),
    description: data['description'] == null
        ? null
        : data['description'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$DiscountCodeToSqlite(
  DiscountCode instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'code': instance.code,
    'discount_type': instance.discountType,
    'discount_value': instance.discountValue,
    'max_uses': instance.maxUses,
    'current_uses': instance.currentUses,
    'valid_from': instance.validFrom?.toIso8601String(),
    'valid_until': instance.validUntil?.toIso8601String(),
    'applicable_plans': instance.applicablePlans == null
        ? null
        : jsonEncode(instance.applicablePlans),
    'minimum_amount': instance.minimumAmount,
    'is_active': instance.isActive ? 1 : 0,
    'created_at': instance.createdAt.toIso8601String(),
    'description': instance.description,
  };
}

/// Construct a [DiscountCode]
class DiscountCodeAdapter
    extends OfflineFirstWithSupabaseAdapter<DiscountCode> {
  DiscountCodeAdapter();

  @override
  final supabaseTableName = 'discount_codes';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'code': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'code',
    ),
    'discountType': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount_type',
    ),
    'discountValue': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount_value',
    ),
    'maxUses': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'max_uses',
    ),
    'currentUses': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'current_uses',
    ),
    'validFrom': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_from',
    ),
    'validUntil': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'valid_until',
    ),
    'applicablePlans': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'applicable_plans',
    ),
    'minimumAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'minimum_amount',
    ),
    'isActive': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_active',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
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
    'code': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'code',
      iterable: false,
      type: String,
    ),
    'discountType': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount_type',
      iterable: false,
      type: String,
    ),
    'discountValue': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount_value',
      iterable: false,
      type: double,
    ),
    'maxUses': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'max_uses',
      iterable: false,
      type: int,
    ),
    'currentUses': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'current_uses',
      iterable: false,
      type: int,
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
    'applicablePlans': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'applicable_plans',
      iterable: true,
      type: String,
    ),
    'minimumAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'minimum_amount',
      iterable: false,
      type: double,
    ),
    'isActive': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_active',
      iterable: false,
      type: bool,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    DiscountCode instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `DiscountCode` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'DiscountCode';

  @override
  Future<DiscountCode> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$DiscountCodeFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    DiscountCode input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$DiscountCodeToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<DiscountCode> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$DiscountCodeFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    DiscountCode input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$DiscountCodeToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
