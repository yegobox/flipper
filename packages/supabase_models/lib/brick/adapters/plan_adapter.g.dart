// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Plan> _$PlanFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Plan(
      id: data['id'] as int,
      businessId: data['business_id'] as int?,
      selectedPlan: data['selected_plan'] as String?,
      additionalDevices: data['additional_devices'] as int?,
      isYearlyPlan: data['is_yearly_plan'] as bool?,
      totalPrice: data['total_price'] as int?,
      createdAt: data['created_at'] == null
          ? null
          : DateTime.tryParse(data['created_at'] as String),
      paymentCompletedByUser: data['payment_completed_by_user'] as bool?,
      payStackCustomerId: data['paystack_customer_id'] as int?,
      rule: data['rule'] as String?,
      paymentMethod: data['payment_method'] as String?);
}

Future<Map<String, dynamic>> _$PlanToSupabase(Plan instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'selected_plan': instance.selectedPlan,
    'additional_devices': instance.additionalDevices,
    'is_yearly_plan': instance.isYearlyPlan,
    'total_price': instance.totalPrice,
    'created_at': instance.createdAt?.toIso8601String(),
    'payment_completed_by_user': instance.paymentCompletedByUser,
    'paystack_customer_id': instance.payStackCustomerId,
    'rule': instance.rule,
    'payment_method': instance.paymentMethod
  };
}

Future<Plan> _$PlanFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Plan(
      id: data['id'] as int,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      selectedPlan: data['selected_plan'] == null
          ? null
          : data['selected_plan'] as String?,
      additionalDevices: data['additional_devices'] == null
          ? null
          : data['additional_devices'] as int?,
      isYearlyPlan:
          data['is_yearly_plan'] == null ? null : data['is_yearly_plan'] == 1,
      totalPrice:
          data['total_price'] == null ? null : data['total_price'] as int?,
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      paymentCompletedByUser: data['payment_completed_by_user'] == null
          ? null
          : data['payment_completed_by_user'] == 1,
      payStackCustomerId: data['pay_stack_customer_id'] == null
          ? null
          : data['pay_stack_customer_id'] as int?,
      rule: data['rule'] == null ? null : data['rule'] as String?,
      paymentMethod: data['payment_method'] == null
          ? null
          : data['payment_method'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$PlanToSqlite(Plan instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'selected_plan': instance.selectedPlan,
    'additional_devices': instance.additionalDevices,
    'is_yearly_plan':
        instance.isYearlyPlan == null ? null : (instance.isYearlyPlan! ? 1 : 0),
    'total_price': instance.totalPrice,
    'created_at': instance.createdAt?.toIso8601String(),
    'payment_completed_by_user': instance.paymentCompletedByUser == null
        ? null
        : (instance.paymentCompletedByUser! ? 1 : 0),
    'pay_stack_customer_id': instance.payStackCustomerId,
    'rule': instance.rule,
    'payment_method': instance.paymentMethod
  };
}

/// Construct a [Plan]
class PlanAdapter extends OfflineFirstWithSupabaseAdapter<Plan> {
  PlanAdapter();

  @override
  final supabaseTableName = 'plans';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'selectedPlan': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'selected_plan',
    ),
    'additionalDevices': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'additional_devices',
    ),
    'isYearlyPlan': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_yearly_plan',
    ),
    'totalPrice': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'total_price',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'paymentCompletedByUser': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_completed_by_user',
    ),
    'payStackCustomerId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'paystack_customer_id',
    ),
    'rule': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'rule',
    ),
    'paymentMethod': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_method',
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
      type: int,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'selectedPlan': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'selected_plan',
      iterable: false,
      type: String,
    ),
    'additionalDevices': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'additional_devices',
      iterable: false,
      type: int,
    ),
    'isYearlyPlan': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_yearly_plan',
      iterable: false,
      type: bool,
    ),
    'totalPrice': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'total_price',
      iterable: false,
      type: int,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'paymentCompletedByUser': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_completed_by_user',
      iterable: false,
      type: bool,
    ),
    'payStackCustomerId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pay_stack_customer_id',
      iterable: false,
      type: int,
    ),
    'rule': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'rule',
      iterable: false,
      type: String,
    ),
    'paymentMethod': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_method',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Plan instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Plan` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Plan';

  @override
  Future<Plan> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PlanFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Plan input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PlanToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Plan> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PlanFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Plan input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PlanToSqlite(input, provider: provider, repository: repository);
}
