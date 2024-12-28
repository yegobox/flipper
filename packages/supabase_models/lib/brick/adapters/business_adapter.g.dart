// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Business> _$BusinessFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Business(
      id: data['id'] as String?,
      serverId: data['server_id'] as int,
      name: data['name'] as String?,
      currency: data['currency'] as String?,
      categoryId: data['category_id'] as String?,
      latitude: data['latitude'] as String?,
      longitude: data['longitude'] as String?,
      userId: data['user_id'] as int?,
      timeZone: data['time_zone'] as String?,
      country: data['country'] as String?,
      businessUrl: data['business_url'] as String?,
      hexColor: data['hex_color'] as String?,
      imageUrl: data['image_url'] as String?,
      type: data['type'] as String?,
      active: data['active'] as bool?,
      chatUid: data['chat_uid'] as String?,
      metadata: data['metadata'] as String?,
      role: data['role'] as String?,
      lastSeen: data['last_seen'] as int?,
      firstName: data['first_name'] as String?,
      lastName: data['last_name'] as String?,
      createdAt: data['created_at'] as String?,
      deviceToken: data['device_token'] as String?,
      backUpEnabled: data['back_up_enabled'] as bool?,
      subscriptionPlan: data['subscription_plan'] as String?,
      nextBillingDate: data['next_billing_date'] as String?,
      previousBillingDate: data['previous_billing_date'] as String?,
      isLastSubscriptionPaymentSucceeded:
          data['is_last_subscription_payment_succeeded'] as bool?,
      backupFileId: data['backup_file_id'] as String?,
      email: data['email'] as String?,
      lastDbBackup: data['last_db_backup'] as String?,
      fullName: data['full_name'] as String?,
      tinNumber: data['tin_number'] as int?,
      bhfId: data['bhf_id'] as String?,
      dvcSrlNo: data['dvc_srl_no'] as String?,
      adrs: data['adrs'] as String?,
      taxEnabled: data['tax_enabled'] as bool?,
      taxServerUrl: data['tax_server_url'] as String?,
      isDefault: data['is_default'] as bool?,
      businessTypeId: data['business_type_id'] as int?,
      lastTouched: data['last_touched'] == null
          ? null
          : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : DateTime.tryParse(data['deleted_at'] as String),
      encryptionKey: data['encryption_key'] as String?);
}

Future<Map<String, dynamic>> _$BusinessToSupabase(Business instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'server_id': instance.serverId,
    'name': instance.name,
    'currency': instance.currency,
    'category_id': instance.categoryId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'user_id': instance.userId,
    'time_zone': instance.timeZone,
    'country': instance.country,
    'business_url': instance.businessUrl,
    'hex_color': instance.hexColor,
    'image_url': instance.imageUrl,
    'type': instance.type,
    'active': instance.active,
    'chat_uid': instance.chatUid,
    'metadata': instance.metadata,
    'role': instance.role,
    'last_seen': instance.lastSeen,
    'first_name': instance.firstName,
    'last_name': instance.lastName,
    'created_at': instance.createdAt,
    'device_token': instance.deviceToken,
    'back_up_enabled': instance.backUpEnabled,
    'subscription_plan': instance.subscriptionPlan,
    'next_billing_date': instance.nextBillingDate,
    'previous_billing_date': instance.previousBillingDate,
    'is_last_subscription_payment_succeeded':
        instance.isLastSubscriptionPaymentSucceeded,
    'backup_file_id': instance.backupFileId,
    'email': instance.email,
    'last_db_backup': instance.lastDbBackup,
    'full_name': instance.fullName,
    'tin_number': instance.tinNumber,
    'bhf_id': instance.bhfId,
    'dvc_srl_no': instance.dvcSrlNo,
    'adrs': instance.adrs,
    'tax_enabled': instance.taxEnabled,
    'tax_server_url': instance.taxServerUrl,
    'is_default': instance.isDefault,
    'business_type_id': instance.businessTypeId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'encryption_key': instance.encryptionKey
  };
}

Future<Business> _$BusinessFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Business(
      id: data['id'] as String,
      serverId: data['server_id'] as int,
      name: data['name'] == null ? null : data['name'] as String?,
      currency: data['currency'] == null ? null : data['currency'] as String?,
      categoryId:
          data['category_id'] == null ? null : data['category_id'] as String?,
      latitude: data['latitude'] == null ? null : data['latitude'] as String?,
      longitude:
          data['longitude'] == null ? null : data['longitude'] as String?,
      userId: data['user_id'] == null ? null : data['user_id'] as int?,
      timeZone: data['time_zone'] == null ? null : data['time_zone'] as String?,
      country: data['country'] == null ? null : data['country'] as String?,
      businessUrl:
          data['business_url'] == null ? null : data['business_url'] as String?,
      hexColor: data['hex_color'] == null ? null : data['hex_color'] as String?,
      imageUrl: data['image_url'] == null ? null : data['image_url'] as String?,
      type: data['type'] == null ? null : data['type'] as String?,
      active: data['active'] == null ? null : data['active'] == 1,
      chatUid: data['chat_uid'] == null ? null : data['chat_uid'] as String?,
      metadata: data['metadata'] == null ? null : data['metadata'] as String?,
      role: data['role'] == null ? null : data['role'] as String?,
      lastSeen: data['last_seen'] == null ? null : data['last_seen'] as int?,
      firstName:
          data['first_name'] == null ? null : data['first_name'] as String?,
      lastName: data['last_name'] == null ? null : data['last_name'] as String?,
      createdAt:
          data['created_at'] == null ? null : data['created_at'] as String?,
      deviceToken:
          data['device_token'] == null ? null : data['device_token'] as String?,
      backUpEnabled:
          data['back_up_enabled'] == null ? null : data['back_up_enabled'] == 1,
      subscriptionPlan: data['subscription_plan'] == null
          ? null
          : data['subscription_plan'] as String?,
      nextBillingDate: data['next_billing_date'] == null
          ? null
          : data['next_billing_date'] as String?,
      previousBillingDate: data['previous_billing_date'] == null
          ? null
          : data['previous_billing_date'] as String?,
      isLastSubscriptionPaymentSucceeded:
          data['is_last_subscription_payment_succeeded'] == null
              ? null
              : data['is_last_subscription_payment_succeeded'] == 1,
      backupFileId: data['backup_file_id'] == null
          ? null
          : data['backup_file_id'] as String?,
      email: data['email'] == null ? null : data['email'] as String?,
      lastDbBackup: data['last_db_backup'] == null
          ? null
          : data['last_db_backup'] as String?,
      fullName: data['full_name'] == null ? null : data['full_name'] as String?,
      tinNumber: data['tin_number'] == null ? null : data['tin_number'] as int?,
      bhfId: data['bhf_id'] == null ? null : data['bhf_id'] as String?,
      dvcSrlNo:
          data['dvc_srl_no'] == null ? null : data['dvc_srl_no'] as String?,
      adrs: data['adrs'] == null ? null : data['adrs'] as String?,
      taxEnabled: data['tax_enabled'] == null ? null : data['tax_enabled'] == 1,
      taxServerUrl: data['tax_server_url'] == null
          ? null
          : data['tax_server_url'] as String?,
      isDefault: data['is_default'] == null ? null : data['is_default'] == 1,
      businessTypeId: data['business_type_id'] == null
          ? null
          : data['business_type_id'] as int?,
      lastTouched: data['last_touched'] == null
          ? null
          : data['last_touched'] == null
              ? null
              : DateTime.tryParse(data['last_touched'] as String),
      deletedAt: data['deleted_at'] == null
          ? null
          : data['deleted_at'] == null
              ? null
              : DateTime.tryParse(data['deleted_at'] as String),
      encryptionKey: data['encryption_key'] == null
          ? null
          : data['encryption_key'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$BusinessToSqlite(Business instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'server_id': instance.serverId,
    'name': instance.name,
    'currency': instance.currency,
    'category_id': instance.categoryId,
    'latitude': instance.latitude,
    'longitude': instance.longitude,
    'user_id': instance.userId,
    'time_zone': instance.timeZone,
    'country': instance.country,
    'business_url': instance.businessUrl,
    'hex_color': instance.hexColor,
    'image_url': instance.imageUrl,
    'type': instance.type,
    'active': instance.active == null ? null : (instance.active! ? 1 : 0),
    'chat_uid': instance.chatUid,
    'metadata': instance.metadata,
    'role': instance.role,
    'last_seen': instance.lastSeen,
    'first_name': instance.firstName,
    'last_name': instance.lastName,
    'created_at': instance.createdAt,
    'device_token': instance.deviceToken,
    'back_up_enabled': instance.backUpEnabled == null
        ? null
        : (instance.backUpEnabled! ? 1 : 0),
    'subscription_plan': instance.subscriptionPlan,
    'next_billing_date': instance.nextBillingDate,
    'previous_billing_date': instance.previousBillingDate,
    'is_last_subscription_payment_succeeded':
        instance.isLastSubscriptionPaymentSucceeded == null
            ? null
            : (instance.isLastSubscriptionPaymentSucceeded! ? 1 : 0),
    'backup_file_id': instance.backupFileId,
    'email': instance.email,
    'last_db_backup': instance.lastDbBackup,
    'full_name': instance.fullName,
    'tin_number': instance.tinNumber,
    'bhf_id': instance.bhfId,
    'dvc_srl_no': instance.dvcSrlNo,
    'adrs': instance.adrs,
    'tax_enabled':
        instance.taxEnabled == null ? null : (instance.taxEnabled! ? 1 : 0),
    'tax_server_url': instance.taxServerUrl,
    'is_default':
        instance.isDefault == null ? null : (instance.isDefault! ? 1 : 0),
    'business_type_id': instance.businessTypeId,
    'last_touched': instance.lastTouched?.toIso8601String(),
    'deleted_at': instance.deletedAt?.toIso8601String(),
    'encryption_key': instance.encryptionKey
  };
}

/// Construct a [Business]
class BusinessAdapter extends OfflineFirstWithSupabaseAdapter<Business> {
  BusinessAdapter();

  @override
  final supabaseTableName = 'businesses';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'serverId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'server_id',
    ),
    'name': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'name',
    ),
    'currency': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'currency',
    ),
    'categoryId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'category_id',
    ),
    'latitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'latitude',
    ),
    'longitude': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'longitude',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'timeZone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'time_zone',
    ),
    'country': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'country',
    ),
    'businessUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_url',
    ),
    'hexColor': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'hex_color',
    ),
    'imageUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'image_url',
    ),
    'type': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'type',
    ),
    'active': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'active',
    ),
    'chatUid': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'chat_uid',
    ),
    'metadata': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'metadata',
    ),
    'role': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'role',
    ),
    'lastSeen': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_seen',
    ),
    'firstName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'first_name',
    ),
    'lastName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_name',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'deviceToken': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'device_token',
    ),
    'backUpEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'back_up_enabled',
    ),
    'subscriptionPlan': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'subscription_plan',
    ),
    'nextBillingDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'next_billing_date',
    ),
    'previousBillingDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'previous_billing_date',
    ),
    'isLastSubscriptionPaymentSucceeded': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_last_subscription_payment_succeeded',
    ),
    'backupFileId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'backup_file_id',
    ),
    'email': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'email',
    ),
    'lastDbBackup': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_db_backup',
    ),
    'fullName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'full_name',
    ),
    'tinNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tin_number',
    ),
    'bhfId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'bhf_id',
    ),
    'dvcSrlNo': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'dvc_srl_no',
    ),
    'adrs': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'adrs',
    ),
    'taxEnabled': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_enabled',
    ),
    'taxServerUrl': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'tax_server_url',
    ),
    'isDefault': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'is_default',
    ),
    'businessTypeId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_type_id',
    ),
    'lastTouched': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'last_touched',
    ),
    'deletedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'deleted_at',
    ),
    'encryptionKey': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'encryption_key',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
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
    'serverId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'server_id',
      iterable: false,
      type: int,
    ),
    'name': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'name',
      iterable: false,
      type: String,
    ),
    'currency': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'currency',
      iterable: false,
      type: String,
    ),
    'categoryId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'category_id',
      iterable: false,
      type: String,
    ),
    'latitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'latitude',
      iterable: false,
      type: String,
    ),
    'longitude': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'longitude',
      iterable: false,
      type: String,
    ),
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: int,
    ),
    'timeZone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'time_zone',
      iterable: false,
      type: String,
    ),
    'country': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'country',
      iterable: false,
      type: String,
    ),
    'businessUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_url',
      iterable: false,
      type: String,
    ),
    'hexColor': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'hex_color',
      iterable: false,
      type: String,
    ),
    'imageUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'image_url',
      iterable: false,
      type: String,
    ),
    'type': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'type',
      iterable: false,
      type: String,
    ),
    'active': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'active',
      iterable: false,
      type: bool,
    ),
    'chatUid': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'chat_uid',
      iterable: false,
      type: String,
    ),
    'metadata': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'metadata',
      iterable: false,
      type: String,
    ),
    'role': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'role',
      iterable: false,
      type: String,
    ),
    'lastSeen': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_seen',
      iterable: false,
      type: int,
    ),
    'firstName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'first_name',
      iterable: false,
      type: String,
    ),
    'lastName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_name',
      iterable: false,
      type: String,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: String,
    ),
    'deviceToken': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'device_token',
      iterable: false,
      type: String,
    ),
    'backUpEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'back_up_enabled',
      iterable: false,
      type: bool,
    ),
    'subscriptionPlan': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'subscription_plan',
      iterable: false,
      type: String,
    ),
    'nextBillingDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'next_billing_date',
      iterable: false,
      type: String,
    ),
    'previousBillingDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'previous_billing_date',
      iterable: false,
      type: String,
    ),
    'isLastSubscriptionPaymentSucceeded': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_last_subscription_payment_succeeded',
      iterable: false,
      type: bool,
    ),
    'backupFileId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'backup_file_id',
      iterable: false,
      type: String,
    ),
    'email': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'email',
      iterable: false,
      type: String,
    ),
    'lastDbBackup': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_db_backup',
      iterable: false,
      type: String,
    ),
    'fullName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'full_name',
      iterable: false,
      type: String,
    ),
    'tinNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tin_number',
      iterable: false,
      type: int,
    ),
    'bhfId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'bhf_id',
      iterable: false,
      type: String,
    ),
    'dvcSrlNo': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'dvc_srl_no',
      iterable: false,
      type: String,
    ),
    'adrs': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'adrs',
      iterable: false,
      type: String,
    ),
    'taxEnabled': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_enabled',
      iterable: false,
      type: bool,
    ),
    'taxServerUrl': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'tax_server_url',
      iterable: false,
      type: String,
    ),
    'isDefault': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'is_default',
      iterable: false,
      type: bool,
    ),
    'businessTypeId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_type_id',
      iterable: false,
      type: int,
    ),
    'lastTouched': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'last_touched',
      iterable: false,
      type: DateTime,
    ),
    'deletedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'deleted_at',
      iterable: false,
      type: DateTime,
    ),
    'encryptionKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'encryption_key',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Business instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Business` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Business';

  @override
  Future<Business> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Business input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Business> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Business input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$BusinessToSqlite(input,
          provider: provider, repository: repository);
}
