// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<PlanDiscount> _$PlanDiscountFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return PlanDiscount(
    id: data['id'] as String?,
    planId: data['plan_id'] as String,
    discountCodeId: data['discount_code_id'] as String,
    originalPrice: data['original_price'] as double,
    discountAmount: data['discount_amount'] as double,
    finalPrice: data['final_price'] as double,
    appliedAt: data['applied_at'] == null
        ? null
        : DateTime.tryParse(data['applied_at'] as String),
    businessId: data['business_id'] as String,
  );
}

Future<Map<String, dynamic>> _$PlanDiscountToSupabase(
  PlanDiscount instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'plan_id': instance.planId,
    'discount_code_id': instance.discountCodeId,
    'original_price': instance.originalPrice,
    'discount_amount': instance.discountAmount,
    'final_price': instance.finalPrice,
    'applied_at': instance.appliedAt.toIso8601String(),
    'business_id': instance.businessId,
  };
}

Future<PlanDiscount> _$PlanDiscountFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return PlanDiscount(
    id: data['id'] as String,
    planId: data['plan_id'] as String,
    discountCodeId: data['discount_code_id'] as String,
    originalPrice: data['original_price'] as double,
    discountAmount: data['discount_amount'] as double,
    finalPrice: data['final_price'] as double,
    appliedAt: DateTime.parse(data['applied_at'] as String),
    businessId: data['business_id'] as String,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$PlanDiscountToSqlite(
  PlanDiscount instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'plan_id': instance.planId,
    'discount_code_id': instance.discountCodeId,
    'original_price': instance.originalPrice,
    'discount_amount': instance.discountAmount,
    'final_price': instance.finalPrice,
    'applied_at': instance.appliedAt.toIso8601String(),
    'business_id': instance.businessId,
  };
}

/// Construct a [PlanDiscount]
class PlanDiscountAdapter
    extends OfflineFirstWithSupabaseAdapter<PlanDiscount> {
  PlanDiscountAdapter();

  @override
  final supabaseTableName = 'plan_discounts';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'planId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'plan_id',
    ),
    'discountCodeId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount_code_id',
    ),
    'originalPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'original_price',
    ),
    'discountAmount': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount_amount',
    ),
    'finalPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'final_price',
    ),
    'appliedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'applied_at',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
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
    'planId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'plan_id',
      iterable: false,
      type: String,
    ),
    'discountCodeId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount_code_id',
      iterable: false,
      type: String,
    ),
    'originalPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'original_price',
      iterable: false,
      type: double,
    ),
    'discountAmount': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount_amount',
      iterable: false,
      type: double,
    ),
    'finalPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'final_price',
      iterable: false,
      type: double,
    ),
    'appliedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'applied_at',
      iterable: false,
      type: DateTime,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    PlanDiscount instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `PlanDiscount` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'PlanDiscount';

  @override
  Future<PlanDiscount> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanDiscountFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    PlanDiscount input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanDiscountToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<PlanDiscount> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanDiscountFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    PlanDiscount input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanDiscountToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
