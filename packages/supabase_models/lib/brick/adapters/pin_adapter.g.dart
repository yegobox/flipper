// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Pin> _$PinFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Pin(
      id: data['id'] as String?,
      userId: data['user_id'] as int?,
      phoneNumber: data['phone_number'] as String?,
      pin: data['pin'] as int?,
      branchId: data['branch_id'] as int?,
      businessId: data['business_id'] as int?,
      ownerName: data['owner_name'] as String?,
      tokenUid: data['token_uid'] as String?,
      uid: data['uid'] as String?);
}

Future<Map<String, dynamic>> _$PinToSupabase(Pin instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'user_id': instance.userId,
    'phone_number': instance.phoneNumber,
    'pin': instance.pin,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'owner_name': instance.ownerName,
    'token_uid': instance.tokenUid,
    'uid': instance.uid
  };
}

Future<Pin> _$PinFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Pin(
      id: data['id'] as String,
      userId: data['user_id'] == null ? null : data['user_id'] as int?,
      phoneNumber:
          data['phone_number'] == null ? null : data['phone_number'] as String?,
      pin: data['pin'] == null ? null : data['pin'] as int?,
      branchId: data['branch_id'] == null ? null : data['branch_id'] as int?,
      businessId:
          data['business_id'] == null ? null : data['business_id'] as int?,
      ownerName:
          data['owner_name'] == null ? null : data['owner_name'] as String?,
      tokenUid: data['token_uid'] == null ? null : data['token_uid'] as String?,
      uid: data['uid'] == null ? null : data['uid'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$PinToSqlite(Pin instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'user_id': instance.userId,
    'phone_number': instance.phoneNumber,
    'pin': instance.pin,
    'branch_id': instance.branchId,
    'business_id': instance.businessId,
    'owner_name': instance.ownerName,
    'token_uid': instance.tokenUid,
    'uid': instance.uid
  };
}

/// Construct a [Pin]
class PinAdapter extends OfflineFirstWithSupabaseAdapter<Pin> {
  PinAdapter();

  @override
  final supabaseTableName = 'pins';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'userId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'user_id',
    ),
    'phoneNumber': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'phone_number',
    ),
    'pin': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'pin',
    ),
    'branchId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'branch_id',
    ),
    'businessId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'business_id',
    ),
    'ownerName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'owner_name',
    ),
    'tokenUid': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'token_uid',
    ),
    'uid': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'uid',
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
    'userId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'user_id',
      iterable: false,
      type: int,
    ),
    'phoneNumber': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'phone_number',
      iterable: false,
      type: String,
    ),
    'pin': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'pin',
      iterable: false,
      type: int,
    ),
    'branchId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'branch_id',
      iterable: false,
      type: int,
    ),
    'businessId': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'business_id',
      iterable: false,
      type: int,
    ),
    'ownerName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'owner_name',
      iterable: false,
      type: String,
    ),
    'tokenUid': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'token_uid',
      iterable: false,
      type: String,
    ),
    'uid': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'uid',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Pin instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Pin` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Pin';

  @override
  Future<Pin> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PinFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Pin input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PinToSupabase(input, provider: provider, repository: repository);
  @override
  Future<Pin> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PinFromSqlite(input, provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Pin input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$PinToSqlite(input, provider: provider, repository: repository);
}
