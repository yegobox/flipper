// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Plan> _$PlanFromSupabase(
  Map<String, dynamic> data, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Plan(
    id: data['id'] == null ? null : data['id'] as String?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
    selectedPlan:
        data['selected_plan'] == null ? null : data['selected_plan'] as String?,
    additionalDevices:
        data['additional_devices'] == null
            ? null
            : data['additional_devices'] as int?,
    isYearlyPlan:
        data['is_yearly_plan'] == null ? null : data['is_yearly_plan'] as bool?,
    totalPrice:
        data['total_price'] == null ? null : data['total_price'] as int?,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    paymentCompletedByUser:
        data['payment_completed_by_user'] == null
            ? null
            : data['payment_completed_by_user'] as bool? ?? false,
    rule: data['rule'] == null ? null : data['rule'] as String?,
    paymentMethod:
        data['payment_method'] == null
            ? null
            : data['payment_method'] as String?,
    addons: await Future.wait<PlanAddon>(
      data['addons']
              ?.map(
                (d) => PlanAddonAdapter().fromSupabase(
                  d,
                  provider: provider,
                  repository: repository,
                ),
              )
              .toList()
              .cast<Future<PlanAddon>>() ??
          [],
    ),
    nextBillingDate:
        data['next_billing_date'] == null
            ? null
            : data['next_billing_date'] == null
            ? null
            : DateTime.tryParse(data['next_billing_date'] as String),
    numberOfPayments:
        data['number_of_payments'] == null
            ? null
            : data['number_of_payments'] as int?,
    phoneNumber:
        data['phone_number'] == null ? null : data['phone_number'] as String?,
    externalId:
        data['external_id'] == null ? null : data['external_id'] as String?,
    paymentStatus:
        data['payment_status'] == null
            ? null
            : data['payment_status'] as String?,
    lastProcessedAt:
        data['last_processed_at'] == null
            ? null
            : data['last_processed_at'] == null
            ? null
            : DateTime.tryParse(data['last_processed_at'] as String),
    lastError:
        data['last_error'] == null ? null : data['last_error'] as String?,
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    lastUpdated:
        data['last_updated'] == null
            ? null
            : data['last_updated'] == null
            ? null
            : DateTime.tryParse(data['last_updated'] as String),
    processingStatus:
        data['processing_status'] == null
            ? null
            : data['processing_status'] as String?,
  );
}

Future<Map<String, dynamic>> _$PlanToSupabase(
  Plan instance, {
  required SupabaseProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'selected_plan': instance.selectedPlan,
    'additional_devices': instance.additionalDevices,
    'is_yearly_plan': instance.isYearlyPlan,
    'total_price': instance.totalPrice,
    'created_at': instance.createdAt?.toIso8601String(),
    'payment_completed_by_user': instance.paymentCompletedByUser,
    'rule': instance.rule,
    'payment_method': instance.paymentMethod,
    'addons': await Future.wait<Map<String, dynamic>>(
      instance.addons
          .map(
            (s) => PlanAddonAdapter().toSupabase(
              s,
              provider: provider,
              repository: repository,
            ),
          )
          .toList(),
    ),
    'next_billing_date': instance.nextBillingDate?.toIso8601String(),
    'number_of_payments': instance.numberOfPayments,
    'phone_number': instance.phoneNumber,
    'external_id': instance.externalId,
    'payment_status': instance.paymentStatus,
    'last_processed_at': instance.lastProcessedAt?.toIso8601String(),
    'last_error': instance.lastError,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'last_updated': instance.lastUpdated?.toIso8601String(),
    'processing_status': instance.processingStatus,
  };
}

Future<Plan> _$PlanFromSqlite(
  Map<String, dynamic> data, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return Plan(
    id: data['id'] == null ? null : data['id'] as String?,
    businessId:
        data['business_id'] == null ? null : data['business_id'] as String?,
    branchId: data['branch_id'] == null ? null : data['branch_id'] as String?,
    selectedPlan:
        data['selected_plan'] == null ? null : data['selected_plan'] as String?,
    additionalDevices:
        data['additional_devices'] == null
            ? null
            : data['additional_devices'] as int?,
    isYearlyPlan:
        data['is_yearly_plan'] == null ? null : data['is_yearly_plan'] == 1,
    totalPrice:
        data['total_price'] == null ? null : data['total_price'] as int?,
    createdAt:
        data['created_at'] == null
            ? null
            : data['created_at'] == null
            ? null
            : DateTime.tryParse(data['created_at'] as String),
    paymentCompletedByUser:
        data['payment_completed_by_user'] == null
            ? null
            : data['payment_completed_by_user'] == 1,
    rule: data['rule'] == null ? null : data['rule'] as String?,
    paymentMethod:
        data['payment_method'] == null
            ? null
            : data['payment_method'] as String?,
    addons:
        (await provider
            .rawQuery(
              'SELECT DISTINCT `f_PlanAddon_brick_id` FROM `_brick_Plan_addons` WHERE l_Plan_brick_id = ?',
              [data['_brick_id'] as int],
            )
            .then((results) {
              final ids = results.map((r) => r['f_PlanAddon_brick_id']);
              return Future.wait<PlanAddon>(
                ids.map(
                  (primaryKey) => repository!
                      .getAssociation<PlanAddon>(
                        Query.where('primaryKey', primaryKey, limit1: true),
                      )
                      .then((r) => r!.first),
                ),
              );
            })).toList().cast<PlanAddon>(),
    nextBillingDate:
        data['next_billing_date'] == null
            ? null
            : data['next_billing_date'] == null
            ? null
            : DateTime.tryParse(data['next_billing_date'] as String),
    numberOfPayments:
        data['number_of_payments'] == null
            ? null
            : data['number_of_payments'] as int?,
    phoneNumber:
        data['phone_number'] == null ? null : data['phone_number'] as String?,
    externalId:
        data['external_id'] == null ? null : data['external_id'] as String?,
    paymentStatus:
        data['payment_status'] == null
            ? null
            : data['payment_status'] as String?,
    lastProcessedAt:
        data['last_processed_at'] == null
            ? null
            : data['last_processed_at'] == null
            ? null
            : DateTime.tryParse(data['last_processed_at'] as String),
    lastError:
        data['last_error'] == null ? null : data['last_error'] as String?,
    updatedAt:
        data['updated_at'] == null
            ? null
            : data['updated_at'] == null
            ? null
            : DateTime.tryParse(data['updated_at'] as String),
    lastUpdated:
        data['last_updated'] == null
            ? null
            : data['last_updated'] == null
            ? null
            : DateTime.tryParse(data['last_updated'] as String),
    processingStatus:
        data['processing_status'] == null
            ? null
            : data['processing_status'] as String?,
  )..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$PlanToSqlite(
  Plan instance, {
  required SqliteProvider provider,
  OfflineFirstWithSupabaseRepository? repository,
}) async {
  return {
    'id': instance.id,
    'business_id': instance.businessId,
    'branch_id': instance.branchId,
    'selected_plan': instance.selectedPlan,
    'additional_devices': instance.additionalDevices,
    'is_yearly_plan':
        instance.isYearlyPlan == null ? null : (instance.isYearlyPlan! ? 1 : 0),
    'total_price': instance.totalPrice,
    'created_at': instance.createdAt?.toIso8601String(),
    'payment_completed_by_user':
        instance.paymentCompletedByUser == null
            ? null
            : (instance.paymentCompletedByUser! ? 1 : 0),
    'rule': instance.rule,
    'payment_method': instance.paymentMethod,
    'next_billing_date': instance.nextBillingDate?.toIso8601String(),
    'number_of_payments': instance.numberOfPayments,
    'phone_number': instance.phoneNumber,
    'external_id': instance.externalId,
    'payment_status': instance.paymentStatus,
    'last_processed_at': instance.lastProcessedAt?.toIso8601String(),
    'last_error': instance.lastError,
    'updated_at': instance.updatedAt?.toIso8601String(),
    'last_updated': instance.lastUpdated?.toIso8601String(),
    'processing_status': instance.processingStatus,
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
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
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
    'rule': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'rule',
    ),
    'paymentMethod': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_method',
    ),
    'addons': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'addons',
      associationType: PlanAddon,
      associationIsNullable: false,
    ),
    'nextBillingDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'next_billing_date',
    ),
    'numberOfPayments': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'number_of_payments',
    ),
    'phoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number',
    ),
    'externalId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'external_id',
    ),
    'paymentStatus': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'payment_status',
    ),
    'lastProcessedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_processed_at',
    ),
    'lastError': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_error',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    ),
    'lastUpdated': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_updated',
    ),
    'processingStatus': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'processing_status',
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
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: String,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: String,
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
    ),
    'addons': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'addons',
      iterable: true,
      type: PlanAddon,
    ),
    'nextBillingDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'next_billing_date',
      iterable: false,
      type: DateTime,
    ),
    'numberOfPayments': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'number_of_payments',
      iterable: false,
      type: int,
    ),
    'phoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number',
      iterable: false,
      type: String,
    ),
    'externalId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'external_id',
      iterable: false,
      type: String,
    ),
    'paymentStatus': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'payment_status',
      iterable: false,
      type: String,
    ),
    'lastProcessedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_processed_at',
      iterable: false,
      type: DateTime,
    ),
    'lastError': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_error',
      iterable: false,
      type: String,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    ),
    'lastUpdated': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_updated',
      iterable: false,
      type: DateTime,
    ),
    'processingStatus': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'processing_status',
      iterable: false,
      type: String,
    ),
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
    Plan instance,
    DatabaseExecutor executor,
  ) async {
    final results = await executor.rawQuery(
      '''
        SELECT * FROM `Plan` WHERE id = ? LIMIT 1''',
      [instance.id],
    );

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Plan';
  @override
  Future<void> afterSave(instance, {required provider, repository}) async {
    if (instance.primaryKey != null) {
      final addonsOldColumns = await provider.rawQuery(
        'SELECT `f_PlanAddon_brick_id` FROM `_brick_Plan_addons` WHERE `l_Plan_brick_id` = ?',
        [instance.primaryKey],
      );
      final addonsOldIds = addonsOldColumns.map(
        (a) => a['f_PlanAddon_brick_id'],
      );
      final addonsNewIds =
          instance.addons.map((s) => s.primaryKey).whereType<int>();
      final addonsIdsToDelete = addonsOldIds.where(
        (id) => !addonsNewIds.contains(id),
      );

      await Future.wait<void>(
        addonsIdsToDelete.map((id) async {
          return await provider
              .rawExecute(
                'DELETE FROM `_brick_Plan_addons` WHERE `l_Plan_brick_id` = ? AND `f_PlanAddon_brick_id` = ?',
                [instance.primaryKey, id],
              )
              .catchError((e) => null);
        }),
      );

      await Future.wait<int?>(
        instance.addons.map((s) async {
          final id =
              s.primaryKey ??
              await provider.upsert<PlanAddon>(s, repository: repository);
          return await provider.rawInsert(
            'INSERT OR IGNORE INTO `_brick_Plan_addons` (`l_Plan_brick_id`, `f_PlanAddon_brick_id`) VALUES (?, ?)',
            [instance.primaryKey, id],
          );
        }),
      );
    }
  }

  @override
  Future<Plan> fromSupabase(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async => await _$PlanFromSupabase(
    input,
    provider: provider,
    repository: repository,
  );
  @override
  Future<Map<String, dynamic>> toSupabase(
    Plan input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$PlanToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Plan> fromSqlite(
    Map<String, dynamic> input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$PlanFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(
    Plan input, {
    required provider,
    covariant OfflineFirstWithSupabaseRepository? repository,
  }) async =>
      await _$PlanToSqlite(input, provider: provider, repository: repository);
}
