// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<FlipperSaleCompaign> _$FlipperSaleCompaignFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FlipperSaleCompaign(
    id: data['id'] as String?,
    compaignId: data['compaign_id'] == null
        ? null
        : data['compaign_id'] as int?,
    discountRate: data['discount_rate'] == null
        ? null
        : data['discount_rate'] as int?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    couponCode: data['coupon_code'] == null
        ? null
        : data['coupon_code'] as String?,
  );
}

Future<Map<String, dynamic>> _$FlipperSaleCompaignToSupabase(
  FlipperSaleCompaign instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'compaign_id': instance.compaignId,
    'discount_rate': instance.discountRate,
    'created_at': instance.createdAt?.toIso8601String(),
    'coupon_code': instance.couponCode,
  };
}

Future<FlipperSaleCompaign> _$FlipperSaleCompaignFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return FlipperSaleCompaign(
    id: data['id'] as String,
    compaignId: data['compaign_id'] == null
        ? null
        : data['compaign_id'] as int?,
    discountRate: data['discount_rate'] == null
        ? null
        : data['discount_rate'] as int?,
    createdAt: data['created_at'] == null
        ? null
        : data['created_at'] == null
        ? null
        : DateTime.tryParse(data['created_at'] as String),
    couponCode: data['coupon_code'] == null
        ? null
        : data['coupon_code'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$FlipperSaleCompaignToSqlite(
  FlipperSaleCompaign instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'compaign_id': instance.compaignId,
    'discount_rate': instance.discountRate,
    'created_at': instance.createdAt?.toIso8601String(),
    'coupon_code': instance.couponCode,
  };
}

/// Construct a [FlipperSaleCompaign]
class FlipperSaleCompaignAdapter
    extends OfflineFirstWithSupabaseAdapter<FlipperSaleCompaign> {
  FlipperSaleCompaignAdapter();

  @override
  final supabaseTableName = 'flipper_sale_compaigns';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'compaignId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'compaign_id',
    ),
    'discountRate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'discount_rate',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'couponCode': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'coupon_code',
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
    'compaignId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'compaign_id',
      iterable: false,
      type: int,
    ),
    'discountRate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'discount_rate',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'couponCode': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'coupon_code',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    FlipperSaleCompaign instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `FlipperSaleCompaign` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'FlipperSaleCompaign';

  @override
  Future<FlipperSaleCompaign> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FlipperSaleCompaignFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    FlipperSaleCompaign input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FlipperSaleCompaignToSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<FlipperSaleCompaign> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FlipperSaleCompaignFromSqlite(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSqlite(
    FlipperSaleCompaign input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$FlipperSaleCompaignToSqlite(
    input,
    provider: provider,
    repository: repository,
  );
}
